<#
.SYNOPSIS
  Valida los SVG del proyecto IFCD0110.

.DESCRIPTION
  Recorre los documentos HTML del alcance y comprueba las reglas de calidad
  acordadas para los diagramas e iconos SVG:

    E001  fill/stroke con color literal (#hex) fuera de var(--token, fallback)
    E002  <svg> sin atributo viewBox
    E003  <svg role="img"> sin aria-labelledby
    E004  id duplicado dentro del mismo documento
    E005  id accesible generico ("title"/"desc") en lugar de uno prefijado
    W001  stroke-width fuera de la escala {1.2, 1.5, 2}
    W002  font-size fuera de la escala {9, 11, 13}
    W003  color literal fuera de la paleta de tokens del proyecto
    W004  aria-labelledby que referencia un id inexistente
    W005  fichero SVG externo con paleta propia (no tokenizada)

  Alcance y reglas aplicables:

    - SVG inline dentro de los 4 HTML: se aplican TODAS las reglas. Los
      diagramas inline heredan la hoja compartida (assets/css/shared.css), que
      define la escala y las utilidades de color; de ahi que E001 y las escalas
      W001-W003 sean obligatorias.
    - SVG externo en assets/svg/*.svg: son documentos independientes que NO
      heredan los tokens del sitio, asi que se comprueban solo las reglas
      estructurales y de accesibilidad (E002, E003, E004, E005 y W004). E001 y
      W001-W003 se omiten a proposito y se informa con W005, para que el coste
      sea visible y no una omision silenciosa.

  El fichero 'practica-gutenberg\index - copia.html' queda EXCLUIDO por
  decision explicita: no forma parte del alcance de 93 SVG y no se edita.

.PARAMETER Fail
  Devuelve codigo de salida 1 si hay alguna infraccion de nivel error.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File scripts\check-svg.ps1
  powershell -ExecutionPolicy Bypass -File scripts\check-svg.ps1 -Fail
#>
[CmdletBinding()]
param(
  [switch]$Fail
)

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot

$Targets = @(
  @{ Path = 'index.html';                     Module = 'root' },
  @{ Path = 'sesion-0\index.html';            Module = 'sesion' },
  @{ Path = 'practica-gutenberg\index.html';  Module = 'gutenberg' },
  @{ Path = 'practica-xampp\index.html';      Module = 'xampp' }
)

$Excluded = 'practica-gutenberg\index - copia.html'

$Palette = @(
  '#eef2f1','#ffffff','#fff','#0f1f1e','#47595a','#ccd6d4','#e2e9e7',
  '#0b6b52','#e5f1ec','#a8321f','#faece8','#8a5a00','#fdf4e3'
)

$StrokeKnown  = @('1.2','1.5','2','2.4')
$StrokeTarget = @('1.2','1.5','2')
$FontKnown    = @('9','10','11','12','13')
$FontTarget   = @('9','11','13')

$findings = New-Object System.Collections.Generic.List[object]

function Add-Finding {
  param(
    [string]$Severity, [string]$Code, [string]$File, [int]$Line,
    [string]$Message, [string]$Snippet = ''
  )
  $script:findings.Add([pscustomobject]@{
    Severity = $Severity; Code = $Code; File = $File; Line = $Line
    Message  = $Message; Snippet = $Snippet
  })
}

# Comprueba un documento SVG. $TokenRules decide si se exigen los tokens de
# color y la escala tipografica del sitio (solo para el SVG inline).
function Invoke-SvgChecks {
  param(
    [string[]]$Lines,
    [string]$Relative,
    [bool]$TokenRules
  )

  # --- ids duplicados -------------------------------------------------------
  $idHits = @{}
  for ($i = 0; $i -lt $Lines.Count; $i++) {
    foreach ($m in [regex]::Matches($Lines[$i], '\sid="([^"]+)"')) {
      $id = $m.Groups[1].Value
      if (-not $idHits.ContainsKey($id)) { $idHits[$id] = @() }
      $idHits[$id] += ($i + 1)
    }
  }
  foreach ($id in $idHits.Keys) {
    $hits = $idHits[$id]
    if ($hits.Count -gt 1) {
      Add-Finding -Severity 'ERROR' -Code 'E004' -File $Relative -Line $hits[0] `
        -Message "id duplicado '$id' en las lineas $($hits -join ', ')"
    }
    if ($id -in @('title','desc')) {
      Add-Finding -Severity 'ERROR' -Code 'E005' -File $Relative -Line $hits[0] `
        -Message "id accesible generico '$id': usar un id prefijado por modulo (p. ej. 'desk-t')"
    }
  }

  for ($i = 0; $i -lt $Lines.Count; $i++) {
    $line = $Lines[$i]
    $lineNo = $i + 1

    # --- <svg> sin viewBox / role sin aria-labelledby -----------------------
    # El contenedor oculto de <defs> (.svg-defs) es un almacen de recursos,
    # no un diagrama: no se valida como tal.
    if ($line -match '<svg\b' -and $line -notmatch 'class="[^"]*svg-defs') {
      if ($line -notmatch 'viewBox=') {
        Add-Finding -Severity 'ERROR' -Code 'E002' -File $Relative -Line $lineNo `
          -Message '<svg> sin atributo viewBox' -Snippet $line.Trim()
      }
      if ($line -match 'role="img"' -and $line -notmatch 'aria-labelledby=') {
        Add-Finding -Severity 'ERROR' -Code 'E003' -File $Relative -Line $lineNo `
          -Message 'svg role="img" sin aria-labelledby' -Snippet $line.Trim()
      }
    }

    if ($TokenRules) {
      # --- colores literales -------------------------------------------------
      foreach ($m in [regex]::Matches($line, '(fill|stroke)="(#[0-9a-fA-F]{3,8})"')) {
        $attr = $m.Groups[1].Value; $color = $m.Groups[2].Value.ToLower()
        Add-Finding -Severity 'ERROR' -Code 'E001' -File $Relative -Line $lineNo `
          -Message "$attr color literal '$color' sin var(--token, fallback)" -Snippet $line.Trim()
        if ($Palette -notcontains $color) {
          Add-Finding -Severity 'WARN' -Code 'W003' -File $Relative -Line $lineNo `
            -Message "color '$color' fuera de la paleta de tokens del proyecto"
        }
      }

      # --- escalas -----------------------------------------------------------
      foreach ($m in [regex]::Matches($line, 'stroke-width="([0-9.]+)"')) {
        $w = $m.Groups[1].Value
        if ($StrokeKnown -notcontains $w) {
          Add-Finding -Severity 'WARN' -Code 'W001' -File $Relative -Line $lineNo `
            -Message "stroke-width='$w' fuera de la escala objetivo {1.2, 1.5, 2}"
        }
      }
      foreach ($m in [regex]::Matches($line, 'font-size="([0-9.]+)"')) {
        $fs = $m.Groups[1].Value
        if ($FontKnown -notcontains $fs) {
          Add-Finding -Severity 'WARN' -Code 'W002' -File $Relative -Line $lineNo `
            -Message "font-size='$fs' fuera de la escala objetivo {9, 11, 13}"
        }
      }
    }
  }

  # --- aria-labelledby apunta a ids existentes -------------------------------
  $text = [string]::Join("`n", $Lines)
  foreach ($m in [regex]::Matches($text, 'aria-labelledby="([^"]+)"')) {
    foreach ($ref in ($m.Groups[1].Value -split '\s+')) {
      if ($ref -and -not $idHits.ContainsKey($ref)) {
        Add-Finding -Severity 'ERROR' -Code 'W004' -File $Relative -Line 1 `
          -Message "aria-labelledby referencia '$ref', que no existe en el documento"
      }
    }
  }

  # --- W005: paleta propia en un fichero externo -----------------------------
  if (-not $TokenRules) {
    $literales = @([regex]::Matches($text, '(fill|stroke)="#[0-9a-fA-F]{3,8}"')).Count
    if ($literales -gt 0) {
      Add-Finding -Severity 'WARN' -Code 'W005' -File $Relative -Line 1 `
        -Message "fichero SVG externo con $literales colores literales: se admiten (no hereda los tokens del sitio); solo el SVG inline debe tokenizarse"
    }
  }
}

# --- SVG inline en los HTML del alcance ---------------------------------------
foreach ($target in $Targets) {
  $full = Join-Path $Root $target.Path
  if (-not (Test-Path -LiteralPath $full)) {
    Write-Warning "No se encuentra: $($target.Path) (se omite)"
    continue
  }

  Invoke-SvgChecks -Lines (Get-Content -LiteralPath $full) `
                    -Relative $target.Path.Replace('\','/') `
                    -TokenRules $true
}

# --- SVG externos en assets/svg/ ------------------------------------------------
$svgDir = Join-Path $Root 'assets\svg'
if (Test-Path -LiteralPath $svgDir) {
  foreach ($file in (Get-ChildItem -LiteralPath $svgDir -Filter '*.svg' -File | Sort-Object Name)) {
    Invoke-SvgChecks -Lines (Get-Content -LiteralPath $file.FullName) `
                      -Relative "assets/svg/$($file.Name)" `
                      -TokenRules $false
  }
}

# --- informe ----------------------------------------------------------------
Write-Host ''
Write-Host '== IFCD0110 · validacion de SVG ==' -ForegroundColor Cyan
Write-Host "Excluido por decision: $Excluded"
Write-Host ''

if ($findings.Count -eq 0) {
  Write-Host 'Sin infracciones.' -ForegroundColor Green
  exit 0
}

$findings |
  Sort-Object File, Line, Code |
  Format-Table -AutoSize `
    @{Label='Sev';Expression={ if ($_.Severity -eq 'ERROR') { 'ERROR' } else { 'warn' } }},
    Code, File, Line, Message -Wrap | Out-String -Width 200 | Write-Host

$errors   = @($findings | Where-Object Severity -eq 'ERROR').Count
$warnings = @($findings | Where-Object Severity -eq 'WARN').Count
Write-Host "Errores: $errors   Avisos: $warnings" -ForegroundColor $(if ($errors) { 'Red' } else { 'Yellow' })

if ($Fail -and $errors -gt 0) { exit 1 }
exit 0
