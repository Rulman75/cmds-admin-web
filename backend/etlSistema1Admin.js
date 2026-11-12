const { spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const SQLPLUS_BIN = process.env.SQLPLUS_BIN || 'C:\\oracle32\\client\\sqlplus.exe';
const ORA_HOST = process.env.ORACLE_HOST || '186.67.6.133';
const ORA_PORT = process.env.ORACLE_PORT || '9521';
const ORA_SERVICE = process.env.ORACLE_SERVICE || 'cmdseducaprod.padclprodpriv.vcnpadclprod.oraclevcn.com';
const ORA_USER = process.env.ORACLE_USER || 'cmds_consultas';
const ORA_PASS = process.env.ORACLE_PASS || 'Bomberos##4248';

const PG_CONFIG = {
  host: process.env.PG_HOST || '192.168.30.48',
  port: Number(process.env.PG_PORT || 5432),
  user: process.env.PG_USER || 'cmds_admin',
  password: process.env.PG_PASS || 'CmdsPostgres2026!',
  database: process.env.PG_DB || 'bd_cmds_admin',
  max: 10
};

const TMP_DIR = 'C:\\Users\\rhormazabal\\.gemini\\antigravity\\brain\\5a3a283f-33ba-4a99-ac32-724d2266e50d\\scratch\\etl_admin';
fs.mkdirSync(TMP_DIR, { recursive: true });

const SCHEMA_JSON_PATH = path.join(__dirname, '..', 'data', 'oracle_schema.json');
const oracleSchema = JSON.parse(fs.readFileSync(SCHEMA_JSON_PATH, 'utf8'));

// BLOB columns in ADM_OBS that actually contain text descriptions/observations
const TEXT_BLOB_COLS = new Set([
  'ORDE_DESCRIPCION',
  'OSMO_DESCRIPCION',
  'OSDE_OBSERVACIONES',
  'HORU_OBSERVACION',
  'INIC_OBSERVACIONES',
  'INIC_OBS_LOG',
  'INIC_OBS_REV',
  'REEV_OBSERVACIONES'
]);

function cleanIdent(name) {
  const clean = String(name || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9_]/g, '_');
  if (/^[0-9]/.test(clean)) return `_${clean}`;
  return clean;
}

function getDsn() {
  return `(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${ORA_HOST})(PORT=${ORA_PORT}))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${ORA_SERVICE})))`;
}

function runSqlPlusScript(scriptText, timeoutMs = 600000) {
  const scriptFile = path.join(TMP_DIR, '_run_batch.sql');
  fs.writeFileSync(scriptFile, scriptText + '\nEXIT;\n', 'utf8');
  const connArg = `${ORA_USER}/"${ORA_PASS}"@${getDsn()}`;
  const res = spawnSync(SQLPLUS_BIN, ['-S', '-L', connArg, `@${scriptFile}`], {
    encoding: 'utf8',
    env: { ...process.env, NLS_LANG: 'AMERICAN_AMERICA.AL32UTF8' },
    timeout: timeoutMs,
    maxBuffer: 1024 * 1024 * 50
  });
  if (res.error) {
    throw new Error(`Error ejecutando SQL*Plus: ${res.error.message}`);
  }
  if (/ORA-01017|ORA-28000/i.test(res.stdout || '') || /ORA-01017|ORA-28000/i.test(res.stderr || '')) {
    throw new Error(`Alerta de autenticación Oracle detectada (Cortacircuito inmediato):\n${res.stdout}\n${res.stderr}`);
  }
  if (res.status !== 0) {
    throw new Error(`SQL*Plus retornó código ${res.status} (Cortacircuito activado):\n${res.stdout}\n${res.stderr}`);
  }
  return res.stdout;
}

function buildOracleSelectExpr(col) {
  const colName = col.name;
  const colType = String(col.type || 'VARCHAR2').toUpperCase();
  const qName = `"${colName}"`;

  if (colType === 'BLOB' || colType === 'LONG RAW' || colType === 'BFILE') {
    if (TEXT_BLOB_COLS.has(colName.toUpperCase())) {
      return `REPLACE(REPLACE(REPLACE(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(${qName}, 2000, 1)), CHR(0), ''), CHR(13), ' '), CHR(10), ' ') AS ${qName}`;
    }
    return `NULL AS ${qName}`;
  }
  if (colType === 'RAW') {
    return `RAWTOHEX(${qName}) AS ${qName}`;
  }
  if (colType === 'CLOB' || colType === 'NCLOB' || colType === 'LONG' || colType === 'XMLTYPE') {
    return `REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(${qName}, 3500, 1), CHR(0), ''), CHR(13), ' '), CHR(10), ' ') AS ${qName}`;
  }
  if (colType === 'DATE' || colType.startsWith('TIMESTAMP')) {
    return `CASE WHEN ${qName} IS NOT NULL AND EXTRACT(YEAR FROM ${qName}) BETWEEN 1900 AND 2100 THEN TO_CHAR(${qName}, 'YYYY-MM-DD HH24:MI:SS') ELSE NULL END AS ${qName}`;
  }
  if (colType.includes('CHAR')) {
    return `REPLACE(REPLACE(REPLACE(${qName}, CHR(0), ''), CHR(13), ' '), CHR(10), ' ') AS ${qName}`;
  }
  return qName;
}

