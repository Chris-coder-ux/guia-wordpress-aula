<#
.SYNOPSIS
  Valida la coherencia del rail, el indice de pasos y la persistencia del progreso.

.DESCRIPTION
  Recorre los 4 documentos HTML del proyecto y comprueba las invariantes
  acordadas para la navegacion por pasos y el guardado del progreso:

    E101  details.toc-mobile dentro de nav.rail: markup muerto (nunca visible)
    E102  el indice movil no ofrece un enlace por cada paso de la pagina
    E103  el indice movil y la lista #rail-list no coinciden (href, orden, etiqueta)
    E104  <main id="contenido"> sin tabindex="-1": el skip link no fija el foco
    E105  <div> como hijo directo de <ol>: HTML invalido
    E106  clase del subsistema rail usada en el HTML pero sin regla en shared.css
    E107  dos paginas comparten la misma clave de progreso o la misma clave de fuente
    E108  el 'total' de la configuracion no coincide con el numero de pasos
    E109  details.toc-mobile sin 'noprint': el indice se imprimiria
    E110  clave de progreso con un formato distinto de 'ifct0510-<modulo>-progress.vN'
    E111  el numero de pasos que anuncia el hero no coincide con los pasos reales
    E112  el titulo del rail ('Los N pasos') no coincide con los pasos reales
    E113  el resumen del indice movil ('... de los N pasos') no coincide con los reales
    W101  el rotulo del rail no comparte ninguna palabra con el titulo de su paso

  Este script NO ejecuta JavaScript: comprueba el HTML y el CSS de forma
  estatica. Las comprobaciones que dependen del navegador (geometria de la
  barra de progreso, foco real, migracion de localStorage) se verifican
  aparte con el navegador de pruebas.

  Avisos conocidos: son nivel 'warn', no hacen fallar el gate y no son
  infracciones. En sesion-0 los rotulos 'Descargas', 'Cuelgues', 'Checklist'
  y 'Ergonomia' son abreviaturas heredadas que no comparten palabra con el
  titulo de su paso; quedan listados para revision editorial.

.PARAMETER Fail
  Devuelve codigo de salida 1 si hay alguna infraccion de nivel error.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File scripts\check-ui.ps1
  powershell -ExecutionPolicy Bypass -File scripts\check-ui.ps1 -Fail
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

# Palabras vacias: no cuentan como coincidencia significativa entre el rotulo
# del rail y el titulo del paso.
$StopWords = @(
  'de','del','la','el','los','las','un','una','unos','unas','y','o','u','en',
  'para','por','con','al','a','se','su','sus','que','es','son','ser','lo','the',
  'of','to','and','your','you'
)

$findings = New-Object System.Collections.Generic.List[object]
$storage  = New-Object System.Collections.Generic.List[object]

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

# --- utilidades de texto ---------------------------------------------------

function Get-LineNumber {
  param([string]$Text, [int]$Index)
  if ($Index -le 0) { return 1 }
  $safe = [Math]::Min($Index, $Text.Length)
  return ($Text.Substring(0, $safe) -split "`n").Count
}

function Get-PlainText {
  param([string]$Html)
  if ([string]::IsNullOrEmpty($Html)) { return '' }
  $t = $Html -replace '<[^>]+>', ' '
  $t = $t -replace '&nbsp;', ' '
  $t = $t -replace '&', '&'
  $t = $t -replace '&[a-z]+;', ' '
  $t = $t -replace '\s+', ' '
  return $t.Trim()
}

function Get-Normalized {
  param([string]$Text)
  if ([string]::IsNullOrEmpty($Text)) { return '' }
  $t = $Text.ToLowerInvariant()
  $t = $t.Normalize([Text.NormalizationForm]::FormD)
  $t = [regex]::Replace($t, '[\u0300-\u036f]', '')
  $t = $t -replace '[^\p{L}\p{N}]', ' '
  $t = $t -replace '\s+', ' '
  return $t.Trim()
}

function Get-Tokens {
  param([string]$Text)
  $n = Get-Normalized $Text
  if (-not $n) { return @() }
  return @($n -split ' ' | Where-Object { $_ -and ($StopWords -notcontains $_) })
}

