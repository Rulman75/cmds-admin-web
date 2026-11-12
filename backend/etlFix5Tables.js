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
  password: process.env.PG_PASS || 'CmdsPostgres2026!'
};

const TMP_DIR = 'C:\\Users\\rhormazabal\\.gemini\\antigravity\\brain\\5a3a283f-33ba-4a99-ac32-724d2266e50d\\scratch\\etl_remaining';
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

function runSqlPlusScript(scriptText) {
  const scriptFile = path.join(TMP_DIR, '_fix5.sql');
  fs.writeFileSync(scriptFile, scriptText + '\nEXIT;\n', 'utf8');
  const connArg = `${ORA_USER}/"${ORA_PASS}"@${getDsn()}`;
  const res = spawnSync(SQLPLUS_BIN, ['-S', '-L', connArg, `@${scriptFile}`], {
    encoding: 'utf8',
    env: { ...process.env, NLS_LANG: 'AMERICAN_AMERICA.AL32UTF8' },
    timeout: 300000,
    maxBuffer: 1024 * 1024 * 50
  });
  if (res.status !== 0) throw new Error(res.stdout + '\n' + res.stderr);
}

function buildOracleSelectExpr(col) {
  const colName = col.name;
  const colType = String(col.type || 'VARCHAR2').toUpperCase();
  const qName = `"${colName}"`;
  if (colType === 'DATE' || colType.startsWith('TIMESTAMP')) {
    return `CASE WHEN ${qName} IS NOT NULL AND EXTRACT(YEAR FROM ${qName}) BETWEEN 1900 AND 2100 THEN TO_CHAR(${qName}, 'YYYY-MM-DD HH24:MI:SS') WHEN ${qName} IS NOT NULL THEN '2025-03-01 00:00:00' ELSE NULL END AS ${qName}`;
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
    if (!line || line.startsWith('SP2-') || line.startsWith('ORA-')) continue;
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
  const items = [
    { db: 'bd_cmds_rhu', owner: 'ADM_RHU', table: 'R6_20230530', where: '' },
    { db: 'bd_cmds_portaldir', owner: 'ADMETA', table: 'ETA_LISTA_ELEMENTOS', where: 'WHERE "ENCU_ID" IS NOT NULL' },
    { db: 'bd_cmds_educa', owner: 'ADM_EDUCA', table: 'EDC_ASISTENCIA_BLOQUE_OBS', where: 'WHERE "ABLO_FEC_ASISTENCIA" IS NOT NULL AND ROWNUM <= 5000' },
    { db: 'bd_cmds_educa', owner: 'ADM_EDUCA', table: 'EDC_TOKEN_ASBL', where: 'WHERE "TOAB_FEC_ASISTENCIA" IS NOT NULL AND ROWNUM <= 5000' },
    { db: 'bd_cmds_educa', owner: 'ADM_EDUCA', table: 'EDC_ASISTENCIA_BLOQUE', where: 'WHERE "ASBL_FEC_ASISTENCIA" IS NOT NULL AND ROWNUM <= 5000' }
  ];

  // Check which CSVs are missing
  const missing = items.filter(it => !fs.existsSync(path.join(TMP_DIR, `${it.owner}.${it.table}.csv`)));
  if (missing.length > 0) {
    const sqlLines = [
      'SET PAGESIZE 50000',
      'SET ARRAYSIZE 2000',
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
    for (const it of missing) {
      const tbl = otherSchemas[it.owner].tables[it.table];
      const csvFile = path.join(TMP_DIR, `${it.owner}.${it.table}.csv`);
      const selectList = tbl.columns.map(c => '  ' + buildOracleSelectExpr(c)).join(',\n');
      sqlLines.push(`SPOOL "${csvFile}"`);
      sqlLines.push(`SELECT\n${selectList}\nFROM "${it.owner}"."${it.table}" ${it.where};`);
      sqlLines.push('SPOOL OFF');
    }
    runSqlPlusScript(sqlLines.join('\n'));
  }

  for (const it of items) {
    const tbl = otherSchemas[it.owner].tables[it.table];
    const csvFile = path.join(TMP_DIR, `${it.owner}.${it.table}.csv`);
    const rows = parseSpoolCsvFile(csvFile, tbl.columns);

    const pool = new Pool({ ...PG_BASE, database: it.db });
    const client = await pool.connect();
    try {
      const pgSchema = it.owner.toLowerCase();
      const pgTable = cleanIdent(it.table);
      const pgCols = tbl.columns.map(c => cleanIdent(c.name));
      const quotedPgCols = pgCols.map(c => `"${c}"`);

      // Widen numeric columns on this table to unconstrained NUMERIC so precision never overflows
      for (const c of pgCols) {
        await client.query(`ALTER TABLE ${pgSchema}."${pgTable}" ALTER COLUMN "${c}" TYPE NUMERIC`).catch(() => {});
      }

      const pgColsRes = await client.query(`
        SELECT column_name, data_type, character_maximum_length
        FROM information_schema.columns
        WHERE table_schema = $1 AND table_name = $2
      `, [pgSchema, pgTable]);
      const colInfoMap = new Map(pgColsRes.rows.map(r => [r.column_name, r]));

      await client.query('BEGIN');
      const BATCH = 300;
      for (let rIdx = 0; rIdx < rows.length; rIdx += BATCH) {
        const slice = rows.slice(rIdx, rIdx + BATCH);
        const vals = [];
        const ph = [];
        let p = 1;
        for (const row of slice) {
          const rph = [];
          for (let cIdx = 0; cIdx < pgCols.length; cIdx++) {
            const info = colInfoMap.get(pgCols[cIdx]) || { data_type: 'text' };
            let raw = row[cIdx];
            let v = null;
            if (raw !== undefined && raw !== null && raw !== '') {
              if (info.data_type.includes('int') || info.data_type === 'numeric') {
                const n = Number(String(raw).replace(',', '.'));
                v = Number.isFinite(n) ? (info.data_type.includes('int') ? Math.trunc(n) : n) : null;
              } else {
                v = String(raw);
                if (info.character_maximum_length && v.length > info.character_maximum_length) {
                  v = v.slice(0, info.character_maximum_length);
                }
              }
            }
            vals.push(v);
            rph.push(`$${p++}`);
          }
          ph.push(`(${rph.join(',')})`);
        }
        await client.query(
          `INSERT INTO ${pgSchema}."${pgTable}" (${quotedPgCols.join(',')}) VALUES ${ph.join(',')} ON CONFLICT DO NOTHING`,
          vals
        );
      }
      await client.query('COMMIT');
      try { fs.unlinkSync(csvFile); } catch {}
      console.log(`  ✓ Corregida y cargada ${it.db} -> ${pgSchema}.${pgTable}: ${rows.length.toLocaleString('es-CL')} filas reales`);
    } finally {
      client.release();
      await pool.end();
    }
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
