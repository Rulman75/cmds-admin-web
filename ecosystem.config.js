module.exports = {
  apps: [
    {
      name: 'cmds-admin-3005',
      cwd: 'C:/Users/rhormazabal/.gemini/antigravity/scratch/migracion-sistemas-pad/backend',
      script: 'server.js',
      env: {
        NODE_ENV: 'production',
        PORT: 3005,
        PG_HOST: '192.168.30.48',
        PG_PORT: 5432,
        PG_USER: 'cmds_admin',
        PG_PASS: 'CmdsPostgres2026!',
        PG_DB: 'bd_cmds_admin'
      }
    },
    {
      name: 'cmds-educa-3006',
      cwd: 'C:/Users/rhormazabal/.gemini/antigravity/scratch/cmds-educa-web/backend',
      script: 'server.js',
      env: {
        NODE_ENV: 'production',
        PORT: 3006,
        PG_HOST: '192.168.30.48',
        PG_PORT: 5432,
        PG_USER: 'cmds_admin',
        PG_PASS: 'CmdsPostgres2026!',
        PG_DB: 'bd_cmds_educa'
      }
    },
    {
      name: 'cmds-rhu-3007',
      cwd: 'C:/Users/rhormazabal/.gemini/antigravity/scratch/cmds-rhu-web/backend',
      script: 'server.js',
      env: {
        NODE_ENV: 'production',
        PORT: 3007,
        PG_HOST: '192.168.30.48',
        PG_PORT: 5432,
        PG_USER: 'cmds_admin',
        PG_PASS: 'CmdsPostgres2026!',
        PG_DB: 'bd_cmds_rhu'
      }
    },
    {
      name: 'cmds-portaldir-3008',
      cwd: 'C:/Users/rhormazabal/.gemini/antigravity/scratch/cmds-portaldir-web/backend',
      script: 'server.js',
      env: {
        NODE_ENV: 'production',
        PORT: 3008,
        PG_HOST: '192.168.30.48',
        PG_PORT: 5432,
        PG_USER: 'cmds_admin',
        PG_PASS: 'CmdsPostgres2026!',
        PG_DB: 'bd_cmds_portaldir'
      }
    }
  ]
};
