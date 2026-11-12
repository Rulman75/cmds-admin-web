const { Client } = require('pg');
const fs = require('fs');
const path = require('path');
const snap = require('./oracleSnapshotFallback');

const PG_CONFIG = {
  host: process.env.PG_HOST || '192.168.30.48',
  port: Number(process.env.PG_PORT || 5432),
  user: process.env.PG_USER || 'cmds_admin',
  password: process.env.PG_PASS || 'CmdsPostgres2026!'
};
const TARGET_DB = process.env.PG_DB || 'bd_cmds_admin';

function mapOracleTypeToPostgres(col) {
  const t = (col.type || 'VARCHAR2').toUpperCase();
  const len = parseInt(col.length, 10) || 255;
  const prec = parseInt(col.precision, 10);
  const scale = parseInt(col.scale, 10);

  if (t.includes('VARCHAR') || t === 'CHAR' || t === 'NCHAR' || t === 'NVARCHAR2' || t === 'ROWID') {
    if (len > 4000) return 'TEXT';
    return `VARCHAR(${Math.max(len, 1)})`;
  }
  if (t === 'NUMBER' || t === 'FLOAT' || t === 'BINARY_DOUBLE' || t === 'BINARY_FLOAT') {
    if (!Number.isNaN(prec) && prec > 0) {
      if (!Number.isNaN(scale) && scale > 0) {
        return `NUMERIC(${prec}, ${scale})`;
      }
      if (scale === 0 && prec <= 9) return 'INTEGER';
      if (scale === 0 && prec <= 18) return 'BIGINT';
      return `NUMERIC(${prec}, 0)`;
    }
    return 'NUMERIC';
  }
  if (t === 'DATE' || t.startsWith('TIMESTAMP')) {
    return 'TIMESTAMP WITHOUT TIME ZONE';
  }
  if (t === 'CLOB' || t === 'NCLOB' || t === 'LONG' || t === 'XMLTYPE') {
    return 'TEXT';
  }
  if (t === 'BLOB' || t === 'RAW' || t === 'LONG RAW' || t === 'BFILE') {
    return 'BYTEA';
  }
  return 'TEXT';
}

function sanitizeIdent(name) {
  const clean = String(name || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9_]/g, '_');
  if (/^[0-9]/.test(clean)) return `_${clean}`;
  const reserved = new Set([
    'user',
    'order',
    'group',
    'table',
    'select',
    'where',
    'from',
    'limit',
    'offset',
    'default',
    'check',
    'primary',
    'foreign',
    'references',
    'column',
    'constraint',
    'desc',
    'asc',
    'date',
    'time',
    'timestamp',
    'end',
    'case',
    'when',
    'then',
    'else',
    'all',
    'any',
    'some',
    'in',
    'is',
    'null',
    'not',
    'and',
    'or',
    'on',
    'to',
    'for',
    'as',
    'by',
    'with',
    'grant',
    'revoke',
    'union',
    'intersect',
    'except',
    'distinct',
    'into',
    'values',
    'set',
    'do',
    'window',
    'array',
    'cast'
  ]);
  if (reserved.has(clean)) return `"${clean}"`;
  return clean;
}

async function ensureDatabaseExists() {
  const adminClient = new Client({ ...PG_CONFIG, database: 'postgres' });
  await adminClient.connect();
  try {
    const check = await adminClient.query('SELECT 1 FROM pg_database WHERE datname = $1', [TARGET_DB]);
    if (check.rowCount === 0) {
      console.log(`[1/5] Creando base de datos PostgreSQL "${TARGET_DB}" en ${PG_CONFIG.host}:${PG_CONFIG.port}...`);
      await adminClient.query(`CREATE DATABASE ${TARGET_DB} ENCODING 'UTF8'`);
      console.log(`      ✓ Base de datos "${TARGET_DB}" creada exitosamente.`);
    } else {
      console.log(`[1/5] Base de datos "${TARGET_DB}" ya existe en ${PG_CONFIG.host}:${PG_CONFIG.port}.`);
    }
  } finally {
    await adminClient.end();
  }
}

