#requires -Version 5.1
<#######################################################################
 IFCD0110 - Lanzador de servidor Python + Cloudflare Quick Tunnel

 Requisitos:
   - Windows PowerShell 5.1 o PowerShell 7+
   - Python instalado y disponible como python o python3
   - cloudflared instalado y disponible en PATH

 Ejemplos:
   .\launch-tunnel-fixed.ps1
   .\launch-tunnel-fixed.ps1 -Port 8080 -ProjectPath 'C:\MiProyecto'
#########################################################################>

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateRange(1, 65535)]
    [int]$Port = 8081,

    [Parameter()]
    [string]$ProjectPath = ''
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$ServerProc = $null
$CloudflaredProc = $null
$StdoutFile = $null
$StderrFile = $null
$PythonStdoutFile = $null
$PythonStderrFile = $null
$TunnelUrl = $null

function Write-Box {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Lines
    )

    $width = 62
    Write-Host ('+' + ('-' * $width) + '+') -ForegroundColor Cyan
    foreach ($line in $Lines) {
        if ($null -eq $line) { $line = '' }
        if ($line.Length -gt ($width - 2)) {
            $line = $line.Substring(0, $width - 2)
        }
        $padding = ' ' * ($width - 2 - $line.Length)
        Write-Host ('| ' + $line + $padding + ' |') -ForegroundColor Cyan
    }
    Write-Host ('+' + ('-' * $width) + '+') -ForegroundColor Cyan
}

function Test-CommandExecutable {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,

        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    try {
        & $Command @Arguments *> $null
        return ($LASTEXITCODE -eq 0)
    }
    catch {
        return $false
    }
}

function Get-ListeningPortOwner {
    param(
        [Parameter(Mandatory = $true)]
        [int]$ListeningPort
    )

    try {
        $listeners = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners()
        return @($listeners | Where-Object { $_.Port -eq $ListeningPort })
    }
    catch {
        return @()
    }
}