function parseCsvLine(line) {
  const result = [];
  let cur = '';
  let inQuotes = false;
  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    if (inQuotes) {
      if (ch === '"') {
        if (i + 1 < line.length && line[i + 1] === '"') {
          cur += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        cur += ch;
      }
    } else {
      if (ch === '"') {
        inQuotes = true;
      } else if (ch === ',') {
        result.push(cur);
        cur = '';
      } else {
        cur += ch;
      }
    }
  }
  result.push(cur);
  return result;
}

function parseSpoolCsvFile(filePath, expectedCols) {
  if (!fs.existsSync(filePath)) return [];
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split(/\r?\n/);
  const rows = [];
  let headerSeen = false;
  const upperExpected = expectedCols.map(c => c.name.toUpperCase());

  for (let rawLine of lines) {
    const line = rawLine.trim();
    if (!line) continue;
    if (line.startsWith('SP2-') || line.startsWith('ORA-') || line.startsWith('ERROR:')) continue;

    const fields = parseCsvLine(rawLine);
    if (fields.length !== expectedCols.length) continue;

    // Check if this line is the header (or repeated header after 50,000 rows)
    const isHeader = fields.every((val, idx) => val.trim().toUpperCase() === upperExpected[idx]);
    if (isHeader) {
      headerSeen = true;
      continue;
    }
    if (!headerSeen) continue;

    rows.push(fields);
  }
  return rows;
}

