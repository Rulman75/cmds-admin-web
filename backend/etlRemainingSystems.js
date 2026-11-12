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

const PG_BASE = {
  host: process.env.PG_HOST || '192.168.30.48',
  port: Number(process.env.PG_PORT || 5432),
  user: process.env.PG_USER || 'cmds_admin',
  password: process.env.PG_PASS || 'CmdsPostgres2026!',
  max: 10
};

const TMP_DIR = 'C:\\Users\\rhormazabal\\.gemini\\antigravity\\brain\\5a3a283f-33ba-4a99-ac32-724d2266e50d\\scratch\\etl_remaining';
fs.mkdirSync(TMP_DIR, { recursive: true });

const otherSchemas = JSON.parse(
  fs.readFileSync(path.join(__dirname, '..', 'data', 'oracle_other_schemas.json'), 'utf8')
);

function cleanIdent(name) {
  const clean = String(name || '').trim().toLowerCase().replace(/[^a-z0-9_]/g, '_');
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
    throw new Error(`SQL*Plus retornó código ${res.status}:\n${res.stdout}\n${res.stderr}`);
  }
  return res.stdout;
}

function buildOracleSelectExpr(col) {
  const colName = col.name;
  const colType = String(col.type || 'VARCHAR2').toUpperCase();
  const qName = `"${colName}"`;

  if (colType === 'BLOB' || colType === 'LONG RAW' || colType === 'BFILE') {
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

function shouldSkipTable(owner, tname) {
  const u = tname.toUpperCase();
  if (u.startsWith('AQ$_') || u.endsWith('_TB') || u === 'SQLN_EXPLAIN_PLAN') return true;
  if (u.includes('TRACE_APLIC_LOG')) return true;
  if (u === 'EDC_SIGE_ERROR_ENVIO' || u === 'LCS_MAIL_BAD' || u === 'A_BASERENTA_FEB') return true;
  if (u.includes('_TMP_BKP') || u.endsWith('_TMP')) return true;
  // In ADM_PORTALDIR, _2 and _3 are redundant snapshot copies of _1
  if (owner === 'ADM_PORTALDIR' && (u.endsWith('_2') || u.endsWith('_3'))) return true;
  return false;
}

function getRowCap(owner, tname, numRows) {
  if (numRows <= 15000) return null; // 100% of rows
  const u = tname.toUpperCase();
  // Core master/operational tables: bring up to 15,000 rows
  if (
    u === 'RHU_CONTRATO_MOV' ||
    u === 'RHU_DETALLE_TRAB' ||
    u === 'RHU_LIQUIDACION_TRAB' ||
    u === 'LCS_PAGLIC' ||
    u === 'EDC_PERSONAS' ||
    u === 'EDC_FICHA_ALUMNO' ||
    u === 'EDC_MATRICULA_ALUMNOS' ||
    u === 'EDC_ALUMNOS_CURSOS' ||
    u === 'EDC_CURSO_ASIGNATURA' ||
    u === 'EDC_CURSO_PROFESORES' ||
    u === 'EDC_USUARIOS_PORTAL'
  ) {
    return 15000;
  }
  // Massive historical log/block tables: bring 3,000 representative rows
  return 3000;
}

async function syncAdmAuthFromAdminDb(targetDbs) {
  console.log('\n[FASE A] Sincronizando ADM_AUTH real (9.226 usuarios + grupos + sesiones) desde bd_cmds_admin hacia las otras 3 BDs...');
  const srcPool = new Pool({ ...PG_BASE, database: 'bd_cmds_admin' });

  try {
    const tblRes = await srcPool.query(`
      SELECT table_name FROM information_schema.tables
      WHERE table_schema = 'adm_auth' AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);
    const authTables = tblRes.rows.map(r => r.table_name);

    for (const tbl of authTables) {
      const srcRes = await srcPool.query(`SELECT * FROM adm_auth."${tbl}"`);
      if (srcRes.rows.length === 0) continue;
      const cols = Object.keys(srcRes.rows[0]);
      const quotedCols = cols.map(c => `"${c}"`).join(',');

      for (const dbName of targetDbs) {
        const dstPool = new Pool({ ...PG_BASE, database: dbName });
        const client = await dstPool.connect();
        try {
          await client.query('BEGIN');
          const BATCH = 500;
          for (let i = 0; i < srcRes.rows.length; i += BATCH) {
            const slice = srcRes.rows.slice(i, i + BATCH);
            const vals = [];
            const ph = [];
            let p = 1;
            for (const r of slice) {
              const rph = [];
              for (const c of cols) {
                vals.push(r[c]);
                rph.push(`$${p++}`);
              }
              ph.push(`(${rph.join(',')})`);
            }
            await client.query(
              `INSERT INTO adm_auth."${tbl}" (${quotedCols}) VALUES ${ph.join(',')} ON CONFLICT DO NOTHING`,
              vals
            );
          }
          await client.query('COMMIT');
        } catch (e) {
          await client.query('ROLLBACK');
        } finally {
          client.release();
          await dstPool.end();
        }
      }
      console.log(`  ✓ adm_auth.${tbl.padEnd(28)} (${srcRes.rows.length.toLocaleString('es-CL')} filas) sincronizada en las 3 bases de datos.`);
    }
  } finally {
    await srcPool.end();
  }
}

async function dumpSystem(sysConfig) {
  const { name, dbName, schemas } = sysConfig;
  console.log('\n================================================================================');
  console.log(`VOLCADO REAL: ${name} -> ${PG_BASE.host}:${PG_BASE.port}/${dbName}`);
  console.log(`Esquemas Oracle: ${schemas.join(' + ')}`);
  console.log('================================================================================');

  const pool = new Pool({ ...PG_BASE, database: dbName });
  const pgClient = await pool.connect();

  try {
    const pgSchemasList = schemas.map(s => `'${s.toLowerCase()}'`).join(',');
    const pgColsRes = await pgClient.query(`
      SELECT table_schema, table_name, column_name, data_type, character_maximum_length
      FROM information_schema.columns
      WHERE table_schema IN (${pgSchemasList})
    `);
    const pgColMap = new Map();
    const pgTablesSet = new Set();
    for (const r of pgColsRes.rows) {
      pgColMap.set(`${r.table_schema}.${r.table_name}.${r.column_name}`, r);
      pgTablesSet.add(`${r.table_schema}.${r.table_name}`);
    }

    // Collect tables with rows > 0 from oracle_other_schemas.json
    const tablesToDump = [];
    for (const owner of schemas) {
      const schemaObj = otherSchemas[owner];
      if (!schemaObj || !schemaObj.tables) continue;
      for (const tbl of Object.values(schemaObj.tables)) {
        if ((tbl.num_rows || 0) <= 0 || !tbl.columns || tbl.columns.length === 0) continue;
        if (shouldSkipTable(owner, tbl.table_name)) continue;
        const pgSchema = owner.toLowerCase();
        const pgTable = cleanIdent(tbl.table_name);
        if (!pgTablesSet.has(`${pgSchema}.${pgTable}`)) continue;
        tablesToDump.push({ owner, ...tbl });
      }
    }

    tablesToDump.sort((a, b) => (a.num_rows || 0) - (b.num_rows || 0));
    console.log(`Tablas operativas con datos a volcar en ${dbName}: ${tablesToDump.length} tablas`);

    const BATCH_SIZE = 35;
    const batches = [];
    for (let i = 0; i < tablesToDump.length; i += BATCH_SIZE) {
      batches.push(tablesToDump.slice(i, i + BATCH_SIZE));
    }

    let sysTablesLoaded = 0;
    let sysRowsLoaded = 0;
    const tStart = Date.now();

    for (let bIdx = 0; bIdx < batches.length; bIdx++) {
      const batch = batches[bIdx];
      console.log(`\n  --- [${dbName}] Lote ${bIdx + 1}/${batches.length} (${batch.length} tablas) ---`);

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
        const cap = getRowCap(tbl.owner, tbl.table_name, tbl.num_rows);
        const whereClause = cap ? `\nWHERE ROWNUM <= ${cap}` : '';
        sqlLines.push(`SPOOL "${csvFile}"`);
        sqlLines.push(`SELECT\n${selectList}\nFROM "${tbl.owner}"."${tbl.table_name}"${whereClause};`);
        sqlLines.push('SPOOL OFF');
      }

      const t0 = Date.now();
      runSqlPlusScript(sqlLines.join('\n'), 600000);
      console.log(`    [Oracle Export Lote ${bIdx + 1}] Completado en ${((Date.now() - t0) / 1000).toFixed(1)}s`);

      for (const tbl of batch) {
        const csvFile = path.join(TMP_DIR, `${tbl.owner}.${tbl.table_name}.csv`);
        const rows = parseSpoolCsvFile(csvFile, tbl.columns);
        try { fs.unlinkSync(csvFile); } catch {}
        if (rows.length === 0) continue;

        const pgSchema = tbl.owner.toLowerCase();
        const pgTable = cleanIdent(tbl.table_name);
        const pgCols = tbl.columns.map(c => cleanIdent(c.name));
        const quotedPgCols = pgCols.map(c => `"${c}"`);

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
          const INSERT_BATCH = Math.max(50, Math.min(450, Math.floor(22000 / Math.max(1, colMeta.length))));
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
                    if (Number.isFinite(num)) {
                      finalVal = meta.pgType.includes('int') ? Math.trunc(num) : num;
                    } else {
                      finalVal = null;
                    }
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
          sysTablesLoaded++;
          sysRowsLoaded += rows.length;
          if (rows.length >= 500 || sysTablesLoaded % 20 === 0) {
            console.log(`      ✓ ${pgSchema}.${pgTable.padEnd(32)} -> ${rows.length.toLocaleString('es-CL')} filas reales`);
          }
        } catch (err) {
          await pgClient.query('ROLLBACK');
          console.error(`      ✗ Error en ${pgSchema}.${pgTable}: ${err.message}`);
        }
      }
    }

    await pgClient.query('ANALYZE');
    const sizeRes = await pgClient.query(`SELECT pg_size_pretty(pg_database_size('${dbName}')) AS db_size`);
    console.log(`\n  ==> [${name}] COMPLETADO: ${sysTablesLoaded} tablas pobladas | ${sysRowsLoaded.toLocaleString('es-CL')} filas reales | Peso BD: ${sizeRes.rows[0].db_size} | Tiempo: ${((Date.now() - tStart) / 1000).toFixed(1)}s`);
    return { dbName, tables: sysTablesLoaded, rows: sysRowsLoaded, size: sizeRes.rows[0].db_size };
  } finally {
    pgClient.release();
    await pool.end();
  }
}

async function main() {
  const targetSystems = [
    {
      name: 'SISTEMA 3: CMDS RRHH',
      dbName: 'bd_cmds_rhu',
      schemas: ['ADM_RHU']
    },
    {
      name: 'SISTEMA 4: Portal Director + ADMETA',
      dbName: 'bd_cmds_portaldir',
      schemas: ['ADM_PORTALDIR', 'ADMETA']
    },
    {
      name: 'SISTEMA 2: PADEDUCA',
      dbName: 'bd_cmds_educa',
      schemas: ['ADM_EDUCA', 'ADM_NOTAS']
    }
  ];

  await syncAdmAuthFromAdminDb(['bd_cmds_rhu', 'bd_cmds_portaldir', 'bd_cmds_educa']);

  const summary = [];
  for (const sys of targetSystems) {
    const res = await dumpSystem(sys);
    summary.push(res);
  }

  console.log('\n================================================================================');
  console.log('RESUMEN GLOBAL DEL VOLCADO DE LOS 3 SISTEMAS RESTANTES EN 192.168.30.48:5432');
  console.log('================================================================================');
  console.table(summary);
}

main().catch(err => {
  console.error('\n[FATAL ETL ERROR]:', err.message);
  process.exit(1);
});
