# CMDS ADMIN (`ADM_OBS` + `ADM_AUTH`) — Corporación Municipal de Desarrollo Social de Antofagasta

Sistema corporativo de Gestión Administrativa y Presupuestaria de CMDS Antofagasta, migrado desde Scriptcase/Oracle hacia **React 19 + TypeScript + Tailwind CSS + Node.js/Express 5 + PostgreSQL 18.6**.

## Características Principales
- **Puerto por defecto:** `3005` (`http://localhost:3005`)
- **Base de Datos PostgreSQL 18.6 (`192.168.30.48:5432`):** `bd_cmds_admin` (**280 tablas**, **863.902 filas reales** en `adm_obs` y `adm_auth`)
- **Módulos Implementados:**
  1. **Fase 0 y 1:** Dashboard Ejecutivo, Boletas de Honorarios (`BHO_BOLETAS`, `BHO_FLUJO_ESTADO`), Evidencias Mensuales (`BHO_EVIDENCIA`), Interfaces Contables Softland / Nómina Servipag y Mantenedor General.
  2. **Fase 2:** Oficina de Partes (`OPA_DOCUMENTOS`, `OPA_FLUJO`, `OPA_VALORADOS`), Órdenes de Servicio (`OPA_ORDEN_SERVICIO`) y Hoja de Ruta Presupuestaria / CDP (`HR_INICIATIVA`, `HR_HOJA_RUTA`, `HR_DISPONIBILIDAD_PPTO`).
  3. **Fase 3:** Integración Mercado Público (`MPU_ORDENES_CAB`, `MPU_ORDENES_DET`), Proyectos y Obras (`OTR_ITEMS_CONTRATISTA`), RRHH Salud APS / REM (`REGISTRO`, `OBS_TRAZABILIDAD`) y Agenda / Atención al Usuario.

## Ejecución Rápida
```powershell
# Iniciar únicamente CMDS ADMIN (:3005)
cd backend
node server.js

# O iniciar los 4 sistemas del ecosistema CMDS en un solo paso:
powershell -ExecutionPolicy Bypass -File .\iniciar-ecosistema-cmds.ps1
```
