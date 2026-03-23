# =========================
# HASEADITO
# Verificador de hashes SHA256
# Estilo retro / old school
# =========================

$Host.UI.RawUI.WindowTitle = "HASEADITO"

function Escribir-Maquina {
    param(
        [string]$Texto,
        [string]$Color = "Green",
        [int]$Velocidad = 15
    )

    foreach ($char in $Texto.ToCharArray()) {
        Write-Host -NoNewline $char -ForegroundColor $Color
        Start-Sleep -Milliseconds $Velocidad
    }

    Write-Host ""
}

function Escribir-Lento {
    param(
        [string]$Texto,
        [string]$Color = "DarkGreen",
        [int]$Velocidad = 6
    )

    foreach ($char in $Texto.ToCharArray()) {
        Write-Host -NoNewline $char -ForegroundColor $Color
        Start-Sleep -Milliseconds $Velocidad
    }

    Write-Host ""
}

function Barra-Progreso-Retro {
    param(
        [int]$Total = 24,
        [int]$Delay = 45,
        [string]$Color = "Green"
    )

    Write-Host -NoNewline "[" -ForegroundColor $Color
    for ($i = 1; $i -le $Total; $i++) {
        Write-Host -NoNewline "#" -ForegroundColor $Color
        Start-Sleep -Milliseconds $Delay
    }
    Write-Host "]" -ForegroundColor $Color
}

function Mostrar-Boot-Retro {
    Clear-Host

    $bootColor = "DarkGreen"
    $mainColor = "Green"

    Escribir-Lento "Phoenix ROM BIOS PLUS Version 1.10 A04" $bootColor 8
    Escribir-Lento "Copyright (C) 1985-1994 Phoenix Technologies Ltd." $bootColor 8
    Write-Host ""
    Escribir-Lento "CPU : IntelDX4 Compatible @ 100MHz" $bootColor 7
    Escribir-Lento "Base Memory Test : 640K OK" $bootColor 7
    Escribir-Lento "Extended Memory  : 16384K OK" $bootColor 7
    Escribir-Lento "Detecting IDE Primary Master ... OK" $bootColor 7
    Escribir-Lento "Detecting IDE Primary Slave  ... NONE" $bootColor 7
    Escribir-Lento "Detecting Floppy Drive A:    ... 1.44MB 3.5in" $bootColor 7
    Escribir-Lento "Initializing system services ............ OK" $bootColor 7
    Write-Host ""
    Escribir-Lento "Starting HASEADITO subsystem" $mainColor 10
    Barra-Progreso-Retro 30 35 $mainColor
    Start-Sleep -Milliseconds 300
    Clear-Host
}

function Mostrar-Cabecera {
    $color = "Green"
    Write-Host "============================================================" -ForegroundColor $color
    Write-Host "                     H A S E A D I T O                      " -ForegroundColor $color
    Write-Host "============================================================" -ForegroundColor $color
    Write-Host ""
    Escribir-Maquina "HASEADITO - Verificador de hashes SHA256" $color 18
    Escribir-Maquina "Creado por: Lic. Emanuel D'Amico" "DarkGreen" 18
    Write-Host ""
    Write-Host "------------------------------------------------------------" -ForegroundColor $color
    Write-Host ""
}

function Guardar-ReporteHtml {
    param(
        [array]$Resultados,
        [string]$RutaSalida
    )

    $html = @"
<html>
<head>
<meta charset='UTF-8'>
<title>hasheadito</title>
<style>
body {
    background-color: #000000;
    color: #00FF00;
    font-family: Consolas, 'Courier New', monospace;
    margin: 20px;
}
h2, h3 {
    color: #00FF00;
}
table {
    border-collapse: collapse;
    width: 100%;
}
th, td {
    border: 1px solid #00AA00;
    padding: 8px;
    text-align: left;
}
th {
    background-color: #001100;
}
.ok {
    background-color: #002200;
    color: #66FF66;
    font-weight: bold;
}
.bad {
    background-color: #220000;
    color: #FF6666;
    font-weight: bold;
}
pre {
    background-color: #001100;
    border: 1px solid #00AA00;
    padding: 10px;
    white-space: pre-wrap;
    word-break: break-all;
}
</style>
</head>
<body>
<h2>HASEADITO - Resultado de verificacion</h2>
<h3>Creado por: Lic. Emanuel D'Amico</h3>
<table>
<tr>
<th>Archivo</th>
<th>Estado</th>
<th>Hash calculado</th>
</tr>
"@

    foreach ($r in $Resultados) {
        $clase = if ($r.Estado -eq "MATCH") { "ok" } else { "bad" }

        $html += @"
<tr class='$clase'>
    <td>$($r.Archivo)</td>
    <td>$($r.Estado)</td>
    <td>$($r.HashCalculado)</td>
</tr>
"@
    }

    $html += @"
</table>
</body>
</html>
"@

    Set-Content -Path $RutaSalida -Value $html -Encoding UTF8
}