# Extrae los enlaces de un fragmento de HTML. El numero de orden se separa
# del rotulo porque el rail lo muestra en un <span class="n"> que el indice
# movil no lleva.
function Get-Links {
  param([string]$Html)
  $res = @()
  if ([string]::IsNullOrEmpty($Html)) { return $res }
  foreach ($m in [regex]::Matches($Html, '<a\b([^>]*)>([\s\S]*?)</a\s*>')) {
    $attrs = $m.Groups[1].Value
    $inner = $m.Groups[2].Value
    $href = ''
    if ($attrs -match 'href="([^"]*)"') { $href = $Matches[1] }
    $label = $inner -replace '<span\s+class="n">[^<]*</span>', ' '
    $res += [pscustomobject]@{
      Href  = $href
      Label = (Get-PlainText $label)
    }
  }
  return $res
}

# --- CSS compartido ---------------------------------------------------------

$cssPath = Join-Path $Root 'assets\css\shared.css'
$css = ''
if (Test-Path -LiteralPath $cssPath) {
  $css = Get-Content -LiteralPath $cssPath -Raw -Encoding UTF8
} else {
  Write-Warning "No se encuentra assets\css\shared.css"
}

function Test-CssRule {
  param([string]$Css, [string]$Class)
  if ([string]::IsNullOrEmpty($Css)) { return $false }
  return [regex]::IsMatch($Css, '\.' + [regex]::Escape($Class) + '(?![a-zA-Z0-9_-])')
}

# Devuelve el cuerpo de la primera regla que empieza por el selector dado,
# equilibando las llaves. Se usa para comparar los dos bloques del tema oscuro.
function Get-CssBlockBody {
  param([string]$Css, [string]$Selector)
  if ([string]::IsNullOrEmpty($Css)) { return $null }
  $idx = $Css.IndexOf($Selector)
  if ($idx -lt 0) { return $null }
  $open = $Css.IndexOf('{', $idx)
  if ($open -lt 0) { return $null }
  $depth = 0
  for ($i = $open; $i -lt $Css.Length; $i++) {
    $c = $Css[$i]
    if ($c -eq '{') { $depth++ }
    elseif ($c -eq '}') {
      $depth--
      if ($depth -eq 0) { return $Css.Substring($open + 1, $i - $open - 1) }
    }
  }
  return $null
}

# Normaliza un cuerpo de regla para comparar solo los valores declarados, no
# el formato (comentarios, saltos de linea y espacios).
function Get-CssDeclarations {
  param([string]$Body)
  if ($null -eq $Body) { return $null }
  $t = [regex]::Replace($Body, '/\*[\s\S]*?\*/', '')
  $t = [regex]::Replace($t, '\s+', '')
  return $t
}

