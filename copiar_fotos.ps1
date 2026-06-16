# Copia las fotos subidas al chat a la carpeta img/ de la landing page
# Ejecutar con doble clic (o clic derecho → Ejecutar con PowerShell)

$uploads = "$env:APPDATA\Claude\local-agent-mode-sessions\1f2ad039-a815-4706-b424-0478adbfadfc\5c89b04a-36d1-409e-be20-4dd62c87685f\local_052a2b52-7641-4c93-8ba7-3b6ff46fafc1\uploads"
$destino = "$PSScriptRoot\img"

# Crear carpeta img si no existe
if (-not (Test-Path $destino)) {
    New-Item -ItemType Directory -Path $destino | Out-Null
    Write-Host "Carpeta img/ creada."
}

# Buscar imagenes en uploads
$imagenes = Get-ChildItem -Path $uploads -Include *.jpg,*.jpeg,*.png,*.webp -Recurse -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 3

if ($imagenes.Count -eq 0) {
    Write-Host "No se encontraron imagenes en la carpeta de subidas." -ForegroundColor Red
    Write-Host "Ruta buscada: $uploads"
    pause
    exit
}

$nombres = @("foto_00.jpg", "foto_01.jpg", "foto_02.jpg")
$i = 0
foreach ($img in $imagenes) {
    $dest = Join-Path $destino $nombres[$i]
    Copy-Item -Path $img.FullName -Destination $dest -Force
    Write-Host "✓ Copiado: $($img.Name) → img\$($nombres[$i])" -ForegroundColor Green
    $i++
}

Write-Host ""
Write-Host "¡Listo! Las $($imagenes.Count) fotos estan en la carpeta img/" -ForegroundColor Cyan
Write-Host "Recarga index.html en el navegador para verlas."
pause
