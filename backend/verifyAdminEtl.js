const { Pool } = require('pg');
const http = require('http');

const pool = new Pool({
  host: '192.168.30.48',
  port: 5432,
  user: 'cmds_admin',
  password: 'CmdsPostgres2026!',
  database: 'bd_cmds_admin'
});

function httpGet(urlPath) {
  return new Promise((resolve, reject) => {
    const t0 = Date.now();
    http.get(`http://localhost:3005${urlPath}`, (res) => {
      let body = '';
      res.on('data', d => (body += d));
      res.on('end', () => {
        resolve({ status: res.statusCode, ms: Date.now() - t0, body });
      });
    }).on('error', reject);
  });
}

async function main() {
  console.log('1. Ejecutando ANALYZE sobre las 863.902 filas reales en bd_cmds_admin...');
  await pool.query('ANALYZE');

  console.log('2. Probando todos los módulos de CMDS ADMIN (http://localhost:3005) con los datos reales:');
  const endpoints = [
    '/api/health',
    '/api/dashboard/inicio-stats',
    '/api/boletas/filtros',
    '/api/boletas?limit=20',
    '/api/boletas/funcionarios?limit=20',
    '/api/boletas/interfaces',
    '/api/evidencias?limit=20',
    '/api/mantenedor/unidades',
    '/api/oficina-partes',
    '/api/ordenes-servicio',
    '/api/hoja-ruta',
    '/api/obras',
    '/api/mercado-publico',
    '/api/rrhh-aps',
    '/api/agenda-atencion'
  ];

  for (const ep of endpoints) {
    const res = await httpGet(ep);
    let info = '';
    if (res.status !== 200) {
      info = ' -> ' + res.body.slice(0, 160);
    } else {
      try {
        const j = JSON.parse(res.body);
        const keys = Object.keys(j).slice(0, 4).join(', ');
        info = ` [keys: ${keys}]`;
      } catch {}
    }
    console.log(`  - ${ep.padEnd(32)} -> HTTP ${res.status} (${res.ms} ms)${info}`);
  }

  await pool.end();
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
