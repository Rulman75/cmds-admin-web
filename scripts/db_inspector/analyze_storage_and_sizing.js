const fs = require('fs');
const path = require('path');
const { Client } = require('../../backend/node_modules/pg');

const DATA_DIR = path.join(__dirname, '..', '..', 'data');
const s1 = JSON.parse(fs.readFileSync(path.join(DATA_DIR, 'oracle_schema.json'), 'utf8'));
const s2 = JSON.parse(fs.readFileSync(path.join(DATA_DIR, 'oracle_other_schemas.json'), 'utf8'));

function estimateColumnBytes(col) {
  const t = String(col.type || col.DATA_TYPE || 'VARCHAR2').toUpperCase();
  const len = parseInt(col.length || col.DATA_LENGTH || 50, 10);
  if (t.includes('NUMBER') || t.includes('FLOAT')) return 8;
  if (t.includes('DATE') || t.includes('TIMESTAMP')) return 8;
  if (t.includes('CLOB') || t.includes('BLOB') || t.includes('LONG')) return 256;
  if (t === 'CHAR') return Math.min(len, 64);
  // Average fill factor of VARCHAR2 in administrative/educational DBs is ~32% of declared max length (clamped between 6 and 180 bytes)
  return Math.max(6, Math.min(180, Math.round(len * 0.32)));
}

function collectAllTables() {
  const bySchema = {};

  // From oracle_schema.json (ADM_OBS, ADM_AUTH, ADM_CMDS, PADLOG)
  for (const [key, tbl] of Object.entries(s1.tables || {})) {
    const owner = tbl.owner;
    if (!bySchema[owner]) bySchema[owner] = [];
    bySchema[owner].push({
      owner,
      table_name: tbl.table_name,
      num_rows: Number(tbl.num_rows || 0),
      columns: tbl.columns || []
    });
  }

  // From oracle_other_schemas.json (ADM_EDUCA, ADM_NOTAS, ADM_RHU, ADM_PORTALDIR, ADMETA)
  for (const [owner, schemaObj] of Object.entries(s2 || {})) {
    if (!bySchema[owner]) bySchema[owner] = [];
    const tblMap = schemaObj.tables || {};
    for (const tbl of Object.values(tblMap)) {
      bySchema[owner].push({
        owner,
        table_name: tbl.table_name,
        num_rows: Number(tbl.num_rows || 0),
        columns: tbl.columns || []
      });
    }
  }

  return bySchema;
}

