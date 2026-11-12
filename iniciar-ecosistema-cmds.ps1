<#
.SYNOPSIS
  Script Maestro de Inicio, Detención y Monitoreo del Ecosistema Corporativo CMDS (4 Sistemas PAD)
  Conectado al Servidor PostgreSQL 18.6 Dedicado: 192.168.30.48:5432

.DESCRIPTION
  Administra en un solo paso los 4 sistemas web independientes migrados desde Scriptcase/Oracle:
    1. CMDS ADMIN              -> http://localhost:3005 (BD: bd_cmds_admin)
    2. PADEDUCA                -> http://localhost:3006 (BD: bd_cmds_educa)
    3. CMDS RRHH               -> http://localhost:3007 (BD: bd_cmds_rhu)
    4. Portal Director + ADMETA-> http://localhost:3008 (BD: bd_cmds_portaldir)

.PARAMETER Accion
  'iniciar' (por defecto): Levanta los servicios que estén apagados y verifica salud.
  'reiniciar'            : Detiene y vuelve a levantar los 4 servicios.
  'detener'              : Detiene los 4 servicios.
  'estado'               : Muestra únicamente el panel de estado sin iniciar ni detener procesos.
#>

param(
  [ValidateSet('iniciar', 'reiniciar', 'detener', 'estado')]
  [string]$Accion = 'iniciar'
)

$ErrorActionPreference = 'SilentlyContinue'
$PG_HOST = '192.168.30.48'
$PG_PORT = 5432

$Sistemas = @(
  @{
    Id       = 1
    Nombre   = 'CMDS ADMIN (ADM_OBS + ADM_AUTH)'
    Puerto   = 3005
    BaseDatos= 'bd_cmds_admin'
    WorkDir  = 'C:\Users\rhormazabal\.gemini\antigravity\scratch\migracion-sistemas-pad\backend'
    Script   = 'server.js'
    Url      = 'http://localhost:3005'
  },
  @{
    Id       = 2
    Nombre   = 'PADEDUCA (ADM_EDUCA + ADM_NOTAS)'
    Puerto   = 3006
    BaseDatos= 'bd_cmds_educa'
    WorkDir  = 'C:\Users\rhormazabal\.gemini\antigravity\scratch\cmds-educa-web\backend'
    Script   = 'server.js'
    Url      = 'http://localhost:3006'
  },
  @{
    Id       = 3
    Nombre   = 'CMDS RRHH (ADM_RHU)'
    Puerto   = 3007
    BaseDatos= 'bd_cmds_rhu'
    WorkDir  = 'C:\Users\rhormazabal\.gemini\antigravity\scratch\cmds-rhu-web\backend'
    Script   = 'server.js'
    Url      = 'http://localhost:3007'
  },
  @{
    Id       = 4
    Nombre   = 'Portal Director + ADMETA'
    Puerto   = 3008
    BaseDatos= 'bd_cmds_portaldir'
    WorkDir  = 'C:\Users\rhormazabal\.gemini\antigravity\scratch\cmds-portaldir-web\backend'
    Script   = 'server.js'
    Url      = 'http://localhost:3008'
  }
)

function Get-ListeningPid([int]$Port) {
  $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($conn) { return $conn.OwningProcess }
  return $null
}

Write-Host ""
Write-Host "========================================================================================" -ForegroundColor Cyan
Write-Host "  ECOSISTEMA CORPORATIVO CMDS ANTOFAGASTA — GESTOR MAESTRO DE SERVICIOS PAD" -ForegroundColor White
Write-Host "  Servidor PostgreSQL 18.6 Dedicado: ${PG_HOST}:${PG_PORT}" -ForegroundColor Cyan
Write-Host "========================================================================================" -ForegroundColor Cyan

# 1. Verificar conectividad TCP con el servidor PostgreSQL 192.168.30.48:5432
$pgTest = Test-NetConnection -ComputerName $PG_HOST -Port $PG_PORT -WarningAction SilentlyContinue
if ($pgTest.TcpTestSucceeded) {
  Write-Host "  [OK] Conectividad con PostgreSQL (${PG_HOST}:${PG_PORT}): ACTIVA" -ForegroundColor Green
} else {
  Write-Host "  [ALERTA] No se pudo alcanzar PostgreSQL en ${PG_HOST}:${PG_PORT}. Verifique la red/VPN." -ForegroundColor Red
}
Write-Host ""

