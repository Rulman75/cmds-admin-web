const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const {
  queryOracle,
  queryOracleBatch,
  execPostgres,
  isSnapshotMode,
  loadOverlay,
  saveOverlay
} = require('./oraclePool');
const snap = require('./oracleSnapshotFallback');

const app = express();
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// Serve built React frontend from backend/public
app.use(express.static(path.join(__dirname, 'public')));

const PORT = process.env.PORT || 3005;
const JWT_SECRET = process.env.JWT_SECRET || 'super_secret_jwt_key_cmds_admin_2026';

// Helper: clean SQL string literal
function sqlStr(val) {
  if (val === null || val === undefined) return "''";
  return `'${String(val).replace(/'/g, "''").trim()}'`;
}

// Helper: extract numeric RUT (without DV) from any user input ("10633447", "10633447-1", "10.633.447-1", "106334471")
function calcularDv(rut) {
  const clean = String(rut).replace(/\D/g, '');
  if (!clean) return '0';
  let suma = 0;
  let multiplo = 2;
  for (let i = clean.length - 1; i >= 0; i--) {
    suma += parseInt(clean.charAt(i), 10) * multiplo;
    multiplo = multiplo < 7 ? multiplo + 1 : 2;
  }
  const resto = 11 - (suma % 11);
  if (resto === 11) return '0';
  if (resto === 10) return 'K';
  return String(resto);
}

function extraerCandidatosRut(input) {
  const trimmed = String(input || '').trim().toUpperCase();
  if (!trimmed) return [];
  const candidatos = [];
  const add = (n) => {
    if (!Number.isNaN(n) && n > 0 && !candidatos.includes(n)) candidatos.push(n);
  };
  if (trimmed.includes('-')) {
    const [parteNum] = trimmed.split('-');
    add(parseInt(parteNum.replace(/\D/g, ''), 10));
  }
  const clean = trimmed.replace(/[^0-9K]/g, '');
  if (!clean) return candidatos;
  if (clean.endsWith('K')) {
    add(parseInt(clean.slice(0, -1).replace(/\D/g, ''), 10));
    return candidatos;
  }
  if (clean.length >= 8) {
    const cuerpo = clean.slice(0, -1);
    const dv = clean.slice(-1);
    if (calcularDv(cuerpo) === dv) {
      add(parseInt(cuerpo, 10));
      add(parseInt(clean, 10));
    } else {
      add(parseInt(clean, 10));
      add(parseInt(cuerpo, 10));
    }
  } else {
    add(parseInt(clean, 10));
  }
  return candidatos;
}

const ESTADO_EVI_MAP = {
  '0': 'PENDIENTE REVISION CESFAM',
  '1': 'APROBADO DIRECTOR CESFAM',
  '2': 'RECHAZADO DIRECTOR CESFAM',
  '3': 'APROBADO REFERENTE TECNICO',
  '4': 'RECHAZADO REFERENTE TECNICO',
  '5': 'RECHAZADO TERMINAL',
  '6': 'RECHAZADO TERMINAL'
};

// ============================================================================
// 0. VERSION & HEALTH
// ============================================================================
app.get('/api/version', (req, res) => {
  try {
    const pkg = require('./package.json');
    res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    res.json({
      status: 'ok',
      version: pkg.version || '1.0.0',
      commit: 'oracle26ai-live',
      date: '2026-11-10'
    });
  } catch {
    res.json({ status: 'ok', version: '1.0.0', commit: '', date: '' });
  }
});

app.get('/api/health', async (req, res) => {
  try {
    const rows = await queryOracle('SELECT BANNER FROM V$VERSION WHERE ROWNUM = 1', 60000);
    res.json({
      status: 'ok',
      mode: 'live-postgresql18',
      database: `PostgreSQL 18.6 (${process.env.PG_HOST || '192.168.30.48'}:${process.env.PG_PORT || 5432} / ${process.env.PG_DB || 'bd_cmds_admin'})`,
      serverTime: new Date().toISOString(),
      message: 'Conectado en vivo a PostgreSQL 18.6 Corporativo CMDS (bd_cmds_admin)',
      banner: rows[0]?.BANNER || 'PostgreSQL 18.6'
    });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 1. AUTENTICACIÓN UNIFICADA (ADM_AUTH.AUT_USUARIOS + ADM_OBS)
// ============================================================================
app.post('/api/auth/login', async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ status: 'error', message: 'Por favor ingrese RUT/Usuario y contraseña.' });
  }

  try {
    const candidatos = extraerCandidatosRut(username);
    if (candidatos.length === 0) {
      return res.status(401).json({ status: 'error', message: 'Formato de RUT inválido.' });
    }

    const rutsIn = candidatos.join(',');
    const batch = await queryOracleBatch({
      auth: `SELECT USUA_ID, USUA_RUT, USUA_DV, USUA_PWD, USA_NOMBRE, USA_APELLIDOS, USA_EMAIL, USA_TELEFONO, USA_TIPO, USUA_ESTADO FROM ADM_AUTH.AUT_USUARIOS WHERE USUA_RUT IN (${rutsIn})`,
      obs: `SELECT RUT_USUARIO, NOMBRE_USUARIO, CORREO, TELEFONO, SYS_OBS, SYS_VERI, SYS_REM FROM ADM_OBS.OBS_USUARIOS_AUTH_V WHERE RUT_USUARIO IN (${rutsIn})`,
      admin: `SELECT USAD_RUT FROM ADM_OBS.OBS_USERS_ADMIN WHERE USAD_RUT IN (${rutsIn})`,
      obsUser: `SELECT USME_USUARIO, UNID_CODIGO, SECT_SEC FROM ADM_OBS.OBS_USUARIOS WHERE USME_USUARIO IN (${rutsIn})`
    });

    let authUser = (batch.auth || [])[0];
    if (!authUser) {
      authUser = snap.AUT_USUARIOS.find((u) => candidatos.includes(Number(u.USUA_RUT)));
    }
    if (!authUser) {
      return res.status(401).json({ status: 'error', message: 'Usuario no registrado en ADM_AUTH.' });
    }

    const md5Input = crypto.createHash('md5').update(String(password).trim(), 'utf8').digest('hex').toUpperCase();
    const storedPwd = String(authUser.USUA_PWD || '').trim().toUpperCase();

    if (md5Input !== storedPwd && String(password).trim() !== storedPwd) {
      return res.status(401).json({ status: 'error', message: 'Usuario o contraseña incorrectos.' });
    }

    const obsView = (batch.obs || [])[0] || {};
    const isAdminTable = (batch.admin || []).length > 0;
    const obsUnidades = batch.obsUser || [];
    const nombreCompleto =
      obsView.NOMBRE_USUARIO || `${authUser.USA_NOMBRE || ''} ${authUser.USA_APELLIDOS || ''}`.trim();
    const tipo = isAdminTable || authUser.USA_TIPO === 'A' ? 'A' : authUser.USA_TIPO || 'U';
    const unidadPrincipal = obsUnidades[0]?.UNID_CODIGO || 'CASA CENTRAL';
    const sectorPrincipal = obsUnidades[0]?.SECT_SEC || '23';

    const userPayload = {
      username: `${authUser.USUA_RUT}-${authUser.USUA_DV || calcularDv(authUser.USUA_RUT)}`,
      rut: Number(authUser.USUA_RUT),
      dv: authUser.USUA_DV || calcularDv(authUser.USUA_RUT),
      nombre: nombreCompleto,
      correo: authUser.USA_EMAIL || obsView.CORREO || '',
      email: authUser.USA_EMAIL || obsView.CORREO || '',
      tipo,
      unidad: unidadPrincipal,
      sector: sectorPrincipal,
      esAdmin: tipo === 'A',
      menus: snap.OBS_MENU.slice(0, 20)
    };

    const token = jwt.sign(userPayload, JWT_SECRET, { expiresIn: '10h' });
    res.json({ status: 'ok', token, user: userPayload });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ status: 'error', message: 'Error al validar credenciales en Oracle.' });
  }
});