function Stop-StartedProcess {
    param(
        [Parameter()]
        [System.Diagnostics.Process]$Process,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($null -eq $Process) { return }

    try {
        $Process.Refresh()
        if (-not $Process.HasExited) {
            Write-Host "[*] Deteniendo $Name (PID: $($Process.Id))..." -ForegroundColor Yellow
            Stop-Process -Id $Process.Id -Force -ErrorAction SilentlyContinue
            $Process.WaitForExit(3000)
        }
    }
    catch {
        # El proceso puede haber terminado entre Refresh y Stop-Process.
    }
}

function Remove-TemporaryFiles {
    foreach ($file in @($StdoutFile, $StderrFile, $PythonStdoutFile, $PythonStderrFile)) {
        if (-not [string]::IsNullOrWhiteSpace($file)) {
            Remove-Item -LiteralPath $file -Force -ErrorAction SilentlyContinue
        }
    }
}

try {
    if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
        if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) {
            $ProjectPath = $PSScriptRoot
        }
        else {
            $ProjectPath = (Get-Location).Path
        }
    }

    $ProjectPath = [System.IO.Path]::GetFullPath($ProjectPath)
    if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
        throw "El directorio del proyecto no existe: $ProjectPath"
    }

    Write-Box @(
        'IFCD0110 - Lanzador con tunel Cloudflare',
        "Directorio publicado: $ProjectPath"
    )
    Write-Host ''

    # -----------------------------------------------------------------
    # 1. Verificar cloudflared y su ejecución real
    # -----------------------------------------------------------------
    Write-Host '[1/4] Verificando cloudflared...' -ForegroundColor Yellow
    $CloudflaredCommand = @(Get-Command cloudflared -CommandType Application -ErrorAction SilentlyContinue) | Select-Object -First 1
    if ($null -eq $CloudflaredCommand) {
        throw 'cloudflared no esta instalado o no se encuentra en PATH. Instala con: winget install --id Cloudflare.cloudflared --exact'
    }

    $CloudflaredPath = [string]$CloudflaredCommand.Path
    if (-not (Test-CommandExecutable -Command $CloudflaredPath -Arguments @('--version'))) {
        throw "cloudflared se encontro, pero no puede ejecutarse: $CloudflaredPath"
    }
    Write-Host "    OK $CloudflaredPath" -ForegroundColor Green

    # -----------------------------------------------------------------
    # 2. Verificar Python y evitar el alias de Microsoft Store
    # -----------------------------------------------------------------
    Write-Host '[2/4] Verificando Python...' -ForegroundColor Yellow
    $PythonCommand = $null
    foreach ($candidate in @('python', 'python3')) {
        $command = @(Get-Command $candidate -CommandType Application -ErrorAction SilentlyContinue) | Select-Object -First 1
        if ($null -ne $command) {
            $candidatePath = [string]$command.Path
            if (Test-CommandExecutable -Command $candidatePath -Arguments @('--version')) {
                $PythonCommand = $candidatePath
                break
            }
        }
    }

    if ($null -eq $PythonCommand) {
        throw 'Python no esta instalado o no puede ejecutarse. Instala Python desde python.org o con: winget install --id Python.Python.3 --exact'
    }
    Write-Host "    OK $PythonCommand" -ForegroundColor Green

    # -----------------------------------------------------------------
    # 3. Comprobar que el puerto esta libre y arrancar Python
    # -----------------------------------------------------------------
    Write-Host "[3/4] Comprobando puerto $Port..." -ForegroundColor Yellow
    $existingListeners = @()
    for ($portCheck = 1; $portCheck -le 5; $portCheck++) {
        $existingListeners = @(Get-ListeningPortOwner -ListeningPort $Port)
        if ($existingListeners.Count -eq 0) { break }
        Start-Sleep -Milliseconds 500
    }
    if ($existingListeners.Count -gt 0) {
        $addresses = ($existingListeners | ForEach-Object { $_.Address.ToString() }) -join ', '
        throw "El puerto $Port sigue en uso ($addresses). Cierra el servicio existente o utiliza otro puerto."
    }
    Write-Host "    OK Puerto $Port libre" -ForegroundColor Green

    $suffix = [Guid]::NewGuid().ToString('N')
    $tempDirectory = [System.IO.Path]::GetTempPath()
    $PythonStdoutFile = Join-Path $tempDirectory "ifct0510_python_$suffix.stdout.log"
    $PythonStderrFile = Join-Path $tempDirectory "ifct0510_python_$suffix.stderr.log"
    $StdoutFile = Join-Path $tempDirectory "ifct0510_cloudflared_$suffix.stdout.log"
    $StderrFile = Join-Path $tempDirectory "ifct0510_cloudflared_$suffix.stderr.log"

    Write-Host "[3/4] Iniciando servidor local en puerto $Port..." -ForegroundColor Yellow
    $ServerProc = Start-Process `
        -FilePath $PythonCommand `
        -ArgumentList @('-m', 'http.server', "$Port", '--bind', '127.0.0.1') `
        -WorkingDirectory $ProjectPath `
        -RedirectStandardOutput $PythonStdoutFile `
        -RedirectStandardError $PythonStderrFile `
        -WindowStyle Hidden `
        -PassThru

    Start-Sleep -Seconds 2
    $ServerProc.Refresh()
    if ($ServerProc.HasExited) {
        $pythonError = if (Test-Path -LiteralPath $PythonStderrFile) { Get-Content -LiteralPath $PythonStderrFile -Raw -ErrorAction SilentlyContinue } else { '' }
        throw "Python termino inesperadamente. $pythonError"
    }

    $serverReady = $false
    for ($i = 0; $i -lt 10; $i++) {
        try {
            $probe = Invoke-WebRequest -Uri "http://127.0.0.1:$Port/" -Method Get -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
            if ($probe.StatusCode -ge 200 -and $probe.StatusCode -lt 500) {
                $serverReady = $true
                break
            }
        }
        catch {
            # Python puede tardar unos instantes en empezar a escuchar.
        }
        Start-Sleep -Milliseconds 300
    }
    if (-not $serverReady) {
        throw "Python esta ejecutandose, pero no ha abierto el puerto $Port."
    }
    Write-Host "    OK Servidor HTTP responde en http://127.0.0.1:$Port (PID: $($ServerProc.Id))" -ForegroundColor Green

    # -----------------------------------------------------------------
    # 4. Arrancar cloudflared, extraer una URL limpia y abrir navegador
    # -----------------------------------------------------------------
    Write-Host '[4/4] Creando tunel Cloudflare...' -ForegroundColor Yellow
    $CloudflaredProc = Start-Process `
        -FilePath $CloudflaredPath `
        -ArgumentList @('tunnel', '--url', "http://127.0.0.1:$Port") `
        -WorkingDirectory $ProjectPath `
        -RedirectStandardOutput $StdoutFile `
        -RedirectStandardError $StderrFile `
        -WindowStyle Hidden `
        -PassThru

    Write-Host '    Esperando URL del tunel (maximo 30 segundos)...' -ForegroundColor Yellow
    $deadline = (Get-Date).AddSeconds(30)

    while ((Get-Date) -lt $deadline -and [string]::IsNullOrWhiteSpace($TunnelUrl)) {
        Start-Sleep -Milliseconds 500

        foreach ($logFile in @($StderrFile, $StdoutFile)) {
            if (Test-Path -LiteralPath $logFile) {
                $content = Get-Content -LiteralPath $logFile -Raw -ErrorAction SilentlyContinue
                if ($content -match '(https://[a-z0-9-]+\.trycloudflare\.com)') {
                    $TunnelUrl = $Matches[1]
                    break
                }
            }
        }

        $CloudflaredProc.Refresh()
        if ($CloudflaredProc.HasExited -and [string]::IsNullOrWhiteSpace($TunnelUrl)) {
            break
        }
    }

    if ([string]::IsNullOrWhiteSpace($TunnelUrl)) {
        Write-Host ''
        Write-Host 'No se pudo obtener la URL del tunel.' -ForegroundColor Red
        Write-Host '=== LOG DE STDERR ===' -ForegroundColor Yellow
        if (Test-Path -LiteralPath $StderrFile) { Get-Content -LiteralPath $StderrFile -ErrorAction SilentlyContinue | Write-Host }
        Write-Host '=== LOG DE STDOUT ===' -ForegroundColor Yellow
        if (Test-Path -LiteralPath $StdoutFile) { Get-Content -LiteralPath $StdoutFile -ErrorAction SilentlyContinue | Write-Host }
        throw 'Cloudflared no proporciono una URL trycloudflare.com valida.'
    }

    # La URL puede aparecer en el log justo antes de que cloudflared termine
    # por un error de red, firewall, proxy o limitacion del servicio.
    $CloudflaredProc.Refresh()
    if ($CloudflaredProc.HasExited) {
        Write-Host ''
        Write-Host 'Cloudflared termino inmediatamente despues de generar la URL.' -ForegroundColor Red
        Write-Host '=== LOG DE STDERR ===' -ForegroundColor Yellow
        if (Test-Path -LiteralPath $StderrFile) { Get-Content -LiteralPath $StderrFile -ErrorAction SilentlyContinue | Write-Host }
        Write-Host '=== LOG DE STDOUT ===' -ForegroundColor Yellow
        if (Test-Path -LiteralPath $StdoutFile) { Get-Content -LiteralPath $StdoutFile -ErrorAction SilentlyContinue | Write-Host }
        throw 'El tunel ya no esta activo; la URL no puede utilizarse.'
    }

    Write-Host "    OK Tunel creado: $TunnelUrl" -ForegroundColor Green
    Write-Host ''
    Write-Box @('LISTO - Abriendo navegador...')
    Write-Host ''
    Write-Host "  Local:    http://127.0.0.1:$Port" -ForegroundColor Gray
    Write-Host "  Publico:  $TunnelUrl" -ForegroundColor Green
    Write-Host ''

    Start-Process -FilePath $TunnelUrl | Out-Null
    Write-Host '  Pulsa Ctrl+C para detener los procesos iniciados por este script.' -ForegroundColor Yellow
    Write-Host ''

    while ($true) {
        Start-Sleep -Seconds 5
        $ServerProc.Refresh()
        $CloudflaredProc.Refresh()

        if ($CloudflaredProc.HasExited) {
            Write-Host '[!] cloudflared ha terminado. La URL publica dejara de funcionar.' -ForegroundColor Red
            Write-Host '=== LOG DE STDERR ===' -ForegroundColor Yellow
            if (Test-Path -LiteralPath $StderrFile) { Get-Content -LiteralPath $StderrFile -ErrorAction SilentlyContinue | Write-Host }
            Write-Host '=== LOG DE STDOUT ===' -ForegroundColor Yellow
            if (Test-Path -LiteralPath $StdoutFile) { Get-Content -LiteralPath $StdoutFile -ErrorAction SilentlyContinue | Write-Host }
            break
        }

        if ($ServerProc.HasExited) {
            Write-Host '[!] Python ha terminado. La URL publica dejara de funcionar.' -ForegroundColor Red
            Write-Host '[!] Uno de los procesos ha terminado.' -ForegroundColor Yellow
            break
        }
    }
}
catch {
    Write-Host ''
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.InvocationInfo -and $_.InvocationInfo.PositionMessage) {
        Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor DarkRed
    }
}
finally {
    Write-Host ''
    Write-Host '[*] Deteniendo los procesos iniciados por este script...' -ForegroundColor Yellow
    Stop-StartedProcess -Process $CloudflaredProc -Name 'cloudflared'
    Stop-StartedProcess -Process $ServerProc -Name 'Python'
    Remove-TemporaryFiles
    Write-Host '[*] Detenido.' -ForegroundColor Green
}
