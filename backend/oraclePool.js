const { Pool, types } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Parse BIGINT (20) and NUMERIC (1700) as JavaScript Number
types.setTypeParser(20, (val) => (val === null ? null : parseInt(val, 10)));
types.setTypeParser(1700, (val) => (val === null ? null : Number(val)));

const PG_CONFIG = {
  host: process.env.PG_HOST || '192.168.30.48',
  port: Number(process.env.PG_PORT || 5432),
  user: process.env.PG_USER || 'cmds_admin',
  password: process.env.PG_PASS || 'CmdsPostgres2026!',
  database: process.env.PG_DB || 'bd_cmds_admin',
  max: 15,
  idleTimeoutMillis: 30000
};

const pgPool = new Pool(PG_CONFIG);

pgPool.on('error', (err) => {
  console.error('[PostgreSQL Pool Error]:', err.message);
});

/**
 * Translate Oracle SQL constructs used in server.js to native PostgreSQL 18 SQL.
 */
function translateOracleToPostgres(sqlText) {
  let q = String(sqlText || '').trim();
  if (q.endsWith(';')) q = q.slice(0, -1).trim();

  // 1. V$VERSION health check
  if (/V\$VERSION/i.test(q)) {
    return 'SELECT version() AS banner';
  }

  // 2. NVL(a, b) -> COALESCE(a, b)
  q = q.replace(/\bNVL\s*\(/gi, 'COALESCE(');

  // 3. DBMS_LOB.SUBSTR(col, len, pos) -> SUBSTR(col::text, pos, len)
  q = q.replace(
    /\bDBMS_LOB\.SUBSTR\s*\(\s*([^,]+?)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/gi,
    'SUBSTR($1::text, $3, $2)'
  );

  // 4. Outer wrapper: SELECT * FROM ( ... ) WHERE ROWNUM <= N -> SELECT * FROM ( ... ) AS _subq LIMIT N
  q = q.replace(/\)\s*WHERE\s+ROWNUM\s*<=\s*(\d+)\s*$/i, ') AS _subq LIMIT $1');

  // 5. Direct WHERE ROWNUM <= N -> LIMIT N
  q = q.replace(/\bWHERE\s+ROWNUM\s*<=\s*(\d+)/gi, 'LIMIT $1');
  q = q.replace(/\bAND\s+ROWNUM\s*<=\s*(\d+)/gi, 'LIMIT $1');

  // 6. Remove FROM DUAL
  q = q.replace(/\s+FROM\s+DUAL\b/gi, '');

  return q;
}

function normalizeRowsToUppercase(rows) {
  if (!rows || !Array.isArray(rows)) return [];
  return rows.map((row) => {
    const out = {};
    for (const [k, v] of Object.entries(row)) {
      out[k.toUpperCase()] = v === null || v === undefined ? '' : v;
    }
    return out;
  });
}

const queryCache = new Map();

async function queryOracle(sqlText, ttlMs = 0) {
  if (ttlMs > 0) {
    const cached = queryCache.get(sqlText);
    if (cached && Date.now() - cached.ts < ttlMs) {
      return cached.data;
    }
  }
  const pgSql = translateOracleToPostgres(sqlText);
  const res = await pgPool.query(pgSql);
  const rows = normalizeRowsToUppercase(res.rows);
  if (ttlMs > 0 && rows.length > 0) {
    queryCache.set(sqlText, { ts: Date.now(), data: rows });
  }
  return rows;
}

async function queryOracleBatch(namedQueries, cacheKey = null, ttlMs = 0) {
  if (cacheKey && ttlMs > 0) {
    const cached = queryCache.get(cacheKey);
    if (cached && Date.now() - cached.ts < ttlMs) {
      return cached.data;
    }
  }
  const entries = Object.entries(namedQueries);
  const results = await Promise.all(
    entries.map(async ([name, q]) => {
      const rows = await queryOracle(q, 0);
      return [name, rows];
    })
  );
  const data = Object.fromEntries(entries.map((_, i) => results[i]));
  if (cacheKey && ttlMs > 0) {
    queryCache.set(cacheKey, { ts: Date.now(), data });
  }
  return data;
}

async function execPostgres(sqlText, params = []) {
  const res = await pgPool.query(sqlText, params);
  invalidateCache();
  return res;
}

function invalidateCache(prefix = '') {
  if (!prefix) {
    queryCache.clear();
    return;
  }
  for (const key of queryCache.keys()) {
    if (key.startsWith(prefix)) queryCache.delete(key);
  }
}

function isSnapshotMode() {
  return false; // Running 100% live on PostgreSQL 18 (192.168.30.48:5432 / bd_cmds_admin)
}

const OVERLAY_FILE = path.join(__dirname, 'data', 'local_mutations.json');

function loadOverlay() {
  try {
    if (!fs.existsSync(OVERLAY_FILE)) {
      return {
        boletasCreated: [],
        boletasEstadoUpdates: {},
        flujoEstadosAdded: [],
        evidenciasUpdates: {},
        evidenciasLogsAdded: [],
        funcionariosCreated: [],
        mantenedorCreated: {}
      };
    }
    return JSON.parse(fs.readFileSync(OVERLAY_FILE, 'utf8'));
  } catch {
    return {
      boletasCreated: [],
      boletasEstadoUpdates: {},
      flujoEstadosAdded: [],
      evidenciasUpdates: {},
      evidenciasLogsAdded: [],
      funcionariosCreated: [],
      mantenedorCreated: {}
    };
  }
}

function saveOverlay(data) {
  const dir = path.dirname(OVERLAY_FILE);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(OVERLAY_FILE, JSON.stringify(data, null, 2), 'utf8');
}

function sqlStr(val) {
  if (val === null || val === undefined) return 'NULL';
  return `'${String(val).replace(/'/g, "''")}'`;
}

module.exports = {
  pgPool,
  queryOracle,
  queryOracleBatch,
  execPostgres,
  invalidateCache,
  isSnapshotMode,
  loadOverlay,
  saveOverlay,
  sqlStr
};