# --- E114: los dos bloques del tema oscuro deben declarar lo mismo ------------
# El tema oscuro se declara dos veces en shared.css: una para la preferencia
# del sistema y otra para la eleccion manual (data-theme="dark"). Si las dos
# listas se desincronizan, el boton de tema y la pagina se ven distintos
# segun como se haya llegado al tema oscuro.
$darkSystem = Get-CssDeclarations (Get-CssBlockBody $css ':root:not([data-theme="light"])')
$darkManual = Get-CssDeclarations (Get-CssBlockBody $css ':root[data-theme="dark"]')
if ($null -eq $darkSystem) {
  Add-Finding -Severity 'ERROR' -Code 'E114' -File 'assets/css/shared.css' -Line 1 `
    -Message 'no se encuentra el bloque de tema oscuro por preferencia del sistema (:root:not([data-theme="light"]))'
} elseif ($null -eq $darkManual) {
  Add-Finding -Severity 'ERROR' -Code 'E114' -File 'assets/css/shared.css' -Line 1 `
    -Message 'no se encuentra el bloque de tema oscuro manual (:root[data-theme="dark"])'
} elseif ($darkSystem -ne $darkManual) {
  Add-Finding -Severity 'ERROR' -Code 'E114' -File 'assets/css/shared.css' -Line 1 `
    -Message 'los dos bloques de tema oscuro no declaran los mismos tokens: el tema manual se veria distinto del tema del sistema'
}

# --- E115: la clave de tema debe ser la misma en el <head> y en shared.js -----
# El <head> lleva un script en linea que aplica el tema guardado antes del
# primer pintado. Si su clave no coincide con la de shared.js, el boton
# guardaria la preferencia en un sitio y el <head> leeria otro.
$jsPath = Join-Path $Root 'assets\js\shared.js'
$js = ''
if (Test-Path -LiteralPath $jsPath) {
  $js = Get-Content -LiteralPath $jsPath -Raw -Encoding UTF8
}
$jsThemeKey = ''
if ($js -match "THEME_KEY\s*=\s*'([^']+)'") { $jsThemeKey = $Matches[1] }

# --- recorrido de las paginas ----------------------------------------------

foreach ($target in $Targets) {
  $full = Join-Path $Root $target.Path
  if (-not (Test-Path -LiteralPath $full)) {
    Write-Warning "No se encuentra: $($target.Path) (se omite)"
    continue
  }

  $text     = Get-Content -LiteralPath $full -Raw -Encoding UTF8
  $relative = $target.Path.Replace('\','/')

  # --- configuracion de IFCD0110 -------------------------------------------
  $cfgMatch = [regex]::Match($text, 'window\.IFCD0110\s*=\s*\{([\s\S]*?)\}')
  $cfgKey = ''; $cfgFontKey = ''; $cfgTotal = $null
  if ($cfgMatch.Success) {
    $cfg = $cfgMatch.Groups[1].Value
    if ($cfg -match '\bkey:\s*[''"]([^''"]+)[''"]')    { $cfgKey = $Matches[1] }
    if ($cfg -match '\bfontKey:\s*[''"]([^''"]+)[''"]') { $cfgFontKey = $Matches[1] }
    if ($cfg -match '\btotal:\s*(\d+)')                 { $cfgTotal = [int]$Matches[1] }
    $storage.Add([pscustomobject]@{
      Module = $target.Module; File = $relative
      Key = $cfgKey; FontKey = $cfgFontKey
    })
  }

  # --- numero de pasos -----------------------------------------------------
  $stepCount = [regex]::Matches($text, 'data-done="').Count

  # --- E108: 'total' de la configuracion frente a los pasos reales ----------
  if ($null -ne $cfgTotal -and $cfgTotal -ne $stepCount) {
    Add-Finding -Severity 'ERROR' -Code 'E108' -File $relative -Line 1 `
      -Message "la configuracion declara total=$cfgTotal pero la pagina tiene $stepCount pasos"
  }

  # --- E110: formato de la clave de progreso --------------------------------
  if ($cfgKey -and $cfgKey -notmatch '^ifct0510-[a-z0-9]+-progress\.v[0-9]+$') {
    Add-Finding -Severity 'ERROR' -Code 'E110' -File $relative -Line 1 `
      -Message "clave de progreso '$cfgKey' fuera del formato 'ifct0510-<modulo>-progress.vN'"
  }

  # --- E115: clave de tema coherente entre el <head> y shared.js --------------
  # El <head> lleva un script en linea que aplica el tema guardado antes del
  # primer pintado. Si su clave no coincide con la de shared.js, el boton
  # guardaria la preferencia en un sitio y el <head> leeria otro.
  $pageThemeKey = ''
  foreach ($m in [regex]::Matches($text, 'localStorage\.getItem\(\s*[''"]([^''"]+)[''"]\s*\)')) {
    if ($m.Groups[1].Value -match '^ifct0510-theme') { $pageThemeKey = $m.Groups[1].Value }
  }
  if (-not $pageThemeKey) {
    Add-Finding -Severity 'ERROR' -Code 'E115' -File $relative -Line 1 `
      -Message 'no se encuentra el script del <head> que aplica el tema guardado antes del primer pintado'
  } elseif ($pageThemeKey -notmatch '^ifct0510-theme\.v[0-9]+$') {
    Add-Finding -Severity 'ERROR' -Code 'E115' -File $relative -Line 1 `
      -Message "clave de tema '$pageThemeKey' fuera del formato 'ifct0510-theme.vN'"
  } elseif ($jsThemeKey -and $pageThemeKey -ne $jsThemeKey) {
    Add-Finding -Severity 'ERROR' -Code 'E115' -File $relative -Line 1 `
      -Message "el <head> usa la clave de tema '$pageThemeKey' y shared.js usa '$jsThemeKey': el tema guardado no se aplicaria al abrir la pagina"
  }

  # --- E116: boton de tema presente y con nombre accesible -------------------
  $toggleMatch = [regex]::Match($text, '<button\b[^>]*\bid="theme-toggle"[^>]*>')
  if (-not $toggleMatch.Success) {
    Add-Finding -Severity 'ERROR' -Code 'E116' -File $relative -Line 1 `
      -Message 'no hay boton #theme-toggle en la barra superior'
  } else {
    $toggleLine = Get-LineNumber $text $toggleMatch.Index
    if ($toggleMatch.Value -notmatch 'aria-label=') {
      Add-Finding -Severity 'ERROR' -Code 'E116' -File $relative -Line $toggleLine `
        -Message 'el boton #theme-toggle no tiene aria-label: un lector de pantalla no sabria que hace' `
        -Snippet $toggleMatch.Value
    }
    if ($toggleMatch.Value -notmatch 'title=') {
      Add-Finding -Severity 'WARN' -Code 'W116' -File $relative -Line $toggleLine `
        -Message 'el boton #theme-toggle no tiene title: el icono no explica su funcion a quien no lo distingue' `
        -Snippet $toggleMatch.Value
    }
  }

  # --- E111: el numero de pasos que anuncia el hero frente a los reales ------
  foreach ($m in [regex]::Matches($text, '<li\b[^>]*\bdata-state\b[^>]*>([\s\S]*?)</li\s*>')) {
    $heroLabel = Get-PlainText $m.Groups[1].Value
    if ($heroLabel -match '(\d+)') {
      $heroCount = [int]$Matches[1]
      if ($heroCount -ne $stepCount) {
        Add-Finding -Severity 'ERROR' -Code 'E111' -File $relative `
          -Line (Get-LineNumber $text $m.Index) `
          -Message "el hero anuncia '$heroLabel' pero la pagina tiene $stepCount pasos"
      }
    }
  }

  # --- E104: main#contenido con tabindex -------------------------------------
  $mainMatch = [regex]::Match($text, '<main\b[^>]*\bid="contenido"[^>]*>')
  if ($mainMatch.Success -and $mainMatch.Value -notmatch 'tabindex="-1"') {
    Add-Finding -Severity 'ERROR' -Code 'E104' -File $relative `
      -Line (Get-LineNumber $text $mainMatch.Index) `
      -Message '<main id="contenido"> sin tabindex="-1": el skip link no fija el foco en el contenido' `
      -Snippet $mainMatch.Value
  }

  # --- E105: <div> hijo directo de <ol> --------------------------------------
  foreach ($m in [regex]::Matches($text, '<ol\b[^>]*>\s*<div\b')) {
    Add-Finding -Severity 'ERROR' -Code 'E105' -File $relative `
      -Line (Get-LineNumber $text $m.Index) `
      -Message '<div> como hijo directo de <ol>: HTML invalido' `
      -Snippet ($m.Value -replace '\s+', ' ')
  }

  # --- E106: clases del subsistema rail sin regla en shared.css -------------
  $railClasses = @()
  foreach ($m in [regex]::Matches($text, 'class="([^"]*)"')) {
    foreach ($cls in ($m.Groups[1].Value -split '\s+')) {
      if ($cls -and ($cls -match '^rail($|__)' -or $cls -eq 'toc-mobile')) {
        if ($railClasses -notcontains $cls) { $railClasses += $cls }
      }
    }
  }
  foreach ($cls in ($railClasses | Sort-Object)) {
    if (-not (Test-CssRule $css $cls)) {
      Add-Finding -Severity 'ERROR' -Code 'E106' -File $relative -Line 1 `
        -Message "clase '$cls' usada en el HTML pero sin regla en assets\css\shared.css"
    }
  }

  # --- rail y lista de pasos -------------------------------------------------
  $railMatch = [regex]::Match($text, '<nav\b[^>]*\bclass="[^"]*\brail\b[^"]*"[^>]*>')
  $railStart = -1; $railEnd = -1
  if ($railMatch.Success) {
    $railStart = $railMatch.Index
    $closeNav = $text.IndexOf('</nav>', $railStart)
    if ($closeNav -gt 0) { $railEnd = $closeNav }
  }

  $listMatch = [regex]::Match($text, '<ol\b[^>]*\bid="rail-list"[^>]*>')
  $railListLinks = @()
  if ($listMatch.Success) {
    $closeOl = $text.IndexOf('</ol>', $listMatch.Index)
    if ($closeOl -gt 0) {
      $railListLinks = @(Get-Links $text.Substring($listMatch.Index, $closeOl - $listMatch.Index))
    }
  }

  # --- E112: el titulo del rail frente a los pasos reales -------------------
  if ($railStart -ge 0 -and $railEnd -gt $railStart) {
    $railInner = $text.Substring($railStart, $railEnd - $railStart)
    $h2Match = [regex]::Match($railInner, '<h2\b[^>]*>([\s\S]*?)</h2\s*>')
    if ($h2Match.Success) {
      $railTitle = Get-PlainText $h2Match.Groups[1].Value
      if ($railTitle -match '(\d+)') {
        $railCount = [int]$Matches[1]
        if ($railCount -ne $stepCount) {
          Add-Finding -Severity 'ERROR' -Code 'E112' -File $relative `
            -Line (Get-LineNumber $text ($railStart + $h2Match.Index)) `
            -Message "el rail titula '$railTitle' pero la pagina tiene $stepCount pasos"
        }
      }
    }
  }

  # --- bloques del indice movil ----------------------------------------------
  $tocBlocks = @()
  foreach ($m in [regex]::Matches($text, '<details\b[^>]*\bclass="[^"]*\btoc-mobile\b[^"]*"[^>]*>')) {
    $start = $m.Index
    $close = $text.IndexOf('</details>', $start)
    if ($close -lt 0) { continue }
    $inner = $text.Substring($start, $close - $start)
    $tocBlocks += [pscustomobject]@{
      Start      = $start
      Line       = (Get-LineNumber $text $start)
      OpenTag    = $m.Value
      Inner      = $inner
      InsideRail = ($railStart -ge 0 -and $start -gt $railStart -and $close -lt $railEnd)
      Links      = @(Get-Links $inner)
    }
  }

  foreach ($toc in $tocBlocks) {
    # E101: indice movil dentro del rail (nunca visible: el rail se oculta)
    if ($toc.InsideRail) {
      Add-Finding -Severity 'ERROR' -Code 'E101' -File $relative -Line $toc.Line `
        -Message 'details.toc-mobile dentro de nav.rail: @media (max-width:1080px) oculta el rail, asi que este indice nunca se ve' `
        -Snippet $toc.OpenTag
    }
    # E109: el indice movil se imprimiria
    if ($toc.OpenTag -notmatch 'noprint') {
      Add-Finding -Severity 'ERROR' -Code 'E109' -File $relative -Line $toc.Line `
        -Message 'details.toc-mobile sin la clase noprint: el indice aparece en la impresion en A4' `
        -Snippet $toc.OpenTag
    }
  }

  # --- E113: el resumen del indice movil frente a los pasos reales ---------
  foreach ($toc in $tocBlocks) {
    if ($toc.InsideRail) { continue }
    $sumMatch = [regex]::Match($toc.Inner, '<summary\b[^>]*>([\s\S]*?)</summary\s*>')
    if (-not $sumMatch.Success) { continue }
    $sumText = Get-PlainText $sumMatch.Groups[1].Value
    if ($sumText -match '(\d+)') {
      $sumCount = [int]$Matches[1]
      if ($sumCount -ne $stepCount) {
        Add-Finding -Severity 'ERROR' -Code 'E113' -File $relative `
          -Line (Get-LineNumber $text ($toc.Start + $sumMatch.Index)) `
          -Message "el indice movil anuncia '$sumText' pero la pagina tiene $stepCount pasos"
      }
    }
  }

  # --- E102 / E103: el indice movil fuera del rail debe cubrir los pasos ----
  if ($stepCount -gt 0) {
    $outerTocs = @($tocBlocks | Where-Object { -not $_.InsideRail })
    $outerLinks = @()
    foreach ($toc in $outerTocs) { $outerLinks += $toc.Links }

    if ($outerTocs.Count -eq 0) {
      Add-Finding -Severity 'ERROR' -Code 'E102' -File $relative -Line 1 `
        -Message "no hay indice de pasos fuera del rail: en movil (rail oculto) los $stepCount pasos no tienen indice"
    } elseif ($outerLinks.Count -ne $stepCount) {
      Add-Finding -Severity 'ERROR' -Code 'E102' -File $relative `
        -Line $outerTocs[0].Line `
        -Message "el indice movil tiene $($outerLinks.Count) enlaces y la pagina tiene $stepCount pasos"
    }

    if ($outerTocs.Count -gt 0 -and $railListLinks.Count -gt 0) {
      $max = [Math]::Max($outerLinks.Count, $railListLinks.Count)
      for ($i = 0; $i -lt $max; $i++) {
        $a = if ($i -lt $outerLinks.Count) { $outerLinks[$i] } else { $null }
        $b = if ($i -lt $railListLinks.Count) { $railListLinks[$i] } else { $null }
        if ($null -eq $a -or $null -eq $b) {
          Add-Finding -Severity 'ERROR' -Code 'E103' -File $relative -Line $outerTocs[0].Line `
            -Message "el indice movil y la lista del rail tienen distinto numero de entradas (posicion $($i + 1))"
          break
        }
        if ($a.Href -ne $b.Href) {
          Add-Finding -Severity 'ERROR' -Code 'E103' -File $relative -Line $outerTocs[0].Line `
            -Message "el indice movil apunta a '$($a.Href)' y la lista del rail a '$($b.Href)' (posicion $($i + 1))"
        }
        if ((Get-Normalized $a.Label) -ne (Get-Normalized $b.Label)) {
          Add-Finding -Severity 'ERROR' -Code 'E103' -File $relative -Line $outerTocs[0].Line `
            -Message "el indice movil dice '$($a.Label)' y la lista del rail '$($b.Label)' (posicion $($i + 1))"
        }
      }
    }
  }

  # --- W101: el rotulo del rail frente al titulo del paso ---------------------
  if ($railListLinks.Count -gt 0) {
    foreach ($link in $railListLinks) {
      if ($link.Href -notmatch '^#paso-(\d+)$') { continue }
      $stepId = $Matches[1]
      $titleMatch = [regex]::Match(
        $text,
        'id="paso-' + $stepId + '"[\s\S]{0,4000}?class="step__title"[^>]*>([\s\S]*?)</h3>'
      )
      if (-not $titleMatch.Success) { continue }
      $title = Get-PlainText $titleMatch.Groups[1].Value

      $labelTokens = @(Get-Tokens $link.Label)
      $titleTokens = @(Get-Tokens $title)
      if ($labelTokens.Count -eq 0 -or $titleTokens.Count -eq 0) { continue }

      $shared = @($labelTokens | Where-Object { $titleTokens -contains $_ })
      if ($shared.Count -eq 0) {
        Add-Finding -Severity 'WARN' -Code 'W101' -File $relative `
          -Line (Get-LineNumber $text $titleMatch.Index) `
          -Message "el rotulo del rail '$($link.Label)' no comparte ninguna palabra con el titulo del paso '$title'"
      }
    }
  }
}

# --- E107: claves de almacenamiento compartidas entre paginas ----------------
foreach ($kind in @('Key', 'FontKey')) {
  $groups = $storage | Where-Object { $_.$kind } | Group-Object -Property $kind
  foreach ($g in $groups) {
    if ($g.Count -gt 1) {
      $where = ($g.Group | ForEach-Object { $_.Module }) -join ', '
      Add-Finding -Severity 'ERROR' -Code 'E107' -File 'assets/js/shared.js' -Line 1 `
        -Message "la $kind '$($g.Name)' la comparten varias paginas ($where): el progreso o la fuente se cruzan entre modulos"
    }
  }
}

# --- informe -----------------------------------------------------------------
Write-Host ''
Write-Host '== IFCD0110 · validacion de UI (rail / indice / progreso) ==' -ForegroundColor Cyan
Write-Host "Paginas comprobadas: $($Targets.Count)   Modulos: $($storage.Count)"
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