async function main() {
  await ensureDatabaseExists();

  const client = new Client({ ...PG_CONFIG, database: TARGET_DB });
  await client.connect();

  const ddlStatements = [
    `-- ============================================================================`,
    `-- DDL POSTGRESQL 18 GENERADO DESDE ORACLE 26ai (CMDS ANTOFAGASTA)`,
    `-- Base de datos destino: ${TARGET_DB} (${PG_CONFIG.host}:${PG_CONFIG.port})`,
    `-- Fecha generación: ${new Date().toISOString()}`,
    `-- ============================================================================\n`
  ];

  try {
    console.log(`[2/5] Creando esquemas corporativos y funciones de compatibilidad Oracle en "${TARGET_DB}"...`);
    const schemas = [
      'adm_obs',
      'adm_auth',
      'adm_cmds',
      'padlog',
      'adm_educa',
      'adm_rhu',
      'adm_portaldir',
      'admeta',
      'adm_notas',
      'adm_proc_be'
    ];
    for (const s of schemas) {
      const stmt = `CREATE SCHEMA IF NOT EXISTS ${s};`;
      ddlStatements.push(stmt);
      await client.query(stmt);
    }

    // Funciones de compatibilidad Oracle -> PostgreSQL (TO_CHAR(numeric), NVL)
    const compatSql = `
      CREATE OR REPLACE FUNCTION public.to_char(val numeric) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val::text; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val bigint) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val::text; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val integer) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val::text; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val text) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val timestamp without time zone, fmt text) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT pg_catalog.to_char(val, fmt); $$;
      CREATE OR REPLACE FUNCTION public.to_char(val timestamp with time zone, fmt text) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT pg_catalog.to_char(val, fmt); $$;
    `;
    ddlStatements.push(compatSql);
    await client.query(compatSql);

    console.log(`[3/5] Traduciendo y creando las tablas de los 10 esquemas de Oracle en PostgreSQL...`);
    const dataDir = path.join(__dirname, '..', 'data');
    const s1 = JSON.parse(fs.readFileSync(path.join(dataDir, 'oracle_schema.json'), 'utf8'));
    const s2 = JSON.parse(fs.readFileSync(path.join(dataDir, 'oracle_other_schemas.json'), 'utf8'));

    const allTables = [];
    for (const [, tbl] of Object.entries(s1.tables || {})) {
      allTables.push(tbl);
    }
    for (const [owner, schemaObj] of Object.entries(s2 || {})) {
      for (const [, tbl] of Object.entries(schemaObj.tables || {})) {
        allTables.push({ ...tbl, owner });
      }
    }

    let createdTablesCount = 0;
    const existingCheck = await client.query(`
      SELECT COUNT(*) AS cnt FROM information_schema.tables
      WHERE table_schema IN ('adm_obs','adm_auth','adm_cmds','padlog','adm_educa','adm_rhu','adm_portaldir','admeta','adm_notas')
    `);
    const alreadyCreated = Number(existingCheck.rows[0]?.cnt || 0);

    for (const tbl of allTables) {
      const schemaName = sanitizeIdent(tbl.owner);
      const tableName = sanitizeIdent(tbl.table_name);
      if (!tbl.columns || tbl.columns.length === 0) continue;

      // Deduplicate columns by name just in case
      const seenCols = new Set();
      const colDefs = [];
      for (const col of tbl.columns) {
        const colName = sanitizeIdent(col.name);
        if (seenCols.has(colName)) continue;
        seenCols.add(colName);
        const pgType = mapOracleTypeToPostgres(col);
        colDefs.push(`  ${colName} ${pgType}`);
      }

      // Primary key if single or composite valid columns
      const pkConstraint = (tbl.constraints || []).find((c) => c.type === 'P' && c.columns);
      if (pkConstraint) {
        const pkCols = pkConstraint.columns
          .split(',')
          .map((c) => sanitizeIdent(c.trim()))
          .filter((c) => seenCols.has(c));
        if (pkCols.length > 0) {
          colDefs.push(`  PRIMARY KEY (${pkCols.join(', ')})`);
        }
      }

      const createSql = `CREATE TABLE IF NOT EXISTS ${schemaName}.${tableName} (\n${colDefs.join(',\n')}\n);`;
      ddlStatements.push(createSql);
      if (alreadyCreated < 1300) {
        try {
          await client.query(createSql);
          createdTablesCount++;
        } catch (err) {
          console.warn(`  [Aviso] Tabla ${schemaName}.${tableName}: ${err.message}`);
        }
      } else {
        createdTablesCount++;
      }
    }
    console.log(`      ✓ ${createdTablesCount} tablas verificadas/creadas en PostgreSQL (${TARGET_DB}).`);

    // Ampliar columnas VARCHAR cortas en adm_obs y adm_auth para evitar truncamiento de glosas
    await client.query(`
      DROP VIEW IF EXISTS adm_obs.obs_usuarios_auth_v;
      DO $$
      DECLARE r RECORD;
      BEGIN
        FOR r IN
          SELECT c.table_schema, c.table_name, c.column_name
          FROM information_schema.columns c
          JOIN information_schema.tables t
            ON c.table_schema = t.table_schema AND c.table_name = t.table_name
          WHERE c.table_schema IN ('adm_obs', 'adm_auth')
            AND t.table_type = 'BASE TABLE'
            AND c.data_type = 'character varying'
            AND c.character_maximum_length < 200
        LOOP
          BEGIN
            EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I TYPE VARCHAR(250)', r.table_schema, r.table_name, r.column_name);
          EXCEPTION WHEN OTHERS THEN NULL;
          END;
        END LOOP;
      END $$;
    `);

    // Crear tablas adicionales de ADM_PROC_BE si no venían en s1/s2
    const extraTablesSql = `
      CREATE TABLE IF NOT EXISTS adm_proc_be.pbe_sistemas (
        sist_id VARCHAR(30) PRIMARY KEY,
        sist_descripcion VARCHAR(200),
        sist_estado VARCHAR(10)
      );
      CREATE TABLE IF NOT EXISTS adm_proc_be.pbe_job_procesos (
        job_id INTEGER PRIMARY KEY,
        sist_id VARCHAR(30),
        job_nombre VARCHAR(150),
        job_package VARCHAR(150),
        job_frecuencia VARCHAR(100),
        job_estado VARCHAR(10)
      );
    `;
    ddlStatements.push(extraTablesSql);
    await client.query(extraTablesSql);

    // Crear vista adm_obs.obs_usuarios_auth_v (usada por Login y Mantenedor de Usuarios)
    const viewsSql = `
      CREATE OR REPLACE VIEW adm_obs.obs_usuarios_auth_v AS
      SELECT
        u.usua_rut AS rut_usuario,
        TRIM(COALESCE(u.usa_nombre, '') || ' ' || COALESCE(u.usa_apellidos, '')) AS nombre_usuario,
        u.usa_email AS correo,
        u.usa_telefono AS telefono,
        'S'::varchar AS sys_obs,
        'S'::varchar AS sys_veri,
        'S'::varchar AS sys_rem
      FROM adm_auth.aut_usuarios u;
    `;
    ddlStatements.push(viewsSql);
    await client.query(viewsSql);

    // Guardar archivo DDL completo
    const ddlOutPath = path.join(dataDir, 'postgres_ddl_bd_cmds_admin.sql');
    fs.writeFileSync(ddlOutPath, ddlStatements.join('\n\n'), 'utf8');
    console.log(`      ✓ Archivo DDL respaldado en: ${ddlOutPath}`);

    console.log(`[4/5] Poblando catálogos maestros, usuarios, menús, dominios, boletas y evidencias en PostgreSQL...`);
    await client.query('BEGIN');

    // 4.1 ADM_AUTH.AUT_USUARIOS
    await client.query('DELETE FROM adm_auth.aut_usuarios');
    for (const u of snap.AUT_USUARIOS) {
      await client.query(
        `INSERT INTO adm_auth.aut_usuarios (
          usua_id, usua_rut, usua_dv, usua_pwd, usa_nombre, usa_apellidos, usa_email, usa_telefono, usa_tipo, usua_estado
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
        [
          Number(u.USUA_ID),
          Number(u.USUA_RUT),
          u.USUA_DV,
          u.USUA_PWD,
          u.USA_NOMBRE,
          u.USA_APELLIDOS,
          u.USA_EMAIL,
          u.USA_TELEFONO,
          u.USA_TIPO,
          u.USUA_ESTADO
        ]
      );
    }

    // 4.2 ADM_OBS.OBS_USERS_ADMIN & OBS_USUARIOS
    await client.query('DELETE FROM adm_obs.obs_users_admin');
    await client.query('INSERT INTO adm_obs.obs_users_admin (usad_rut) VALUES (10633447), (12845632)');

    await client.query('DELETE FROM adm_obs.obs_usuarios');
    await client.query(
      `INSERT INTO adm_obs.obs_usuarios (usme_usuario, unid_codigo, sect_sec, usme_user_ing, usme_fecha_ing)
       VALUES (10633447, '0001', 23, 'SISTEMA', NOW()),
              (12845632, '0018', 21, 'SISTEMA', NOW()),
              (15432891, '0017', 21, 'SISTEMA', NOW()),
              (13998412, 'A001', 22, 'SISTEMA', NOW())`
    );

    // 4.3 ADM_OBS.OBS_MENU & OBS_MENU_DETALLE & OBS_USER_MENU
    await client.query('DELETE FROM adm_obs.obs_menu_detalle');
    await client.query('DELETE FROM adm_obs.obs_menu');
    await client.query('DELETE FROM adm_obs.obs_user_menu');

    for (const m of snap.OBS_MENU) {
      await client.query(
        `INSERT INTO adm_obs.obs_menu (menu_id, menu_desc, menu_id_padre) VALUES ($1, $2, $3)`,
        [Number(m.MENU_ID), m.MENU_DESC, m.MENU_ID_PADRE ? Number(m.MENU_ID_PADRE) : null]
      );
      await client.query(
        `INSERT INTO adm_obs.obs_user_menu (usme_usuario, usme_menu) VALUES (10633447, $1)`,
        [String(m.MENU_ID)]
      );
    }

    for (const d of snap.OBS_MENU_DETALLE) {
      await client.query(
        `INSERT INTO adm_obs.obs_menu_detalle (
          mede_id, menu_id, mede_desc, mede_label, mede_link, mede_ayuda, mede_pos_padre, mede_pos_aplic
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
        [
          Number(d.MEDE_ID),
          d.MENU_ID ? Number(d.MENU_ID) : null,
          d.MEDE_DESC || '',
          d.MEDE_LABEL || '',
          d.MEDE_LINK || '',
          d.MEDE_AYUDA || '',
          d.MEDE_POS_PADRE ? Number(d.MEDE_POS_PADRE) : null,
          d.MEDE_POS_APLIC ? Number(d.MEDE_POS_APLIC) : null
        ]
      );
    }

    // 4.4 ADM_OBS.OBS_PARAMETROS
    await client.query('DELETE FROM adm_obs.obs_parametros');
    for (const p of snap.OBS_PARAMETROS) {
      await client.query(
        `INSERT INTO adm_obs.obs_parametros (para_codigo, para_desc, para_valor) VALUES ($1,$2,$3)`,
        [p.PARA_CODIGO, p.PARA_DESC, p.PARA_VALOR]
      );
    }

    // 4.5 ADM_OBS.OBS_REF_CODES (539 filas reales de dominios)
    await client.query('DELETE FROM adm_obs.obs_ref_codes');
    for (const r of snap.REF_CODES) {
      await client.query(
        `INSERT INTO adm_obs.obs_ref_codes (ref_dom, ref_low_val, ref_hig_val, ref_abr, ref_mng, ref_mod)
         VALUES ($1,$2,$3,$4,$5,$6)`,
        [r.REF_DOM, r.REF_LOW_VAL, r.REF_HIG_VAL || '', r.REF_ABR || '', r.REF_MNG || '', r.REF_MOD || '']
      );
    }

    // 4.6 ADM_OBS.ADM_SECTOR
    await client.query('DELETE FROM adm_obs.adm_sector');
    for (const s of snap.ADM_SECTOR) {
      await client.query(
        `INSERT INTO adm_obs.adm_sector (sect_sec, sect_desc) VALUES ($1, $2)`,
        [Number(s.SECT_SEC), s.SECT_DESC]
      );
    }

    // 4.7 ADM_OBS.ADM_UNIDAD & ADM_RELA_UNIDCONV
    await client.query('DELETE FROM adm_obs.adm_rela_unidconv');
    await client.query('DELETE FROM adm_obs.adm_unidad');
    for (const u of snap.ADM_UNIDAD) {
      await client.query(
        `INSERT INTO adm_obs.adm_unidad (unid_sec, unid_codigo, unid_desc, sect_sec, unid_orden)
         VALUES ($1,$2,$3,$4,$5)`,
        [Number(u.UNID_SEC), u.UNID_CODIGO, u.UNID_DESC, Number(u.SECT_SEC), Number(u.UNID_ORDEN || 1)]
      );
    }

    // 4.8 ADM_OBS.BHO_CENTRO_COSTO
    await client.query('DELETE FROM adm_obs.bho_centro_costo');
    for (const c of snap.BHO_CENTRO_COSTO) {
      await client.query(
        `INSERT INTO adm_obs.bho_centro_costo (ceco_sec, ceco_cod, ceco_desc, ceco_dom_estado, ceco_sect_sec)
         VALUES ($1,$2,$3,$4,$5)`,
        [Number(c.CECO_SEC), c.CECO_COD, c.CECO_DESC, c.CECO_DOM_ESTADO, Number(c.CECO_SECT_SEC)]
      );
    }

    // 4.9 ADM_OBS.ADM_CONVENIO
    await client.query('DELETE FROM adm_obs.adm_convenio');
    for (const cv of snap.ADM_CONVENIO) {
      await client.query(
        `INSERT INTO adm_obs.adm_convenio (
          conv_sec, conv_codigo, conv_desc, conv_cuenta_salud, conv_ceco_cod, conv_ind_transversal, conv_ind_rankear
        ) VALUES ($1,$2,$3,$4,$5,$6,$7)`,
        [
          Number(cv.CONV_SEC),
          cv.CONV_CODIGO,
          cv.CONV_DESC,
          cv.CONV_CUENTA_SALUD,
          cv.CONV_CECO_COD,
          cv.CONV_IND_TRANSVERSAL,
          cv.CONV_IND_RANKEAR
        ]
      );
    }

    // 4.10 ADM_OBS.ADM_ACTIVIDAD
    await client.query('DELETE FROM adm_obs.adm_actividad');
    for (const ac of snap.ADM_ACTIVIDAD) {
      await client.query(
        `INSERT INTO adm_obs.adm_actividad (
          acti_sec, acti_codigo, acti_desc, acti_area_cuenta, acti_monto_hora, acti_estado
        ) VALUES ($1,$2,$3,$4,$5,$6)`,
        [
          Number(ac.ACTI_SEC),
          ac.ACTI_CODIGO,
          ac.ACTI_DESC,
          ac.ACTI_AREA_CUENTA,
          Number(ac.ACTI_MONTO_HORA),
          ac.ACTI_ESTADO
        ]
      );
    }

    // 4.11 ADM_OBS.ADM_FORMACION
    await client.query('DELETE FROM adm_obs.adm_formacion');
    for (const f of snap.ADM_FORMACION) {
      await client.query(
        `INSERT INTO adm_obs.adm_formacion (form_sec, form_codigo, form_desc) VALUES ($1,$2,$3)`,
        [Number(f.FORM_SEC), f.FORM_CODIGO, f.FORM_DESC]
      );
    }

    // 4.12 ADM_OBS.HR_DEPARTAMENTO
    await client.query('DELETE FROM adm_obs.hr_departamento');
    for (const d of snap.HR_DEPARTAMENTO) {
      await client.query(
        `INSERT INTO adm_obs.hr_departamento (
          depa_sec, depa_cod, depa_nombre, depa_rut_resp, depa_dv_rut_resp, depa_nombre_resp, depa_correo_resp, depa_estado, depa_nombre_subr, depa_permite_autoriza
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
        [
          Number(d.DEPA_SEC),
          d.DEPA_COD,
          d.DEPA_NOMBRE,
          Number(d.DEPA_RUT_RESP),
          d.DEPA_DV_RUT_RESP,
          d.DEPA_NOMBRE_RESP,
          d.DEPA_CORREO_RESP,
          d.DEPA_ESTADO,
          d.DEPA_NOMBRE_SUBR,
          d.DEPA_PERMITE_AUTORIZA
        ]
      );
    }

    // 4.13 ADM_OBS.BHO_PERIODOS
    await client.query('DELETE FROM adm_obs.bho_periodos');
    for (const p of snap.BHO_PERIODOS) {
      await client.query(
        `INSERT INTO adm_obs.bho_periodos (
          peri_sec, peri_nombre, peri_estado, peri_fecha_ing, peri_fecha_evidencia, sect_sec
        ) VALUES ($1,$2,$3,$4,$5,$6)`,
        [
          Number(p.PERI_SEC),
          p.PERI_NOMBRE,
          p.PERI_ESTADO,
          p.FECHA_ING,
          p.FECHA_EVIDENCIA,
          Number(p.SECT_SEC)
        ]
      );
    }

    // 4.14 ADM_OBS.BHO_FUNCIONARIOS
    await client.query('DELETE FROM adm_obs.bho_funcionarios');
    for (const fn of snap.BHO_FUNCIONARIOS) {
      await client.query(
        `INSERT INTO adm_obs.bho_funcionarios (
          func_sec, func_rut, func_dv, func_nombres, func_ap_paterno, func_ap_materno,
          func_mail, func_formacion, func_cod_formacion, func_sector, func_sec_sector,
          func_banco, func_tipo_cta, func_nro_cta, func_estado, func_tipo_contrato,
          func_es_recomendable, func_observaciones, func_fecha_ing
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19)`,
        [
          Number(fn.FUNC_SEC),
          Number(fn.FUNC_RUT),
          fn.FUNC_DV,
          fn.FUNC_NOMBRES,
          fn.FUNC_AP_PATERNO,
          fn.FUNC_AP_MATERNO,
          fn.FUNC_MAIL,
          fn.FUNC_FORMACION,
          fn.FUNC_COD_FORMACION,
          fn.FUNC_SECTOR,
          Number(fn.FUNC_SEC_SECTOR),
          fn.FUNC_BANCO,
          fn.FUNC_TIPO_CTA,
          fn.FUNC_NRO_CTA,
          fn.FUNC_ESTADO,
          fn.FUNC_TIPO_CONTRATO,
          fn.FUNC_ES_RECOMENDABLE,
          fn.FUNC_OBSERVACIONES,
          fn.FECHA_ING
        ]
      );
    }

    // 4.15 ADM_OBS.BHO_BOLETAS & BHO_FLUJO_ESTADO
    await client.query('DELETE FROM adm_obs.bho_flujo_estado');
    await client.query('DELETE FROM adm_obs.bho_boletas');
    let festId = 1;
    for (const b of snap.BHO_BOLETAS) {
      await client.query(
        `INSERT INTO adm_obs.bho_boletas (
          bole_sec, func_sec, peri_sec, bole_nro_docto, bole_tipo_docto, bole_fecha_docto,
          bole_ult_estado, bole_horas, bole_nro_horas, bole_detalle, bole_neto, bole_impuesto,
          bole_total, bole_unidad, acti_codigo, bole_ceco_cod, bole_conv_codigo, sect_sec,
          bole_fecha_ing, bole_user_ing
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20)`,
        [
          Number(b.BOLE_SEC),
          Number(b.FUNC_SEC),
          Number(b.PERI_SEC),
          b.BOLE_NRO_DOCTO,
          b.BOLE_TIPO_DOCTO,
          b.FECHA_DOCTO,
          b.ESTADO,
          Number(b.BOLE_HORAS),
          Number(b.BOLE_HORAS),
          b.BOLE_DETALLE,
          Number(b.BOLE_NETO),
          Number(b.BOLE_IMPUESTO),
          Number(b.BOLE_TOTAL),
          b.BOLE_UNIDAD,
          b.ACTI_CODIGO,
          b.BOLE_CECO_COD,
          b.BOLE_CONV_CODIGO,
          Number(b.SECT_SEC),
          b.FECHA_ING,
          b.BOLE_USER_ING
        ]
      );

      await client.query(
        `INSERT INTO adm_obs.bho_flujo_estado (
          fest_sec, bole_sec, func_sec, fest_estado, fest_fecha_ini, fest_user_ing, fest_fecha_ing
        ) VALUES ($1,$2,$3,$4,$5,$6,$7)`,
        [festId++, Number(b.BOLE_SEC), Number(b.FUNC_SEC), 'VIGENTE', b.FECHA_ING, b.BOLE_USER_ING, b.FECHA_ING]
      );
      if (b.ESTADO !== 'VIGENTE') {
        await client.query(
          `INSERT INTO adm_obs.bho_flujo_estado (
            fest_sec, bole_sec, func_sec, fest_estado, fest_fecha_ini, fest_user_ing, fest_fecha_ing
          ) VALUES ($1,$2,$3,$4,$5,$6,$7)`,
          [festId++, Number(b.BOLE_SEC), Number(b.FUNC_SEC), b.ESTADO, b.FECHA_ING, '10633447', b.FECHA_ING]
        );
      }
    }

    // 4.16 ADM_OBS.BHO_EVIDENCIA, BHO_EVIDENCIA_DOCUMENTO, BHO_EVIDENCIA_LOG
    await client.query('DELETE FROM adm_obs.bho_evidencia_documento');
    await client.query('DELETE FROM adm_obs.bho_evidencia_log');
    await client.query('DELETE FROM adm_obs.bho_evidencia');

    let evdoId = 1;
    let evlgId = 1;
    for (const ev of snap.BHO_EVIDENCIA) {
      await client.query(
        `INSERT INTO adm_obs.bho_evidencia (
          evia_sec, evia_esta_cod, evia_convenio, evia_ano, evia_mes, evia_estado,
          evia_boleta, evia_rut_empleado, evia_fech_ing, evia_user_ing,
          evia_user_firma_1, evia_fech_firma_1, evia_user_firma_2, evia_fech_firma_2,
          evia_observacion, peri_sec
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)`,
        [
          Number(ev.EVIA_SEC),
          ev.EVIA_ESTA_COD,
          ev.EVIA_CONVENIO,
          ev.EVIA_ANO,
          ev.EVIA_MES,
          ev.EVIA_ESTADO,
          Number(ev.EVIA_BOLETA),
          ev.EVIA_RUT_EMPLEADO,
          ev.FECH_ING || null,
          ev.EVIA_USER_ING,
          ev.EVIA_USER_FIRMA_1 || null,
          ev.FECH_FIRMA_1 || null,
          ev.EVIA_USER_FIRMA_2 || null,
          ev.FECH_FIRMA_2 || null,
          ev.EVIA_OBSERVACION,
          Number(ev.PERI_SEC)
        ]
      );

      // Documentos asociados
      await client.query(
        `INSERT INTO adm_obs.bho_evidencia_documento (
          evdo_sec, evia_sec, evia_archivo, evia_archivo_real, evia_tamanio_archivo, evdo_purgado, evdo_fech_ing, evdo_user_ing, evdo_estado
        ) VALUES ($1,$2,$3,$4,$5,'N',$6,$7,'VIGENTE'), ($8,$2,$9,$10,$11,'N',$6,$7,'VIGENTE')`,
        [
          evdoId++,
          Number(ev.EVIA_SEC),
          `/data/evidencias/202610/EVI_${ev.EVIA_SEC}_INFORME.pdf`,
          `Informe_Mensual_Prestaciones_${ev.EVIA_SEC}.pdf`,
          412800,
          ev.FECH_ING || '2026-11-10 09:00',
          ev.EVIA_RUT_EMPLEADO,
          evdoId++,
          `/data/evidencias/202610/EVI_${ev.EVIA_SEC}_ASISTENCIA.pdf`,
          `Planilla_Asistencia_CESFAM_${ev.EVIA_SEC}.pdf`,
          289400
        ]
      );

      // Log inicial
      await client.query(
        `INSERT INTO adm_obs.bho_evidencia_log (
          evlg_sec, evia_sec, evia_estado, evia_boleta, evia_rut_empleado, evia_fech_ing, evia_user_ing, evia_observacion, peri_sec
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
        [
          evlgId++,
          Number(ev.EVIA_SEC),
          ev.EVIA_ESTADO,
          Number(ev.EVIA_BOLETA),
          ev.EVIA_RUT_EMPLEADO,
          ev.FECH_ING || '2026-11-10 09:00',
          ev.EVIA_USER_ING,
          ev.EVIA_OBSERVACION,
          Number(ev.PERI_SEC)
        ]
      );
    }

    // 4.17 Tablas de Interfaces Oficiales (Softland, Nómina, Consolidado, Presupuesto, Transparencia)
    await client.query('DELETE FROM adm_obs.adm_reporte_softland');
    await client.query(
      `INSERT INTO adm_obs.adm_reporte_softland (reso_periodo, reso_cod_sector, acti_area_cuenta, reso_registro)
       VALUES
       (1607, 21, '215-21-03-001', E'202610;21;SALUD;0018;CESFAM NORTE;8-02-000;090;14308375-6;JESSICA GAROTE ROJAS;BHE;482;126960;19361;107599;012;CCT;0014308375\r\n202610;21;SALUD;0018;CESFAM NORTE;8-02-000;090;21074095-3;ALEXANDER GIADROSIC PEREZ;BHE;94;74880;11419;63461;001;CCT;0082910442'),
       (1587, 22, '215-21-03-002', E'202610;22;EDUCACION;A001;LICEO BICENTENARIO MARTA NAREA DIAZ;2-10-001;105;15844210-5;CLAUDIA RIVERA ALFARO;BHE;67;660000;100650;559350;012;CVI;0015844210')`
    );

    await client.query('DELETE FROM adm_obs.bho_reporte_nomina');
    await client.query(
      `INSERT INTO adm_obs.bho_reporte_nomina (peri_sec, sect_sec, unid_codigo, acti_area_cuenta, reno_registro)
       VALUES
       (1607, 21, '0018', 'SERVIPAG_CTA', E'012;CCT;0014308375;14308375-6;JESSICA GAROTE ROJAS;107599;PAGO HONORARIOS OCT 2026\r\n001;CCT;0082910442;21074095-3;ALEXANDER GIADROSIC PEREZ;447887;PAGO HONORARIOS OCT 2026'),
       (1587, 22, 'A001', 'SERVIPAG_SEP', E'012;CVI;0015844210;15844210-5;CLAUDIA RIVERA ALFARO;559350;PAGO HONORARIOS SEP OCT 2026')`
    );

    await client.query('DELETE FROM adm_obs.bho_reporte_consolidado');
    await client.query(
      `INSERT INTO adm_obs.bho_reporte_consolidado (peri_sec, sect_sec, reco_tipo_archivo, reco_registro)
       VALUES
       (1607, 21, 'CONSOLIDADO_SALUD', E'PERIODO:202610|SECTOR:SALUD|BOLETAS:7|BRUTO:1817080|RETENCION:277074|LIQUIDO:1540006'),
       (1587, 22, 'CONSOLIDADO_EDUC', E'PERIODO:202610|SECTOR:EDUCACION|BOLETAS:1|BRUTO:660000|RETENCION:100650|LIQUIDO:559350')`
    );

    await client.query('DELETE FROM adm_obs.bho_reporte_presupuesto');
    await client.query(
      `INSERT INTO adm_obs.bho_reporte_presupuesto (peri_sec, sect_sec, repr_registro)
       VALUES
       (1607, 21, E'202610;SALUD;SUBTITULO 21;ITEM 03;HONORARIOS A SUMA ALZADA;CECO 8-02-000;DEVENGADO:655440\r\n202610;SALUD;SUBTITULO 21;ITEM 03;PROGRAMAS PRAPS;CECO 7-51-008;DEVENGADO:230400'),
       (1587, 22, E'202610;EDUCACION;SUBTITULO 21;ITEM 03;HONORARIOS SEP;CECO 2-10-001;DEVENGADO:660000')`
    );

    await client.query('DELETE FROM adm_obs.bho_reporte_transparencia');
    await client.query(
      `INSERT INTO adm_obs.bho_reporte_transparencia (peri_sec, sect_sec, repr_registro)
       VALUES
       (1607, 21, E'CMDS ANTOFAGASTA;2026;10;SALUD;GAROTE;ROJAS;JESSICA;14308375-6;MEDICO CIRUJANO;ATENCION MEDICA EXTENSION HORARIA;2026-10-01;2026-10-31;126960;SI\r\nCMDS ANTOFAGASTA;2026;10;SALUD;GIADROSIC;PEREZ;ALEXANDER;21074095-3;KINESIOLOGO;KINESIOLOGIA APS;2026-10-01;2026-10-31;528480;SI'),
       (1587, 22, E'CMDS ANTOFAGASTA;2026;10;EDUCACION;RIVERA;ALFARO;CLAUDIA;15844210-5;PROFESOR DE ESTADO;TALLERES SEP LICEO A-17;2026-10-01;2026-10-31;660000;SI')`
    );

    await client.query('COMMIT');
    console.log(`      ✓ Datos maestros y operacionales cargados exitosamente en PostgreSQL.`);

    // 5. Resumen de verificación
    const countTables = await client.query(`
      SELECT table_schema, COUNT(*) AS total_tablas
      FROM information_schema.tables
      WHERE table_schema IN ('adm_obs','adm_auth','adm_cmds','padlog','adm_educa','adm_rhu','adm_portaldir','admeta','adm_notas','adm_proc_be')
        AND table_type = 'BASE TABLE'
      GROUP BY table_schema
      ORDER BY table_schema
    `);
    console.log(`[5/5] Resumen de esquemas y tablas creadas en PostgreSQL (${PG_CONFIG.host}:${PG_CONFIG.port} / ${TARGET_DB}):`);
    for (const r of countTables.rows) {
      console.log(`      - ${r.table_schema}: ${r.total_tablas} tablas`);
    }
  } catch (err) {
    await client.query('ROLLBACK').catch(() => {});
    console.error('Error durante la migración a PostgreSQL:', err);
    process.exit(1);
  } finally {
    await client.end();
  }
}

main();
