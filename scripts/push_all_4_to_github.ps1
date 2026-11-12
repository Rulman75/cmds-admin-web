$ErrorActionPreference = 'Stop'

# 1. Obtener token desde Git Credential Manager
$credLines = "protocol=https`nhost=github.com`n`n" | git credential fill
$ghUser = ($credLines | Where-Object { $_ -like "username=*" }) -replace "^username=", ""
$ghToken = ($credLines | Where-Object { $_ -like "password=*" }) -replace "^password=", ""

if (-not $ghToken) {
  throw "No se encontró credencial de GitHub en Git Credential Manager."
}

$headers = @{
  Authorization = "Bearer $ghToken"
  Accept        = "application/vnd.github+json"
  "User-Agent"  = "Antigravity-CMDS-Backup"
}

$Proyectos = @(
  @{
    RepoName    = "cmds-admin-web"
    LocalPath   = "C:\Users\rhormazabal\.gemini\antigravity\scratch\migracion-sistemas-pad"
    Description = "Sistema Corporativo CMDS ADMIN (ADM_OBS + ADM_AUTH) - Boletas de Honorarios, Oficina de Partes, Orden de Servicio, Hoja de Ruta, Mercado Publico y Salud APS (PostgreSQL 18.6 - Puerto 3005)"
  },
  @{
    RepoName    = "cmds-educa-web"
    LocalPath   = "C:\Users\rhormazabal\.gemini\antigravity\scratch\cmds-educa-web"
    Description = "Sistema Corporativo PADEDUCA (ADM_EDUCA + ADM_NOTAS) - Gestion Escolar, Matriculas, Libro de Clases Digital Circular N30, PIE, SIGE MINEDUC y Convivencia (PostgreSQL 18.6 - Puerto 3006)"
  },
  @{
    RepoName    = "cmds-rhu-web"
    LocalPath   = "C:\Users\rhormazabal\.gemini\antigravity\scratch\cmds-rhu-web"
    Description = "Sistema Corporativo CMDS RRHH (ADM_RHU) - Gestion de Recursos Humanos, Contratos, Carrera Funcionaria, Bolsa de Trabajo BTR, Licencias y Remuneraciones (PostgreSQL 18.6 - Puerto 3007)"
  },
  @{
    RepoName    = "cmds-portaldir-web"
    LocalPath   = "C:\Users\rhormazabal\.gemini\antigravity\scratch\cmds-portaldir-web"
    Description = "Sistema Corporativo Portal Director + ADMETA (ADM_PORTALDIR + ADMETA) - Inteligencia Escolar Comunal (53 RBDs), Subvenciones, Riesgo Escolar y Encuestas (PostgreSQL 18.6 - Puerto 3008)"
  }
)

foreach ($p in $Proyectos) {
  Write-Host "`n==========================================================================" -ForegroundColor Cyan
  Write-Host "Procesando $($p.RepoName) ($($p.LocalPath))..." -ForegroundColor Cyan
  Write-Host "==========================================================================" -ForegroundColor Cyan

  # Verificar si el repo ya existe en GitHub; si no, crearlo
  $repoUrl = "https://api.github.com/repos/$ghUser/$($p.RepoName)"
  $exists = $false
  try {
    $null = Invoke-RestMethod -Uri $repoUrl -Headers $headers -Method GET
    $exists = $true
    Write-Host "  [GitHub] El repositorio $ghUser/$($p.RepoName) ya existe." -ForegroundColor Yellow
  } catch {
    $exists = $false
  }

  if (-not $exists) {
    $body = @{
      name        = $p.RepoName
      description = $p.Description
      private     = $false
      auto_init   = $false
    } | ConvertTo-Json -Compress
    $created = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers -Method POST -Body $body -ContentType "application/json; charset=utf-8"
    Write-Host "  [GitHub] Repositorio creado: $($created.html_url)" -ForegroundColor Green
  }

  Set-Location $p.LocalPath

  if (-not (Test-Path (Join-Path $p.LocalPath ".git"))) {
    git init -b main | Out-Null
  } else {
    git branch -M main | Out-Null
  }

  $remoteUrl = "https://github.com/$ghUser/$($p.RepoName).git"
  $existingRemote = git remote 2>$null
  if ($existingRemote -contains "origin") {
    git remote set-url origin $remoteUrl
  } else {
    git remote add origin $remoteUrl
  }

  git add -A
  $status = git status --porcelain
  if ($status) {
    git commit -m "Respaldo completo $($p.RepoName) migrado a PostgreSQL 18.6 (192.168.30.48:5432)" | Out-Null
    Write-Host "  [Git] Commit local creado exitosamente." -ForegroundColor Green
  } else {
    Write-Host "  [Git] Sin cambios pendientes para commit." -ForegroundColor Gray
  }

  git push -u origin main --force
  Write-Host "  [OK] Push completado a https://github.com/$ghUser/$($p.RepoName)" -ForegroundColor Green
}