async function main() {
  const bySchema = collectAllTables();

  const systems = [
    {
      id: 1,
      name: 'CMDS ADMIN',
      db: 'bd_cmds_admin',
      port: 3005,
      schemas: ['ADM_OBS', 'ADM_AUTH']
    },
    {
      id: 2,
      name: 'PADEDUCA',
      db: 'bd_cmds_educa',
      port: 3006,
      schemas: ['ADM_EDUCA', 'ADM_NOTAS']
    },
    {
      id: 3,
      name: 'CMDS RRHH',
      db: 'bd_cmds_rhu',
      port: 3007,
      schemas: ['ADM_RHU']
    },
    {
      id: 4,
      name: 'Portal Director + ADMETA',
      db: 'bd_cmds_portaldir',
      port: 3008,
      schemas: ['ADM_PORTALDIR', 'ADMETA']
    }
  ];

  console.log('================================================================================');
  console.log('1. DIMENSIONAMIENTO DE DATOS EN ORACLE 26ai -> POSTGRESQL 18 (192.168.30.48)');
  console.log('================================================================================\n');

  let grandTotalTables = 0;
  let grandTotalRows = 0;
  let grandTotalBytes = 0;

  for (const sys of systems) {
    let sysTables = 0;
    let sysRows = 0;
    let sysBytes = 0;
    const allSysTables = [];

    for (const sch of sys.schemas) {
      const tbls = bySchema[sch] || [];
      for (const t of tbls) {
        // SkipServicios Basicos in ADM_OBS if needed, or report full schema
        const colBytes = (t.columns || []).reduce((acc, c) => acc + estimateColumnBytes(c), 0) || 85;
        // PostgreSQL tuple header (24 bytes) + page/alignment + ~25% index overhead
        const pgRowBytes = Math.round((colBytes + 28) * 1.25);
        const estBytes = t.num_rows * pgRowBytes;

        sysTables++;
        sysRows += t.num_rows;
        sysBytes += estBytes;
        allSysTables.push({
          full_name: `${sch}.${t.table_name}`,
          num_rows: t.num_rows,
          col_count: (t.columns || []).length,
          pg_row_bytes: pgRowBytes,
          est_mb: +(estBytes / (1024 * 1024)).toFixed(2)
        });
      }
    }

    // Add shared ADM_AUTH count for systems 2, 3, 4 (21 tables)
    const extraAuth = sys.id === 1 ? 0 : 21;
    grandTotalTables += sysTables + extraAuth;
    grandTotalRows += sysRows;
    grandTotalBytes += sysBytes;

    allSysTables.sort((a, b) => b.est_mb - a.est_mb);

    // Calculate Escenario B (Operativo / Depurado: excluding _TMP_, _BKP, _ERROR_ENVIO, clones _1/_2/_3, and capping historic logs)
    let cleanRows = 0;
    let cleanBytes = 0;
    for (const t of allSysTables) {
      const name = t.full_name.toUpperCase();
      if (
        name.includes('_TMP_') ||
        name.includes('_BKP') ||
        name.includes('ERROR_ENVIO') ||
        /_DET_[123]$/.test(name) ||
        /_ASISTENCIA_[12]$/.test(name) ||
        name.endsWith('AUT_OAUTH_ACCESS_TOKENS') ||
        name.endsWith('AUT_OAUTH_REFRESH_TOKENS')
      ) {
        continue;
      }
      if (name.endsWith('EDC_ASISTENCIA_BLOQUE')) {
        // Keep last 2 years (~15% of 12-year history)
        cleanRows += Math.round(t.num_rows * 0.15);
        cleanBytes += t.est_mb * 1024 * 1024 * 0.15;
      } else if (name.endsWith('RHU_CAPACITACION_MOV') || name.endsWith('RHU_ESTADOS')) {
        // Keep active/recent 10%
        cleanRows += Math.round(t.num_rows * 0.10);
        cleanBytes += t.est_mb * 1024 * 1024 * 0.10;
      } else {
        cleanRows += t.num_rows;
        cleanBytes += t.est_mb * 1024 * 1024;
      }
    }

    const estMB = (sysBytes / (1024 * 1024)).toFixed(1);
    const estGB = (sysBytes / (1024 * 1024 * 1024)).toFixed(2);
    const cleanMB = (cleanBytes / (1024 * 1024)).toFixed(1);
    const cleanGB = (cleanBytes / (1024 * 1024 * 1024)).toFixed(2);
    console.log(`▶ SISTEMA ${sys.id}: ${sys.name} (${sys.db} - Puerto ${sys.port})`);
    console.log(`  Esquemas: ${sys.schemas.join(' + ')}${extraAuth ? ' (+ ADM_AUTH)' : ''}`);
    console.log(`  Tablas: ${sysTables + extraAuth} | Filas Totales Oracle: ${sysRows.toLocaleString('es-CL')}`);
    console.log(`  [Escenario A - Volcado 100% Bruto]: ${estMB} MB (~${estGB} GB)`);
    console.log(`  [Escenario B - Volcado Operativo Depurado]: ${cleanMB} MB (~${cleanGB} GB) | ${cleanRows.toLocaleString('es-CL')} filas`);
    console.log('  Top 5 tablas con mayor volumen:');
    for (const top of allSysTables.slice(0, 5)) {
      const pct = sysRows > 0 ? ((top.num_rows / sysRows) * 100).toFixed(1) : '0.0';
      console.log(`    - ${top.full_name.padEnd(42)} | ${top.num_rows.toLocaleString('es-CL').padStart(13)} filas (${pct}%) | ~${top.est_mb.toLocaleString('es-CL')} MB`);
    }
    console.log('');
  }

  console.log('--------------------------------------------------------------------------------');
  console.log(`TOTAL GLOBAL (4 SISTEMAS): ${grandTotalTables} tablas | ${grandTotalRows.toLocaleString('es-CL')} filas | ~${(grandTotalBytes / (1024 * 1024 * 1024)).toFixed(2)} GB`);
  console.log('--------------------------------------------------------------------------------\n');

  // Connect to PostgreSQL 192.168.30.48:5432
  console.log('================================================================================');
  console.log('2. ESTADO ACTUAL DEL SERVIDOR POSTGRESQL CLONADO (192.168.30.48:5432)');
  console.log('================================================================================');
  const client = new Client({
    host: '192.168.30.48',
    port: 5432,
    user: 'cmds_admin',
    password: 'CmdsPostgres2026!',
    database: 'postgres'
  });
  await client.connect();

  const dbSizes = await client.query(`
    SELECT datname,
           pg_database_size(datname) AS bytes,
           pg_size_pretty(pg_database_size(datname)) AS size_pretty
    FROM pg_database
    WHERE datistemplate = false
    ORDER BY pg_database_size(datname) DESC
  `);

  let totalClusterBytes = 0;
  let padClusterBytes = 0;
  const padDbs = new Set(['bd_cmds_admin', 'bd_cmds_educa', 'bd_cmds_rhu', 'bd_cmds_portaldir']);

  for (const r of dbSizes.rows) {
    totalClusterBytes += Number(r.bytes);
    if (padDbs.has(r.datname)) padClusterBytes += Number(r.bytes);
  }

  console.log(`Total Bases de Datos en 192.168.30.48: ${dbSizes.rows.length}`);
  console.log(`Peso total ocupado por todas las BDs en el clúster: ${(totalClusterBytes / (1024 * 1024)).toFixed(2)} MB (~${(totalClusterBytes / (1024 * 1024 * 1024)).toFixed(2)} GB)`);
  console.log(`Peso actual de las 4 BDs PAD (con estructura 1.437 tablas + semillas): ${(padClusterBytes / (1024 * 1024)).toFixed(2)} MB\n`);

  console.log('Detalle de las 4 Bases de Datos PAD en 192.168.30.48:');
  for (const r of dbSizes.rows.filter(x => padDbs.has(x.datname))) {
    console.log(`  - ${r.datname.padEnd(22)}: ${r.size_pretty}`);
  }

  console.log('\nTop 5 otras Bases de Datos existentes en 192.168.30.48:');
  for (const r of dbSizes.rows.filter(x => !padDbs.has(x.datname)).slice(0, 5)) {
    console.log(`  - ${r.datname.padEnd(22)}: ${r.size_pretty}`);
  }

  // Check PostgreSQL data_directory and version
  const settings = await client.query(`
    SELECT name, setting FROM pg_settings WHERE name IN ('data_directory', 'server_version', 'max_connections', 'shared_buffers')
  `);
  console.log('\nConfiguración del Motor PostgreSQL 192.168.30.48:');
  for (const s of settings.rows) {
    console.log(`  - ${s.name.padEnd(20)}: ${s.setting}`);
  }

  const roleInfo = await client.query(`SELECT rolname, rolsuper, rolcreatedb FROM pg_roles WHERE rolname = current_user`);
  console.log('Privilegios usuario PG:', roleInfo.rows[0]);
  if (roleInfo.rows[0] && roleInfo.rows[0].rolsuper) {
    try {
      await client.query(`CREATE TEMP TABLE _df_info (line text); COPY _df_info FROM PROGRAM 'df -h /var/lib/postgresql';`);
      const dfRes = await client.query(`SELECT * FROM _df_info`);
      console.log('\nEspacio en Disco del Servidor 192.168.30.48 (/var/lib/postgresql):');
      for (const r of dfRes.rows) console.log('  ' + r.line);
    } catch (e) {
      console.log('No se pudo leer df -h:', e.message);
    }
  }

  await client.end();
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