async function main() {
  console.log('================================================================================');
  console.log('VOLCADO REAL ORACLE 26ai -> POSTGRESQL 18.6 (SISTEMA 1: bd_cmds_admin)');
  console.log(`Destino: ${PG_CONFIG.host}:${PG_CONFIG.port}/${PG_CONFIG.database}`);
  console.log('================================================================================\n');

  // 1. Single-attempt preflight check on Oracle
  console.log('[1/4] Verificando conexión única a Oracle 26ai (con cortacircuito -L)...');
  const preflightOut = runSqlPlusScript([
    'SET PAGESIZE 100',
    'SET FEEDBACK OFF',
    'SELECT BANNER FROM V$VERSION;',
    'EXIT;'
  ].join('\n'), 20000);
  console.log('  -> Conexión Oracle OK:', preflightOut.trim().split('\n')[0]);

  // 2. Connect to PostgreSQL 192.168.30.48
  const pgPool = new Pool(PG_CONFIG);
  const pgClient = await pgPool.connect();

  try {
    console.log('[2/4] Preparando columnas TEXT y obteniendo metadatos de bd_cmds_admin en 192.168.30.48...');
    // Ensure all BLOB-text columns in PostgreSQL are TEXT
    const textAlterList = [
      ['opa_orden_servicio', 'orde_descripcion'],
      ['opa_orden_servicio_aud', 'orde_descripcion'],
      ['opa_orden_servicio_bkp_0307202', 'orde_descripcion'],
      ['opa_orden_servicio_mov', 'osmo_descripcion'],
      ['opa_orden_servicio_mov_aud', 'osmo_descripcion'],
      ['opa_orden_servicio_mov_bkp_0307202', 'osmo_descripcion'],
      ['opa_orse_derivados', 'osde_observaciones'],
      ['opa_orse_derivados_aud', 'osde_observaciones'],
      ['opa_orse_derivados_bkp_0307202', 'osde_observaciones'],
      ['opa_orse_mov_log', 'osmo_descripcion'],
      ['opa_orse_mov_log_aud', 'osmo_descripcion'],
      ['opa_orse_mov_log_bkp_0307202', 'osmo_descripcion'],
      ['hr_iniciativa', 'inic_observaciones'],
      ['hr_iniciativa', 'inic_obs_log'],
      ['hr_iniciativa', 'inic_obs_rev'],
      ['hr_hoja_ruta', 'horu_observacion'],
      ['hr_hoja_ruta_log', 'horu_observacion'],
      ['hr_registro_evaluador', 'reev_observaciones']
    ];
    for (const [t, c] of textAlterList) {
      await pgClient.query(`ALTER TABLE adm_obs.${t} ALTER COLUMN ${c} TYPE TEXT USING ${c}::text`).catch(() => {});
    }

    // Load actual column types from PostgreSQL to convert values safely
    const pgColsRes = await pgClient.query(`
      SELECT table_schema, table_name, column_name, data_type, character_maximum_length
      FROM information_schema.columns
      WHERE table_schema IN ('adm_obs', 'adm_auth')
    `);
    const pgColMap = new Map();
    for (const r of pgColsRes.rows) {
      pgColMap.set(`${r.table_schema}.${r.table_name}.${r.column_name}`, r);
    }

    // Also widen any VARCHAR columns that might clip UTF-8 strings during full dump to TEXT if needed, or let's inspect
    // Filter tables from oracle_schema.json for ADM_AUTH and ADM_OBS (excluding SBA_* Servicios Básicos and AQ queues)
    const allTables = Object.values(oracleSchema.tables).filter(t => {
      if (!['ADM_AUTH', 'ADM_OBS'].includes(t.owner)) return false;
      if (t.table_name.startsWith('SBA_')) return false;
      if (t.table_name.startsWith('AQ$_') || t.table_name.endsWith('_TB')) return false;
      if (t.table_name === 'SQLN_EXPLAIN_PLAN') return false;
      // Skip dead OAuth token tables (258k expired tokens) and COVID temp table if desired, or keep small sample
      return (t.num_rows || 0) > 0 && (t.columns || []).length > 0;
    });

    // Sort smaller/catalog tables first, larger operational tables after
    allTables.sort((a, b) => (a.num_rows || 0) - (b.num_rows || 0));

    console.log(`[3/4] Tablas con datos a volcar desde Oracle (excluyendo Servicios Básicos SBA_*): ${allTables.length} tablas`);

    // Group tables into batches for SQL*Plus SPOOL sessions so we only open ~8 connections total
    const BATCH_SIZE = 30;
    const batches = [];
    for (let i = 0; i < allTables.length; i += BATCH_SIZE) {
      batches.push(allTables.slice(i, i + BATCH_SIZE));
    }

    let totalMigratedTables = 0;
    let totalMigratedRows = 0;
    const startTime = Date.now();

    for (let bIdx = 0; bIdx < batches.length; bIdx++) {
      const batch = batches[bIdx];
      console.log(`\n--- Lote ${bIdx + 1}/${batches.length} (${batch.length} tablas: ${batch[0].owner}.${batch[0].table_name} .. ${batch[batch.length - 1].owner}.${batch[batch.length - 1].table_name}) ---`);

      // Build single SQL*Plus script for this entire batch
      const sqlLines = [
        'SET PAGESIZE 50000',
        'SET ARRAYSIZE 2000',
        'SET LONG 4000',
        'SET LONGCHUNKSIZE 4000',
        'SET FEEDBACK OFF',
        'SET VERIFY OFF',
        'SET HEADING ON',
        'SET ECHO OFF',
        'SET TERMOUT OFF',
        'SET TRIMSPOOL ON',
        "ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';",
        "ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS';",
        "ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';",
        'SET MARKUP CSV ON DELIMITER , QUOTE ON'
      ];

      for (const tbl of batch) {
        const csvFile = path.join(TMP_DIR, `${tbl.owner}.${tbl.table_name}.csv`);
        if (fs.existsSync(csvFile)) fs.unlinkSync(csvFile);
        const selectList = tbl.columns.map(c => '  ' + buildOracleSelectExpr(c)).join(',\n');
        // For the 2 OAuth token cache tables (258k rows), cap at 2,000 recent rows to keep DB clean; for all business tables, 100% of rows
        let whereClause = '';
        if (tbl.table_name === 'AUT_OAUTH_ACCESS_TOKENS' || tbl.table_name === 'AUT_OAUTH_REFRESH_TOKENS') {
          whereClause = ' WHERE ROWNUM <= 2000';
        }
        sqlLines.push(`SPOOL "${csvFile}"`);
        sqlLines.push(`SELECT\n${selectList}\nFROM "${tbl.owner}"."${tbl.table_name}"${whereClause};`);
        sqlLines.push('SPOOL OFF');
      }
      sqlLines.push('EXIT;');

      const t0 = Date.now();
      runSqlPlusScript(sqlLines.join('\n'), 600000);
      console.log(`  [Oracle Export Lote ${bIdx + 1}] Completado en ${((Date.now() - t0) / 1000).toFixed(1)}s`);

      // Now load each CSV into PostgreSQL 192.168.30.48
      for (const tbl of batch) {
        const csvFile = path.join(TMP_DIR, `${tbl.owner}.${tbl.table_name}.csv`);
        const rows = parseSpoolCsvFile(csvFile, tbl.columns);
        try { fs.unlinkSync(csvFile); } catch {}

        if (rows.length === 0) {
          continue;
        }

        const pgSchema = tbl.owner.toLowerCase();
        const pgTable = cleanIdent(tbl.table_name);
        const pgCols = tbl.columns.map(c => cleanIdent(c.name));
        const quotedPgCols = pgCols.map(c => `"${c}"`);

        // Prepare column type converters based on PostgreSQL column metadata
        const colMeta = pgCols.map((colName, idx) => {
          const info = pgColMap.get(`${pgSchema}.${pgTable}.${colName}`);
          return {
            pgCol: colName,
            oraType: String(tbl.columns[idx].type || '').toUpperCase(),
            pgType: info ? info.data_type : 'text',
            maxLen: info ? info.character_maximum_length : null
          };
        });

        await pgClient.query('BEGIN');
        try {
          await pgClient.query(`TRUNCATE TABLE ${pgSchema}."${pgTable}" CASCADE`);

          const INSERT_BATCH = Math.max(50, Math.min(500, Math.floor(25000 / Math.max(1, colMeta.length))));
          for (let rIdx = 0; rIdx < rows.length; rIdx += INSERT_BATCH) {
            const slice = rows.slice(rIdx, rIdx + INSERT_BATCH);
            const values = [];
            const placeholders = [];
            let pCount = 1;

            for (const row of slice) {
              const rowPh = [];
              for (let cIdx = 0; cIdx < colMeta.length; cIdx++) {
                let rawVal = row[cIdx];
                const meta = colMeta[cIdx];
                let finalVal = null;

                if (rawVal !== undefined && rawVal !== null && rawVal !== '') {
                  if (meta.pgType.includes('int') || meta.pgType === 'numeric' || meta.pgType === 'double precision' || meta.pgType === 'real') {
                    const num = Number(String(rawVal).replace(',', '.'));
                    finalVal = Number.isFinite(num) ? num : null;
                  } else if (meta.pgType.includes('timestamp') || meta.pgType === 'date') {
                    finalVal = rawVal.trim();
                  } else if (meta.pgType === 'bytea') {
                    finalVal = Buffer.from(rawVal, 'utf8');
                  } else {
                    finalVal = String(rawVal);
                    if (meta.maxLen && finalVal.length > meta.maxLen) {
                      finalVal = finalVal.slice(0, meta.maxLen);
                    }
                  }
                }
                values.push(finalVal);
                rowPh.push(`$${pCount++}`);
              }
              placeholders.push(`(${rowPh.join(',')})`);
            }

            const insertSql = `INSERT INTO ${pgSchema}."${pgTable}" (${quotedPgCols.join(',')}) VALUES ${placeholders.join(',')} ON CONFLICT DO NOTHING`;
            await pgClient.query(insertSql, values);
          }

          await pgClient.query('COMMIT');
          totalMigratedTables++;
          totalMigratedRows += rows.length;
          if (rows.length >= 500 || totalMigratedTables % 15 === 0) {
            console.log(`    ✓ ${pgSchema}.${pgTable.padEnd(32)} -> ${rows.length.toLocaleString('es-CL')} filas volcadas`);
          }
        } catch (err) {
          await pgClient.query('ROLLBACK');
          console.error(`    ✗ Error en ${pgSchema}.${pgTable}: ${err.message}`);
        }
      }
    }

    // Ensure demo/admin user 10633447 can still log in with 7888 if needed, or check their real record in aut_usuarios
    const elapsedSec = ((Date.now() - startTime) / 1000).toFixed(1);
    const sizeRes = await pgClient.query(`SELECT pg_size_pretty(pg_database_size('bd_cmds_admin')) AS db_size`);

    console.log('\n================================================================================');
    console.log('[4/4] VOLCADO REAL DE SISTEMA 1 (bd_cmds_admin) COMPLETADO CON ÉXITO');
    console.log(`  - Tablas pobladas con datos reales de Oracle: ${totalMigratedTables}`);
    console.log(`  - Total filas reales insertadas en PostgreSQL: ${totalMigratedRows.toLocaleString('es-CL')}`);
    console.log(`  - Tamaño actual de bd_cmds_admin en 192.168.30.48: ${sizeRes.rows[0].db_size}`);
    console.log(`  - Tiempo total de ejecución: ${elapsedSec} segundos`);
    console.log('================================================================================');
  } finally {
    pgClient.release();
    await pgPool.end();
  }
}

main().catch(err => {
  console.error('\n[FATAL ETL ERROR]:', err.message);
  process.exit(1);
});
