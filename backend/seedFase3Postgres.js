const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.PG_HOST || '192.168.30.48',
  port: Number(process.env.PG_PORT || 5432),
  user: process.env.PG_USER || 'cmds_admin',
  password: process.env.PG_PASS || 'CmdsPostgres2026!',
  database: process.env.PG_DB || 'bd_cmds_admin'
});

async function replaceRow(client, table, keyCol, keyVal, insertSql, params) {
  await client.query(`DELETE FROM adm_obs.${table} WHERE ${keyCol} = $1`, [keyVal]);
  await client.query(insertSql, params);
}

async function seedFase3() {
  const client = await pool.connect();
  try {
    // =========================================================================
    // 1. MÓDULO 9: RRHH APS Y REPOSITORIO REM (REGISTRO, ESTAMIENTO, ESTABLECIMIENTO, CONTRATO, REM)
    // =========================================================================
    console.log('[1/3] Poblando Módulo 9 Fase 3: RRHH APS (adm_obs.establecimiento, estamiento, contrato, registro)...');

    const establecimientos = [
      ['CES-01', 'CESFAM NORTE', '1'],
      ['CES-02', 'CESFAM CORVALLIS', '2'],
      ['CES-03', 'CESFAM CENTRO SUR', '3'],
      ['CES-04', 'CESFAM ORIENTE', '4'],
      ['CES-05', 'CESFAM JUAN PAPIC', '5'],
      ['CES-06', 'CESFAM DRA. MARIA CRISTINA ROJAS', '6'],
      ['CES-07', 'CESFAM DR. ANTONIO RENDIC', '7'],
      ['CES-08', 'CESFAM VALDIVIESO', '8'],
      ['DIR-APS', 'DIRECCION DE SALUD APS CMDS', '9']
    ];
    for (const [cod, nom, ord] of establecimientos) {
      await replaceRow(
        client,
        'establecimiento',
        'esta_cod',
        cod,
        `INSERT INTO adm_obs.establecimiento (esta_cod, esta_nomb, esta_user_ing, esta_fec_ing, esta_col_orden)
         VALUES ($1, $2, '10633447', NOW(), $3)`,
        [cod, nom, ord]
      );
    }

    const estamentos = [
      ['EST-A1', 'MEDICOS CIRUJANOS Y DE FAMILIA', 'CATEGORIA A'],
      ['EST-A2', 'CIRUJANOS DENTISTAS (ODONTOLOGOS)', 'CATEGORIA A'],
      ['EST-A3', 'QUIMICOS FARMACEUTICOS', 'CATEGORIA A'],
      ['EST-B1', 'ENFERMERAS / ENFERMEROS UNIVERSITARIOS', 'CATEGORIA B'],
      ['EST-B2', 'MATRONAS / MATRONES', 'CATEGORIA B'],
      ['EST-B3', 'KINESIOLOGOS Y TERAPEUTAS', 'CATEGORIA B'],
      ['EST-B4', 'PSICOLOGOS Y TRABAJADORES SOCIALES', 'CATEGORIA B'],
      ['EST-B5', 'NUTRICIONISTAS Y TECNOLOGOS MEDICOS', 'CATEGORIA B'],
      ['EST-C1', 'TENS - TECNICOS NIVEL SUPERIOR ENFERMERIA', 'CATEGORIA C'],
      ['EST-C2', 'TECNICOS DE NIVEL SUPERIOR ODONTOLOGIA', 'CATEGORIA C'],
      ['EST-D1', 'ADMINISTRATIVOS DE SALUD (SOME / OIRS)', 'CATEGORIA D'],
      ['EST-E1', 'AUXILIARES DE SERVICIO Y CONDUCTORES AMBULANCIA', 'CATEGORIA E']
    ];
    for (const [cod, nom, cat] of estamentos) {
      await replaceRow(
        client,
        'estamiento',
        'esmi_cod',
        cod,
        `INSERT INTO adm_obs.estamiento (esmi_cod, esmi_nomb, esmi_cate, esmi_user_ing, esmi_fec_ing)
         VALUES ($1, $2, $3, '10633447', NOW())`,
        [cod, nom, cat]
      );
    }

    const contratos = [
      ['CONT-PL', 'PLANTA TITULAR APS (LEY 19.378)'],
      ['CONT-PF', 'CONTRATA PLAZO FIJO APS (LEY 19.378)'],
      ['CONT-HO', 'HONORARIOS CONVENIOS PRAPS'],
      ['CONT-RE', 'REEMPLAZO CONTINUIDAD ATENCION']
    ];
    for (const [cod, nom] of contratos) {
      await replaceRow(
        client,
        'contrato',
        'cont_cod',
        cod,
        `INSERT INTO adm_obs.contrato (cont_cod, cont_nomb, cont_user_ing, cont_fec_ing)
         VALUES ($1, $2, '10633447', NOW())`,
        [cod, nom]
      );
    }

    // Registros de dotación y ausentismo APS por CESFAM y Estamento
    const registrosAps = [
      [9001, '2026-11-10', 'CES-01', 'EST-A1', 'CONT-PL', 24, 20, 2, 1, 1, 0, 24, 0, 0, 0, 'VIGENTE'],
      [9002, '2026-11-10', 'CES-01', 'EST-B1', 'CONT-PL', 32, 27, 2, 2, 1, 0, 32, 1, 0, 0, 'VIGENTE'],
      [9003, '2026-11-10', 'CES-01', 'EST-C1', 'CONT-PF', 48, 41, 3, 3, 1, 0, 48, 1, 0, 0, 'VIGENTE'],
      [9004, '2026-11-10', 'CES-02', 'EST-A1', 'CONT-PL', 21, 18, 1, 1, 0, 1, 21, 0, 0, 0, 'VIGENTE'],
      [9005, '2026-11-10', 'CES-02', 'EST-B1', 'CONT-PL', 29, 25, 2, 2, 0, 0, 29, 0, 0, 0, 'VIGENTE'],
      [9006, '2026-11-10', 'CES-02', 'EST-C1', 'CONT-PL', 44, 38, 2, 3, 1, 0, 44, 0, 0, 0, 'VIGENTE'],
      [9007, '2026-11-10', 'CES-03', 'EST-A2', 'CONT-PF', 14, 12, 1, 1, 0, 0, 14, 0, 0, 0, 'VIGENTE'],
      [9008, '2026-11-10', 'CES-04', 'EST-B2', 'CONT-PL', 18, 16, 1, 1, 0, 0, 18, 0, 0, 0, 'VIGENTE'],
      [9009, '2026-11-10', 'CES-05', 'EST-C1', 'CONT-PF', 39, 34, 2, 2, 1, 0, 39, 0, 0, 0, 'VIGENTE'],
      [9010, '2026-11-10', 'CES-06', 'EST-D1', 'CONT-PL', 22, 19, 1, 1, 1, 0, 22, 0, 1, 0, 'VIGENTE'],
      [9011, '2026-11-10', 'CES-07', 'EST-B3', 'CONT-HO', 16, 15, 0, 1, 0, 0, 16, 0, 0, 2, 'VIGENTE'],
      [9012, '2026-11-10', 'CES-08', 'EST-E1', 'CONT-PL', 15, 14, 1, 0, 0, 0, 15, 0, 0, 0, 'VIGENTE']
    ];
    for (const [sec, fecha, esta, esmi, cont, tot, op, fl, lm, dp, ce, esq, gr, tt, jp, est] of registrosAps) {
      await replaceRow(
        client,
        'registro',
        'regi_sec',
        sec,
        `INSERT INTO adm_obs.registro (
          regi_sec, regi_fecha, esta_cod, esmi_cod, cont_cod,
          regi_total_func, regi_func_o, regi_func_fl, regi_func_lm,
          regi_func_dp, regi_func_ce, regi_fun_esquema_c, regi_fun_grupo_r,
          regi_fun_tt, regi_func_jp_hd, regi_user_ing, regi_fec_ing, regi_estado
        ) VALUES ($1, $2::timestamp, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, '10633447', NOW(), $16)`,
        [sec, fecha, esta, esmi, cont, tot, op, fl, lm, dp, ce, esq, gr, tt, jp, est]
      );
    }

    console.log('[2/3] Poblando Repositorio REM (adm_obs.obs_carpetas_rem, obs_subcarpetas_rem, obs_archivos)...');
    const carpetasRem = [
      [1, 'REM OCTUBRE 2026 - CONSOLIDADO APS', 'ABIERTO'],
      [2, 'REM SEPTIEMBRE 2026 - CERRADO MINSAL', 'CERRADO'],
      [3, 'REM AGOSTO 2026 - CERRADO MINSAL', 'CERRADO'],
      [4, 'REM NOVIEMBRE 2026 - EN RECEPCION CESFAM', 'ABIERTO']
    ];
    for (const [sec, nom, est] of carpetasRem) {
      await replaceRow(
        client,
        'obs_carpetas_rem',
        'care_sec',
        sec,
        `INSERT INTO adm_obs.obs_carpetas_rem (care_sec, care_nombre, care_estado, care_user_ing, care_fecha_ing)
         VALUES ($1, $2, $3, '10633447', NOW())`,
        [sec, nom, est]
      );
    }

    const subcarpetasRem = [
      [1, 'SERIE REM-A (CONSULTAS Y CONTROLES SALUD)', 'ACTIVO'],
      [2, 'SERIE REM-BM (PROCEDIMIENTOS Y APOYO CLINICO)', 'ACTIVO'],
      [3, 'SERIE REM-P (PROGRAMA SALUD POBLACION BAJO CONTROL)', 'ACTIVO'],
      [4, 'SERIE REM-D (ATENCIONES ODONTOLOGICAS)', 'ACTIVO']
    ];
    for (const [sec, nom, est] of subcarpetasRem) {
      await replaceRow(
        client,
        'obs_subcarpetas_rem',
        'sure_sec',
        sec,
        `INSERT INTO adm_obs.obs_subcarpetas_rem (sure_sec, sure_nombre, sure_estado, sure_user_ing, sure_fecha_ing)
         VALUES ($1, $2, $3, '10633447', NOW())`,
        [sec, nom, est]
      );
    }

    const archivosRem = [
      [501, 'REM_A_CESFAM_NORTE_202610.xlsx', 1, 1450, 'VALIDADO ESTADISTICA', '2026-11-04 10:20:00', 'SHA256-98AF12C'],
      [502, 'REM_A_CESFAM_CORVALLIS_202610.xlsx', 1, 1320, 'VALIDADO ESTADISTICA', '2026-11-04 11:45:00', 'SHA256-77BC81E'],
      [503, 'REM_BM_CESFAM_ORIENTE_202610.xlsx', 2, 890, 'VALIDADO ESTADISTICA', '2026-11-05 09:10:00', 'SHA256-41DE90F'],
      [504, 'REM_D_ODONTOLOGIA_JUAN_PAPIC_202610.xlsx', 4, 640, 'EN REVISION', '2026-11-08 16:05:00', 'SHA256-12FA03B'],
      [505, 'REM_P_POBLACION_CONTROL_RENDIC_202610.xlsx', 3, 2110, 'ENVIADO MINSAL', '2026-11-09 12:30:00', 'SHA256-88CC44A']
    ];
    for (const [sec, nom, plan, lineas, est, fCarga, chk] of archivosRem) {
      await replaceRow(
        client,
        'obs_archivos',
        'arch_sec',
        sec,
        `INSERT INTO adm_obs.obs_archivos (arch_sec, arch_nombre, plan_sec, arch_total_lineas, arch_dom_estado_archivo, arch_fec_carga, arch_usr_ing, arch_checksum)
         VALUES ($1, $2, $3, $4, $5, $6::timestamp, '10633447', $7)`,
        [sec, nom, plan, lineas, est, fCarga, chk]
      );
    }

    // =========================================================================
    // 2. MÓDULO 10: AGENDA DE ATENCIÓN Y CAMPAÑAS SALUD (OBS_DATOS_SOLICITUD, SAL_*)
    // =========================================================================
    console.log('[3/3] Poblando Módulo 10 Fase 3: Agenda de Atención y Campañas Salud (adm_obs.obs_datos_solicitud, sal_*)...');
    const bloquesHora = [
      [1, '08:30'],
      [2, '09:00'],
      [3, '09:30'],
      [4, '10:00'],
      [5, '10:30'],
      [6, '11:00'],
      [7, '11:30'],
      [8, '12:00'],
      [9, '15:00'],
      [10, '15:30'],
      [11, '16:00']
    ];
    for (const [nro, hora] of bloquesHora) {
      await replaceRow(
        client,
        'obs_hora_solicitud',
        'daho_nro',
        nro,
        `INSERT INTO adm_obs.obs_hora_solicitud (daho_nro, daho_hora) VALUES ($1, $2)`,
        [nro, hora]
      );
    }

    const solicitudesAgenda = [
      [6001, 'RUT', 15432890, '4', 'MARIA', 'GONZALEZ', 'TAPIA', '+56984120933', 'mgonzalez@gmail.com', 2, '2026-11-11', '09:00', 'ATENDIDO', 'Consulta postulación beca y certificado matrícula SEP', 'AG-2026-6001'],
      [6002, 'RUT', 12980341, 'K', 'PEDRO', 'ARAYA', 'CORTES', '+56976541290', 'paraya.antof@outlook.com', 8, '2026-11-11', '09:30', 'CONFIRMADO', 'Entrega documentación finiquito y certificado antigüedad docente', 'AG-2026-6002'],
      [6003, 'RUT', 18765112, '2', 'CLAUDIA', 'ROJAS', 'PIZARRO', '+56991234455', 'crojas.aps@gmail.com', 3, '2026-11-11', '10:00', 'CONFIRMADO', 'Inscripción convenio prestador honorarios odontología APS', 'AG-2026-6003'],
      [6004, 'RUT', 9876123, '8', 'JORGE', 'ZEPEDA', 'MORALES', '+56965439876', 'jzepeda@constructoraloa.cl', 4, '2026-11-11', '10:30', 'PENDIENTE', 'Revisión estado de pago factura FE-88412 y retención garantía', 'AG-2026-6004'],
      [6005, 'RUT', 16543900, '1', 'VALENTINA', 'MUÑOZ', 'CASTILLO', '+56988776655', 'vmunoz.pie@gmail.com', 2, '2026-11-12', '11:00', 'CONFIRMADO', 'Evaluación diagnóstica integral Programa Integración Escolar PIE', 'AG-2026-6005'],
      [6006, 'RUT', 14220987, '5', 'ROBERTO', 'CARRASCO', 'DIAZ', '+56955443322', 'rcarrasco@gmail.com', 6, '2026-11-12', '11:30', 'PENDIENTE', 'Audiencia aclaración jurídica contrato suministro transporte escolar', 'AG-2026-6006']
    ];
    for (const [sec, tdoc, rut, dv, nom, pat, mat, cel, mail, depa, fec, hora, est, obs, idUnico] of solicitudesAgenda) {
      await replaceRow(
        client,
        'obs_datos_solicitud',
        'daso_sec',
        sec,
        `INSERT INTO adm_obs.obs_datos_solicitud (
          daso_sec, daso_tipo_docto, daso_rut, daso_dv, daso_nombre, daso_ape_pat,
          daso_ape_mat, daso_celular, daso_email, depa_sec, daso_fec_atencion,
          daho_hora, daso_flag_envio_wsp, daso_flag_envio_email, daso_id_unico,
          daso_fec_ing, daso_estado, daso_observ
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11::timestamp, $12, 'S', 'S', $13, NOW(), $14, $15)`,
        [sec, tdoc, rut, dv, nom, pat, mat, cel, mail, depa, fec, hora, idUnico, est, obs]
      );
    }

    const especialidades = [
      ['OFT', 'OFTALMOLOGIA Y OPTOMETRIA APS (UAPO)'],
      ['MAM', 'MAMOGRAFIA Y PREVENCION CANCER DE MAMA'],
      ['ODO', 'ODONTOLOGIA INTEGRAL Y ENDODONCIA APS'],
      ['CAR', 'CONTROL CARDIOVASCULAR Y PIE DIABETICO'],
      ['OTR', 'OTORRINOLARINGOLOGIA Y AUDIOMETRIA ESCOLAR']
    ];
    for (const [cod, desc] of especialidades) {
      await replaceRow(
        client,
        'sal_especialidad',
        'espe_cod',
        cod,
        `INSERT INTO adm_obs.sal_especialidad (espe_cod, espe_desc) VALUES ($1, $2)`,
        [cod, desc]
      );
    }

    const campanas = [
      [1, 'OPERATIVO UAPO OFTALMOLOGIA Y ENTREGA DE LENTES CESFAM NORTE / CORVALLIS', '2026-11-02', '2026-11-30', 'ACTIVA', 120],
      [2, 'CAMPAÑA PREVENTIVA MAMOGRAFIA MOVIL APS COMUNA DE ANTOFAGASTA', '2026-11-05', '2026-12-15', 'ACTIVA', 200],
      [3, 'OPERATIVO ODONTOLOGICO INTEGRAL ALTAS EDUCATIVAS Y GESTANTES', '2026-10-15', '2026-11-25', 'ACTIVA', 85]
    ];
    for (const [sec, desc, fIni, fFin, est, cupos] of campanas) {
      await replaceRow(
        client,
        'sal_campana',
        'camp_sec',
        sec,
        `INSERT INTO adm_obs.sal_campana (camp_sec, camp_desc, camp_fec_ini, camp_fec_fin, camp_estado, camp_cnt_cupo, camp_fec_ing)
         VALUES ($1, $2, $3::timestamp, $4::timestamp, $5, $6, NOW())`,
        [sec, desc, fIni, fFin, est, cupos]
      );
    }

    const pacientes = [
      [1, 101, 'OFT', 8451230, '9', 'ROSA ELENA', 'CONTRERAS', 'VEGA', 68, 'F', 'Av. Bonilla 8920', '+56982341100'],
      [1, 102, 'OFT', 7120984, '2', 'HUMBERTO', 'SALINAS', 'ROJAS', 72, 'M', 'Población Corvallis Pje. 4 #1120', '+56971123344'],
      [2, 201, 'MAM', 13450981, 'K', 'PATRICIA', 'MENDEZ', 'CASTRO', 51, 'F', 'Calle Ovallle 450', '+56994432211'],
      [3, 301, 'ODO', 19876234, '5', 'CAMILA', 'PASTEN', 'OLIVARES', 27, 'F', 'Av. Argentina 1920 Depto 42', '+56963345566']
    ];
    for (const [campSec, nroAt, espe, rut, dv, nom, pat, mat, edad, gen, dir, cel] of pacientes) {
      await client.query('DELETE FROM adm_obs.sal_ficha_paciente WHERE camp_sec = $1 AND cacu_nro_atencion = $2', [campSec, nroAt]);
      await client.query(
        `INSERT INTO adm_obs.sal_ficha_paciente (
          camp_sec, cacu_nro_atencion, espe_cod, fipa_rut, fipa_dv,
          fipa_nombres, fipa_ape_pat, fipa_ape_mat, fipa_edad, fipa_genero,
          fipa_direccion, fipa_celular, fipa_fec_ing
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, NOW())`,
        [campSec, nroAt, espe, rut, dv, nom, pat, mat, edad, gen, dir, cel]
      );

      await client.query('DELETE FROM adm_obs.sal_campana_cupo WHERE camp_sec = $1 AND cacu_nro_atencion = $2', [campSec, nroAt]);
      await client.query(
        `INSERT INTO adm_obs.sal_campana_cupo (camp_sec, cacu_nro_atencion, cacu_fec_crea, fipa_rut, cacu_estado)
         VALUES ($1, $2, NOW(), $3, 'CONFIRMADO')`,
        [campSec, nroAt, rut]
      );
    }

    console.log('✓ Módulos 9 y 10 de Fase 3 (RRHH APS + REM y Agenda de Atención) poblados exitosamente en PostgreSQL 18 (bd_cmds_admin).');
  } finally {
    client.release();
    await pool.end();
  }
}

seedFase3().catch((err) => {
  console.error('Error en seedFase3Postgres:', err);
  process.exit(1);
});
