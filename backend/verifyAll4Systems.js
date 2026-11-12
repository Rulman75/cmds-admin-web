const { Pool } = require('pg');
const http = require('http');

const PG_BASE = {
  host: '192.168.30.48',
  port: 5432,
  user: 'cmds_admin',
  password: 'CmdsPostgres2026!'
};

function httpGet(url) {
  return new Promise((resolve, reject) => {
    const t0 = Date.now();
    http.get(url, (res) => {
      let body = '';
      res.on('data', d => (body += d));
      res.on('end', () => resolve({ status: res.statusCode, ms: Date.now() - t0, body }));
    }).on('error', reject);
  });
}

async function main() {
  // Create performance indexes on bd_cmds_educa and bd_cmds_rhu
  const pEduca = new Pool({ ...PG_BASE, database: 'bd_cmds_educa' });
  const educaIdxs = [
    'CREATE INDEX IF NOT EXISTS idx_edc_ac_grcu ON adm_educa.edc_alumnos_cursos (grcu_sec)',
    'CREATE INDEX IF NOT EXISTS idx_edc_ac_fial ON adm_educa.edc_alumnos_cursos (fial_sec)',
    'CREATE INDEX IF NOT EXISTS idx_edc_fial_pers ON adm_educa.edc_ficha_alumno (pers_sec)',
    'CREATE INDEX IF NOT EXISTS idx_edc_fial_esed ON adm_educa.edc_ficha_alumno (esed_sec)',
    'CREATE INDEX IF NOT EXISTS idx_edc_gc_esed ON adm_educa.edc_grados_cursos (esed_sec, tien_cod)',
    'CREATE INDEX IF NOT EXISTS idx_edc_ca_grcu ON adm_educa.edc_curso_asignatura (grcu_sec)',
    'CREATE INDEX IF NOT EXISTS idx_edc_asbl_fial ON adm_educa.edc_asistencia_bloque (fial_sec)',
    'CREATE INDEX IF NOT EXISTS idx_edc_nacu_fial ON adm_educa.edc_notas_asig_curso (fial_sec)'
  ];
  for (const sql of educaIdxs) await pEduca.query(sql).catch(() => {});
  await pEduca.query('ANALYZE');
  await pEduca.end();

  const pRhu = new Pool({ ...PG_BASE, database: 'bd_cmds_rhu' });
  const rhuIdxs = [
    'CREATE INDEX IF NOT EXISTS idx_rhu_trab_pers ON adm_rhu.rhu_trabajador (pers_sec)',
    'CREATE INDEX IF NOT EXISTS idx_rhu_cont_trab ON adm_rhu.rhu_contrato (trab_sec)',
    'CREATE INDEX IF NOT EXISTS idx_rhu_cmov_cont ON adm_rhu.rhu_contrato_mov (cont_sec)',
    'CREATE INDEX IF NOT EXISTS idx_rhu_lqrt_peri ON adm_rhu.rhu_liqui_resum_trab (peri_cod, trab_sec)'
  ];
  for (const sql of rhuIdxs) await pRhu.query(sql).catch(() => {});
  await pRhu.query('ANALYZE');
  await pRhu.end();

  const dbs = [
    { name: 'bd_cmds_admin', port: 3005, schemas: ['adm_obs', 'adm_auth'] },
    { name: 'bd_cmds_educa', port: 3006, schemas: ['adm_educa', 'adm_notas', 'adm_auth'] },
    { name: 'bd_cmds_rhu', port: 3007, schemas: ['adm_rhu', 'adm_auth'] },
    { name: 'bd_cmds_portaldir', port: 3008, schemas: ['adm_portaldir', 'admeta', 'adm_auth'] }
  ];

  console.log('=== 1. ESTADO FINAL DE LAS 4 BASES DE DATOS EN 192.168.30.48:5432 ===');
  let grandTotalTables = 0;
  let grandPopulatedTables = 0;
  let grandTotalRows = 0;

  for (const d of dbs) {
    const pool = new Pool({ ...PG_BASE, database: d.name });
    const sizeRes = await pool.query(`SELECT pg_size_pretty(pg_database_size('${d.name}')) AS sz`);
    const cntRes = await pool.query(`
      SELECT COUNT(*)::int AS total_tables,
             COUNT(*) FILTER (WHERE n_live_tup > 0)::int AS populated_tables,
             COALESCE(SUM(n_live_tup), 0)::bigint AS total_rows
      FROM pg_stat_user_tables
      WHERE schemaname = ANY($1)
    `, [d.schemas]);
    const r = cntRes.rows[0];
    grandTotalTables += Number(r.total_tables);
    grandPopulatedTables += Number(r.populated_tables);
    grandTotalRows += Number(r.total_rows);
    console.log(
      `  - ${d.name.padEnd(20)} (:${d.port}) | Tablas Totales: ${String(r.total_tables).padStart(3)} | Con Datos: ${String(r.populated_tables).padStart(3)} | Filas: ${Number(r.total_rows).toLocaleString('es-CL').padStart(11)} | Peso: ${sizeRes.rows[0].sz}`
    );
    await pool.end();
  }
  console.log(`  ----------------------------------------------------------------------------------------------------`);
  console.log(`  TOTAL CONSOLIDADO (4 BDs)          | Tablas Totales: ${grandTotalTables} | Con Datos: ${grandPopulatedTables} | Filas: ${grandTotalRows.toLocaleString('es-CL').padStart(11)}`);

  console.log('\n=== 2. PRUEBA DE ENDPOINTS EN VIVO EN LOS 4 PORTALES (3005..3008) ===');
  const checks = [
    'http://localhost:3005/api/health',
    'http://localhost:3005/api/dashboard/inicio-stats',
    'http://localhost:3005/api/boletas?limit=10',
    'http://localhost:3005/api/oficina-partes',
    'http://localhost:3005/api/mercado-publico',
    'http://localhost:3006/api/health',
    'http://localhost:3006/api/dashboard',
    'http://localhost:3006/api/establecimiento-cursos',
    'http://localhost:3006/api/alumnos-matricula',
    'http://localhost:3006/api/libro/asistencia',
    'http://localhost:3006/api/sige',
    'http://localhost:3007/api/health',
    'http://localhost:3007/api/resumen',
    'http://localhost:3007/api/ficha-personal',
    'http://localhost:3007/api/remuneraciones',
    'http://localhost:3007/api/licencias-permisos',
    'http://localhost:3008/api/health',
    'http://localhost:3008/api/resumen',
    'http://localhost:3008/api/asistencia-subvenciones',
    'http://localhost:3008/api/riesgo-desempeno',
    'http://localhost:3008/api/encuestas-admeta'
  ];

  for (const url of checks) {
    const res = await httpGet(url);
    console.log(`  - ${url.padEnd(52)} -> HTTP ${res.status} (${res.ms} ms)`);
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
