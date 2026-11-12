const { spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');
require('../../backend/node_modules/dotenv').config({ path: path.join(__dirname, '..', '..', '.env') });

const SQLPLUS_BIN = 'C:\\oracle32\\client\\sqlplus.exe';
const host = process.env.ORACLE_HOST || '186.67.6.133';
const port = process.env.ORACLE_PORT || '9521';
const service = process.env.ORACLE_SERVICE || 'cmdseducaprod.padclprodpriv.vcnpadclprod.oraclevcn.com';
const user = process.env.ORACLE_USER || 'cmds_consultas';
const pass = process.env.ORACLE_PASS || 'Bomberos##4248';

console.log('=== PRUEBA CONTROLADA DE 1 INTENTO A ORACLE 26ai (SIN REINTENTOS) ===');
console.log(`Usuario: ${user} | Host: ${host}:${port} | Largo Clave: ${pass.length} caracteres`);

const dsn = `(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${host})(PORT=${port}))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${service})))`;
// Note: pass in sqlplus command line wrapped in double quotes for ## special chars
const connArg = `${user}/"${pass}"@${dsn}`;

const sqlInput = [
  'WHENEVER LOGONERROR EXIT 99;',
  'SET PAGESIZE 50000',
  'SET FEEDBACK OFF',
  'SET HEADING ON',
  'SET MARKUP CSV ON DELIMITER , QUOTE ON',
  `SELECT OWNER, COUNT(*) AS TABLAS, SUM(NVL(NUM_ROWS,0)) AS FILAS, ROUND(SUM(NVL(BLOCKS,0))*8/1024, 2) AS ORACLE_BLOCKS_MB, ROUND(SUM(NVL(NUM_ROWS,0)*NVL(AVG_ROW_LEN,80))/1024/1024, 2) AS RAW_DATA_MB FROM ALL_TABLES WHERE OWNER IN ('ADM_OBS','ADM_AUTH','ADM_EDUCA','ADM_NOTAS','ADM_RHU','ADM_PORTALDIR','ADMETA') GROUP BY OWNER ORDER BY OWNER;`,
  'EXIT;'
].join('\n');

const res = spawnSync(SQLPLUS_BIN, ['-S', '-L', connArg], {
  input: sqlInput,
  encoding: 'utf8',
  env: { ...process.env, NLS_LANG: 'AMERICAN_AMERICA.AL32UTF8' },
  timeout: 15000
});

console.log('Exit code:', res.status);
if (res.stdout) console.log('STDOUT:\n' + res.stdout.trim());
if (res.stderr) console.log('STDERR:\n' + res.stderr.trim());
