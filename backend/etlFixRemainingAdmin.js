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

const oracleSchema = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'data', 'oracle_schema.json'), 'utf8'));

function cleanIdent(name) {
  const clean = String(name || '').trim().toLowerCase().replace(/[^a-z0-9_]/g, '_');
  if (/^[0-9]/.test(clean)) return `_${clean}`;
  return clean;
}

function getDsn() {
  return `(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${ORA_HOST})(PORT=${ORA_PORT}))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${ORA_SERVICE})))`;
}

function runSqlPlusScript(scriptText, timeoutMs = 600000) {
  const scriptFile = path.join(TMP_DIR, '_run_fix.sql');
  fs.writeFileSync(scriptFile, scriptText + '\nEXIT;\n', 'utf8');
  const connArg = `${ORA_USER}/"${ORA_PASS}"@${getDsn()}`;
  const res = spawnSync(SQLPLUS_BIN, ['-S', '-L', connArg, `@${scriptFile}`], {
    encoding: 'utf8',
    env: { ...process.env, NLS_LANG: 'AMERICAN_AMERICA.AL32UTF8' },
    timeout: timeoutMs,
    maxBuffer: 1024 * 1024 * 50
  });
  if (res.error) throw new Error(res.error.message);
  if (res.status !== 0) throw new Error(`SQL*Plus exit ${res.status}: ${res.stdout}\n${res.stderr}`);
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
    if (line.startsWith('SP2-') || line.startsWith('ORA-') || line.startsWith('ERROR:')) {
      console.log('  [Aviso SQL*Plus en CSV]:', line);
      continue;
    }
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

async function main() {
  const targetNames = new Set([
    'BHO_FUNCIONARIOS',
    'MPU_ORDENES_CAB',
    'OBS_TRAZABILIDAD',
    'OBS_REP_RRHH_RES',
    'OBS_TMP_TRAZABILIDAD_COVID',
    'OPA_MAIL_TO_SEND',
    'DBG_LOGGER_01',
    'DBG_LOGGER_04',
    'DBG_LOGGER_05',
    'DBG_LOGGER_06',
    'DBG_LOGGER_07',
    'DBG_LOGGER_08',
    'DBG_LOGGER_09',
    'DBG_LOGGER_10',
    'DBG_LOGGER_11',
    'DBG_LOGGER_12'
  ]);

  const tables = Object.values(oracleSchema.tables).filter(t => t.owner === 'ADM_OBS' && targetNames.has(t.table_name));
  console.log(`Exportando las ${tables.length} tablas multi-columna con formato multi-línea (< 2499 chars/línea)...`);

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

  for (const tbl of tables) {
    const csvFile = path.join(TMP_DIR, `${tbl.owner}.${tbl.table_name}.csv`);
    if (fs.existsSync(csvFile)) fs.unlinkSync(csvFile);
    // Multiline SELECT so no line in SQL*Plus ever exceeds 2,499 characters!
    const selectList = tbl.columns.map(c => '  ' + buildOracleSelectExpr(c)).join(',\n');
    sqlLines.push(`SPOOL "${csvFile}"`);
    sqlLines.push(`SELECT\n${selectList}\nFROM "${tbl.owner}"."${tbl.table_name}";`);
    sqlLines.push('SPOOL OFF');
  }

  runSqlPlusScript(sqlLines.join('\n'));

  const pool = new Pool(PG_CONFIG);
  const pgClient = await pool.connect();

  try {
    const pgColsRes = await pgClient.query(`
      SELECT table_schema, table_name, column_name, data_type, character_maximum_length
      FROM information_schema.columns
      WHERE table_schema IN ('adm_obs', 'adm_auth')
    `);
    const pgColMap = new Map();
    for (const r of pgColsRes.rows) {
      pgColMap.set(`${r.table_schema}.${r.table_name}.${r.column_name}`, r);
    }

    let extraRows = 0;
    for (const tbl of tables) {
      const csvFile = path.join(TMP_DIR, `${tbl.owner}.${tbl.table_name}.csv`);
      const rows = parseSpoolCsvFile(csvFile, tbl.columns);
      try { fs.unlinkSync(csvFile); } catch {}

      if (rows.length === 0) {
        console.log(`  - ${tbl.table_name}: 0 filas en Oracle`);
        continue;
      }

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
        await pgClient.query(`TRUNCATE TABLE ${pgSchema}."${pgTable}" CASCADE`);
        const INSERT_BATCH = Math.max(50, Math.min(400, Math.floor(20000 / Math.max(1, colMeta.length))));

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
        extraRows += rows.length;
        console.log(`  ✓ ${pgSchema}.${pgTable.padEnd(32)} -> ${rows.length.toLocaleString('es-CL')} filas volcadas`);
      } catch (err) {
        await pgClient.query('ROLLBACK');
        console.error(`  ✗ Error en ${pgSchema}.${pgTable}: ${err.message}`);
      }
    }

    const sizeRes = await pgClient.query(`SELECT pg_size_pretty(pg_database_size('bd_cmds_admin')) AS db_size`);
    console.log(`\nFilas adicionales volcadas: ${extraRows.toLocaleString('es-CL')} | Tamaño actual bd_cmds_admin: ${sizeRes.rows[0].db_size}`);
  } finally {
    pgClient.release();
    await pool.end();
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