# =========================
# INICIO
# =========================

Mostrar-Boot-Retro
Mostrar-Cabecera

$carpetaPDF = Join-Path $PSScriptRoot "PDF"
$carpetaHASHES = Join-Path $PSScriptRoot "HASHES"

if (!(Test-Path $carpetaPDF)) {
    Write-Host "ERROR: No existe la carpeta PDF." -ForegroundColor Red
    exit 1
}

if (!(Test-Path $carpetaHASHES)) {
    Write-Host "ERROR: No existe la carpeta HASHES." -ForegroundColor Red
    exit 1
}

$archivoHashes = Get-ChildItem -Path $carpetaHASHES -Filter *.txt -File | Select-Object -First 1

if ($null -eq $archivoHashes) {
    Write-Host "ERROR: No se encontro ningun archivo .txt dentro de HASHES." -ForegroundColor Red
    exit 1
}

Write-Host "Archivo de hashes detectado: $($archivoHashes.Name)" -ForegroundColor Yellow
Write-Host ""

$hashesEsperados = Get-Content $archivoHashes.FullName |
    ForEach-Object { ($_ -replace '\s', '').Trim().ToUpper() } |
    Where-Object { $_ -ne "" }

if ($hashesEsperados.Count -eq 0) {
    Write-Host "ERROR: El archivo de hashes esta vacio." -ForegroundColor Red
    exit 1
}

$tablaHashes = @{}
foreach ($hash in $hashesEsperados) {
    if (-not $tablaHashes.ContainsKey($hash)) {
        $tablaHashes[$hash] = 0
    }
}

$pdfs = Get-ChildItem -Path $carpetaPDF -Filter *.pdf -File | Sort-Object Name

if ($pdfs.Count -eq 0) {
    Write-Host "ERROR: No se encontraron archivos PDF dentro de la carpeta PDF." -ForegroundColor Red
    exit 1
}

$resultados = @()

Write-Host "Iniciando verificacion..." -ForegroundColor Cyan
Write-Host ""

foreach ($pdf in $pdfs) {
    try {
        $hashCalculado = (Get-FileHash -Path $pdf.FullName -Algorithm SHA256).Hash.ToUpper()

        if ($tablaHashes.ContainsKey($hashCalculado)) {
            $tablaHashes[$hashCalculado]++
            Write-Host "[OK]        $($pdf.Name)" -ForegroundColor Green

            $resultados += [PSCustomObject]@{
                Archivo       = $pdf.Name
                Estado        = "MATCH"
                HashCalculado = $hashCalculado
            }
        }
        else {
            Write-Host "[NOT MATCH] $($pdf.Name)" -ForegroundColor Red

            $resultados += [PSCustomObject]@{
                Archivo       = $pdf.Name
                Estado        = "NOT MATCH"
                HashCalculado = $hashCalculado
            }
        }
    }
    catch {
        Write-Host "[ERROR]     $($pdf.Name)" -ForegroundColor Red

        $resultados += [PSCustomObject]@{
            Archivo       = $pdf.Name
            Estado        = "ERROR"
            HashCalculado = ""
        }
    }
}

$hashesNoUsados = $tablaHashes.GetEnumerator() |
    Where-Object { $_.Value -eq 0 } |
    ForEach-Object { $_.Key }

$match = ($resultados | Where-Object { $_.Estado -eq "MATCH" }).Count
$notMatch = ($resultados | Where-Object { $_.Estado -eq "NOT MATCH" }).Count
$error = ($resultados | Where-Object { $_.Estado -eq "ERROR" }).Count

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "RESUMEN FINAL" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Green
Write-Host "[MATCH]      $match" -ForegroundColor Green
Write-Host "[NOT MATCH]  $notMatch" -ForegroundColor Red
Write-Host "[ERROR]      $error" -ForegroundColor Red
Write-Host "[UNUSED HASH] $($hashesNoUsados.Count)" -ForegroundColor Yellow
Write-Host ""

$csvSalida = Join-Path $PSScriptRoot "hasheadito_resultado.csv"
$htmlSalida = Join-Path $PSScriptRoot "hasheadito_resultado.html"
$txtHashesSinUso = Join-Path $PSScriptRoot "hasheadito_hashes_sin_coincidencia.txt"

$resultados | Export-Csv -Path $csvSalida -NoTypeInformation -Encoding UTF8
$hashesNoUsados | Set-Content -Path $txtHashesSinUso -Encoding UTF8
Guardar-ReporteHtml -Resultados $resultados -RutaSalida $htmlSalida

Write-Host "Archivos generados:" -ForegroundColor Yellow
Write-Host " - hasheadito_resultado.csv" -ForegroundColor Yellow
Write-Host " - hasheadito_resultado.html" -ForegroundColor Yellow
Write-Host " - hasheadito_hashes_sin_coincidencia.txt" -ForegroundColor Yellow
Write-Host ""
Write-Host "Proceso finalizado." -ForegroundColor Cyan