# 2. Detener servicios si la acción es 'detener' o 'reiniciar'
if ($Accion -eq 'detener' -or $Accion -eq 'reiniciar') {
  Write-Host "  -> Deteniendo servicios activos en puertos 3005..3008..." -ForegroundColor Yellow
  foreach ($sys in $Sistemas) {
    $procId = Get-ListeningPid -Port $sys.Puerto
    if ($procId) {
      Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
      Write-Host "     - Puerto $($sys.Puerto) ($($sys.Nombre)) detenido (PID $procId)." -ForegroundColor DarkYellow
    }
  }
  Start-Sleep -Seconds 2
}

# 3. Iniciar servicios si la acción es 'iniciar' o 'reiniciar'
if ($Accion -eq 'iniciar' -or $Accion -eq 'reiniciar') {
  Write-Host "  -> Verificando e iniciando los 4 sistemas corporativos CMDS..." -ForegroundColor Cyan
  foreach ($sys in $Sistemas) {
    $procId = Get-ListeningPid -Port $sys.Puerto
    if ($procId) {
      Write-Host "     - [YA ACTIVO] Puerto $($sys.Puerto): $($sys.Nombre) (PID $procId)" -ForegroundColor Green
    } else {
      Write-Host "     - [INICIANDO] Puerto $($sys.Puerto): $($sys.Nombre)..." -ForegroundColor Yellow
      $logOut = Join-Path $sys.WorkDir "service-$($sys.Puerto).log"
      $logErr = Join-Path $sys.WorkDir "service-$($sys.Puerto).err.log"
      Start-Process -FilePath "node.exe" `
        -ArgumentList $sys.Script `
        -WorkingDirectory $sys.WorkDir `
        -WindowStyle Hidden `
        -RedirectStandardOutput $logOut `
        -RedirectStandardError $logErr
    }
  }
  Start-Sleep -Seconds 3
}

# 4. Panel de Estado y Health Check HTTP de los 4 Portales
Write-Host ""
Write-Host "----------------------------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ("  {0,-6} {1,-34} {2,-19} {3,-8} {4,-10} {5}" -f "PUERTO", "SISTEMA", "BASE DE DATOS", "PID", "SALUD API", "URL ACCESO") -ForegroundColor White
Write-Host "----------------------------------------------------------------------------------------" -ForegroundColor DarkGray

foreach ($sys in $Sistemas) {
  $procId = Get-ListeningPid -Port $sys.Puerto
  $pidStr = if ($procId) { "$procId" } else { "-" }
  $healthStr = "APAGADO"
  $color = "Red"

  if ($procId) {
    try {
      $resp = Invoke-RestMethod -Uri "$($sys.Url)/api/health" -Method GET -TimeoutSec 4
      if ($resp.status -eq 'ok') {
        $healthStr = "ONLINE OK"
        $color = "Green"
      } else {
        $healthStr = "WARN"
        $color = "Yellow"
      }
    } catch {
      $healthStr = "SIN RESP"
      $color = "Yellow"
    }
  }

  Write-Host ("  :{0,-5} {1,-34} {2,-19} {3,-8} {4,-10} {5}" -f $sys.Puerto, $sys.Nombre, $sys.BaseDatos, $pidStr, $healthStr, $sys.Url) -ForegroundColor $color
}

Write-Host "----------------------------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "  Comandos disponibles:" -ForegroundColor Gray
Write-Host "    .\iniciar-ecosistema-cmds.ps1                  (Inicia los servicios caídos y muestra estado)" -ForegroundColor Gray
Write-Host "    .\iniciar-ecosistema-cmds.ps1 -Accion estado   (Solo consulta estado y salud API)" -ForegroundColor Gray
Write-Host "    .\iniciar-ecosistema-cmds.ps1 -Accion reiniciar(Reinicia los 4 sistemas)" -ForegroundColor Gray
Write-Host "    .\iniciar-ecosistema-cmds.ps1 -Accion detener  (Detiene los 4 sistemas)" -ForegroundColor Gray
Write-Host "========================================================================================" -ForegroundColor Cyan
Write-Host ""