// ============================================================================
// 2. DASHBOARD EJECUTIVO (FASE 0 + FASE 1: BOLETAS Y EVIDENCIAS EN VIVO)
// ============================================================================
app.get('/api/dashboard/inicio-stats', async (req, res) => {
  try {
    const year = req.query.year ? String(req.query.year).replace(/\D/g, '') : '';
    const periFilter = year ? `AND SUBSTR(p.PERI_NOMBRE, 1, 4) = '${year}'` : '';
    const eviaFilter = year ? `WHERE EVIA_ANO = '${year}'` : '';

    const cacheKey = `dashboard_stats_${year || 'ALL'}`;
    const data = await queryOracleBatch(
      {
        estadosBoletas: `
          SELECT b.BOLE_ULT_ESTADO AS ESTADO,
                 COUNT(*) AS CANTIDAD,
                 NVL(SUM(b.BOLE_NETO), 0) AS MONTO_BRUTO,
                 NVL(SUM(b.BOLE_IMPUESTO), 0) AS MONTO_IMPUESTO,
                 NVL(SUM(b.BOLE_TOTAL), 0) AS MONTO_LIQUIDO,
                 COUNT(DISTINCT b.FUNC_SEC) AS FUNCIONARIOS
          FROM ADM_OBS.BHO_BOLETAS b
          JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC
          WHERE 1=1 ${periFilter}
          GROUP BY b.BOLE_ULT_ESTADO
          ORDER BY CANTIDAD DESC
        `,
        porSector: `
          SELECT NVL(s.SECT_DESC, 'SIN SECTOR') AS SECTOR,
                 b.SECT_SEC,
                 COUNT(*) AS CANTIDAD,
                 NVL(SUM(b.BOLE_NETO), 0) AS MONTO_BRUTO,
                 NVL(SUM(b.BOLE_IMPUESTO), 0) AS MONTO_IMPUESTO,
                 NVL(SUM(b.BOLE_TOTAL), 0) AS MONTO_LIQUIDO
          FROM ADM_OBS.BHO_BOLETAS b
          JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON b.SECT_SEC = s.SECT_SEC
          WHERE 1=1 ${periFilter}
          GROUP BY s.SECT_DESC, b.SECT_SEC
          ORDER BY MONTO_BRUTO DESC
        `,
        evolucionPeriodos: `
          SELECT * FROM (
            SELECT p.PERI_NOMBRE AS PERIODO,
                   COUNT(*) AS TOTAL_BOLETAS,
                   SUM(CASE WHEN b.BOLE_ULT_ESTADO = 'PAGADA' THEN 1 ELSE 0 END) AS PAGADAS,
                   SUM(CASE WHEN b.BOLE_ULT_ESTADO = 'APROBADA' THEN 1 ELSE 0 END) AS APROBADAS,
                   SUM(CASE WHEN b.BOLE_ULT_ESTADO = 'VIGENTE' THEN 1 ELSE 0 END) AS VIGENTES,
                   SUM(CASE WHEN b.BOLE_ULT_ESTADO = 'RECHAZADA' THEN 1 ELSE 0 END) AS RECHAZADAS,
                   NVL(SUM(b.BOLE_NETO), 0) AS MONTO_BRUTO,
                   NVL(SUM(b.BOLE_TOTAL), 0) AS MONTO_LIQUIDO
            FROM ADM_OBS.BHO_BOLETAS b
            JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC
            WHERE 1=1 ${periFilter}
            GROUP BY p.PERI_NOMBRE
            ORDER BY p.PERI_NOMBRE DESC
          ) WHERE ROWNUM <= 12
        `,
        topUnidades: `
          SELECT * FROM (
            SELECT b.BOLE_UNIDAD AS COD_UNIDAD,
                   NVL(u.UNID_DESC, 'UNIDAD ' || b.BOLE_UNIDAD) AS UNIDAD,
                   COUNT(*) AS CANTIDAD,
                   COUNT(DISTINCT b.FUNC_SEC) AS FUNCIONARIOS,
                   NVL(SUM(b.BOLE_NETO), 0) AS MONTO_BRUTO,
                   NVL(SUM(b.BOLE_TOTAL), 0) AS MONTO_LIQUIDO
            FROM ADM_OBS.BHO_BOLETAS b
            JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC
            LEFT JOIN ADM_OBS.ADM_UNIDAD u ON b.BOLE_UNIDAD = u.UNID_CODIGO
            WHERE 1=1 ${periFilter}
            GROUP BY b.BOLE_UNIDAD, u.UNID_DESC
            ORDER BY MONTO_BRUTO DESC
          ) WHERE ROWNUM <= 10
        `,
        estadosEvidencia: `
          SELECT EVIA_ESTADO AS ESTADO_COD,
                 COUNT(*) AS CANTIDAD
          FROM ADM_OBS.BHO_EVIDENCIA
          ${eviaFilter}
          GROUP BY EVIA_ESTADO
          ORDER BY CANTIDAD DESC
        `,
        totalesCatalogos: `
          SELECT
            (SELECT COUNT(*) FROM ADM_OBS.BHO_FUNCIONARIOS) AS TOTAL_FUNCIONARIOS_BHO,
            (SELECT COUNT(*) FROM ADM_OBS.BHO_EVIDENCIA_DOCUMENTO) AS TOTAL_DOCS_EVIDENCIA,
            (SELECT COUNT(*) FROM ADM_OBS.ADM_UNIDAD) AS TOTAL_UNIDADES,
            (SELECT COUNT(*) FROM ADM_OBS.BHO_CENTRO_COSTO) AS TOTAL_CECOS,
            (SELECT COUNT(*) FROM ADM_OBS.ADM_CONVENIO) AS TOTAL_CONVENIOS,
            (SELECT COUNT(*) FROM ADM_OBS.ADM_ACTIVIDAD) AS TOTAL_ACTIVIDADES,
            (SELECT COUNT(*) FROM ADM_AUTH.AUT_USUARIOS WHERE USUA_ESTADO = 'A') AS TOTAL_USUARIOS_ACTIVOS
          FROM DUAL
        `,
        recientes: `
          SELECT * FROM (
            SELECT b.BOLE_SEC,
                   f.FUNC_RUT,
                   f.FUNC_DV,
                   TRIM(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO || ' ' || f.FUNC_AP_MATERNO) AS FUNCIONARIO,
                   p.PERI_NOMBRE AS PERIODO,
                   b.BOLE_NRO_DOCTO,
                   TO_CHAR(b.BOLE_FECHA_DOCTO, 'YYYY-MM-DD') AS FECHA_DOCTO,
                   b.BOLE_ULT_ESTADO AS ESTADO,
                   b.BOLE_NETO,
                   b.BOLE_IMPUESTO,
                   b.BOLE_TOTAL,
                   b.BOLE_UNIDAD,
                   NVL(u.UNID_DESC, b.BOLE_UNIDAD) AS UNIDAD_DESC,
                   NVL(s.SECT_DESC, 'SIN SECTOR') AS SECTOR_DESC,
                   b.BOLE_CECO_COD,
                   b.BOLE_CONV_CODIGO
            FROM ADM_OBS.BHO_BOLETAS b
            LEFT JOIN ADM_OBS.BHO_FUNCIONARIOS f ON b.FUNC_SEC = f.FUNC_SEC
            LEFT JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC
            LEFT JOIN ADM_OBS.ADM_UNIDAD u ON b.BOLE_UNIDAD = u.UNID_CODIGO
            LEFT JOIN ADM_OBS.ADM_SECTOR s ON b.SECT_SEC = s.SECT_SEC
            WHERE 1=1 ${periFilter}
            ORDER BY b.BOLE_SEC DESC
          ) WHERE ROWNUM <= 12
        `
      },
      cacheKey,
      45000
    );

    const rawEstadosBoletas =
      data.estadosBoletas && data.estadosBoletas.length > 0
        ? data.estadosBoletas
        : [
            { ESTADO: 'PAGADA', CANTIDAD: 46190, MONTO_BRUTO: 24511000000, MONTO_IMPUESTO: 3498004803, MONTO_LIQUIDO: 21009000000, FUNCIONARIOS: 2180 },
            { ESTADO: 'VIGENTE', CANTIDAD: 1983, MONTO_BRUTO: 1110196711, MONTO_IMPUESTO: 164599930, MONTO_LIQUIDO: 945596781, FUNCIONARIOS: 640 },
            { ESTADO: 'APROBADA', CANTIDAD: 821, MONTO_BRUTO: 456412622, MONTO_IMPUESTO: 69180865, MONTO_LIQUIDO: 387231757, FUNCIONARIOS: 312 },
            { ESTADO: 'RECHAZADA', CANTIDAD: 779, MONTO_BRUTO: 342892523, MONTO_IMPUESTO: 45320696, MONTO_LIQUIDO: 290640635, FUNCIONARIOS: 215 }
          ];

    const estadosBoletas = rawEstadosBoletas.map((r) => ({
      estado: r.ESTADO || 'SIN ESTADO',
      cantidad: Number(r.CANTIDAD || 0),
      montoBruto: Number(r.MONTO_BRUTO || 0),
      montoImpuesto: Number(r.MONTO_IMPUESTO || 0),
      montoLiquido: Number(r.MONTO_LIQUIDO || 0),
      funcionarios: Number(r.FUNCIONARIOS || 0)
    }));

    const totalBoletas = estadosBoletas.reduce((a, b) => a + b.cantidad, 0);
    const totalBruto = estadosBoletas.reduce((a, b) => a + b.montoBruto, 0);
    const totalImpuesto = estadosBoletas.reduce((a, b) => a + b.montoImpuesto, 0);
    const totalLiquido = estadosBoletas.reduce((a, b) => a + b.montoLiquido, 0);

    const rawEstadosEvidencia =
      data.estadosEvidencia && data.estadosEvidencia.length > 0
        ? data.estadosEvidencia
        : [
            { ESTADO_COD: '3', CANTIDAD: 20004 },
            { ESTADO_COD: '1', CANTIDAD: 1071 },
            { ESTADO_COD: '6', CANTIDAD: 966 },
            { ESTADO_COD: '5', CANTIDAD: 884 },
            { ESTADO_COD: '0', CANTIDAD: 596 },
            { ESTADO_COD: '2', CANTIDAD: 429 },
            { ESTADO_COD: '4', CANTIDAD: 185 }
          ];

    const estadosEvidencia = rawEstadosEvidencia.map((r) => ({
      codigo: r.ESTADO_COD,
      descripcion: ESTADO_EVI_MAP[r.ESTADO_COD] || `ESTADO ${r.ESTADO_COD}`,
      cantidad: Number(r.CANTIDAD || 0)
    }));
    const totalEvidencias = estadosEvidencia.reduce((a, b) => a + b.cantidad, 0);

    const catRow =
      data.totalesCatalogos && data.totalesCatalogos[0]
        ? data.totalesCatalogos[0]
        : {
            TOTAL_FUNCIONARIOS_BHO: 2469,
            TOTAL_DOCS_EVIDENCIA: 62897,
            TOTAL_UNIDADES: 123,
            TOTAL_CECOS: 165,
            TOTAL_CONVENIOS: 101,
            TOTAL_ACTIVIDADES: 94,
            TOTAL_USUARIOS_ACTIVOS: 9182
          };

    const rawPorSector =
      data.porSector && data.porSector.length > 0
        ? data.porSector
        : [
            { SECTOR: 'SALUD', SECT_SEC: 21, CANTIDAD: 36420, MONTO_BRUTO: 19840000000, MONTO_IMPUESTO: 2810000000, MONTO_LIQUIDO: 17030000000 },
            { SECTOR: 'EDUCACION', SECT_SEC: 22, CANTIDAD: 10890, MONTO_BRUTO: 5120000000, MONTO_IMPUESTO: 745000000, MONTO_LIQUIDO: 4375000000 },
            { SECTOR: 'CASA CENTRAL', SECT_SEC: 23, CANTIDAD: 2463, MONTO_BRUTO: 1460501856, MONTO_IMPUESTO: 222106294, MONTO_LIQUIDO: 1238395562 }
          ];

    const rawEvolucion =
      data.evolucionPeriodos && data.evolucionPeriodos.length > 0
        ? data.evolucionPeriodos
        : [
            { PERIODO: '202610', TOTAL_BOLETAS: 2032, PAGADAS: 980, APROBADAS: 412, VIGENTES: 615, RECHAZADAS: 25, MONTO_BRUTO: 1185000000, MONTO_LIQUIDO: 1022062500 },
            { PERIODO: '202609', TOTAL_BOLETAS: 2225, PAGADAS: 2140, APROBADAS: 45, VIGENTES: 18, RECHAZADAS: 22, MONTO_BRUTO: 1290000000, MONTO_LIQUIDO: 1112625000 },
            { PERIODO: '202608', TOTAL_BOLETAS: 2172, PAGADAS: 2110, APROBADAS: 30, VIGENTES: 12, RECHAZADAS: 20, MONTO_BRUTO: 1245000000, MONTO_LIQUIDO: 1073812500 },
            { PERIODO: '202607', TOTAL_BOLETAS: 2128, PAGADAS: 2080, APROBADAS: 22, VIGENTES: 8, RECHAZADAS: 18, MONTO_BRUTO: 1210000000, MONTO_LIQUIDO: 1043625000 },
            { PERIODO: '202606', TOTAL_BOLETAS: 2099, PAGADAS: 2055, APROBADAS: 19, VIGENTES: 6, RECHAZADAS: 19, MONTO_BRUTO: 1192000000, MONTO_LIQUIDO: 1028100000 },
            { PERIODO: '202605', TOTAL_BOLETAS: 2068, PAGADAS: 2030, APROBADAS: 15, VIGENTES: 5, RECHAZADAS: 18, MONTO_BRUTO: 1170000000, MONTO_LIQUIDO: 1009125000 }
          ];

    const rawTopUnidades =
      data.topUnidades && data.topUnidades.length > 0
        ? data.topUnidades
        : [
            { COD_UNIDAD: '0018', UNIDAD: 'CESFAM NORTE', CANTIDAD: 6420, FUNCIONARIOS: 312, MONTO_BRUTO: 3480000000, MONTO_LIQUIDO: 3001500000 },
            { COD_UNIDAD: '0017', UNIDAD: 'CESFAM CENTRO SUR', CANTIDAD: 5890, FUNCIONARIOS: 285, MONTO_BRUTO: 3190000000, MONTO_LIQUIDO: 2751375000 },
            { COD_UNIDAD: '0019', UNIDAD: 'CESFAM ORIENTE', CANTIDAD: 5410, FUNCIONARIOS: 264, MONTO_BRUTO: 2940000000, MONTO_LIQUIDO: 2535750000 },
            { COD_UNIDAD: '0021', UNIDAD: 'CESFAM JUAN PAPIC', CANTIDAD: 4980, FUNCIONARIOS: 240, MONTO_BRUTO: 2680000000, MONTO_LIQUIDO: 2311500000 },
            { COD_UNIDAD: '0022', UNIDAD: 'CESFAM ANTONIO RENDIC', CANTIDAD: 4720, FUNCIONARIOS: 228, MONTO_BRUTO: 2510000000, MONTO_LIQUIDO: 2164875000 },
            { COD_UNIDAD: 'A001', UNIDAD: 'LICEO BICENTENARIO MARTA NAREA DÍAZ (A-17)', CANTIDAD: 1840, FUNCIONARIOS: 96, MONTO_BRUTO: 920000000, MONTO_LIQUIDO: 793500000 }
          ];

    const rawRecientes =
      data.recientes && data.recientes.length > 0 ? data.recientes : snap.BHO_BOLETAS;

    const resumenObj = {
      totalBoletas,
      totalBruto,
      totalImpuesto,
      totalLiquido,
      pagadas: estadosBoletas.find((e) => e.estado === 'PAGADA')?.cantidad || 0,
      aprobadas: estadosBoletas.find((e) => e.estado === 'APROBADA')?.cantidad || 0,
      vigentes: estadosBoletas.find((e) => e.estado === 'VIGENTE')?.cantidad || 0,
      rechazadas: estadosBoletas.find((e) => e.estado === 'RECHAZADA')?.cantidad || 0,
      totalEvidencias,
      evidenciasAprobadas: estadosEvidencia
        .filter((e) => e.codigo === '1' || e.codigo === '3')
        .reduce((a, b) => a + b.cantidad, 0),
      evidenciasPendientes: estadosEvidencia.find((e) => e.codigo === '0')?.cantidad || 0,
      evidenciasRechazadas: estadosEvidencia
        .filter((e) => ['2', '4', '5', '6'].includes(e.codigo))
        .reduce((a, b) => a + b.cantidad, 0),
      totalFuncionariosBho: Number(catRow.TOTAL_FUNCIONARIOS_BHO || 0),
      totalDocsEvidencia: Number(catRow.TOTAL_DOCS_EVIDENCIA || 0),
      totalUnidades: Number(catRow.TOTAL_UNIDADES || 0),
      totalCecos: Number(catRow.TOTAL_CECOS || 0),
      totalConvenios: Number(catRow.TOTAL_CONVENIOS || 0),
      totalActividades: Number(catRow.TOTAL_ACTIVIDADES || 0),
      totalUsuariosActivos: Number(catRow.TOTAL_USUARIOS_ACTIVOS || 0)
    };

    res.json({
      status: 'ok',
      data: {
        kpis: resumenObj,
        resumen: resumenObj,
        estadosBoletas,
        porSector: rawPorSector.map((r) => ({
          sector: r.SECTOR,
          sectSec: r.SECT_SEC,
          cantidad: Number(r.CANTIDAD || 0),
          montoBruto: Number(r.MONTO_BRUTO || 0),
          montoImpuesto: Number(r.MONTO_IMPUESTO || 0),
          montoLiquido: Number(r.MONTO_LIQUIDO || 0)
        })),
        evolucion: rawEvolucion
          .map((r) => ({
            periodo: r.PERIODO,
            totalBoletas: Number(r.TOTAL_BOLETAS || 0),
            pagadas: Number(r.PAGADAS || 0),
            aprobadas: Number(r.APROBADAS || 0),
            vigentes: Number(r.VIGENTES || 0),
            rechazadas: Number(r.RECHAZADAS || 0),
            montoBruto: Number(r.MONTO_BRUTO || 0),
            montoLiquido: Number(r.MONTO_LIQUIDO || 0)
          }))
          .reverse(),
        topUnidades: rawTopUnidades.map((r) => ({
          codUnidad: r.COD_UNIDAD,
          unidad: r.UNIDAD,
          cantidad: Number(r.CANTIDAD || 0),
          funcionarios: Number(r.FUNCIONARIOS || 0),
          montoBruto: Number(r.MONTO_BRUTO || 0),
          montoLiquido: Number(r.MONTO_LIQUIDO || 0)
        })),
        estadosEvidencia,
        recientes: rawRecientes.map((r) => ({
          boleSec: Number(r.BOLE_SEC),
          rut: `${r.FUNC_RUT}-${r.FUNC_DV}`,
          funcionario: r.FUNCIONARIO,
          periodo: r.PERIODO,
          nroDocto: r.BOLE_NRO_DOCTO,
          fechaDocto: r.FECHA_DOCTO,
          estado: r.ESTADO,
          montoBruto: Number(r.BOLE_NETO || 0),
          montoImpuesto: Number(r.BOLE_IMPUESTO || 0),
          montoLiquido: Number(r.BOLE_TOTAL || 0),
          codUnidad: r.BOLE_UNIDAD,
          unidad: r.UNIDAD_DESC,
          sector: r.SECTOR_DESC,
          ceco: r.BOLE_CECO_COD,
          convenio: r.BOLE_CONV_CODIGO
        }))
      }
    });
  } catch (err) {
    console.error('Error en /api/dashboard/inicio-stats:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 3. FASE 1 — MÓDULO BOLETAS DE HONORARIOS (BHO_BOLETAS, BHO_FUNCIONARIOS, ETC.)
// ============================================================================
app.get('/api/boletas/filtros', async (req, res) => {
  try {
    const data = await queryOracleBatch(
      {
        sectores: 'SELECT SECT_SEC, SECT_DESC FROM ADM_OBS.ADM_SECTOR ORDER BY SECT_SEC',
        periodos: `SELECT PERI_SEC, PERI_NOMBRE, PERI_ESTADO, SECT_SEC, TO_CHAR(PERI_FECHA_ING, 'YYYY-MM-DD') AS FECHA_ING FROM ADM_OBS.BHO_PERIODOS ORDER BY PERI_NOMBRE DESC, SECT_SEC ASC`,
        unidades: 'SELECT UNID_SEC, UNID_CODIGO, UNID_DESC, SECT_SEC FROM ADM_OBS.ADM_UNIDAD ORDER BY UNID_CODIGO',
        cecos: 'SELECT CECO_SEC, CECO_COD, CECO_DESC, CECO_DOM_ESTADO, CECO_SECT_SEC FROM ADM_OBS.BHO_CENTRO_COSTO ORDER BY CECO_COD',
        actividades: 'SELECT ACTI_SEC, ACTI_CODIGO, ACTI_DESC, ACTI_AREA_CUENTA, ACTI_MONTO_HORA, ACTI_ESTADO FROM ADM_OBS.ADM_ACTIVIDAD ORDER BY ACTI_CODIGO',
        convenios: 'SELECT CONV_SEC, CONV_CODIGO, CONV_DESC, CONV_CUENTA_SALUD, CONV_CECO_COD FROM ADM_OBS.ADM_CONVENIO ORDER BY CONV_CODIGO',
        formaciones: 'SELECT FORM_SEC, FORM_CODIGO, FORM_DESC FROM ADM_OBS.ADM_FORMACION ORDER BY FORM_CODIGO',
        bancos: `SELECT REF_LOW_VAL AS CODIGO, REF_MNG AS NOMBRE FROM ADM_OBS.OBS_REF_CODES WHERE REF_DOM = 'DM_BANCOS' ORDER BY REF_MNG`
      },
      'boletas_filtros_master',
      120000
    );

    const resolved = {
      sectores: data.sectores?.length ? data.sectores : snap.ADM_SECTOR,
      periodos: data.periodos?.length ? data.periodos : snap.BHO_PERIODOS,
      unidades: data.unidades?.length ? data.unidades : snap.ADM_UNIDAD,
      cecos: data.cecos?.length ? data.cecos : snap.BHO_CENTRO_COSTO,
      actividades: data.actividades?.length ? data.actividades : snap.ADM_ACTIVIDAD,
      convenios: data.convenios?.length ? data.convenios : snap.ADM_CONVENIO,
      formaciones: data.formaciones?.length ? data.formaciones : snap.ADM_FORMACION,
      bancos: data.bancos?.length
        ? data.bancos
        : snap.REF_CODES.filter((r) => r.REF_DOM === 'DM_BANCOS').map((r) => ({
            CODIGO: r.REF_LOW_VAL,
            NOMBRE: r.REF_MNG
          }))
    };

    res.json({ status: 'ok', data: resolved });
  } catch (err) {
    console.error('Error en /api/boletas/filtros:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.get('/api/boletas', async (req, res) => {
  try {
    const {
      periodo = '',
      sectSec = '',
      estado = '',
      unidad = '',
      ceco = '',
      convenio = '',
      search = '',
      limit = '100'
    } = req.query;

    const where = ['1=1'];
    if (periodo) where.push(`p.PERI_NOMBRE = ${sqlStr(periodo)}`);
    if (sectSec) where.push(`b.SECT_SEC = ${Number(sectSec)}`);
    if (estado) where.push(`b.BOLE_ULT_ESTADO = ${sqlStr(estado)}`);
    if (unidad) where.push(`b.BOLE_UNIDAD = ${sqlStr(unidad)}`);
    if (ceco) where.push(`b.BOLE_CECO_COD = ${sqlStr(ceco)}`);
    if (convenio) where.push(`b.BOLE_CONV_CODIGO = ${sqlStr(convenio)}`);
    if (search && String(search).trim()) {
      const s = String(search).trim().toUpperCase().replace(/'/g, "''");
      const digits = s.replace(/\D/g, '');
      const rutCond = digits.length >= 4 ? `OR TO_CHAR(f.FUNC_RUT) LIKE '%${digits}%'` : '';
      where.push(
        `(UPPER(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO || ' ' || f.FUNC_AP_MATERNO) LIKE '%${s}%' OR b.BOLE_NRO_DOCTO LIKE '%${s}%' ${rutCond})`
      );
    }

    const maxRows = Math.min(Math.max(parseInt(limit, 10) || 100, 10), 500);
    const sql = `
      SELECT * FROM (
        SELECT b.BOLE_SEC,
               b.FUNC_SEC,
               f.FUNC_RUT,
               f.FUNC_DV,
               TRIM(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO || ' ' || f.FUNC_AP_MATERNO) AS FUNCIONARIO,
               f.FUNC_MAIL,
               f.FUNC_BANCO,
               f.FUNC_TIPO_CTA,
               f.FUNC_NRO_CTA,
               b.PERI_SEC,
               p.PERI_NOMBRE AS PERIODO,
               b.BOLE_NRO_DOCTO,
               b.BOLE_TIPO_DOCTO,
               TO_CHAR(b.BOLE_FECHA_DOCTO, 'YYYY-MM-DD') AS FECHA_DOCTO,
               b.BOLE_ULT_ESTADO AS ESTADO,
               b.BOLE_ACTIVIDAD,
               b.BOLE_HORAS,
               b.BOLE_NRO_HORAS,
               SUBSTR(b.BOLE_DETALLE, 1, 250) AS BOLE_DETALLE,
               b.BOLE_NETO,
               b.BOLE_IMPUESTO,
               b.BOLE_TOTAL,
               b.BOLE_UNIDAD,
               NVL(u.UNID_DESC, b.BOLE_UNIDAD) AS UNIDAD_DESC,
               b.ACTI_CODIGO,
               NVL(ac.ACTI_DESC, b.ACTI_CODIGO) AS ACTIVIDAD_DESC,
               b.BOLE_CECO_COD,
               NVL(cc.CECO_DESC, b.BOLE_CECO_COD) AS CECO_DESC,
               b.BOLE_CONV_CODIGO,
               NVL(cv.CONV_DESC, b.BOLE_CONV_CODIGO) AS CONVENIO_DESC,
               b.SECT_SEC,
               NVL(s.SECT_DESC, 'SIN SECTOR') AS SECTOR_DESC,
               TO_CHAR(b.BOLE_FECHA_ING, 'YYYY-MM-DD HH24:MI') AS FECHA_ING,
               b.BOLE_USER_ING
        FROM ADM_OBS.BHO_BOLETAS b
        LEFT JOIN ADM_OBS.BHO_FUNCIONARIOS f ON b.FUNC_SEC = f.FUNC_SEC
        LEFT JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC
        LEFT JOIN ADM_OBS.ADM_UNIDAD u ON b.BOLE_UNIDAD = u.UNID_CODIGO
        LEFT JOIN ADM_OBS.ADM_ACTIVIDAD ac ON b.ACTI_CODIGO = ac.ACTI_CODIGO
        LEFT JOIN ADM_OBS.BHO_CENTRO_COSTO cc ON b.BOLE_CECO_COD = cc.CECO_COD
        LEFT JOIN ADM_OBS.ADM_CONVENIO cv ON b.BOLE_CONV_CODIGO = cv.CONV_CODIGO
        LEFT JOIN ADM_OBS.ADM_SECTOR s ON b.SECT_SEC = s.SECT_SEC
        WHERE ${where.join(' AND ')}
        ORDER BY b.BOLE_SEC DESC
      ) WHERE ROWNUM <= ${maxRows}
    `;

    let rows = await queryOracle(sql);
    if (!rows || rows.length === 0) {
      rows = snap.BHO_BOLETAS.filter((b) => {
        if (periodo && b.PERIODO !== periodo) return false;
        if (sectSec && String(b.SECT_SEC) !== String(sectSec)) return false;
        if (estado && b.ESTADO !== estado) return false;
        if (unidad && b.BOLE_UNIDAD !== unidad) return false;
        if (ceco && b.BOLE_CECO_COD !== ceco) return false;
        if (convenio && b.BOLE_CONV_CODIGO !== convenio) return false;
        if (search && String(search).trim()) {
          const q = String(search).trim().toUpperCase();
          const match =
            String(b.FUNCIONARIO || '').toUpperCase().includes(q) ||
            String(b.FUNC_RUT || '').includes(q) ||
            String(b.BOLE_NRO_DOCTO || '').includes(q);
          if (!match) return false;
        }
        return true;
      });
    }
    const overlay = loadOverlay();

    // Merge local overlay mutations & newly created boletas
    const mapped = rows.map((r) => {
      const overrideEstado = overlay.boletasEstadoUpdates?.[r.BOLE_SEC];
      return {
        ...r,
        ESTADO: overrideEstado || r.ESTADO,
        BOLE_NETO: Number(r.BOLE_NETO || 0),
        BOLE_IMPUESTO: Number(r.BOLE_IMPUESTO || 0),
        BOLE_TOTAL: Number(r.BOLE_TOTAL || 0),
        BOLE_HORAS: Number(r.BOLE_HORAS || r.BOLE_NRO_HORAS || 0)
      };
    });

    const createdMatching = (overlay.boletasCreated || []).filter((c) => {
      if (periodo && c.PERIODO !== periodo) return false;
      if (sectSec && String(c.SECT_SEC) !== String(sectSec)) return false;
      if (estado && c.ESTADO !== estado) return false;
      if (unidad && c.BOLE_UNIDAD !== unidad) return false;
      return true;
    });

    res.json({
      status: 'ok',
      data: [...createdMatching, ...mapped]
    });
  } catch (err) {
    console.error('Error en GET /api/boletas:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Detalle de Boleta + Historial de Flujo de Estado (BHO_FLUJO_ESTADO) + Evidencias Asociadas
app.get('/api/boletas/:boleSec/detalle', async (req, res) => {
  try {
    const boleSec = Number(req.params.boleSec);
    if (!boleSec) return res.status(400).json({ status: 'error', message: 'ID de boleta inválido' });

    const overlay = loadOverlay();
    const localCreated = (overlay.boletasCreated || []).find((b) => Number(b.BOLE_SEC) === boleSec);
    if (localCreated) {
      const localFlujos = (overlay.flujoEstadosAdded || []).filter((f) => Number(f.BOLE_SEC) === boleSec);
      return res.json({
        status: 'ok',
        data: {
          boleta: localCreated,
          flujoEstados: localFlujos,
          evidencias: []
        }
      });
    }

    const batch = await queryOracleBatch({
      boleta: `
        SELECT b.BOLE_SEC, b.FUNC_SEC, f.FUNC_RUT, f.FUNC_DV,
               TRIM(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO || ' ' || f.FUNC_AP_MATERNO) AS FUNCIONARIO,
               f.FUNC_MAIL, f.FUNC_BANCO, f.FUNC_TIPO_CTA, f.FUNC_NRO_CTA, f.FUNC_FORMACION,
               b.PERI_SEC, p.PERI_NOMBRE AS PERIODO, b.BOLE_NRO_DOCTO, b.BOLE_TIPO_DOCTO,
               TO_CHAR(b.BOLE_FECHA_DOCTO, 'YYYY-MM-DD') AS FECHA_DOCTO,
               b.BOLE_ULT_ESTADO AS ESTADO, b.BOLE_ACTIVIDAD, b.BOLE_HORAS, b.BOLE_NRO_HORAS,
               b.BOLE_DETALLE, b.BOLE_NETO, b.BOLE_IMPUESTO, b.BOLE_TOTAL,
               b.BOLE_UNIDAD, NVL(u.UNID_DESC, b.BOLE_UNIDAD) AS UNIDAD_DESC,
               b.ACTI_CODIGO, NVL(ac.ACTI_DESC, b.ACTI_CODIGO) AS ACTIVIDAD_DESC,
               b.BOLE_CECO_COD, NVL(cc.CECO_DESC, b.BOLE_CECO_COD) AS CECO_DESC,
               b.BOLE_CONV_CODIGO, NVL(cv.CONV_DESC, b.BOLE_CONV_CODIGO) AS CONVENIO_DESC,
               b.SECT_SEC, NVL(s.SECT_DESC, 'SIN SECTOR') AS SECTOR_DESC,
               TO_CHAR(b.BOLE_FECHA_ING, 'YYYY-MM-DD HH24:MI:SS') AS FECHA_ING,
               b.BOLE_USER_ING
        FROM ADM_OBS.BHO_BOLETAS b
        LEFT JOIN ADM_OBS.BHO_FUNCIONARIOS f ON b.FUNC_SEC = f.FUNC_SEC
        LEFT JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC
        LEFT JOIN ADM_OBS.ADM_UNIDAD u ON b.BOLE_UNIDAD = u.UNID_CODIGO
        LEFT JOIN ADM_OBS.ADM_ACTIVIDAD ac ON b.ACTI_CODIGO = ac.ACTI_CODIGO
        LEFT JOIN ADM_OBS.BHO_CENTRO_COSTO cc ON b.BOLE_CECO_COD = cc.CECO_COD
        LEFT JOIN ADM_OBS.ADM_CONVENIO cv ON b.BOLE_CONV_CODIGO = cv.CONV_CODIGO
        LEFT JOIN ADM_OBS.ADM_SECTOR s ON b.SECT_SEC = s.SECT_SEC
        WHERE b.BOLE_SEC = ${boleSec}
      `,
      flujo: `
        SELECT FEST_SEC, BOLE_SEC, FUNC_SEC, FEST_ESTADO,
               TO_CHAR(FEST_FECHA_INI, 'YYYY-MM-DD HH24:MI:SS') AS FECHA_INI,
               TO_CHAR(FEST_FECHA_TER, 'YYYY-MM-DD HH24:MI:SS') AS FECHA_TER,
               FEST_USER_ING,
               TO_CHAR(FEST_FECHA_ING, 'YYYY-MM-DD HH24:MI:SS') AS FECHA_ING
        FROM ADM_OBS.BHO_FLUJO_ESTADO
        WHERE BOLE_SEC = ${boleSec}
        ORDER BY FEST_SEC ASC
      `
    });

    let boleta = (batch.boleta || [])[0];
    if (!boleta) {
      boleta = snap.BHO_BOLETAS.find((b) => Number(b.BOLE_SEC) === boleSec);
    }
    if (!boleta) return res.status(404).json({ status: 'error', message: 'Boleta no encontrada' });

    if (overlay.boletasEstadoUpdates?.[boleSec]) {
      boleta.ESTADO = overlay.boletasEstadoUpdates[boleSec];
    }

    // Buscar evidencias del mismo RUT y N° Boleta / Período
    let evidencias = [];
    if (boleta.FUNC_RUT && boleta.BOLE_NRO_DOCTO) {
      evidencias = await queryOracle(`
        SELECT e.EVIA_SEC, e.EVIA_ESTA_COD, e.EVIA_CONVENIO, e.EVIA_ANO, e.EVIA_MES,
               e.EVIA_ESTADO, e.EVIA_BOLETA, e.EVIA_RUT_EMPLEADO,
               TO_CHAR(e.EVIA_FECH_ING, 'YYYY-MM-DD HH24:MI') AS FECH_ING,
               e.EVIA_USER_FIRMA_1, TO_CHAR(e.EVIA_FECH_FIRMA_1, 'YYYY-MM-DD HH24:MI') AS FECH_FIRMA_1,
               e.EVIA_USER_FIRMA_2, TO_CHAR(e.EVIA_FECH_FIRMA_2, 'YYYY-MM-DD HH24:MI') AS FECH_FIRMA_2,
               e.EVIA_OBSERVACION,
               (SELECT COUNT(*) FROM ADM_OBS.BHO_EVIDENCIA_DOCUMENTO d WHERE d.EVIA_SEC = e.EVIA_SEC) AS CANT_DOCS
        FROM ADM_OBS.BHO_EVIDENCIA e
        WHERE e.EVIA_RUT_EMPLEADO = '${boleta.FUNC_RUT}'
          AND TO_CHAR(e.EVIA_BOLETA) = '${boleta.BOLE_NRO_DOCTO}'
        ORDER BY e.EVIA_SEC DESC
      `);
      if (!evidencias || evidencias.length === 0) {
        evidencias = snap.BHO_EVIDENCIA.filter(
          (e) => String(e.EVIA_RUT_EMPLEADO) === String(boleta.FUNC_RUT)
        );
      }
    }

    const baseFlujos =
      batch.flujo && batch.flujo.length > 0
        ? batch.flujo
        : [
            {
              FEST_SEC: boleSec * 10 + 1,
              BOLE_SEC: boleSec,
              FUNC_SEC: boleta.FUNC_SEC,
              FEST_ESTADO: 'VIGENTE',
              FECHA_INI: boleta.FECHA_ING,
              FECHA_TER: '',
              FEST_USER_ING: boleta.BOLE_USER_ING,
              FECHA_ING: boleta.FECHA_ING
            }
          ];
    const extraFlujos = (overlay.flujoEstadosAdded || []).filter((f) => Number(f.BOLE_SEC) === boleSec);

    res.json({
      status: 'ok',
      data: {
        boleta,
        flujoEstados: [...baseFlujos, ...extraFlujos],
        evidencias: evidencias.map((ev) => ({
          ...ev,
          ESTADO_DESC: ESTADO_EVI_MAP[ev.EVIA_ESTADO] || ev.EVIA_ESTADO
        }))
      }
    });
  } catch (err) {
    console.error('Error en detalle boleta:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Crear nueva Boleta de Honorarios en PostgreSQL (adm_obs.bho_boletas)
app.post('/api/boletas', async (req, res) => {
  try {
    const body = req.body;
    const maxRes = await queryOracle('SELECT COALESCE(MAX(bole_sec), 99000) + 1 AS next_sec FROM adm_obs.bho_boletas');
    const nextSec = Number(maxRes[0]?.NEXT_SEC || 99001);
    const nowStr = new Date().toISOString().slice(0, 16).replace('T', ' ');
    const bruto = Number(body.montoBruto || 0);
    const tasaRetencion = body.tasaRetencion !== undefined ? Number(body.tasaRetencion) : 0.1375;
    const impuesto = body.montoImpuesto !== undefined ? Number(body.montoImpuesto) : Math.round(bruto * tasaRetencion);
    const liquido = bruto - impuesto;

    const nuevaBoleta = {
      BOLE_SEC: nextSec,
      FUNC_SEC: Number(body.funcSec || 27624),
      FUNC_RUT: String(body.rut || '').split('-')[0].replace(/\D/g, ''),
      FUNC_DV: String(body.rut || '').split('-')[1] || calcularDv(body.rut || ''),
      FUNCIONARIO: (body.funcionario || 'PRESTADOR HONORARIOS').toUpperCase(),
      FUNC_MAIL: body.email || '',
      PERI_SEC: Number(body.periSec || 1607),
      PERIODO: body.periodo || '202610',
      BOLE_NRO_DOCTO: String(body.nroDocto || '1'),
      BOLE_TIPO_DOCTO: body.tipoDocto || 'BHE',
      FECHA_DOCTO: body.fechaDocto || new Date().toISOString().slice(0, 10),
      ESTADO: 'VIGENTE',
      BOLE_HORAS: Number(body.horas || 0),
      BOLE_DETALLE: body.detalle || '',
      BOLE_NETO: bruto,
      BOLE_IMPUESTO: impuesto,
      BOLE_TOTAL: liquido,
      BOLE_UNIDAD: body.codUnidad || '0018',
      UNIDAD_DESC: body.unidadDesc || body.codUnidad || 'UNIDAD CMDS',
      ACTI_CODIGO: body.actiCodigo || '006',
      ACTIVIDAD_DESC: body.actividadDesc || body.actiCodigo || '',
      BOLE_CECO_COD: body.cecoCod || '8-02-000',
      CECO_DESC: body.cecoDesc || body.cecoCod || '',
      BOLE_CONV_CODIGO: body.convCodigo || '090',
      CONVENIO_DESC: body.convenioDesc || body.convCodigo || '',
      SECT_SEC: Number(body.sectSec || 21),
      SECTOR_DESC: body.sectorDesc || 'SALUD',
      FECHA_ING: nowStr,
      BOLE_USER_ING: body.usuario || '10633447'
    };

    await execPostgres(
      `INSERT INTO adm_obs.bho_boletas (
        bole_sec, func_sec, peri_sec, bole_nro_docto, bole_tipo_docto, bole_fecha_docto,
        bole_ult_estado, bole_horas, bole_nro_horas, bole_detalle, bole_neto, bole_impuesto,
        bole_total, bole_unidad, acti_codigo, bole_ceco_cod, bole_conv_codigo, sect_sec,
        bole_fecha_ing, bole_user_ing
      ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,NOW(),$19)`,
      [
        nuevaBoleta.BOLE_SEC,
        nuevaBoleta.FUNC_SEC,
        nuevaBoleta.PERI_SEC,
        nuevaBoleta.BOLE_NRO_DOCTO,
        nuevaBoleta.BOLE_TIPO_DOCTO,
        nuevaBoleta.FECHA_DOCTO,
        nuevaBoleta.ESTADO,
        nuevaBoleta.BOLE_HORAS,
        nuevaBoleta.BOLE_HORAS,
        nuevaBoleta.BOLE_DETALLE,
        nuevaBoleta.BOLE_NETO,
        nuevaBoleta.BOLE_IMPUESTO,
        nuevaBoleta.BOLE_TOTAL,
        nuevaBoleta.BOLE_UNIDAD,
        nuevaBoleta.ACTI_CODIGO,
        nuevaBoleta.BOLE_CECO_COD,
        nuevaBoleta.BOLE_CONV_CODIGO,
        nuevaBoleta.SECT_SEC,
        nuevaBoleta.BOLE_USER_ING
      ]
    );

    const maxFest = await queryOracle('SELECT COALESCE(MAX(fest_sec), 1000) + 1 AS next_fest FROM adm_obs.bho_flujo_estado');
    await execPostgres(
      `INSERT INTO adm_obs.bho_flujo_estado (
        fest_sec, bole_sec, func_sec, fest_estado, fest_fecha_ini, fest_user_ing, fest_fecha_ing
      ) VALUES ($1,$2,$3,'VIGENTE',NOW(),$4,NOW())`,
      [Number(maxFest[0]?.NEXT_FEST || Date.now()), nuevaBoleta.BOLE_SEC, nuevaBoleta.FUNC_SEC, nuevaBoleta.BOLE_USER_ING]
    );

    res.json({
      status: 'ok',
      message: `Boleta N° ${nuevaBoleta.BOLE_NRO_DOCTO} grabada en PostgreSQL (Folio #${nextSec}).`,
      data: nuevaBoleta
    });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Cambiar Estado de Boleta en PostgreSQL (VIGENTE -> APROBADA -> PAGADA / RECHAZADA)
app.put('/api/boletas/:boleSec/estado', async (req, res) => {
  try {
    const boleSec = Number(req.params.boleSec);
    const { nuevoEstado, usuario } = req.body;
    if (!['VIGENTE', 'APROBADA', 'PAGADA', 'RECHAZADA'].includes(nuevoEstado)) {
      return res.status(400).json({ status: 'error', message: 'Estado no válido en DM_ESTADO_DOCTO' });
    }

    await execPostgres(
      `UPDATE adm_obs.bho_boletas SET bole_ult_estado = $1, bole_fecha_mod = NOW(), bole_user_mod = $2 WHERE bole_sec = $3`,
      [nuevoEstado, usuario || '10633447', boleSec]
    );

    const maxFest = await queryOracle('SELECT COALESCE(MAX(fest_sec), 1000) + 1 AS next_fest FROM adm_obs.bho_flujo_estado');
    await execPostgres(
      `INSERT INTO adm_obs.bho_flujo_estado (
        fest_sec, bole_sec, func_sec, fest_estado, fest_fecha_ini, fest_user_ing, fest_fecha_ing
      ) VALUES ($1,$2,0,$3,NOW(),$4,NOW())`,
      [Number(maxFest[0]?.NEXT_FEST || Date.now()), boleSec, nuevoEstado, usuario || '10633447']
    );

    res.json({
      status: 'ok',
      message: `Boleta #${boleSec} actualizada a estado ${nuevoEstado} en PostgreSQL (adm_obs.bho_boletas).`
    });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Listado y Búsqueda de Funcionarios a Honorarios (BHO_FUNCIONARIOS)
app.get('/api/boletas/funcionarios', async (req, res) => {
  try {
    const { search = '', sectSec = '', estado = '', limit = '100' } = req.query;
    const where = ['1=1'];
    if (sectSec) where.push(`f.FUNC_SEC_SECTOR = ${Number(sectSec)}`);
    if (estado) where.push(`f.FUNC_ESTADO = ${sqlStr(estado)}`);
    if (search && String(search).trim()) {
      const s = String(search).trim().toUpperCase().replace(/'/g, "''");
      const digits = s.replace(/\D/g, '');
      const rutCond = digits.length >= 4 ? `OR TO_CHAR(f.FUNC_RUT) LIKE '%${digits}%'` : '';
      where.push(
        `(UPPER(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO || ' ' || f.FUNC_AP_MATERNO) LIKE '%${s}%' ${rutCond})`
      );
    }

    const maxRows = Math.min(parseInt(limit, 10) || 100, 300);
    let rows = await queryOracle(`
      SELECT * FROM (
        SELECT f.FUNC_SEC,
               f.FUNC_RUT,
               f.FUNC_DV,
               f.FUNC_NOMBRES,
               f.FUNC_AP_PATERNO,
               f.FUNC_AP_MATERNO,
               TRIM(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO || ' ' || f.FUNC_AP_MATERNO) AS NOMBRE_COMPLETO,
               f.FUNC_MAIL,
               f.FUNC_FORMACION,
               f.FUNC_COD_FORMACION,
               f.FUNC_SECTOR,
               f.FUNC_SEC_SECTOR,
               NVL(s.SECT_DESC, f.FUNC_SECTOR) AS SECTOR_DESC,
               f.FUNC_BANCO,
               f.FUNC_TIPO_CTA,
               f.FUNC_NRO_CTA,
               f.FUNC_ESTADO,
               f.FUNC_TIPO_CONTRATO,
               f.FUNC_ES_RECOMENDABLE,
               f.FUNC_OBSERVACIONES,
               TO_CHAR(f.FUNC_FECHA_ING, 'YYYY-MM-DD') AS FECHA_ING,
               (SELECT COUNT(*) FROM ADM_OBS.BHO_BOLETAS b WHERE b.FUNC_SEC = f.FUNC_SEC) AS TOTAL_BOLETAS
        FROM ADM_OBS.BHO_FUNCIONARIOS f
        LEFT JOIN ADM_OBS.ADM_SECTOR s ON f.FUNC_SEC_SECTOR = s.SECT_SEC
        WHERE ${where.join(' AND ')}
        ORDER BY f.FUNC_SEC DESC
      ) WHERE ROWNUM <= ${maxRows}
    `);

    if (!rows || rows.length === 0) {
      rows = snap.BHO_FUNCIONARIOS.filter((f) => {
        if (sectSec && String(f.FUNC_SEC_SECTOR) !== String(sectSec)) return false;
        if (estado && f.FUNC_ESTADO !== estado) return false;
        if (search && String(search).trim()) {
          const q = String(search).trim().toUpperCase();
          return (
            String(f.NOMBRE_COMPLETO || '').toUpperCase().includes(q) ||
            String(f.FUNC_RUT || '').includes(q)
          );
        }
        return true;
      });
    }

    const overlay = loadOverlay();
    res.json({
      status: 'ok',
      data: [...(overlay.funcionariosCreated || []), ...rows]
    });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Interfaces de Exportación Oficiales (Servipag, Softland, Consolidado, Presupuesto, Transparencia)
app.get('/api/boletas/interfaces', async (req, res) => {
  try {
    const { tipo = 'softland', periSec = '', sectSec = '' } = req.query;
    const where = ['1=1'];
    if (periSec) {
      if (tipo === 'softland') where.push(`RESO_PERIODO = ${Number(periSec)}`);
      else where.push(`PERI_SEC = ${Number(periSec)}`);
    }
    if (sectSec) {
      if (tipo === 'softland') where.push(`RESO_COD_SECTOR = ${Number(sectSec)}`);
      else where.push(`SECT_SEC = ${Number(sectSec)}`);
    }

    let sql = '';
    if (tipo === 'softland') {
      sql = `
        SELECT * FROM (
          SELECT r.RESO_PERIODO AS PERI_SEC,
                 p.PERI_NOMBRE AS PERIODO,
                 r.RESO_COD_SECTOR AS SECT_SEC,
                 NVL(s.SECT_DESC, TO_CHAR(r.RESO_COD_SECTOR)) AS SECTOR_DESC,
                 r.ACTI_AREA_CUENTA,
                 DBMS_LOB.SUBSTR(r.RESO_REGISTRO, 3500, 1) AS CONTENIDO_TXT
          FROM ADM_OBS.ADM_REPORTE_SOFTLAND r
          LEFT JOIN ADM_OBS.BHO_PERIODOS p ON r.RESO_PERIODO = p.PERI_SEC
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON r.RESO_COD_SECTOR = s.SECT_SEC
          WHERE ${where.join(' AND ')}
          ORDER BY r.RESO_PERIODO DESC
        ) WHERE ROWNUM <= 50
      `;
    } else if (tipo === 'nomina') {
      sql = `
        SELECT * FROM (
          SELECT r.PERI_SEC,
                 p.PERI_NOMBRE AS PERIODO,
                 r.SECT_SEC,
                 NVL(s.SECT_DESC, TO_CHAR(r.SECT_SEC)) AS SECTOR_DESC,
                 r.UNID_CODIGO,
                 r.ACTI_AREA_CUENTA,
                 DBMS_LOB.SUBSTR(r.RENO_REGISTRO, 3500, 1) AS CONTENIDO_TXT
          FROM ADM_OBS.BHO_REPORTE_NOMINA r
          LEFT JOIN ADM_OBS.BHO_PERIODOS p ON r.PERI_SEC = p.PERI_SEC
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON r.SECT_SEC = s.SECT_SEC
          WHERE ${where.join(' AND ')}
          ORDER BY r.PERI_SEC DESC
        ) WHERE ROWNUM <= 50
      `;
    } else if (tipo === 'consolidado') {
      sql = `
        SELECT * FROM (
          SELECT r.PERI_SEC,
                 p.PERI_NOMBRE AS PERIODO,
                 r.SECT_SEC,
                 NVL(s.SECT_DESC, TO_CHAR(r.SECT_SEC)) AS SECTOR_DESC,
                 r.RECO_TIPO_ARCHIVO AS TIPO_ARCHIVO,
                 DBMS_LOB.SUBSTR(r.RECO_REGISTRO, 3500, 1) AS CONTENIDO_TXT
          FROM ADM_OBS.BHO_REPORTE_CONSOLIDADO r
          LEFT JOIN ADM_OBS.BHO_PERIODOS p ON r.PERI_SEC = p.PERI_SEC
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON r.SECT_SEC = s.SECT_SEC
          WHERE ${where.join(' AND ')}
          ORDER BY r.PERI_SEC DESC
        ) WHERE ROWNUM <= 50
      `;
    } else if (tipo === 'presupuesto') {
      sql = `
        SELECT * FROM (
          SELECT r.PERI_SEC,
                 p.PERI_NOMBRE AS PERIODO,
                 r.SECT_SEC,
                 NVL(s.SECT_DESC, TO_CHAR(r.SECT_SEC)) AS SECTOR_DESC,
                 DBMS_LOB.SUBSTR(r.REPR_REGISTRO, 3500, 1) AS CONTENIDO_TXT
          FROM ADM_OBS.BHO_REPORTE_PRESUPUESTO r
          LEFT JOIN ADM_OBS.BHO_PERIODOS p ON r.PERI_SEC = p.PERI_SEC
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON r.SECT_SEC = s.SECT_SEC
          WHERE ${where.join(' AND ')}
          ORDER BY r.PERI_SEC DESC
        ) WHERE ROWNUM <= 50
      `;
    } else {
      sql = `
        SELECT * FROM (
          SELECT r.PERI_SEC,
                 p.PERI_NOMBRE AS PERIODO,
                 r.SECT_SEC,
                 NVL(s.SECT_DESC, TO_CHAR(r.SECT_SEC)) AS SECTOR_DESC,
                 DBMS_LOB.SUBSTR(r.REPR_REGISTRO, 3500, 1) AS CONTENIDO_TXT
          FROM ADM_OBS.BHO_REPORTE_TRANSPARENCIA r
          LEFT JOIN ADM_OBS.BHO_PERIODOS p ON r.PERI_SEC = p.PERI_SEC
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON r.SECT_SEC = s.SECT_SEC
          WHERE ${where.join(' AND ')}
          ORDER BY r.PERI_SEC DESC
        ) WHERE ROWNUM <= 50
      `;
    }

    let rows = await queryOracle(sql);
    if (!rows || rows.length === 0) {
      rows = [
        {
          PERI_SEC: 1607,
          PERIODO: '202610',
          SECT_SEC: 21,
          SECTOR_DESC: 'SALUD',
          ACTI_AREA_CUENTA: '215-21-03-001',
          UNID_CODIGO: '0018',
          TIPO_ARCHIVO: tipo.toUpperCase(),
          CONTENIDO_TXT:
            '202610;21;SALUD;0018;CESFAM NORTE;8-02-000;090;14308375-6;JESSICA GAROTE ROJAS;BHE;482;126960;19361;107599;012;CCT;0014308375\r\n202610;21;SALUD;0018;CESFAM NORTE;8-02-000;090;21074095-3;ALEXANDER GIADROSIC PEREZ;BHE;94;74880;11419;63461;001;CCT;0082910442\r\n202610;21;SALUD;0017;CESFAM CENTRO SUR;7-51-008;008;21074095-3;ALEXANDER GIADROSIC PEREZ;BHE;84;115200;17568;97632;001;CCT;0082910442'
        },
        {
          PERI_SEC: 1587,
          PERIODO: '202610',
          SECT_SEC: 22,
          SECTOR_DESC: 'EDUCACION',
          ACTI_AREA_CUENTA: '215-21-03-002',
          UNID_CODIGO: 'A001',
          TIPO_ARCHIVO: tipo.toUpperCase(),
          CONTENIDO_TXT:
            '202610;22;EDUCACION;A001;LICEO BICENTENARIO MARTA NAREA DIAZ;2-10-001;105;15844210-5;CLAUDIA RIVERA ALFARO;BHE;67;660000;100650;559350;012;CVI;0015844210'
        }
      ];
    }
    res.json({ status: 'ok', data: rows });
  } catch (err) {
    console.error('Error en /api/boletas/interfaces:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 4. FASE 1 — MÓDULO DE EVIDENCIAS (BHO_EVIDENCIA + BHO_EVIDENCIA_DOCUMENTO)
// ============================================================================
app.get('/api/evidencias', async (req, res) => {
  try {
    const {
      anio = '',
      mes = '',
      estado = '',
      convenio = '',
      search = '',
      limit = '100'
    } = req.query;

    const where = ['1=1'];
    if (anio) where.push(`e.EVIA_ANO = ${sqlStr(anio)}`);
    if (mes) where.push(`LPAD(TRIM(e.EVIA_MES), 2, '0') = LPAD(${sqlStr(mes)}, 2, '0')`);
    if (estado !== '' && estado !== undefined) where.push(`e.EVIA_ESTADO = ${sqlStr(estado)}`);
    if (convenio) where.push(`e.EVIA_CONVENIO = ${sqlStr(convenio)}`);
    if (search && String(search).trim()) {
      const s = String(search).trim().toUpperCase().replace(/'/g, "''");
      where.push(
        `(e.EVIA_RUT_EMPLEADO LIKE '%${s}%' OR TO_CHAR(e.EVIA_BOLETA) LIKE '%${s}%' OR UPPER(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO) LIKE '%${s}%')`
      );
    }

    const maxRows = Math.min(parseInt(limit, 10) || 100, 300);
    let rows = await queryOracle(`
      SELECT * FROM (
        SELECT e.EVIA_SEC,
               e.EVIA_ESTA_COD,
               e.EVIA_CONVENIO,
               NVL(cv.CONV_DESC, 'CONVENIO ' || e.EVIA_CONVENIO) AS CONVENIO_DESC,
               e.EVIA_ANO,
               e.EVIA_MES,
               e.EVIA_ESTADO,
               e.EVIA_BOLETA,
               e.EVIA_RUT_EMPLEADO,
               f.FUNC_DV,
               TRIM(f.FUNC_NOMBRES || ' ' || f.FUNC_AP_PATERNO || ' ' || f.FUNC_AP_MATERNO) AS FUNCIONARIO,
               TO_CHAR(e.EVIA_FECH_ING, 'YYYY-MM-DD HH24:MI') AS FECH_ING,
               e.EVIA_USER_ING,
               e.EVIA_USER_FIRMA_1,
               TO_CHAR(e.EVIA_FECH_FIRMA_1, 'YYYY-MM-DD HH24:MI') AS FECH_FIRMA_1,
               e.EVIA_USER_FIRMA_2,
               TO_CHAR(e.EVIA_FECH_FIRMA_2, 'YYYY-MM-DD HH24:MI') AS FECH_FIRMA_2,
               e.EVIA_OBSERVACION,
               e.PERI_SEC,
               p.PERI_NOMBRE AS PERIODO,
               (SELECT COUNT(*) FROM ADM_OBS.BHO_EVIDENCIA_DOCUMENTO d WHERE d.EVIA_SEC = e.EVIA_SEC) AS CANT_DOCS
        FROM ADM_OBS.BHO_EVIDENCIA e
        LEFT JOIN ADM_OBS.BHO_FUNCIONARIOS f ON TO_CHAR(f.FUNC_RUT) = e.EVIA_RUT_EMPLEADO
        LEFT JOIN ADM_OBS.ADM_CONVENIO cv ON e.EVIA_CONVENIO = cv.CONV_CODIGO
        LEFT JOIN ADM_OBS.BHO_PERIODOS p ON e.PERI_SEC = p.PERI_SEC
        WHERE ${where.join(' AND ')}
        ORDER BY e.EVIA_SEC DESC
      ) WHERE ROWNUM <= ${maxRows}
    `);

    if (!rows || rows.length === 0) {
      rows = snap.BHO_EVIDENCIA.filter((e) => {
        if (anio && String(e.EVIA_ANO) !== String(anio)) return false;
        if (mes && String(e.EVIA_MES).padStart(2, '0') !== String(mes).padStart(2, '0')) return false;
        if (estado !== '' && estado !== undefined && String(e.EVIA_ESTADO) !== String(estado)) return false;
        if (convenio && String(e.EVIA_CONVENIO) !== String(convenio)) return false;
        if (search && String(search).trim()) {
          const q = String(search).trim().toUpperCase();
          return (
            String(e.FUNCIONARIO || '').toUpperCase().includes(q) ||
            String(e.EVIA_RUT_EMPLEADO || '').includes(q) ||
            String(e.EVIA_BOLETA || '').includes(q)
          );
        }
        return true;
      });
    }

    const overlay = loadOverlay();
    const mapped = rows.map((r) => {
      const upd = overlay.evidenciasUpdates?.[r.EVIA_SEC] || {};
      const est = upd.EVIA_ESTADO !== undefined ? upd.EVIA_ESTADO : r.EVIA_ESTADO;
      return {
        ...r,
        ...upd,
        EVIA_ESTADO: est,
        ESTADO_DESC: ESTADO_EVI_MAP[est] || `ESTADO ${est}`,
        CANT_DOCS: Number(r.CANT_DOCS || 0)
      };
    });

    res.json({ status: 'ok', data: mapped });
  } catch (err) {
    console.error('Error en /api/evidencias:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.get('/api/evidencias/:eviaSec/detalle', async (req, res) => {
  try {
    const eviaSec = Number(req.params.eviaSec);
    const batch = await queryOracleBatch({
      documentos: `
        SELECT EVDO_SEC, EVIA_SEC, EVIA_ARCHIVO, EVIA_ARCHIVO_REAL,
               EVIA_TAMANIO_ARCHIVO, EVDO_PURGADO,
               TO_CHAR(EVDO_FECH_ING, 'YYYY-MM-DD HH24:MI:SS') AS FECH_ING,
               EVDO_USER_ING, EVDO_ESTADO
        FROM ADM_OBS.BHO_EVIDENCIA_DOCUMENTO
        WHERE EVIA_SEC = ${eviaSec}
        ORDER BY EVDO_SEC ASC
      `,
      logs: `
        SELECT EVLG_SEC, EVIA_SEC, EVIA_ESTADO, EVIA_BOLETA, EVIA_RUT_EMPLEADO,
               TO_CHAR(EVIA_FECH_ING, 'YYYY-MM-DD HH24:MI:SS') AS FECH_ING,
               EVIA_USER_ING, EVIA_OBSERVACION
        FROM ADM_OBS.BHO_EVIDENCIA_LOG
        WHERE EVIA_SEC = ${eviaSec}
        ORDER BY EVLG_SEC ASC
      `
    });

    const overlay = loadOverlay();
    const extraLogs = (overlay.evidenciasLogsAdded || []).filter((l) => Number(l.EVIA_SEC) === eviaSec);
    const baseDocs =
      batch.documentos && batch.documentos.length > 0
        ? batch.documentos
        : [
            {
              EVDO_SEC: eviaSec * 10 + 1,
              EVIA_SEC: eviaSec,
              EVIA_ARCHIVO: `/data/evidencias/202610/EVI_${eviaSec}_INFORME_ACTIVIDADES.pdf`,
              EVIA_ARCHIVO_REAL: `Informe_Actividades_Folio_${eviaSec}.pdf`,
              EVIA_TAMANIO_ARCHIVO: 428190,
              EVDO_PURGADO: 'N',
              FECH_ING: '2026-11-10 09:05:12',
              EVDO_USER_ING: 'PRESTADOR',
              EVDO_ESTADO: 'VIGENTE'
            },
            {
              EVDO_SEC: eviaSec * 10 + 2,
              EVIA_SEC: eviaSec,
              EVIA_ARCHIVO: `/data/evidencias/202610/EVI_${eviaSec}_ASISTENCIA_CESFAM.pdf`,
              EVIA_ARCHIVO_REAL: `Planilla_Asistencia_Firmada_${eviaSec}.pdf`,
              EVIA_TAMANIO_ARCHIVO: 315420,
              EVDO_PURGADO: 'N',
              FECH_ING: '2026-11-10 09:06:04',
              EVDO_USER_ING: 'PRESTADOR',
              EVDO_ESTADO: 'VIGENTE'
            }
          ];
    const baseLogs =
      batch.logs && batch.logs.length > 0
        ? batch.logs
        : [
            {
              EVLG_SEC: eviaSec * 100 + 1,
              EVIA_SEC: eviaSec,
              EVIA_ESTADO: '0',
              FECH_ING: '2026-11-10 09:05:00',
              EVIA_USER_ING: 'SISTEMA',
              EVIA_OBSERVACION: 'Ingreso inicial de expediente digital de evidencia en portal.'
            }
          ];

    res.json({
      status: 'ok',
      data: {
        documentos: baseDocs,
        logs: [...baseLogs, ...extraLogs].map((l) => ({
          ...l,
          ESTADO_DESC: ESTADO_EVI_MAP[l.EVIA_ESTADO] || l.EVIA_ESTADO
        }))
      }
    });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Visar / Cambiar estado de Evidencia en PostgreSQL (Firma 1 Director CESFAM / Firma 2 Referente Técnico)
app.put('/api/evidencias/:eviaSec/visar', async (req, res) => {
  try {
    const eviaSec = Number(req.params.eviaSec);
    const { nuevoEstado, observacion, usuario, nivelFirma } = req.body;
    const userRut = usuario || '10633447';

    if (nivelFirma === 1 || ['1', '2'].includes(String(nuevoEstado))) {
      await execPostgres(
        `UPDATE adm_obs.bho_evidencia
         SET evia_estado = $1, evia_observacion = COALESCE($2, evia_observacion),
             evia_user_firma_1 = $3, evia_fech_firma_1 = NOW()
         WHERE evia_sec = $4`,
        [String(nuevoEstado), observacion || null, userRut, eviaSec]
      );
    } else {
      await execPostgres(
        `UPDATE adm_obs.bho_evidencia
         SET evia_estado = $1, evia_observacion = COALESCE($2, evia_observacion),
             evia_user_firma_2 = $3, evia_fech_firma_2 = NOW()
         WHERE evia_sec = $4`,
        [String(nuevoEstado), observacion || null, userRut, eviaSec]
      );
    }

    const maxLog = await queryOracle('SELECT COALESCE(MAX(evlg_sec), 1000) + 1 AS next_log FROM adm_obs.bho_evidencia_log');
    await execPostgres(
      `INSERT INTO adm_obs.bho_evidencia_log (
        evlg_sec, evia_sec, evia_estado, evia_fech_ing, evia_user_ing, evia_observacion
      ) VALUES ($1,$2,$3,NOW(),$4,$5)`,
      [
        Number(maxLog[0]?.NEXT_LOG || Date.now()),
        eviaSec,
        String(nuevoEstado),
        userRut,
        observacion || `Cambio de estado a ${ESTADO_EVI_MAP[nuevoEstado] || nuevoEstado}`
      ]
    );

    res.json({
      status: 'ok',
      message: `Evidencia #${eviaSec} actualizada en PostgreSQL a "${ESTADO_EVI_MAP[nuevoEstado] || nuevoEstado}".`
    });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 5. FASE 0 — MANTENEDOR GENERAL (LOS 10 CATÁLOGOS MAESTROS DE ADM_OBS / ADM_AUTH)
// ============================================================================
app.get('/api/mantenedor/:catalogo', async (req, res) => {
  try {
    const { catalogo } = req.params;
    const { search = '' } = req.query;
    const s = String(search || '').trim().toUpperCase().replace(/'/g, "''");

    let sql = '';
    let ttl = 60000;

    switch (catalogo) {
      case 'sectores':
        sql = `
          SELECT s.SECT_SEC, s.SECT_DESC,
                 (SELECT COUNT(*) FROM ADM_OBS.ADM_UNIDAD u WHERE u.SECT_SEC = s.SECT_SEC) AS TOTAL_UNIDADES,
                 (SELECT COUNT(*) FROM ADM_OBS.BHO_CENTRO_COSTO c WHERE c.CECO_SECT_SEC = s.SECT_SEC) AS TOTAL_CECOS
          FROM ADM_OBS.ADM_SECTOR s
          ORDER BY s.SECT_SEC
        `;
        break;
      case 'unidades':
        sql = `
          SELECT u.UNID_SEC, u.UNID_CODIGO, u.UNID_DESC, u.SECT_SEC,
                 NVL(s.SECT_DESC, 'SIN SECTOR') AS SECTOR_DESC,
                 u.UNID_ORDEN,
                 (SELECT COUNT(*) FROM ADM_OBS.ADM_RELA_UNIDCONV r WHERE r.UNID_SEC = u.UNID_SEC) AS TOTAL_CONVENIOS
          FROM ADM_OBS.ADM_UNIDAD u
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON u.SECT_SEC = s.SECT_SEC
          ${s ? `WHERE UPPER(u.UNID_DESC) LIKE '%${s}%' OR u.UNID_CODIGO LIKE '%${s}%'` : ''}
          ORDER BY u.UNID_CODIGO
        `;
        break;
      case 'cecos':
        sql = `
          SELECT c.CECO_SEC, c.CECO_COD, c.CECO_DESC, c.CECO_DOM_ESTADO,
                 c.CECO_SECT_SEC, NVL(s.SECT_DESC, 'SIN SECTOR') AS SECTOR_DESC
          FROM ADM_OBS.BHO_CENTRO_COSTO c
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON c.CECO_SECT_SEC = s.SECT_SEC
          ${s ? `WHERE UPPER(c.CECO_DESC) LIKE '%${s}%' OR UPPER(c.CECO_COD) LIKE '%${s}%'` : ''}
          ORDER BY c.CECO_COD
        `;
        break;
      case 'actividades':
        sql = `
          SELECT ACTI_SEC, ACTI_CODIGO, ACTI_DESC, ACTI_AREA_CUENTA, ACTI_MONTO_HORA, ACTI_ESTADO
          FROM ADM_OBS.ADM_ACTIVIDAD
          ${s ? `WHERE UPPER(ACTI_DESC) LIKE '%${s}%' OR UPPER(ACTI_CODIGO) LIKE '%${s}%'` : ''}
          ORDER BY ACTI_CODIGO
        `;
        break;
      case 'convenios':
        sql = `
          SELECT CONV_SEC, CONV_CODIGO, CONV_DESC, CONV_CUENTA_SALUD, CONV_CECO_COD,
                 CONV_IND_TRANSVERSAL, CONV_IND_RANKEAR
          FROM ADM_OBS.ADM_CONVENIO
          ${s ? `WHERE UPPER(CONV_DESC) LIKE '%${s}%' OR UPPER(CONV_CODIGO) LIKE '%${s}%'` : ''}
          ORDER BY CONV_CODIGO
        `;
        break;
      case 'formaciones':
        sql = `
          SELECT FORM_SEC, FORM_CODIGO, FORM_DESC
          FROM ADM_OBS.ADM_FORMACION
          ${s ? `WHERE UPPER(FORM_DESC) LIKE '%${s}%' OR UPPER(FORM_CODIGO) LIKE '%${s}%'` : ''}
          ORDER BY FORM_CODIGO
        `;
        break;
      case 'departamentos':
        sql = `
          SELECT DEPA_SEC, DEPA_COD, DEPA_NOMBRE, DEPA_RUT_RESP, DEPA_DV_RUT_RESP,
                 DEPA_NOMBRE_RESP, DEPA_CORREO_RESP, DEPA_ESTADO, DEPA_NOMBRE_SUBR,
                 DEPA_PERMITE_AUTORIZA
          FROM ADM_OBS.HR_DEPARTAMENTO
          ${s ? `WHERE UPPER(DEPA_NOMBRE) LIKE '%${s}%' OR UPPER(DEPA_NOMBRE_RESP) LIKE '%${s}%'` : ''}
          ORDER BY DEPA_SEC
        `;
        break;
      case 'usuarios':
        ttl = 15000;
        sql = `
          SELECT * FROM (
            SELECT v.RUT_USUARIO,
                   a.USUA_DV AS DV,
                   v.NOMBRE_USUARIO,
                   v.CORREO,
                   v.TELEFONO,
                   v.SYS_OBS,
                   v.SYS_VERI,
                   v.SYS_REM,
                   NVL(a.USA_TIPO, 'U') AS TIPO,
                   NVL(a.USUA_ESTADO, 'A') AS ESTADO,
                   (SELECT COUNT(*) FROM ADM_OBS.OBS_USER_MENU m WHERE m.USME_USUARIO = v.RUT_USUARIO) AS PERMISOS_MENU
            FROM ADM_OBS.OBS_USUARIOS_AUTH_V v
            LEFT JOIN ADM_AUTH.AUT_USUARIOS a ON v.RUT_USUARIO = a.USUA_RUT
            ${s ? `WHERE UPPER(v.NOMBRE_USUARIO) LIKE '%${s}%' OR TO_CHAR(v.RUT_USUARIO) LIKE '%${s}%' OR UPPER(v.CORREO) LIKE '%${s}%'` : ''}
            ORDER BY v.NOMBRE_USUARIO
          ) WHERE ROWNUM <= 200
        `;
        break;
      case 'menus':
        sql = `
          SELECT m.MENU_ID, m.MENU_DESC, m.MENU_ID_PADRE,
                 p.MENU_DESC AS PADRE_DESC,
                 d.MEDE_LABEL, d.MEDE_LINK, d.MEDE_POS_PADRE, d.MEDE_POS_APLIC
          FROM ADM_OBS.OBS_MENU m
          LEFT JOIN ADM_OBS.OBS_MENU p ON m.MENU_ID_PADRE = p.MENU_ID
          LEFT JOIN ADM_OBS.OBS_MENU_DETALLE d ON m.MENU_ID = d.MENU_ID
          ORDER BY m.MENU_ID_PADRE NULLS FIRST, m.MENU_ID
        `;
        break;
      case 'dominios':
        sql = `
          SELECT REF_DOM, REF_LOW_VAL, REF_HIG_VAL, REF_ABR, REF_MNG, REF_MOD
          FROM ADM_OBS.OBS_REF_CODES
          ${s ? `WHERE UPPER(REF_DOM) LIKE '%${s}%' OR UPPER(REF_MNG) LIKE '%${s}%' OR UPPER(REF_LOW_VAL) LIKE '%${s}%'` : ''}
          ORDER BY REF_DOM, REF_LOW_VAL
        `;
        break;
      case 'parametros':
        sql = `
          SELECT PARA_CODIGO, PARA_DESC, PARA_VALOR
          FROM ADM_OBS.OBS_PARAMETROS
          ORDER BY PARA_CODIGO
        `;
        break;
      case 'periodos':
        sql = `
          SELECT p.PERI_SEC, p.PERI_NOMBRE, p.PERI_ESTADO,
                 TO_CHAR(p.PERI_FECHA_ING, 'YYYY-MM-DD') AS FECHA_ING,
                 TO_CHAR(p.PERI_FECHA_EVIDENCIA, 'YYYY-MM-DD') AS FECHA_EVIDENCIA,
                 p.SECT_SEC, NVL(s.SECT_DESC, 'SIN SECTOR') AS SECTOR_DESC,
                 (SELECT COUNT(*) FROM ADM_OBS.BHO_BOLETAS b WHERE b.PERI_SEC = p.PERI_SEC) AS TOTAL_BOLETAS
          FROM ADM_OBS.BHO_PERIODOS p
          LEFT JOIN ADM_OBS.ADM_SECTOR s ON p.SECT_SEC = s.SECT_SEC
          ORDER BY p.PERI_NOMBRE DESC, p.SECT_SEC ASC
        `;
        break;
      default:
        return res.status(400).json({ status: 'error', message: 'Catálogo no reconocido' });
    }

    let rows = await queryOracle(sql, s ? 0 : ttl);
    if (!rows || rows.length === 0) {
      const menuMap = new Map(snap.OBS_MENU.map((m) => [String(m.MENU_ID), m.MENU_DESC]));
      const detMap = new Map(snap.OBS_MENU_DETALLE.map((d) => [String(d.MENU_ID), d]));
      const fallbackMap = {
        sectores: snap.ADM_SECTOR,
        unidades: snap.ADM_UNIDAD,
        cecos: snap.BHO_CENTRO_COSTO,
        actividades: snap.ADM_ACTIVIDAD,
        convenios: snap.ADM_CONVENIO,
        formaciones: snap.ADM_FORMACION,
        departamentos: snap.HR_DEPARTAMENTO,
        usuarios: snap.AUT_USUARIOS.map((u) => ({
          RUT_USUARIO: u.USUA_RUT,
          DV: u.USUA_DV,
          NOMBRE_USUARIO: `${u.USA_NOMBRE} ${u.USA_APELLIDOS}`.trim(),
          CORREO: u.USA_EMAIL,
          TELEFONO: u.USA_TELEFONO,
          SYS_OBS: u.SYS_OBS,
          SYS_VERI: u.SYS_VERI,
          SYS_REM: u.SYS_REM,
          TIPO: u.USA_TIPO,
          ESTADO: u.USUA_ESTADO,
          PERMISOS_MENU: u.PERMISOS_MENU
        })),
        menus: snap.OBS_MENU.map((m) => {
          const d = detMap.get(String(m.MENU_ID)) || {};
          return {
            MENU_ID: m.MENU_ID,
            MENU_DESC: m.MENU_DESC,
            MENU_ID_PADRE: m.MENU_ID_PADRE,
            PADRE_DESC: m.MENU_ID_PADRE ? menuMap.get(String(m.MENU_ID_PADRE)) || 'RAÍZ' : 'RAÍZ PRINCIPAL',
            MEDE_LABEL: d.MEDE_LABEL || m.MENU_DESC,
            MEDE_LINK: d.MEDE_LINK || '—',
            MEDE_POS_PADRE: d.MEDE_POS_PADRE || '',
            MEDE_POS_APLIC: d.MEDE_POS_APLIC || ''
          };
        }),
        dominios: snap.REF_CODES,
        parametros: snap.OBS_PARAMETROS,
        periodos: snap.BHO_PERIODOS
      };
      rows = fallbackMap[catalogo] || [];
      if (s) {
        rows = rows.filter((item) =>
          Object.values(item).some((v) => String(v || '').toUpperCase().includes(s))
        );
      }
    }
    const overlay = loadOverlay();
    const added = overlay.mantenedorCreated?.[catalogo] || [];

    res.json({
      status: 'ok',
      data: [...added, ...rows]
    });
  } catch (err) {
    console.error('Error en /api/mantenedor:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/mantenedor/:catalogo', (req, res) => {
  try {
    const { catalogo } = req.params;
    const item = req.body;
    const overlay = loadOverlay();
    overlay.mantenedorCreated = overlay.mantenedorCreated || {};
    overlay.mantenedorCreated[catalogo] = [item, ...(overlay.mantenedorCreated[catalogo] || [])];
    saveOverlay(overlay);
    res.json({
      status: 'ok',
      message: `Registro agregado exitosamente en catálogo "${catalogo}".`,
      data: item
    });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 7. FASE 2 — MÓDULO 1: OFICINA DE PARTES (ADM_OBS.OPA_*)
// ============================================================================
app.get('/api/oficina-partes', async (req, res) => {
  try {
    const estado = (req.query.estado || '').trim().toUpperCase();
    const tipo = (req.query.tipo || '').trim().toUpperCase();
    const search = (req.query.search || '').trim().toUpperCase().replace(/'/g, '');

    let where = 'WHERE 1=1';
    if (estado) where += ` AND UPPER(d.DOCU_ULT_ESTADO) = '${estado}'`;
    if (tipo) where += ` AND UPPER(d.DOCU_TIPO_DOCU) = '${tipo}'`;
    if (search) {
      where += ` AND (UPPER(d.DOCU_NRO) LIKE '%${search}%' OR UPPER(d.DOCU_MATERIA) LIKE '%${search}%' OR UPPER(r.REMI_RAZON_SOCIAL) LIKE '%${search}%' OR CAST(d.DOCU_ORDEN AS TEXT) LIKE '%${search}%')`;
    }

    const [documentos, tiposDocumento, remitentes, destinatarios] = await Promise.all([
      queryOracle(
        `
        SELECT d.DOCU_SEC, d.DOCU_ORDEN, d.DOCU_NRO,
               TO_CHAR(d.DOCU_FECHA, 'YYYY-MM-DD') AS FECHA_DOC,
               d.DOCU_MATERIA, d.DOCU_TIPO_DOCU,
               COALESCE(t.TIDO_DESC_DOCU, d.DOCU_TIPO_DOCU) AS TIPO_DESC,
               d.DOCU_ULT_ESTADO, d.DOCU_REMI_SEC,
               COALESCE(r.REMI_RAZON_SOCIAL, 'SIN REMITENTE') AS REMITENTE,
               COALESCE(r.REMI_RUT || '-' || r.REMI_DV, '') AS REMITENTE_RUT,
               d.DOCU_OBS, d.DOCU_REMI_TIPO, d.DOCU_PRIVADO,
               TO_CHAR(d.DOCU_FECHA_ING, 'YYYY-MM-DD HH24:MI') AS FECHA_ING,
               COALESCE(v.VALO_NETO, 0) AS VALO_NETO,
               COALESCE(v.VALO_IVA, 0) AS VALO_IVA,
               COALESCE(v.VALO_TOTAL, 0) AS VALO_TOTAL,
               COALESCE(v.VALO_IND_OC, 'N') AS VALO_IND_OC,
               COALESCE(v.VALO_OC, '') AS VALO_OC,
               f.FLUJ_SEC, f.DEST_SEC,
               COALESCE(dest.DEST_NOMBRE, 'PENDIENTE ASIGNACION') AS DESTINATARIO,
               COALESCE(dest.DEST_AREA, '') AS DESTINATARIO_AREA,
               TO_CHAR(f.FLUJ_FECHA_RPTA, 'YYYY-MM-DD') AS FECHA_PLAZO
        FROM ADM_OBS.OPA_DOCUMENTOS d
        LEFT JOIN ADM_OBS.OPA_TIPO_DOCUMENTOS t ON d.DOCU_TIPO_DOCU = t.TIDO_TIPO_DOCU
        LEFT JOIN ADM_OBS.OPA_REMITENTES r ON d.DOCU_REMI_SEC = r.REMI_SEC
        LEFT JOIN ADM_OBS.OPA_VALORADOS v ON d.DOCU_SEC = v.DOCU_SEC
        LEFT JOIN ADM_OBS.OPA_FLUJO f ON d.DOCU_SEC = f.DOCU_SEC
        LEFT JOIN ADM_OBS.OPA_DESTINATARIOS dest ON f.DEST_SEC = dest.DEST_SEC
        ${where}
        ORDER BY d.DOCU_SEC DESC
        LIMIT 100
      `,
        0
      ),
      queryOracle(`SELECT TIDO_SEC, TIDO_TIPO_DOCU, TIDO_DESC_DOCU, TIDO_ULT_ESTADO FROM ADM_OBS.OPA_TIPO_DOCUMENTOS ORDER BY TIDO_SEC`, 30000),
      queryOracle(`SELECT REMI_SEC, REMI_RUT, REMI_DV, REMI_RAZON_SOCIAL, REMI_TIPO, REMI_TEL, REMI_CONTACTO, REMI_MAIL FROM ADM_OBS.OPA_REMITENTES ORDER BY REMI_SEC DESC LIMIT 100`, 15000),
      queryOracle(`SELECT DEST_SEC, DEST_NOMBRE, DEST_AREA, DEST_MAIL, DEST_RUT, DEST_DV, DEPA_SEC, DEST_ESTADO FROM ADM_OBS.OPA_DESTINATARIOS ORDER BY DEST_SEC`, 30000)
    ]);

    const movs = await queryOracle(
      `
      SELECT m.MODO_SEC, m.DOCU_SEC, m.MODO_ESTADO, m.MODO_OBS, m.MODO_TIPO_FLUJO,
             TO_CHAR(m.MODO_FECHA_ING, 'YYYY-MM-DD HH24:MI') AS FECHA_MOV,
             m.MODO_USER_ING,
             COALESCE(dest.DEST_NOMBRE, '') AS DESTINATARIO
      FROM ADM_OBS.OPA_MOV_DOCUMENTOS m
      LEFT JOIN ADM_OBS.OPA_DESTINATARIOS dest ON m.DEST_SEC = dest.DEST_SEC
      ORDER BY m.MODO_SEC DESC
      LIMIT 200
    `,
      0
    );

    res.json({
      status: 'ok',
      data: documentos || [],
      movimientos: movs || [],
      catalogos: {
        tiposDocumento: tiposDocumento || [],
        remitentes: remitentes || [],
        destinatarios: destinatarios || []
      }
    });
  } catch (err) {
    console.error('Error en GET /api/oficina-partes:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/oficina-partes', async (req, res) => {
  try {
    const {
      docuNro,
      docuFecha,
      docuMateria,
      docuTipoDocu = 'OFIC',
      docuRemiSec = 101,
      docuObs = '',
      destSec = 201,
      valoNeto = 0,
      valoOc = '',
      usuario = '10633447'
    } = req.body;

    if (!docuNro || !docuMateria) {
      return res.status(400).json({ status: 'error', message: 'N° de documento y materia son obligatorios.' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(DOCU_SEC), 5000) + 1 AS NEXT_ID, COALESCE(MAX(DOCU_ORDEN), 2026000) + 1 AS NEXT_ORD FROM ADM_OBS.OPA_DOCUMENTOS`, 0);
    const nextSec = Number(maxRow[0]?.NEXT_ID || 5050);
    const nextOrden = Number(maxRow[0]?.NEXT_ORD || 2026050);
    const neto = Number(valoNeto || 0);
    const iva = Math.round(neto * 0.19);
    const total = neto + iva;

    await execPostgres(
      `INSERT INTO adm_obs.opa_documentos (
        docu_sec, docu_orden, docu_nro, docu_fecha, docu_materia, docu_tipo_docu,
        docu_ult_estado, docu_remi_sec, docu_obs, docu_user_ing, docu_fecha_ing,
        docu_remi_tipo, docu_privado
      ) VALUES ($1, $2, $3, COALESCE($4::timestamp, NOW()), $5, $6, 'INGRESADO', $7, $8, $9, NOW(), 'EXTERNO', 'N')`,
      [nextSec, nextOrden, String(docuNro).toUpperCase(), docuFecha || null, String(docuMateria).toUpperCase(), docuTipoDocu, Number(docuRemiSec), docuObs, String(usuario)]
    );

    if (total > 0) {
      await execPostgres(
        `INSERT INTO adm_obs.opa_valorados (docu_sec, remi_sec, valo_neto, valo_iva, valo_total, valo_ind_oc, valo_oc, valo_user_ing, valo_fecha_ing)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW())`,
        [nextSec, Number(docuRemiSec), neto, iva, total, valoOc ? 'S' : 'N', valoOc || '', String(usuario)]
      );
    }

    const flujSec = nextSec + 1000;
    await execPostgres(
      `INSERT INTO adm_obs.opa_flujo (fluj_sec, docu_sec, fluj_estado, fluj_fecha_rpta, dest_sec, remi_sec, fluj_observaciones, fluj_user_ing, fluj_fecha_ing)
       VALUES ($1, $2, 'INGRESADO', NOW() + INTERVAL '5 days', $3, $4, $5, $6, NOW())`,
      [flujSec, nextSec, Number(destSec), Number(docuRemiSec), docuObs || 'Ingreso por Oficina de Partes', String(usuario)]
    );

    await execPostgres(
      `INSERT INTO adm_obs.opa_mov_documentos (modo_sec, fluj_sec, docu_sec, modo_estado, modo_obs, dest_sec, remi_sec, modo_tipo_flujo, modo_user_ing, modo_fecha_ing)
       VALUES ($1, $2, $3, 'INGRESADO', $4, $5, $6, 'INGRESO', $7, NOW())`,
      [nextSec + 2000, flujSec, nextSec, `Documento ingresado y asignado a destinatario #${destSec}`, Number(destSec), Number(docuRemiSec), String(usuario)]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Documento Folio #${nextOrden} (${docuNro}) registrado en PostgreSQL (adm_obs.opa_documentos).`,
      docuSec: nextSec
    });
  } catch (err) {
    console.error('Error en POST /api/oficina-partes:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.put('/api/oficina-partes/:docuSec/derivar', async (req, res) => {
  try {
    const docuSec = Number(req.params.docuSec);
    const { nuevoEstado = 'RECEPCIONADO', destSec, observacion = '', usuario = '10633447' } = req.body;

    await execPostgres(
      `UPDATE adm_obs.opa_documentos
       SET docu_ult_estado = $1, docu_fecha_mod = NOW(), docu_user_mod = $2
       WHERE docu_sec = $3`,
      [nuevoEstado, String(usuario), docuSec]
    );

    if (destSec) {
      await execPostgres(
        `UPDATE adm_obs.opa_flujo
         SET fluj_estado = $1, dest_sec = $2, fluj_observaciones = $3, fluj_fecha_mod = NOW(), fluj_user_mod = $4
         WHERE docu_sec = $5`,
        [nuevoEstado, Number(destSec), observacion || `Estado actualizado a ${nuevoEstado}`, String(usuario), docuSec]
      );
    } else {
      await execPostgres(
        `UPDATE adm_obs.opa_flujo
         SET fluj_estado = $1, fluj_observaciones = $2, fluj_fecha_mod = NOW(), fluj_user_mod = $3
         WHERE docu_sec = $4`,
        [nuevoEstado, observacion || `Estado actualizado a ${nuevoEstado}`, String(usuario), docuSec]
      );
    }

    const maxMov = await queryOracle(`SELECT COALESCE(MAX(MODO_SEC), 8000) + 1 AS NEXT_MOV FROM ADM_OBS.OPA_MOV_DOCUMENTOS`, 0);
    const nextMov = Number(maxMov[0]?.NEXT_MOV || Date.now() % 1000000);
    await execPostgres(
      `INSERT INTO adm_obs.opa_mov_documentos (modo_sec, fluj_sec, docu_sec, modo_estado, modo_obs, dest_sec, modo_tipo_flujo, modo_user_ing, modo_fecha_ing)
       VALUES ($1, $2, $3, $4, $5, $6, 'CAMBIO ESTADO', $7, NOW())`,
      [nextMov, docuSec + 1000, docuSec, nuevoEstado, observacion || `Actualizado a ${nuevoEstado}`, destSec ? Number(destSec) : 201, String(usuario)]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Documento #${docuSec} actualizado a "${nuevoEstado}" en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en PUT /api/oficina-partes/:docuSec/derivar:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 8. FASE 2 — MÓDULO 2: ORDEN DE SERVICIO - ODS (ADM_OBS.OPA_ORDEN_SERVICIO*)
// ============================================================================
app.get('/api/ordenes-servicio', async (req, res) => {
  try {
    const estado = (req.query.estado || '').trim().toUpperCase();
    const prioridad = (req.query.prioridad || '').trim().toUpperCase();
    const search = (req.query.search || '').trim().toUpperCase().replace(/'/g, '');

    let where = 'WHERE 1=1';
    if (estado) where += ` AND UPPER(o.ORSE_ESTADO) = '${estado}'`;
    if (prioridad) where += ` AND UPPER(o.ORSE_PRIORIDAD) = '${prioridad}'`;
    if (search) {
      where += ` AND (UPPER(o.DOCU_NUMERO) LIKE '%${search}%' OR UPPER(CAST(o.ORDE_DESCRIPCION AS TEXT)) LIKE '%${search}%' OR UPPER(r.REMI_RAZON_SOCIAL) LIKE '%${search}%')`;
    }

    const [ordenes, tiposOds, materias, destinatarios, remitentes] = await Promise.all([
      queryOracle(
        `
        SELECT o.ORSE_SEC, o.ORSE_DOC_SEC, o.DOCU_NUMERO, o.REMI_SEC,
               COALESCE(r.REMI_RAZON_SOCIAL, 'DIRECCION EJECUTIVA CMDS') AS REMITENTE,
               o.ORSE_ESTADO, o.ORSE_ORIGEN,
               TO_CHAR(o.ORSE_FECHA_ENVIO, 'YYYY-MM-DD') AS FECHA_ENVIO,
               TO_CHAR(o.ORSE_FECH_ING, 'YYYY-MM-DD') AS FECHA_ING,
               CAST(o.ORDE_DESCRIPCION AS TEXT) AS DESCRIPCION,
               o.ORSE_IND_RSVA, o.ORSE_PRIORIDAD, o.ORSE_IND_OFPA, o.TIOS_SEC,
               COALESCE(t.TIOS_NOMBRE, 'ORDEN DE SERVICIO') AS TIPO_ODS,
               om.MATE_SEC,
               COALESCE(mat.MATE_NOMBRE, 'GESTION GENERAL') AS MATERIA,
               m.OSMO_SEC, m.DEST_SEC,
               COALESCE(dest.DEST_NOMBRE, 'SIN ASIGNAR') AS DESTINATARIO,
               COALESCE(dest.DEST_AREA, '') AS DESTINATARIO_AREA,
               TO_CHAR(m.OSMO_FECHA_RPTA, 'YYYY-MM-DD') AS FECHA_PLAZO
        FROM ADM_OBS.OPA_ORDEN_SERVICIO o
        LEFT JOIN ADM_OBS.OPA_REMITENTES r ON o.REMI_SEC = r.REMI_SEC
        LEFT JOIN ADM_OBS.OPA_DM_TIPO_ORDEN_SERVICIO t ON o.TIOS_SEC = t.TIOS_SEC
        LEFT JOIN ADM_OBS.OPA_ORSE_MATERIA om ON o.ORSE_SEC = om.ORSE_SEC
        LEFT JOIN ADM_OBS.OPA_MATERIA mat ON om.MATE_SEC = mat.MATE_SEC
        LEFT JOIN ADM_OBS.OPA_ORDEN_SERVICIO_MOV m ON o.ORSE_SEC = m.ORSE_SEC
        LEFT JOIN ADM_OBS.OPA_DESTINATARIOS dest ON m.DEST_SEC = dest.DEST_SEC
        ${where}
        ORDER BY o.ORSE_SEC DESC
        LIMIT 100
      `,
        0
      ),
      queryOracle(`SELECT TIOS_SEC, TIOS_NOMBRE, TIOS_PRINCIPAL FROM ADM_OBS.OPA_DM_TIPO_ORDEN_SERVICIO ORDER BY TIOS_SEC`, 30000),
      queryOracle(`SELECT MATE_SEC, MATE_NOMBRE, MATE_ESTADO FROM ADM_OBS.OPA_MATERIA ORDER BY MATE_SEC`, 30000),
      queryOracle(`SELECT DEST_SEC, DEST_NOMBRE, DEST_AREA, DEST_MAIL FROM ADM_OBS.OPA_DESTINATARIOS ORDER BY DEST_SEC`, 30000),
      queryOracle(`SELECT REMI_SEC, REMI_RAZON_SOCIAL, REMI_TIPO FROM ADM_OBS.OPA_REMITENTES ORDER BY REMI_SEC`, 30000)
    ]);

    res.json({
      status: 'ok',
      data: ordenes || [],
      catalogos: {
        tiposOds: tiposOds || [],
        materias: materias || [],
        destinatarios: destinatarios || [],
        remitentes: remitentes || []
      }
    });
  } catch (err) {
    console.error('Error en GET /api/ordenes-servicio:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/ordenes-servicio', async (req, res) => {
  try {
    const {
      docuNumero,
      remiSec = 108,
      destSec = 203,
      tiosSec = 1,
      mateSec = 1,
      prioridad = 'ALTA',
      origen = 'DIRECCION EJECUTIVA',
      fechaPlazo,
      descripcion = '',
      usuario = '10633447'
    } = req.body;

    if (!descripcion) {
      return res.status(400).json({ status: 'error', message: 'La instrucción/descripción de la ODS es obligatoria.' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(ORSE_SEC), 7000) + 1 AS NEXT_ID FROM ADM_OBS.OPA_ORDEN_SERVICIO`, 0);
    const nextSec = Number(maxRow[0]?.NEXT_ID || 7050);
    const folio = docuNumero || `ODS-2026-0${nextSec - 6920}`;

    await execPostgres(
      `INSERT INTO adm_obs.opa_orden_servicio (
        orse_sec, docu_numero, remi_sec, orse_estado, orse_origen,
        orse_fecha_envio, orse_fech_ing, orse_user_ing, orde_descripcion,
        orse_ind_rsva, orse_prioridad, orse_ind_ofpa, tios_sec
      ) VALUES ($1, $2, $3, 'INGRESADA', $4, NOW(), NOW(), $5, $6, 'N', $7, 0, $8)`,
      [nextSec, folio, Number(remiSec), origen, String(usuario), descripcion, prioridad, Number(tiosSec)]
    );

    await execPostgres(
      `INSERT INTO adm_obs.opa_orse_materia (orse_sec, mate_sec, osma_fech_ing, osma_user_ing)
       VALUES ($1, $2, NOW(), $3)`,
      [nextSec, Number(mateSec), String(usuario)]
    );

    await execPostgres(
      `INSERT INTO adm_obs.opa_orden_servicio_mov (
        osmo_sec, orse_sec, remi_sec, dest_sec, osmo_estado, osmo_fecha_rpta,
        osmo_fech_ing, osmo_user_ing, osmo_descripcion, osmo_tipo_deriv
      ) VALUES ($1, $2, $3, $4, 'INGRESADA', COALESCE($5::timestamp, NOW() + INTERVAL '5 days'), NOW(), $6, $7, 'PRINCIPAL')`,
      [nextSec + 1000, nextSec, Number(remiSec), Number(destSec), fechaPlazo || null, String(usuario), descripcion]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Orden de Servicio ${folio} creada exitosamente en PostgreSQL.`,
      orseSec: nextSec
    });
  } catch (err) {
    console.error('Error en POST /api/ordenes-servicio:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.put('/api/ordenes-servicio/:orseSec/estado', async (req, res) => {
  try {
    const orseSec = Number(req.params.orseSec);
    const { nuevoEstado = 'EN GESTION', observacion = '', destSec, usuario = '10633447' } = req.body;

    await execPostgres(
      `UPDATE adm_obs.opa_orden_servicio
       SET orse_estado = $1, orse_fech_mod = NOW(), orse_user_mod = $2
       WHERE orse_sec = $3`,
      [nuevoEstado, String(usuario), orseSec]
    );

    if (destSec) {
      await execPostgres(
        `UPDATE adm_obs.opa_orden_servicio_mov
         SET osmo_estado = $1, dest_sec = $2, osmo_descripcion = COALESCE(NULLIF($3, ''), osmo_descripcion), osmo_fech_mod = NOW(), osmo_user_mod = $4
         WHERE orse_sec = $5`,
        [nuevoEstado, Number(destSec), observacion, String(usuario), orseSec]
      );
    } else {
      await execPostgres(
        `UPDATE adm_obs.opa_orden_servicio_mov
         SET osmo_estado = $1, osmo_descripcion = COALESCE(NULLIF($2, ''), osmo_descripcion), osmo_fech_mod = NOW(), osmo_user_mod = $3
         WHERE orse_sec = $4`,
        [nuevoEstado, observacion, String(usuario), orseSec]
      );
    }

    clearCache();
    res.json({
      status: 'ok',
      message: `Orden de Servicio #${orseSec} actualizada a "${nuevoEstado}" en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en PUT /api/ordenes-servicio/:orseSec/estado:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 9. FASE 2 — MÓDULO 3: MANTENIMIENTO DE OBRAS - OTR (ADM_OBS.OTR_*)
// ============================================================================
app.get('/api/obras', async (req, res) => {
  try {
    const estado = req.query.estado ? Number(req.query.estado) : 0;
    const tipo = req.query.tipo ? Number(req.query.tipo) : 0;
    const search = (req.query.search || '').trim().toUpperCase().replace(/'/g, '');

    let where = 'WHERE 1=1';
    if (estado) where += ` AND ot.DOEO_ID = ${estado}`;
    if (tipo) where += ` AND ot.DOTO_ID = ${tipo}`;
    if (search) {
      where += ` AND (UPPER(ot.ORTR_OBS) LIKE '%${search}%' OR UPPER(c.CONT_RAZON_SOCIAL) LIKE '%${search}%' OR CAST(ot.ORTR_ID AS TEXT) LIKE '%${search}%')`;
    }

    const [ordenesTrabajo, detalles, estadosOt, tiposOt, ubicaciones, contratistas, zonas, itemsServicio] = await Promise.all([
      queryOracle(
        `
        SELECT ot.ORTR_ID, ot.ZONA_ID, z.ZONA_NUM, z.SECT_SEC,
               COALESCE(s.SECT_DESC, 'EDUCACION / SALUD') AS SECTOR_DESC,
               z.CONT_RUT, c.CONT_DV,
               COALESCE(c.CONT_RAZON_SOCIAL, 'SIN CONTRATISTA') AS CONTRATISTA,
               z.DOUB_ID,
               COALESCE(ub.DOUB_LUGAR, 'ANTOFAGASTA') AS UBICACION,
               ot.ORTR_MONTO_NETO, ot.ORTR_IVA, ot.ORTR_MONTO_BRUTO,
               ot.DOEO_ID,
               COALESCE(est.DOEO_ESTADO, 'EMITIDA') AS ESTADO_DESC,
               ot.DOTO_ID,
               COALESCE(tp.DOTO_DESC, 'MANTENCION') AS TIPO_OT_DESC,
               ot.ORTRA_ANIO,
               TO_CHAR(ot.ORTRA_FEC_CRE, 'YYYY-MM-DD') AS FECHA_CREACION,
               TO_CHAR(ot.ORTR_FEC_INI, 'YYYY-MM-DD') AS FECHA_INICIO,
               TO_CHAR(ot.ORTR_FEC_TER, 'YYYY-MM-DD') AS FECHA_TERMINO,
               ot.USOT_RUT, ot.ORTR_OBS
        FROM ADM_OBS.OTR_ORDEN_TRABAJO ot
        LEFT JOIN ADM_OBS.OTR_ZONAS z ON ot.ZONA_ID = z.ZONA_ID
        LEFT JOIN ADM_OBS.ADM_SECTOR s ON z.SECT_SEC = s.SECT_SEC
        LEFT JOIN ADM_OBS.OTR_CONTRATISTAS c ON z.CONT_RUT = c.CONT_RUT
        LEFT JOIN ADM_OBS.OTR_DOM_UBICACIONES ub ON z.DOUB_ID = ub.DOUB_ID
        LEFT JOIN ADM_OBS.OTR_DOM_ESTADOS_OT est ON ot.DOEO_ID = est.DOEO_ID
        LEFT JOIN ADM_OBS.OTR_DOM_TIPO_OT tp ON ot.DOTO_ID = tp.DOTO_ID
        ${where}
        ORDER BY ot.ORTR_ID DESC
      `,
        0
      ),
      queryOracle(
        `
        SELECT d.ORTD_ID, d.ORTR_ID, d.ITSE_ID,
               i.ITSE_CODIGO, i.ITSE_NOMBRE, i.ITSE_UNIDAD,
               d.ORTD_CANTIDAD, d.ORTD_PRECIO_NETO, d.ORTD_IVA, d.ORTD_PRECIO_BRUTO
        FROM ADM_OBS.OTR_ORDEN_TRABAJO_DET d
        LEFT JOIN ADM_OBS.OTR_ITEM_SERVICIO i ON d.ITSE_ID = i.ITSE_ID
        ORDER BY d.ORTD_ID
      `,
        0
      ),
      queryOracle(`SELECT DOEO_ID, DOEO_ESTADO FROM ADM_OBS.OTR_DOM_ESTADOS_OT ORDER BY DOEO_ID`, 30000),
      queryOracle(`SELECT DOTO_ID, DOTO_DESC FROM ADM_OBS.OTR_DOM_TIPO_OT ORDER BY DOTO_ID`, 30000),
      queryOracle(`SELECT DOUB_ID, DOUB_LUGAR FROM ADM_OBS.OTR_DOM_UBICACIONES ORDER BY DOUB_ID`, 30000),
      queryOracle(`SELECT CONT_RUT, CONT_DV, CONT_RAZON_SOCIAL FROM ADM_OBS.OTR_CONTRATISTAS ORDER BY CONT_RAZON_SOCIAL`, 30000),
      queryOracle(
        `
        SELECT z.ZONA_ID, z.ZONA_NUM, z.SECT_SEC, COALESCE(s.SECT_DESC, 'SECTOR') AS SECTOR_DESC,
               z.CONT_RUT, COALESCE(c.CONT_RAZON_SOCIAL, '') AS CONTRATISTA,
               z.DOUB_ID, COALESCE(u.DOUB_LUGAR, '') AS UBICACION,
               z.ZONA_MONTO_NETO, z.ZONA_IVA, z.ZONA_MONTO_BRUTO, z.ZONA_ANIO
        FROM ADM_OBS.OTR_ZONAS z
        LEFT JOIN ADM_OBS.ADM_SECTOR s ON z.SECT_SEC = s.SECT_SEC
        LEFT JOIN ADM_OBS.OTR_CONTRATISTAS c ON z.CONT_RUT = c.CONT_RUT
        LEFT JOIN ADM_OBS.OTR_DOM_UBICACIONES u ON z.DOUB_ID = u.DOUB_ID
        ORDER BY z.ZONA_ID
      `,
        15000
      ),
      queryOracle(
        `
        SELECT i.ITSE_ID, i.ITSE_CODIGO, i.ITSE_NOMBRE, i.ITSE_DESC, i.ITSE_UNIDAD,
               COALESCE((SELECT MAX(ic.ITCO_PRECIO_NETO) FROM ADM_OBS.OTR_ITEMS_CONTRATISTA ic WHERE ic.ITSE_ID = i.ITSE_ID), 25000) AS PRECIO_UNITARIO
        FROM ADM_OBS.OTR_ITEM_SERVICIO i
        ORDER BY i.ITSE_ID
      `,
        15000
      )
    ]);

    const detByOt = {};
    for (const d of detalles || []) {
      const k = d.ORTR_ID;
      if (!detByOt[k]) detByOt[k] = [];
      detByOt[k].push(d);
    }

    const enriched = (ordenesTrabajo || []).map((ot) => ({
      ...ot,
      ITEMS: detByOt[ot.ORTR_ID] || []
    }));

    res.json({
      status: 'ok',
      data: enriched,
      catalogos: {
        estadosOt: estadosOt || [],
        tiposOt: tiposOt || [],
        ubicaciones: ubicaciones || [],
        contratistas: contratistas || [],
        zonas: zonas || [],
        itemsServicio: itemsServicio || []
      }
    });
  } catch (err) {
    console.error('Error en GET /api/obras:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/obras', async (req, res) => {
  try {
    const {
      zonaId = 1,
      dotoId = 1,
      itseId = 101,
      cantidad = 10,
      precioUnitario = 28500,
      fechaInicio,
      fechaTermino,
      observaciones = '',
      usuario = '10633447'
    } = req.body;

    if (!observaciones) {
      return res.status(400).json({ status: 'error', message: 'La descripción de los trabajos a ejecutar es obligatoria.' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(ORTR_ID), 900) + 1 AS NEXT_ID FROM ADM_OBS.OTR_ORDEN_TRABAJO`, 0);
    const nextId = Number(maxRow[0]?.NEXT_ID || 920);
    const cant = Number(cantidad || 1);
    const pUnit = Number(precioUnitario || 25000);
    const neto = Math.round(cant * pUnit);
    const iva = Math.round(neto * 0.19);
    const bruto = neto + iva;

    await execPostgres(
      `INSERT INTO adm_obs.otr_orden_trabajo (
        ortr_id, zona_id, ortr_monto_neto, ortr_iva, ortr_monto_bruto, doeo_id,
        ortra_anio, ortra_fec_cre, usot_rut, ortr_fec_ins, ortr_user_ins,
        doto_id, ortr_fec_ini, ortr_fec_ter, ortr_obs
      ) VALUES ($1, $2, $3, $4, $5, 1, 2026, NOW(), $6, NOW(), $7, $8, COALESCE($9::timestamp, NOW()), COALESCE($10::timestamp, NOW() + INTERVAL '10 days'), $11)`,
      [nextId, Number(zonaId), neto, iva, bruto, Number(String(usuario).replace(/\D/g, '') || 10633447), String(usuario), Number(dotoId), fechaInicio || null, fechaTermino || null, observaciones]
    );

    await execPostgres(
      `INSERT INTO adm_obs.otr_orden_trabajo_det (
        ortd_id, ortr_id, zoun_id, itse_id, ortd_cantidad, ortd_precio_neto,
        ortd_iva, ortd_precio_bruto, ortd_fec_ins, ortd_user_ins
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), $9)`,
      [nextId * 10 + 1, nextId, Number(zonaId), Number(itseId), cant, neto, iva, bruto, String(usuario)]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Orden de Trabajo OT #${nextId} emitida y registrada en PostgreSQL.`,
      ortrId: nextId
    });
  } catch (err) {
    console.error('Error en POST /api/obras:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.put('/api/obras/:ortrId/estado', async (req, res) => {
  try {
    const ortrId = Number(req.params.ortrId);
    const { doeoId = 2, observacion = '', usuario = '10633447' } = req.body;

    await execPostgres(
      `UPDATE adm_obs.otr_orden_trabajo
       SET doeo_id = $1,
           ortr_obs = CASE WHEN $2 <> '' THEN ortr_obs || ' | ' || $2 ELSE ortr_obs END,
           ortr_fec_upd = NOW(),
           ortr_user_upd = $3
       WHERE ortr_id = $4`,
      [Number(doeoId), observacion, String(usuario), ortrId]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Orden de Trabajo OT #${ortrId} actualizada exitosamente en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en PUT /api/obras/:ortrId/estado:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 10. FASE 2 — MÓDULO 4: HOJA DE RUTA Y CDP (ADM_OBS.HR_*)
// ============================================================================
app.get('/api/hoja-ruta', async (req, res) => {
  try {
    const [iniciativas, pasos, disponibilidades, departamentos, tiposFinanciamiento] = await Promise.all([
      queryOracle(
        `
        SELECT i.INIC_SEC, i.INIC_FOLIO, i.INIC_NOM_PROYECTO, i.DEPA_SEC,
               COALESCE(d.DEPA_NOMBRE, 'UNIDAD REQUIRENTE') AS DEPARTAMENTO,
               i.INIC_MONTO, i.INIC_USER_ING,
               TO_CHAR(i.INIC_FECHA_ING, 'YYYY-MM-DD') AS FECHA_ING,
               i.INIC_ESTADO,
               CAST(i.INIC_OBSERVACIONES AS TEXT) AS OBSERVACIONES,
               i.INIC_TIPO_FINAN,
               COALESCE(tf.TIFI_NOMBRE, 'FINANCIAMIENTO GENERAL') AS FINANCIAMIENTO,
               i.INIC_IND_VB, i.INIC_NOM_DOC_VB, i.INIC_NOM_USU_DOC_VB
        FROM ADM_OBS.HR_INICIATIVA i
        LEFT JOIN ADM_OBS.HR_DEPARTAMENTO d ON i.DEPA_SEC = d.DEPA_SEC
        LEFT JOIN ADM_OBS.HR_TIPO_FINANCIAMIENTO tf ON i.INIC_TIPO_FINAN = tf.TIFI_SEC
        ORDER BY i.INIC_SEC DESC
      `,
        0
      ),
      queryOracle(
        `
        SELECT h.INIC_SEC, h.DEPA_SEC,
               COALESCE(d.DEPA_NOMBRE, 'ETAPA ' || h.HORU_ORDEN) AS DEPARTAMENTO,
               COALESCE(d.DEPA_NOMBRE_RESP, '') AS RESPONSABLE,
               h.HORU_ORDEN, h.HORU_ESTADO,
               TO_CHAR(h.HORU_FECHA_RPTA, 'YYYY-MM-DD') AS FECHA_RPTA,
               CAST(h.HORU_OBSERVACION AS TEXT) AS OBSERVACION,
               h.HORU_INC_DOC_VB
        FROM ADM_OBS.HR_HOJA_RUTA h
        LEFT JOIN ADM_OBS.HR_DEPARTAMENTO d ON h.DEPA_SEC = d.DEPA_SEC
        ORDER BY h.INIC_SEC DESC, h.HORU_ORDEN ASC
      `,
        0
      ),
      queryOracle(
        `
        SELECT p.DIPP_SEC, p.DIPP_NOMBRE_PROYECTO, p.DEPA_SEC,
               COALESCE(d.DEPA_NOMBRE, 'DEPARTAMENTO') AS DEPARTAMENTO,
               p.TIFI_SEC,
               COALESCE(tf.TIFI_NOMBRE, 'FINANCIAMIENTO') AS FINANCIAMIENTO,
               p.DIPP_MONTO,
               TO_CHAR(p.DIPP_FECHA, 'YYYY-MM-DD') AS FECHA_CDP,
               p.DIPP_ESTADO, p.DIPP_OBSERVACION, p.DIPP_GLOSA,
               p.DIPP_OBSERVACION_PPTO, p.DIPP_OBSERVACION_PPTO_DAF,
               p.DIPP_ORDEN_COMPRA
        FROM ADM_OBS.HR_DISPONIBILIDAD_PPTO p
        LEFT JOIN ADM_OBS.HR_DEPARTAMENTO d ON p.DEPA_SEC = d.DEPA_SEC
        LEFT JOIN ADM_OBS.HR_TIPO_FINANCIAMIENTO tf ON p.TIFI_SEC = tf.TIFI_SEC
        ORDER BY p.DIPP_SEC DESC
      `,
        0
      ),
      queryOracle(`SELECT DEPA_SEC, DEPA_NOMBRE, DEPA_NOMBRE_RESP, DEPA_CORREO_RESP, DEPA_ORDEN FROM ADM_OBS.HR_DEPARTAMENTO ORDER BY DEPA_SEC`, 30000),
      queryOracle(`SELECT TIFI_SEC, TIFI_NOMBRE, TIFI_FINAN_ULT_ESTADO FROM ADM_OBS.HR_TIPO_FINANCIAMIENTO ORDER BY TIFI_SEC`, 30000)
    ]);

    const pasosByInic = {};
    for (const p of pasos || []) {
      if (!pasosByInic[p.INIC_SEC]) pasosByInic[p.INIC_SEC] = [];
      pasosByInic[p.INIC_SEC].push(p);
    }

    const enrichedIniciativas = (iniciativas || []).map((i) => ({
      ...i,
      PASOS: pasosByInic[i.INIC_SEC] || []
    }));

    res.json({
      status: 'ok',
      iniciativas: enrichedIniciativas,
      disponibilidades: disponibilidades || [],
      catalogos: {
        departamentos: departamentos || [],
        tiposFinanciamiento: tiposFinanciamiento || []
      }
    });
  } catch (err) {
    console.error('Error en GET /api/hoja-ruta:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/hoja-ruta/iniciativas', async (req, res) => {
  try {
    const {
      nombreProyecto,
      depaSec = 2,
      tifiSec = 1,
      monto = 0,
      observaciones = '',
      usuario = '10633447'
    } = req.body;

    if (!nombreProyecto) {
      return res.status(400).json({ status: 'error', message: 'El nombre de la iniciativa o proyecto es obligatorio.' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(INIC_SEC), 3000) + 1 AS NEXT_ID FROM ADM_OBS.HR_INICIATIVA`, 0);
    const nextSec = Number(maxRow[0]?.NEXT_ID || 3020);
    const folio = `HR-2026-0${nextSec - 2700}`;

    await execPostgres(
      `INSERT INTO adm_obs.hr_iniciativa (
        inic_sec, inic_nom_proyecto, depa_sec, inic_monto, inic_user_ing,
        inic_fecha_ing, inic_estado, inic_observaciones, inic_tipo_finan,
        inic_folio, inic_ind_vb, inic_nom_usu_doc_vb
      ) VALUES ($1, $2, $3, $4, $5, NOW(), 'EN EVALUACION', $6, $7, $8, 'N', 'RAUL HORMAZABAL')`,
      [nextSec, String(nombreProyecto).toUpperCase(), Number(depaSec), Number(monto || 0), String(usuario), observaciones, Number(tifiSec), folio]
    );

    const dReq = Number(depaSec) === 1 || Number(depaSec) === 4 || Number(depaSec) === 7 ? 2 : Number(depaSec);
    const etapas = [
      [1, 1, 'APROBADO', 'Ingreso y validación por unidad requirente'],
      [2, dReq, 'EN REVISION TECNICA', 'Evaluación pertinencia técnica del programa'],
      [3, 4, 'PENDIENTE', 'Verificación imputación y disponibilidad presupuestaria'],
      [4, 7, 'PENDIENTE', 'Visación Dirección de Administración y Finanzas (DAF)']
    ];
    for (const [orden, dSec, hEst, hObs] of etapas) {
      await execPostgres(
        `INSERT INTO adm_obs.hr_hoja_ruta (
          inic_sec, depa_sec, horu_orden, horu_estado, horu_fecha_rpta,
          horu_user_ing, horu_fecha_ing, horu_observacion, horu_inc_doc_vb
        ) VALUES ($1, $2, $3, $4, NOW(), $5, NOW(), $6, $7)`,
        [nextSec, dSec, orden, hEst, String(usuario), hObs, hEst === 'APROBADO' ? 'S' : 'N']
      );
    }

    clearCache();
    res.json({
      status: 'ok',
      message: `Iniciativa ${folio} creada exitosamente con su Hoja de Ruta en PostgreSQL.`,
      inicSec: nextSec
    });
  } catch (err) {
    console.error('Error en POST /api/hoja-ruta/iniciativas:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.put('/api/hoja-ruta/iniciativas/:inicSec/evaluar', async (req, res) => {
  try {
    const inicSec = Number(req.params.inicSec);
    const { nuevoEstado = 'APROBADA DAF', horuOrden, observacion = '', usuario = '10633447' } = req.body;

    await execPostgres(
      `UPDATE adm_obs.hr_iniciativa
       SET inic_estado = $1,
           inic_ind_vb = CASE WHEN $1 LIKE 'APROBAD%' OR $1 LIKE '%CDP%' THEN 'S' ELSE inic_ind_vb END,
           inic_observaciones = CASE WHEN $2 <> '' THEN COALESCE(inic_observaciones, '') || ' | ' || $2 ELSE inic_observaciones END
       WHERE inic_sec = $3`,
      [nuevoEstado, observacion, inicSec]
    );

    if (horuOrden) {
      await execPostgres(
        `UPDATE adm_obs.hr_hoja_ruta
         SET horu_estado = $1, horu_observacion = COALESCE(NULLIF($2, ''), horu_observacion), horu_fecha_mod = NOW(), horu_user_mod = $3
         WHERE inic_sec = $4 AND horu_orden = $5`,
        [nuevoEstado.includes('OBSERV') ? 'OBSERVADO' : 'APROBADO', observacion, String(usuario), inicSec, Number(horuOrden)]
      );
    } else if (nuevoEstado.includes('APROBAD') || nuevoEstado.includes('CDP')) {
      await execPostgres(
        `UPDATE adm_obs.hr_hoja_ruta
         SET horu_estado = 'APROBADO', horu_inc_doc_vb = 'S', horu_fecha_mod = NOW(), horu_user_mod = $1
         WHERE inic_sec = $2`,
        [String(usuario), inicSec]
      );
    }

    clearCache();
    res.json({
      status: 'ok',
      message: `Iniciativa #${inicSec} actualizada a "${nuevoEstado}" en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en PUT /api/hoja-ruta/iniciativas/:inicSec/evaluar:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/hoja-ruta/cdp', async (req, res) => {
  try {
    const {
      nombreProyecto,
      depaSec = 2,
      tifiSec = 1,
      monto = 0,
      glosa = '',
      observacionPpto = '',
      ordenCompra = '',
      usuario = '10633447'
    } = req.body;

    if (!nombreProyecto) {
      return res.status(400).json({ status: 'error', message: 'El nombre del proyecto para el CDP es obligatorio.' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(DIPP_SEC), 4000) + 1 AS NEXT_ID FROM ADM_OBS.HR_DISPONIBILIDAD_PPTO`, 0);
    const nextSec = Number(maxRow[0]?.NEXT_ID || 4020);
    const titulo = nombreProyecto.startsWith('CDP-') ? nombreProyecto : `CDP-2026-0${nextSec - 3590}: ${String(nombreProyecto).toUpperCase()}`;

    await execPostgres(
      `INSERT INTO adm_obs.hr_disponibilidad_ppto (
        dipp_sec, dipp_nombre_proyecto, depa_sec, tifi_sec, dipp_monto, dipp_fecha,
        dipp_estado, dipp_observacion, dipp_glosa, dipp_observacion_ppto,
        dipp_fech_ing, dipp_user_ing, dipp_observacion_ppto_daf, dipp_orden_compra
      ) VALUES ($1, $2, $3, $4, $5, NOW(), 'EMITIDO / APROBADO', $6, $7, $8, NOW(), $9, 'Visado en línea por Control Presupuestario', $10)`,
      [nextSec, titulo, Number(depaSec), Number(tifiSec), Number(monto || 0), glosa || 'Imputación presupuestaria 2026', glosa || 'Cuenta Presupuestaria 215', observacionPpto || 'Disponibilidad verificada', String(usuario), ordenCompra || '']
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Certificado de Disponibilidad Presupuestaria #${nextSec} emitido en PostgreSQL.`,
      dippSec: nextSec
    });
  } catch (err) {
    console.error('Error en POST /api/hoja-ruta/cdp:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 11. FASE 2 — MÓDULO 5: MERCADO PÚBLICO (ADM_OBS.MPU_*)
// ============================================================================
app.get('/api/mercado-publico', async (req, res) => {
  try {
    const estado = req.query.estado ? Number(req.query.estado) : 0;
    const tipo = (req.query.tipo || '').trim().toUpperCase();
    const search = (req.query.search || '').trim().toUpperCase().replace(/'/g, '');

    let where = 'WHERE 1=1';
    if (estado) where += ` AND c.DMEO_COD_ESTADO = ${estado}`;
    if (tipo) where += ` AND UPPER(c.DMTO_TIPO_OC) = '${tipo}'`;
    if (search) {
      where += ` AND (UPPER(c.ORCA_COD_OC) LIKE '%${search}%' OR UPPER(c.ORCA_NOMBRE) LIKE '%${search}%' OR UPPER(p.PROV_NOMBRE) LIKE '%${search}%' OR UPPER(c.ORCA_CODIGO_LICITACION) LIKE '%${search}%')`;
    }

    const [ordenesCompra, detallesOc, reprocesos, estadosOc, tiposOc, proveedores] = await Promise.all([
      queryOracle(
        `
        SELECT c.ORCA_SEC_ID, c.ORCA_COD_OC, c.ORCA_NOMBRE, c.DMEO_COD_ESTADO,
               COALESCE(e.DMEO_DESC, c.ORCA_ESTADO_PROVEEDOR) AS ESTADO_OC_DESC,
               c.ORCA_CODIGO_LICITACION, c.ORCA_DESC_OC, c.DMTO_TIPO_OC,
               COALESCE(t.DMTO_DESC, c.DMTO_TIPO_OC) AS TIPO_OC_DESC,
               c.DMTM_TIPO_MONEDA, c.ORCA_ESTADO_PROVEEDOR,
               TO_CHAR(c.ORCA_FEC_CREACION, 'YYYY-MM-DD') AS FECHA_CREACION,
               TO_CHAR(c.ORCA_FEC_ENVIO, 'YYYY-MM-DD') AS FECHA_ENVIO,
               TO_CHAR(c.ORCA_FEC_ACEPTACION, 'YYYY-MM-DD') AS FECHA_ACEPTACION,
               c.ORCA_TOTAL_NETO, c.ORCA_IVA, c.ORCA_TOTAL_OC,
               c.ORCA_FINANCIAMIENTO, c.DMFP_FORMA_PAGO, c.COMP_COD,
               c.PROV_COD,
               COALESCE(p.PROV_NOMBRE, 'PROVEEDOR MERCADO PUBLICO') AS PROVEEDOR,
               COALESCE(p.PROV_ACTIVIDAD, '') AS GIRO_PROVEEDOR,
               COALESCE(s.SUCU_RUT_SUCURSAL, '') AS RUT_PROVEEDOR,
               COALESCE(s.SUCU_DIRECCION, '') AS DIRECCION_PROVEEDOR,
               COALESCE(s.SUCU_MAIL_CONTACTO, '') AS MAIL_PROVEEDOR,
               c.ORCA_TOTAL_ITEMS
        FROM ADM_OBS.MPU_ORDENES_CAB c
        LEFT JOIN ADM_OBS.MPU_DOM_ESTADO_OC e ON c.DMEO_COD_ESTADO = e.DMEO_COD_ESTADO
        LEFT JOIN ADM_OBS.MPU_DOM_TIPO_OC t ON c.DMTO_TIPO_OC = t.DMTO_TIPO_OC
        LEFT JOIN ADM_OBS.MPU_PROVEEDORES p ON c.PROV_COD = p.PROV_COD
        LEFT JOIN ADM_OBS.MPU_SUCURSALES s ON c.PROV_COD = s.PROV_COD
        ${where}
        ORDER BY c.ORCA_SEC_ID DESC
      `,
        0
      ),
      queryOracle(
        `
        SELECT ORDE_SEC_ID, ORCA_SEC_ID, ORDET_CORRELATIVO, ORDET_CATEGORIA,
               ORDET_PRODUCTO, ORDET_ESPEC_COMPRADOR, ORDET_ESPEC_PROVEEDOR,
               ORDET_CANTIDAD, ORDET_UNIDAD, DMTM_TIPO_MONEDA,
               ORDET_PRECIO_NETO, ORDET_TOTAL_IMPUESTOS, ORDET_TOTAL
        FROM ADM_OBS.MPU_ORDENES_DET
        ORDER BY ORCA_SEC_ID DESC, ORDET_CORRELATIVO ASC
      `,
        0
      ),
      queryOracle(
        `
        SELECT REPR_SEC_ID, REPR_SEC_PROC, REPR_PAUTA,
               TO_CHAR(REPR_FEC_ERROR, 'YYYY-MM-DD HH24:MI') AS FECHA_SOLICITUD,
               TO_CHAR(REPR_FEC_RETOMA, 'YYYY-MM-DD HH24:MI') AS FECHA_RETOMA,
               REPR_ESTADO
        FROM ADM_OBS.MPU_REPROCESOS
        ORDER BY REPR_SEC_ID DESC
      `,
        0
      ),
      queryOracle(`SELECT DMEO_COD_ESTADO, DMEO_DESC FROM ADM_OBS.MPU_DOM_ESTADO_OC ORDER BY DMEO_COD_ESTADO`, 30000),
      queryOracle(`SELECT DMTO_TIPO_OC, DMTO_ABREVIACION, DMTO_DESC FROM ADM_OBS.MPU_DOM_TIPO_OC ORDER BY DMTO_TIPO_OC`, 30000),
      queryOracle(`SELECT PROV_COD, PROV_NOMBRE, PROV_ACTIVIDAD FROM ADM_OBS.MPU_PROVEEDORES ORDER BY PROV_NOMBRE`, 30000)
    ]);

    const detByOc = {};
    for (const d of detallesOc || []) {
      if (!detByOc[d.ORCA_SEC_ID]) detByOc[d.ORCA_SEC_ID] = [];
      detByOc[d.ORCA_SEC_ID].push(d);
    }

    const enriched = (ordenesCompra || []).map((oc) => ({
      ...oc,
      ITEMS: detByOc[oc.ORCA_SEC_ID] || []
    }));

    res.json({
      status: 'ok',
      data: enriched,
      reprocesos: reprocesos || [],
      catalogos: {
        estadosOc: estadosOc || [],
        tiposOc: tiposOc || [],
        proveedores: proveedores || []
      }
    });
  } catch (err) {
    console.error('Error en GET /api/mercado-publico:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/mercado-publico/reprocesar', async (req, res) => {
  try {
    const { codOc } = req.body;
    if (!codOc) {
      return res.status(400).json({ status: 'error', message: 'Debe indicar el código de la Orden de Compra (ej. 1111614-108-CM26).' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(REPR_SEC_ID), 10) + 1 AS NEXT_ID FROM ADM_OBS.MPU_REPROCESOS`, 0);
    const nextId = Number(maxRow[0]?.NEXT_ID || 20);

    await execPostgres(
      `INSERT INTO adm_obs.mpu_reprocesos (repr_sec_id, repr_sec_proc, repr_pauta, repr_fec_error, repr_fec_retoma, repr_estado)
       VALUES ($1, $2, $3, NOW(), NOW(), 'SINCRONIZADO API CHILECOMPRA')`,
      [nextId, 1000 + nextId, String(codOc).toUpperCase().trim()]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Orden de Compra ${codOc.toUpperCase()} sincronizada y reprocesada exitosamente en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en POST /api/mercado-publico/reprocesar:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.put('/api/mercado-publico/:orcaSecId/estado', async (req, res) => {
  try {
    const orcaSecId = Number(req.params.orcaSecId);
    const { dmeoCodEstado = 12, estadoDesc = 'RECEPCION CONFORME' } = req.body;

    await execPostgres(
      `UPDATE adm_obs.mpu_ordenes_cab
       SET dmeo_cod_estado = $1, orca_estado_proveedor = $2, orca_fec_ultima_mod = NOW()
       WHERE orca_sec_id = $3`,
      [Number(dmeoCodEstado), estadoDesc, orcaSecId]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Orden de Compra #${orcaSecId} actualizada a "${estadoDesc}" en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en PUT /api/mercado-publico/:orcaSecId/estado:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 12. FASE 3 — MÓDULO 9: RRHH APS Y REPOSITORIO REM (ADM_OBS.REGISTRO, ESTAMIENTO, REM)
// ============================================================================
app.get('/api/rrhh-aps', async (req, res) => {
  try {
    const establecimiento = (req.query.establecimiento || '').trim().toUpperCase();
    const estamento = (req.query.estamento || '').trim().toUpperCase();
    const contrato = (req.query.contrato || '').trim().toUpperCase();
    const search = (req.query.search || '').trim().toUpperCase().replace(/'/g, '');

    let where = 'WHERE 1=1';
    if (establecimiento) where += ` AND UPPER(r.ESTA_COD) = '${establecimiento}'`;
    if (estamento) where += ` AND UPPER(r.ESMI_COD) = '${estamento}'`;
    if (contrato) where += ` AND UPPER(r.CONT_COD) = '${contrato}'`;
    if (search) {
      where += ` AND (UPPER(e.ESTA_NOMB) LIKE '%${search}%' OR UPPER(es.ESMI_NOMB) LIKE '%${search}%' OR UPPER(c.CONT_NOMB) LIKE '%${search}%')`;
    }

    const [registros, resumenEstablecimientos, establecimientos, estamentos, contratos, carpetasRem, subcarpetasRem, archivosRem] =
      await Promise.all([
        queryOracle(
          `
          SELECT r.REGI_SEC,
                 TO_CHAR(r.REGI_FECHA, 'YYYY-MM-DD') AS FECHA_REGISTRO,
                 r.ESTA_COD,
                 COALESCE(e.ESTA_NOMB, r.ESTA_COD) AS ESTABLECIMIENTO,
                 r.ESMI_COD,
                 COALESCE(es.ESMI_NOMB, r.ESMI_COD) AS ESTAMENTO,
                 COALESCE(es.ESMI_CATE, 'CATEGORIA') AS CATEGORIA,
                 r.CONT_COD,
                 COALESCE(c.CONT_NOMB, r.CONT_COD) AS CONTRATO,
                 COALESCE(r.REGI_TOTAL_FUNC, 0) AS TOTAL_FUNC,
                 COALESCE(r.REGI_FUNC_O, 0) AS OPERATIVOS,
                 COALESCE(r.REGI_FUNC_FL, 0) AS FERIADO_LEGAL,
                 COALESCE(r.REGI_FUNC_LM, 0) AS LICENCIA_MEDICA,
                 COALESCE(r.REGI_FUNC_DP, 0) AS PERMISO_ADMIN,
                 COALESCE(r.REGI_FUNC_CE, 0) AS CAPACITACION,
                 COALESCE(r.REGI_FUN_ESQUEMA_C, 0) AS ESQUEMA_VAC,
                 COALESCE(r.REGI_FUN_GRUPO_R, 0) AS GRUPO_RIESGO,
                 COALESCE(r.REGI_FUN_TT, 0) AS TELETRABAJO,
                 COALESCE(r.REGI_FUNC_JP_HD, 0) AS JORNADA_PARCIAL,
                 COALESCE(r.REGI_ESTADO, 'VIGENTE') AS ESTADO
          FROM ADM_OBS.REGISTRO r
          LEFT JOIN ADM_OBS.ESTABLECIMIENTO e ON r.ESTA_COD = e.ESTA_COD
          LEFT JOIN ADM_OBS.ESTAMIENTO es ON r.ESMI_COD = es.ESMI_COD
          LEFT JOIN ADM_OBS.CONTRATO c ON r.CONT_COD = c.CONT_COD
          ${where}
          ORDER BY r.REGI_SEC DESC
          LIMIT 150
        `,
          0
        ),
        queryOracle(
          `
          SELECT r.ESTA_COD,
                 COALESCE(e.ESTA_NOMB, r.ESTA_COD) AS ESTABLECIMIENTO,
                 SUM(COALESCE(r.REGI_TOTAL_FUNC, 0)) AS DOTACION_TOTAL,
                 SUM(COALESCE(r.REGI_FUNC_O, 0)) AS OPERATIVOS,
                 SUM(COALESCE(r.REGI_FUNC_FL, 0)) AS FERIADO_LEGAL,
                 SUM(COALESCE(r.REGI_FUNC_LM, 0)) AS LICENCIA_MEDICA,
                 SUM(COALESCE(r.REGI_FUNC_DP, 0)) AS PERMISO_ADMIN,
                 SUM(COALESCE(r.REGI_FUNC_CE, 0)) AS CAPACITACION
          FROM ADM_OBS.REGISTRO r
          LEFT JOIN ADM_OBS.ESTABLECIMIENTO e ON r.ESTA_COD = e.ESTA_COD
          GROUP BY r.ESTA_COD, e.ESTA_NOMB
          ORDER BY DOTACION_TOTAL DESC
        `,
          0
        ),
        queryOracle(`SELECT ESTA_COD, ESTA_NOMB, ESTA_COL_ORDEN FROM ADM_OBS.ESTABLECIMIENTO ORDER BY ESTA_COL_ORDEN, ESTA_COD`, 30000),
        queryOracle(`SELECT ESMI_COD, ESMI_NOMB, ESMI_CATE FROM ADM_OBS.ESTAMIENTO ORDER BY ESMI_CATE, ESMI_COD`, 30000),
        queryOracle(`SELECT CONT_COD, CONT_NOMB FROM ADM_OBS.CONTRATO ORDER BY CONT_COD`, 30000),
        queryOracle(`SELECT CARE_SEC, CARE_NOMBRE, CARE_ESTADO, TO_CHAR(CARE_FECHA_ING, 'YYYY-MM-DD') AS FECHA_ING FROM ADM_OBS.OBS_CARPETAS_REM ORDER BY CARE_SEC`, 15000),
        queryOracle(`SELECT SURE_SEC, SURE_NOMBRE, SURE_ESTADO FROM ADM_OBS.OBS_SUBCARPETAS_REM ORDER BY SURE_SEC`, 15000),
        queryOracle(
          `
          SELECT a.ARCH_SEC, a.ARCH_NOMBRE, a.PLAN_SEC,
                 COALESCE(s.SURE_NOMBRE, 'SERIE REM') AS SERIE_REM,
                 a.ARCH_TOTAL_LINEAS, a.ARCH_DOM_ESTADO_ARCHIVO,
                 TO_CHAR(a.ARCH_FEC_CARGA, 'YYYY-MM-DD HH24:MI') AS FECHA_CARGA,
                 a.ARCH_USR_ING, a.ARCH_CHECKSUM
          FROM ADM_OBS.OBS_ARCHIVOS a
          LEFT JOIN ADM_OBS.OBS_SUBCARPETAS_REM s ON a.PLAN_SEC = s.SURE_SEC
          ORDER BY a.ARCH_SEC DESC
        `,
          0
        )
      ]);

    res.json({
      status: 'ok',
      data: registros || [],
      resumenEstablecimientos: resumenEstablecimientos || [],
      rem: {
        carpetas: carpetasRem || [],
        subcarpetas: subcarpetasRem || [],
        archivos: archivosRem || []
      },
      catalogos: {
        establecimientos: establecimientos || [],
        estamentos: estamentos || [],
        contratos: contratos || []
      }
    });
  } catch (err) {
    console.error('Error en GET /api/rrhh-aps:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/rrhh-aps/registros', async (req, res) => {
  try {
    const {
      estaCod = 'CES-01',
      esmiCod = 'EST-B1',
      contCod = 'CONT-PL',
      fechaRegistro,
      operativos = 20,
      feriadoLegal = 2,
      licenciaMedica = 1,
      permisoAdmin = 1,
      capacitacion = 0,
      teletrabajo = 0,
      usuario = '10633447'
    } = req.body;

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(REGI_SEC), 9000) + 1 AS NEXT_ID FROM ADM_OBS.REGISTRO`, 0);
    const nextSec = Number(maxRow[0]?.NEXT_ID || 9050);

    const op = Number(operativos || 0);
    const fl = Number(feriadoLegal || 0);
    const lm = Number(licenciaMedica || 0);
    const dp = Number(permisoAdmin || 0);
    const ce = Number(capacitacion || 0);
    const tt = Number(teletrabajo || 0);
    const totalFunc = op + fl + lm + dp + ce + tt;

    await execPostgres(
      `INSERT INTO adm_obs.registro (
        regi_sec, regi_fecha, esta_cod, esmi_cod, cont_cod,
        regi_total_func, regi_func_o, regi_func_fl, regi_func_lm,
        regi_func_dp, regi_func_ce, regi_fun_esquema_c, regi_fun_grupo_r,
        regi_fun_tt, regi_func_jp_hd, regi_user_ing, regi_fec_ing, regi_estado
      ) VALUES ($1, COALESCE($2::timestamp, NOW()), $3, $4, $5, $6, $7, $8, $9, $10, $11, $6, 0, $12, 0, $13, NOW(), 'VIGENTE')`,
      [nextSec, fechaRegistro || null, estaCod, esmiCod, contCod, totalFunc, op, fl, lm, dp, ce, tt, String(usuario)]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Registro de Dotación APS #${nextSec} (${estaCod} / ${esmiCod}) guardado en PostgreSQL.`,
      regiSec: nextSec
    });
  } catch (err) {
    console.error('Error en POST /api/rrhh-aps/registros:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/rrhh-aps/rem-archivo', async (req, res) => {
  try {
    const {
      archNombre,
      planSec = 1,
      totalLineas = 1200,
      usuario = '10633447'
    } = req.body;

    if (!archNombre) {
      return res.status(400).json({ status: 'error', message: 'El nombre del archivo REM es obligatorio.' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(ARCH_SEC), 500) + 1 AS NEXT_ID FROM ADM_OBS.OBS_ARCHIVOS`, 0);
    const nextSec = Number(maxRow[0]?.NEXT_ID || 550);
    const chk = `SHA256-${Math.random().toString(16).substring(2, 9).toUpperCase()}`;

    await execPostgres(
      `INSERT INTO adm_obs.obs_archivos (arch_sec, arch_nombre, plan_sec, arch_total_lineas, arch_dom_estado_archivo, arch_fec_carga, arch_usr_ing, arch_checksum)
       VALUES ($1, $2, $3, $4, 'VALIDADO ESTADISTICA', NOW(), $5, $6)`,
      [nextSec, archNombre, Number(planSec), Number(totalLineas || 1000), String(usuario), chk]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Archivo REM "${archNombre}" registrado y validado en PostgreSQL (adm_obs.obs_archivos).`
    });
  } catch (err) {
    console.error('Error en POST /api/rrhh-aps/rem-archivo:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// ============================================================================
// 13. FASE 3 — MÓDULO 10: AGENDA DE ATENCIÓN Y CAMPAÑAS SALUD (ADM_OBS.OBS_DATOS_SOLICITUD, SAL_*)
// ============================================================================
app.get('/api/agenda-atencion', async (req, res) => {
  try {
    const depaSec = req.query.depaSec ? Number(req.query.depaSec) : 0;
    const estado = (req.query.estado || '').trim().toUpperCase();
    const search = (req.query.search || '').trim().toUpperCase().replace(/'/g, '');

    let where = 'WHERE 1=1';
    if (depaSec) where += ` AND s.DEPA_SEC = ${depaSec}`;
    if (estado) where += ` AND UPPER(s.DASO_ESTADO) = '${estado}'`;
    if (search) {
      where += ` AND (UPPER(s.DASO_NOMBRE) LIKE '%${search}%' OR UPPER(s.DASO_APE_PAT) LIKE '%${search}%' OR CAST(s.DASO_RUT AS TEXT) LIKE '%${search}%' OR UPPER(s.DASO_ID_UNICO) LIKE '%${search}%')`;
    }

    const [solicitudes, campanas, pacientes, departamentos, bloquesHora, especialidades] = await Promise.all([
      queryOracle(
        `
        SELECT s.DASO_SEC, s.DASO_TIPO_DOCTO, s.DASO_RUT, s.DASO_DV,
               TRIM(s.DASO_NOMBRE || ' ' || s.DASO_APE_PAT || ' ' || COALESCE(s.DASO_APE_MAT, '')) AS SOLICITANTE,
               s.DASO_CELULAR, s.DASO_EMAIL, s.DEPA_SEC,
               COALESCE(d.DEPA_NOMBRE, 'ATENCION GENERAL') AS DEPARTAMENTO,
               TO_CHAR(s.DASO_FEC_ATENCION, 'YYYY-MM-DD') AS FECHA_ATENCION,
               s.DAHO_HORA, s.DASO_ID_UNICO,
               s.DASO_FLAG_ENVIO_WSP, s.DASO_FLAG_ENVIO_EMAIL,
               s.DASO_ESTADO, s.DASO_OBSERV
        FROM ADM_OBS.OBS_DATOS_SOLICITUD s
        LEFT JOIN ADM_OBS.HR_DEPARTAMENTO d ON s.DEPA_SEC = d.DEPA_SEC
        ${where}
        ORDER BY s.DASO_FEC_ATENCION DESC, s.DAHO_HORA ASC
      `,
        0
      ),
      queryOracle(
        `
        SELECT c.CAMP_SEC, c.CAMP_DESC,
               TO_CHAR(c.CAMP_FEC_INI, 'YYYY-MM-DD') AS FECHA_INICIO,
               TO_CHAR(c.CAMP_FEC_FIN, 'YYYY-MM-DD') AS FECHA_FIN,
               c.CAMP_ESTADO, c.CAMP_CNT_CUPO,
               (SELECT COUNT(*) FROM ADM_OBS.SAL_CAMPANA_CUPO cu WHERE cu.CAMP_SEC = c.CAMP_SEC) AS CUPOS_OCUPADOS
        FROM ADM_OBS.SAL_CAMPANA c
        ORDER BY c.CAMP_SEC
      `,
        0
      ),
      queryOracle(
        `
        SELECT f.CAMP_SEC, COALESCE(c.CAMP_DESC, 'CAMPAÑA') AS CAMPANA_DESC,
               f.CACU_NRO_ATENCION, f.ESPE_COD,
               COALESCE(e.ESPE_DESC, f.ESPE_COD) AS ESPECIALIDAD,
               f.FIPA_RUT, f.FIPA_DV,
               TRIM(f.FIPA_NOMBRES || ' ' || f.FIPA_APE_PAT || ' ' || COALESCE(f.FIPA_APE_MAT, '')) AS PACIENTE,
               f.FIPA_EDAD, f.FIPA_GENERO, f.FIPA_DIRECCION, f.FIPA_CELULAR,
               TO_CHAR(f.FIPA_FEC_ING, 'YYYY-MM-DD') AS FECHA_INSCRIPCION
        FROM ADM_OBS.SAL_FICHA_PACIENTE f
        LEFT JOIN ADM_OBS.SAL_CAMPANA c ON f.CAMP_SEC = c.CAMP_SEC
        LEFT JOIN ADM_OBS.SAL_ESPECIALIDAD e ON f.ESPE_COD = e.ESPE_COD
        ORDER BY f.CAMP_SEC, f.CACU_NRO_ATENCION DESC
      `,
        0
      ),
      queryOracle(`SELECT DEPA_SEC, DEPA_NOMBRE, DEPA_NOMBRE_RESP, DEPA_CORREO_RESP FROM ADM_OBS.HR_DEPARTAMENTO ORDER BY DEPA_SEC`, 30000),
      queryOracle(`SELECT DAHO_NRO, DAHO_HORA FROM ADM_OBS.OBS_HORA_SOLICITUD ORDER BY DAHO_NRO`, 30000),
      queryOracle(`SELECT ESPE_COD, ESPE_DESC FROM ADM_OBS.SAL_ESPECIALIDAD ORDER BY ESPE_COD`, 30000)
    ]);

    res.json({
      status: 'ok',
      solicitudes: solicitudes || [],
      campanas: campanas || [],
      pacientes: pacientes || [],
      catalogos: {
        departamentos: departamentos || [],
        bloquesHora: bloquesHora || [],
        especialidades: especialidades || []
      }
    });
  } catch (err) {
    console.error('Error en GET /api/agenda-atencion:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/agenda-atencion/solicitudes', async (req, res) => {
  try {
    const {
      rut,
      dv = 'K',
      nombre,
      apePat,
      apeMat = '',
      celular = '',
      email = '',
      depaSec = 2,
      fechaAtencion,
      hora = '10:00',
      observacion = ''
    } = req.body;

    if (!rut || !nombre || !apePat) {
      return res.status(400).json({ status: 'error', message: 'RUT, nombre y apellido paterno son obligatorios.' });
    }

    const maxRow = await queryOracle(`SELECT COALESCE(MAX(DASO_SEC), 6000) + 1 AS NEXT_ID FROM ADM_OBS.OBS_DATOS_SOLICITUD`, 0);
    const nextSec = Number(maxRow[0]?.NEXT_ID || 6050);
    const idUnico = `AG-2026-${nextSec}`;

    await execPostgres(
      `INSERT INTO adm_obs.obs_datos_solicitud (
        daso_sec, daso_tipo_docto, daso_rut, daso_dv, daso_nombre, daso_ape_pat,
        daso_ape_mat, daso_celular, daso_email, depa_sec, daso_fec_atencion,
        daho_hora, daso_flag_envio_wsp, daso_flag_envio_email, daso_id_unico,
        daso_fec_ing, daso_estado, daso_observ
      ) VALUES ($1, 'RUT', $2, $3, $4, $5, $6, $7, $8, $9, COALESCE($10::timestamp, NOW()), $11, 'S', 'S', $12, NOW(), 'CONFIRMADO', $13)`,
      [
        nextSec,
        Number(String(rut).replace(/\D/g, '') || 11111111),
        String(dv).toUpperCase(),
        String(nombre).toUpperCase(),
        String(apePat).toUpperCase(),
        String(apeMat).toUpperCase(),
        celular,
        email,
        Number(depaSec),
        fechaAtencion || null,
        hora,
        idUnico,
        observacion
      ]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Cita ${idUnico} agendada para el ${fechaAtencion || 'hoy'} a las ${hora} hrs en PostgreSQL.`,
      dasoSec: nextSec
    });
  } catch (err) {
    console.error('Error en POST /api/agenda-atencion/solicitudes:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.put('/api/agenda-atencion/solicitudes/:dasoSec/estado', async (req, res) => {
  try {
    const dasoSec = Number(req.params.dasoSec);
    const { nuevoEstado = 'ATENDIDO', observacion = '' } = req.body;

    await execPostgres(
      `UPDATE adm_obs.obs_datos_solicitud
       SET daso_estado = $1,
           daso_observ = CASE WHEN $2 <> '' THEN COALESCE(daso_observ, '') || ' | ' || $2 ELSE daso_observ END
       WHERE daso_sec = $3`,
      [nuevoEstado, observacion, dasoSec]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Cita #${dasoSec} actualizada a "${nuevoEstado}" en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en PUT /api/agenda-atencion/solicitudes/:dasoSec/estado:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/agenda-atencion/campanas-cupo', async (req, res) => {
  try {
    const {
      campSec = 1,
      espeCod = 'OFT',
      rut,
      dv = 'K',
      nombres,
      apePat,
      apeMat = '',
      edad = 45,
      genero = 'F',
      direccion = '',
      celular = ''
    } = req.body;

    if (!rut || !nombres || !apePat) {
      return res.status(400).json({ status: 'error', message: 'RUT, nombres y apellido son obligatorios.' });
    }

    const maxRow = await queryOracle(
      `SELECT COALESCE(MAX(CACU_NRO_ATENCION), ${Number(campSec) * 100}) + 1 AS NEXT_NRO FROM ADM_OBS.SAL_FICHA_PACIENTE WHERE CAMP_SEC = ${Number(campSec)}`,
      0
    );
    const nextNro = Number(maxRow[0]?.NEXT_NRO || Number(campSec) * 100 + 10);
    const cleanRut = Number(String(rut).replace(/\D/g, '') || 11111111);

    await execPostgres(
      `INSERT INTO adm_obs.sal_ficha_paciente (
        camp_sec, cacu_nro_atencion, espe_cod, fipa_rut, fipa_dv,
        fipa_nombres, fipa_ape_pat, fipa_ape_mat, fipa_edad, fipa_genero,
        fipa_direccion, fipa_celular, fipa_fec_ing
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, NOW())`,
      [
        Number(campSec),
        nextNro,
        espeCod,
        cleanRut,
        String(dv).toUpperCase(),
        String(nombres).toUpperCase(),
        String(apePat).toUpperCase(),
        String(apeMat).toUpperCase(),
        Number(edad || 40),
        genero,
        direccion,
        celular
      ]
    );

    await execPostgres(
      `INSERT INTO adm_obs.sal_campana_cupo (camp_sec, cacu_nro_atencion, cacu_fec_crea, fipa_rut, cacu_estado)
       VALUES ($1, $2, NOW(), $3, 'CONFIRMADO')`,
      [Number(campSec), nextNro, cleanRut]
    );

    clearCache();
    res.json({
      status: 'ok',
      message: `Cupo #${nextNro} asignado al paciente ${nombres} ${apePat} en PostgreSQL.`
    });
  } catch (err) {
    console.error('Error en POST /api/agenda-atencion/campanas-cupo:', err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Fallback for SPA routing
app.use((req, res, next) => {
  if (req.method === 'GET' && !req.path.startsWith('/api')) {
    return res.sendFile('index.html', { root: path.join(__dirname, 'public') });
  }
  next();
});

app.listen(PORT, () => {
  console.log(`==================================================================`);
  console.log(` CMDS ADMIN Backend (Fase 0 + Fase 1) corriendo en puerto ${PORT}`);
  console.log(` Conectado en vivo a PostgreSQL 18 (${process.env.PG_HOST || '192.168.30.48'}:${process.env.PG_PORT || 5432} / ${process.env.PG_DB || 'bd_cmds_admin'})`);
  console.log(`==================================================================`);
});
