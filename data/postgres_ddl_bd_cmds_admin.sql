-- ============================================================================

-- DDL POSTGRESQL 18 GENERADO DESDE ORACLE 26ai (CMDS ANTOFAGASTA)

-- Base de datos destino: bd_cmds_admin (192.168.30.47:5432)

-- Fecha generación: 2026-11-11T00:14:38.736Z

-- ============================================================================


CREATE SCHEMA IF NOT EXISTS adm_obs;

CREATE SCHEMA IF NOT EXISTS adm_auth;

CREATE SCHEMA IF NOT EXISTS adm_cmds;

CREATE SCHEMA IF NOT EXISTS padlog;

CREATE SCHEMA IF NOT EXISTS adm_educa;

CREATE SCHEMA IF NOT EXISTS adm_rhu;

CREATE SCHEMA IF NOT EXISTS adm_portaldir;

CREATE SCHEMA IF NOT EXISTS admeta;

CREATE SCHEMA IF NOT EXISTS adm_notas;

CREATE SCHEMA IF NOT EXISTS adm_proc_be;


      CREATE OR REPLACE FUNCTION public.to_char(val numeric) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val::text; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val bigint) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val::text; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val integer) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val::text; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val text) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT val; $$;
      CREATE OR REPLACE FUNCTION public.to_char(val timestamp without time zone, fmt text) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT pg_catalog.to_char(val, fmt); $$;
      CREATE OR REPLACE FUNCTION public.to_char(val timestamp with time zone, fmt text) RETURNS text LANGUAGE sql IMMUTABLE AS $$ SELECT pg_catalog.to_char(val, fmt); $$;
    

CREATE TABLE IF NOT EXISTS adm_auth.aut_admin (
  admi_user_name VARCHAR(30),
  admi_nombre VARCHAR(100),
  admi_password VARCHAR(40),
  admi_fec_creacion TIMESTAMP WITHOUT TIME ZONE,
  admi_user_creacion VARCHAR(30),
  admi_super_usuario VARCHAR(1),
  PRIMARY KEY (admi_user_name)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_authorization_codes (
  authorization_code VARCHAR(40),
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  redirect_uri VARCHAR(2000),
  expires TIMESTAMP WITHOUT TIME ZONE,
  scope VARCHAR(4000),
  id_token VARCHAR(1000),
  PRIMARY KEY (authorization_code)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_clients (
  client_id VARCHAR(80),
  client_secret VARCHAR(80),
  redirect_uri VARCHAR(2000),
  grant_types VARCHAR(80),
  scope VARCHAR(4000),
  user_id VARCHAR(80),
  PRIMARY KEY (client_id)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_grupos (
  grup_id NUMERIC,
  grup_nombre VARCHAR(50),
  PRIMARY KEY (grup_id)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_grupos_sistemas (
  grup_id NUMERIC,
  sist_id VARCHAR(50),
  grsi_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  grsi_usuario_ins VARCHAR(50),
  PRIMARY KEY (grup_id, sist_id)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_jwt (
  client_id VARCHAR(80),
  subject VARCHAR(80),
  public_key VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_oauth_access_tokens (
  access_token VARCHAR(40),
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  expires TIMESTAMP WITHOUT TIME ZONE,
  scope VARCHAR(4000),
  PRIMARY KEY (access_token)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_oauth_refresh_tokens (
  refresh_token VARCHAR(40),
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  expires TIMESTAMP WITHOUT TIME ZONE,
  scope VARCHAR(4000),
  PRIMARY KEY (refresh_token)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_parametros (
  para_codigo VARCHAR(50),
  para_desc VARCHAR(100),
  para_valor VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_sistemas (
  sist_id VARCHAR(50),
  sist_descripcion VARCHAR(400),
  client_id VARCHAR(80),
  client_secret VARCHAR(80),
  redirect_uri VARCHAR(2000),
  grant_types VARCHAR(80),
  scope VARCHAR(4000),
  PRIMARY KEY (sist_id)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_tmp_usuarios (
  usu_nombre VARCHAR(60),
  usu_rut VARCHAR(10),
  usu_telefono VARCHAR(10),
  usu_mail VARCHAR(50),
  usu_id NUMERIC(23, 0),
  usu_num_rut NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_usuarios (
  usua_id NUMERIC,
  usua_rut NUMERIC,
  usua_dv VARCHAR(1),
  usua_pwd VARCHAR(1000),
  usa_nombre VARCHAR(50),
  usa_apellidos VARCHAR(100),
  usa_email VARCHAR(100),
  usa_telefono VARCHAR(25),
  usa_tipo VARCHAR(1),
  usua_estado VARCHAR(2),
  usua_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usua_usuairo_ins VARCHAR(30),
  usua_scope VARCHAR(4000),
  usua_cambio_pwd VARCHAR(1),
  usua_fec_cambio_pwd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usua_id)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_usuario_grupo (
  usua_id NUMERIC,
  grup_id NUMERIC,
  usgr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usgr_usuario_ins VARCHAR(50),
  PRIMARY KEY (usua_id, grup_id)
);

CREATE TABLE IF NOT EXISTS adm_auth.aut_usuario_pwd (
  usua_id NUMERIC,
  uspw_token VARCHAR(200),
  uspw_estado VARCHAR(30),
  uspw_fec_solicitud TIMESTAMP WITHOUT TIME ZONE,
  uspw_fec_expiracion TIMESTAMP WITHOUT TIME ZONE,
  uspw_fec_cambio TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_auth.sqln_explain_plan (
  statement_id VARCHAR(30),
  "timestamp" TIMESTAMP WITHOUT TIME ZONE,
  remarks VARCHAR(80),
  operation VARCHAR(30),
  options VARCHAR(30),
  object_node VARCHAR(128),
  object_owner VARCHAR(30),
  object_name VARCHAR(30),
  object_instance NUMERIC,
  object_type VARCHAR(30),
  optimizer VARCHAR(255),
  search_columns NUMERIC,
  id NUMERIC,
  parent_id NUMERIC,
  position NUMERIC,
  cost NUMERIC,
  cardinality NUMERIC,
  bytes NUMERIC,
  other_tag VARCHAR(255),
  partition_start VARCHAR(255),
  partition_stop VARCHAR(255),
  partition_id NUMERIC,
  other TEXT,
  distribution VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_auth.tmp_email (
  rut NUMERIC,
  correo VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_auth.tmp_usuarios (
  usua_id NUMERIC,
  usua_rut NUMERIC,
  usua_dv VARCHAR(1),
  usua_pwd VARCHAR(1000),
  usa_nombre VARCHAR(50),
  usa_apellidos VARCHAR(201),
  usa_tipo VARCHAR(1),
  usua_estado VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_auth.usu_oauth (
  username NUMERIC,
  password VARCHAR(1000),
  scope VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS adm_auth.usu_test (
  rut_usuario NUMERIC,
  nombre_usuario VARCHAR(200),
  correo VARCHAR(100),
  telefono VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS adm_auth.usu_totem (
  pers_rut NUMERIC,
  pers_dv VARCHAR(1),
  pers_nombre VARCHAR(50),
  pers_paterno VARCHAR(100),
  pers_materno VARCHAR(100),
  usua_bloqueo VARCHAR(1),
  usua_es_admin VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_auth.x_usuarios_veri (
  func_rut BIGINT,
  func_dv VARCHAR(1),
  func_nombres VARCHAR(500),
  func_apellidos VARCHAR(201),
  func_mail VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_cmds.cds_parametros (
  para_codigo VARCHAR(50),
  para_desc VARCHAR(100),
  para_valor VARCHAR(2000),
  PRIMARY KEY (para_codigo)
);

CREATE TABLE IF NOT EXISTS adm_cmds.oauth_access_tokens (
  access_token VARCHAR(40),
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  expires TIMESTAMP WITHOUT TIME ZONE,
  scope VARCHAR(4000),
  PRIMARY KEY (access_token)
);

CREATE TABLE IF NOT EXISTS adm_cmds.oauth_authorization_codes (
  authorization_code VARCHAR(40),
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  redirect_uri VARCHAR(2000),
  expires TIMESTAMP WITHOUT TIME ZONE,
  scope VARCHAR(4000),
  id_token VARCHAR(1000),
  PRIMARY KEY (authorization_code)
);

CREATE TABLE IF NOT EXISTS adm_cmds.oauth_clients (
  client_id VARCHAR(80),
  client_secret VARCHAR(80),
  redirect_uri VARCHAR(2000),
  grant_types VARCHAR(80),
  scope VARCHAR(4000),
  user_id VARCHAR(80),
  PRIMARY KEY (client_id)
);

CREATE TABLE IF NOT EXISTS adm_cmds.oauth_jwt (
  client_id VARCHAR(80),
  subject VARCHAR(80),
  public_key VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS adm_cmds.oauth_refresh_tokens (
  refresh_token VARCHAR(40),
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  expires TIMESTAMP WITHOUT TIME ZONE,
  scope VARCHAR(4000),
  PRIMARY KEY (refresh_token)
);

CREATE TABLE IF NOT EXISTS adm_cmds.oauth_scopes (
  scope VARCHAR(80),
  is_default NUMERIC,
  PRIMARY KEY (scope)
);

CREATE TABLE IF NOT EXISTS adm_cmds.oauth_users (
  username VARCHAR(80),
  password VARCHAR(80),
  first_name VARCHAR(80),
  last_name VARCHAR(80),
  email VARCHAR(80),
  email_verified NUMERIC,
  scope VARCHAR(4000),
  PRIMARY KEY (username)
);

CREATE TABLE IF NOT EXISTS adm_cmds.ttm_usuarios_bkp (
  usua_usuarios VARCHAR(10),
  usua_clave VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_actividad (
  acti_sec NUMERIC(23, 0),
  acti_codigo VARCHAR(5),
  acti_desc VARCHAR(200),
  acti_area_cuenta VARCHAR(30),
  acti_monto_hora NUMERIC(23, 0),
  acti_estado VARCHAR(10),
  PRIMARY KEY (acti_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_alimentacion_compl (
  alco_sec NUMERIC(23, 0),
  esta_cod VARCHAR(10),
  alco_fecha TIMESTAMP WITHOUT TIME ZONE,
  alco_obs VARCHAR(4000),
  alco_user_ing VARCHAR(30),
  alco_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  alco_user_mod VARCHAR(30),
  alco_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (alco_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_alimentacion_compl_det (
  acde_sec NUMERIC(23, 0),
  alco_sec NUMERIC(23, 0),
  acde_producto VARCHAR(10),
  acde_cant_cajas_cerr INTEGER,
  acde_kg_estan INTEGER,
  acde_cant_tarros INTEGER,
  acde_dia_distrib INTEGER,
  acde_kg_entregados INTEGER,
  acde_user_ing VARCHAR(30),
  acde_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  acde_user_mod VARCHAR(30),
  acde_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  acde_saldo_ini NUMERIC(23, 0),
  acde_saldo_fin NUMERIC(23, 0),
  PRIMARY KEY (acde_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_atencion_urgencia (
  atur_sec NUMERIC(23, 0),
  esta_cod VARCHAR(10),
  atur_periodo VARCHAR(6),
  atur_user_ing VARCHAR(30),
  atur_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  atur_user_mod VARCHAR(30),
  atur_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (atur_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_atencion_urgencia_det (
  aude_sec NUMERIC(23, 0),
  atur_sec NUMERIC(23, 0),
  aude_fecha TIMESTAMP WITHOUT TIME ZONE,
  aude_cant_resp INTEGER,
  aude_cant_no_resp INTEGER,
  aude_cant_sospec NUMERIC,
  aude_cant_muestra INTEGER,
  aude_cant_pac_observac INTEGER,
  aude_cant_fallecidos INTEGER,
  aude_cant_traslados INTEGER,
  aude_cant_consta_les INTEGER,
  aude_recaudac INTEGER,
  aude_cant_total NUMERIC(23, 0),
  aude_user_ing VARCHAR(30),
  aude_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  aude_user_mod VARCHAR(30),
  aude_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (aude_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_convenio (
  conv_sec NUMERIC(23, 0),
  conv_codigo VARCHAR(5),
  conv_desc VARCHAR(200),
  conv_cuenta_salud VARCHAR(30),
  conv_ceco_cod VARCHAR(30),
  conv_ind_transversal VARCHAR(2),
  conv_ind_rankear VARCHAR(2),
  PRIMARY KEY (conv_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_convenio_02092022_bkp (
  conv_sec NUMERIC(23, 0),
  conv_codigo VARCHAR(5),
  conv_desc VARCHAR(200),
  conv_cuenta_salud VARCHAR(30),
  conv_ceco_cod VARCHAR(30),
  conv_ind_transversal VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_festivos (
  fest_fecha TIMESTAMP WITHOUT TIME ZONE,
  fest_desc VARCHAR(200),
  PRIMARY KEY (fest_fecha)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_formacion (
  form_sec NUMERIC(23, 0),
  form_codigo VARCHAR(5),
  form_desc VARCHAR(100),
  PRIMARY KEY (form_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_periodo_epidem (
  peep_sec NUMERIC(23, 0),
  pesa_sec NUMERIC(23, 0),
  peep_semana VARCHAR(250),
  peep_fecha_inicio TIMESTAMP WITHOUT TIME ZONE,
  peep_fecha_fin TIMESTAMP WITHOUT TIME ZONE,
  peep_user_ing VARCHAR(30),
  peep_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  peep_user_mod VARCHAR(30),
  peep_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (peep_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_periodo_salud (
  pesa_sec NUMERIC(23, 0),
  pesa_periodo INTEGER,
  pesa_estado VARCHAR(10),
  pesa_user_ing VARCHAR(30),
  pesa_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  pesa_user_mod VARCHAR(30),
  pesa_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (pesa_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_rela_actisec (
  reac_sec NUMERIC(23, 0),
  sect_sec NUMERIC(23, 0),
  acti_sec NUMERIC(23, 0),
  PRIMARY KEY (reac_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_rela_forsec (
  fose_sec NUMERIC(23, 0),
  form_sec NUMERIC(23, 0),
  sect_sec NUMERIC(23, 0),
  PRIMARY KEY (fose_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_rela_uniceco (
  reun_sec NUMERIC(23, 0),
  unid_codigo VARCHAR(5),
  ceco_cod VARCHAR(30),
  PRIMARY KEY (reun_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_rela_unidconv (
  reuc_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  conv_sec NUMERIC(23, 0),
  PRIMARY KEY (reuc_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_rela_unidconv_02092022_bkp (
  reuc_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  conv_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_reporte_softland (
  reso_periodo INTEGER,
  reso_cod_sector INTEGER,
  reso_registro TEXT,
  acti_area_cuenta VARCHAR(20),
  PRIMARY KEY (reso_periodo, reso_cod_sector, acti_area_cuenta)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_sector (
  sect_sec NUMERIC(23, 0),
  sect_desc VARCHAR(100),
  PRIMARY KEY (sect_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_semana_epidem (
  seep_sec NUMERIC(23, 0),
  peep_sec NUMERIC(23, 0),
  esta_cod VARCHAR(10),
  seep_user_ing VARCHAR(30),
  seep_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  seep_user_mod VARCHAR(30),
  seep_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (seep_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_semana_epidem_det (
  sede_sec NUMERIC(23, 0),
  seep_sec NUMERIC(23, 0),
  sede_item_cat VARCHAR(50),
  sede_item_cod VARCHAR(10),
  sede_cant_cesfam INTEGER,
  sede_cant_sapu INTEGER,
  sede_user_ing VARCHAR(30),
  sede_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  sede_user_mod VARCHAR(30),
  sede_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (sede_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_unidad (
  unid_sec NUMERIC(23, 0),
  unid_codigo VARCHAR(5),
  unid_desc VARCHAR(250),
  sect_sec NUMERIC,
  unid_orden INTEGER,
  PRIMARY KEY (unid_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.adm_usuarios_establecimientos (
  uses_sec NUMERIC(23, 0),
  usme_usuario NUMERIC,
  esta_cod VARCHAR(15),
  uses_user_mod VARCHAR(50),
  uses_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (uses_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.aq__mpu_orden_mpu_tb_h (
  msgid BYTEA,
  subscriber_ NUMERIC,
  name VARCHAR(512),
  address_ NUMERIC,
  dequeue_time TIMESTAMP WITHOUT TIME ZONE,
  transaction_id VARCHAR(30),
  dequeue_user VARCHAR(128),
  propagated_msgid BYTEA,
  retry_count NUMERIC,
  hint VARCHAR(10),
  spare BYTEA,
  PRIMARY KEY (msgid, subscriber_, name, address_)
);

CREATE TABLE IF NOT EXISTS adm_obs.aq__mpu_orden_od_tb_h (
  msgid BYTEA,
  subscriber_ NUMERIC,
  name VARCHAR(512),
  address_ NUMERIC,
  dequeue_time TIMESTAMP WITHOUT TIME ZONE,
  transaction_id VARCHAR(30),
  dequeue_user VARCHAR(128),
  propagated_msgid BYTEA,
  retry_count NUMERIC,
  hint VARCHAR(10),
  spare BYTEA,
  PRIMARY KEY (msgid, subscriber_, name, address_)
);

CREATE TABLE IF NOT EXISTS adm_obs.aq__mpu_request_orden_mpu_tb_h (
  msgid BYTEA,
  subscriber_ NUMERIC,
  name VARCHAR(512),
  address_ NUMERIC,
  dequeue_time TIMESTAMP WITHOUT TIME ZONE,
  transaction_id VARCHAR(30),
  dequeue_user VARCHAR(128),
  propagated_msgid BYTEA,
  retry_count NUMERIC,
  hint VARCHAR(10),
  spare BYTEA,
  PRIMARY KEY (msgid, subscriber_, name, address_)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_boletas (
  bole_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  bole_nro_docto VARCHAR(30),
  bole_tipo_docto VARCHAR(30),
  bole_fecha_docto TIMESTAMP WITHOUT TIME ZONE,
  bole_ult_estado VARCHAR(30),
  bole_actividad VARCHAR(100),
  bole_horas BIGINT,
  bole_detalle VARCHAR(500),
  bole_neto NUMERIC(14, 2),
  bole_impuesto NUMERIC(14, 2),
  bole_total NUMERIC(14, 2),
  bole_user_ing VARCHAR(50),
  bole_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  bole_user_mod VARCHAR(50),
  bole_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  bole_unidad VARCHAR(100),
  acti_codigo VARCHAR(5),
  bole_ceco_cod VARCHAR(30),
  bole_conv_codigo VARCHAR(5),
  nobo_sec NUMERIC,
  sect_sec NUMERIC(23, 0),
  pepu_sec NUMERIC(23, 0),
  bole_nro_horas NUMERIC,
  PRIMARY KEY (bole_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_boletas_02092022_bkp (
  bole_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  bole_nro_docto VARCHAR(30),
  bole_tipo_docto VARCHAR(30),
  bole_fecha_docto TIMESTAMP WITHOUT TIME ZONE,
  bole_ult_estado VARCHAR(30),
  bole_actividad VARCHAR(100),
  bole_horas BIGINT,
  bole_detalle VARCHAR(500),
  bole_neto NUMERIC(14, 2),
  bole_impuesto NUMERIC(14, 2),
  bole_total NUMERIC(14, 2),
  bole_user_ing VARCHAR(50),
  bole_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  bole_user_mod VARCHAR(50),
  bole_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  bole_unidad VARCHAR(100),
  acti_codigo VARCHAR(5),
  bole_ceco_cod VARCHAR(30),
  bole_conv_codigo VARCHAR(5),
  nobo_sec NUMERIC,
  sect_sec NUMERIC(23, 0),
  pepu_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_centro_costo (
  ceco_sec NUMERIC(23, 0),
  ceco_desc VARCHAR(200),
  ceco_cod VARCHAR(30),
  ceco_dom_estado VARCHAR(30),
  ceco_sect_sec NUMERIC(23, 0),
  PRIMARY KEY (ceco_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_conv_func (
  conc_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  conv_codigo VARCHAR(5),
  conc_user_ing VARCHAR(50),
  conc_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  conc_user_mod VARCHAR(50),
  conc_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (conc_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_coto_func (
  coto_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  coto_fecha_ini TIMESTAMP WITHOUT TIME ZONE,
  coto_fecha_termino TIMESTAMP WITHOUT TIME ZONE,
  coto_vigencia VARCHAR(5),
  coto_user_ing VARCHAR(50),
  coto_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  coto_user_mod VARCHAR(50),
  coto_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (coto_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_evidencia (
  evia_sec NUMERIC,
  evia_esta_cod VARCHAR(30),
  evia_convenio VARCHAR(200),
  evia_ano VARCHAR(30),
  evia_mes VARCHAR(30),
  evia_estado VARCHAR(30),
  evia_boleta NUMERIC,
  evia_rut_empleado VARCHAR(30),
  evia_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  evia_user_ing VARCHAR(60),
  evia_fech_firma_1 TIMESTAMP WITHOUT TIME ZONE,
  evia_fech_firma_2 TIMESTAMP WITHOUT TIME ZONE,
  evia_user_firma_1 VARCHAR(60),
  evia_user_firma_2 VARCHAR(60),
  evia_observacion VARCHAR(4000),
  peri_sec NUMERIC(23, 0),
  PRIMARY KEY (evia_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_evidencia_documento (
  evdo_sec NUMERIC,
  evia_sec NUMERIC,
  evia_archivo VARCHAR(200),
  evia_archivo_real VARCHAR(200),
  evia_tamanio_archivo NUMERIC,
  evdo_purgado VARCHAR(1),
  evdo_fech_purgado TIMESTAMP WITHOUT TIME ZONE,
  evdo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  evdo_user_ing VARCHAR(60),
  evdo_estado VARCHAR(1),
  PRIMARY KEY (evdo_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_evidencia_log (
  evlg_sec NUMERIC,
  evia_sec NUMERIC,
  evia_esta_cod VARCHAR(30),
  evia_convenio VARCHAR(200),
  evia_ano VARCHAR(30),
  evia_mes VARCHAR(30),
  evia_estado VARCHAR(30),
  evia_boleta NUMERIC,
  evia_rut_empleado VARCHAR(30),
  evia_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  evia_user_ing VARCHAR(60),
  evia_observacion VARCHAR(4000),
  peri_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_flujo_estado (
  fest_sec NUMERIC(23, 0),
  bole_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  fest_estado VARCHAR(30),
  fest_fecha_ini TIMESTAMP WITHOUT TIME ZONE,
  fest_fecha_ter TIMESTAMP WITHOUT TIME ZONE,
  fest_user_ing VARCHAR(50),
  fest_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fest_user_mod VARCHAR(50),
  fest_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (fest_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_flujo_estado_02092022_bkp (
  fest_sec NUMERIC(23, 0),
  bole_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  fest_estado VARCHAR(30),
  fest_fecha_ini TIMESTAMP WITHOUT TIME ZONE,
  fest_fecha_ter TIMESTAMP WITHOUT TIME ZONE,
  fest_user_ing VARCHAR(50),
  fest_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fest_user_mod VARCHAR(50),
  fest_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_funcionarios (
  func_sec NUMERIC(23, 0),
  func_rut BIGINT,
  func_dv VARCHAR(1),
  func_nombres VARCHAR(500),
  func_ap_paterno VARCHAR(100),
  func_ap_materno VARCHAR(100),
  func_mail VARCHAR(50),
  func_formacion VARCHAR(500),
  func_sector VARCHAR(100),
  func_banco VARCHAR(100),
  func_tipo_cta VARCHAR(30),
  func_nro_cta VARCHAR(100),
  func_user_ing VARCHAR(50),
  func_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  func_user_mod VARCHAR(50),
  func_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  func_cod_formacion VARCHAR(25),
  func_sec_sector NUMERIC(23, 0),
  func_estado VARCHAR(5),
  fun_cer_inha VARCHAR(2),
  fun_cer_ante VARCHAR(2),
  func_fec_ing_sistema TIMESTAMP WITHOUT TIME ZONE,
  func_fec_ing_cmds TIMESTAMP WITHOUT TIME ZONE,
  func_motivo_estado VARCHAR(10),
  func_es_recomendable VARCHAR(2),
  func_motivo_reco VARCHAR(30),
  func_observaciones VARCHAR(500),
  func_fec_cambio_estado TIMESTAMP WITHOUT TIME ZONE,
  func_tipo_contrato VARCHAR(5),
  func_registro_sis VARCHAR(100),
  PRIMARY KEY (func_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_funcionarios_02092022_bkp (
  func_sec NUMERIC(23, 0),
  func_rut BIGINT,
  func_dv VARCHAR(1),
  func_nombres VARCHAR(500),
  func_ap_paterno VARCHAR(100),
  func_ap_materno VARCHAR(100),
  func_mail VARCHAR(50),
  func_formacion VARCHAR(100),
  func_sector VARCHAR(100),
  func_banco VARCHAR(100),
  func_tipo_cta VARCHAR(30),
  func_nro_cta VARCHAR(100),
  func_user_ing VARCHAR(50),
  func_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  func_user_mod VARCHAR(50),
  func_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  func_cod_formacion VARCHAR(25),
  func_sec_sector NUMERIC(23, 0),
  func_estado VARCHAR(5),
  fun_cer_inha VARCHAR(2),
  fun_cer_ante VARCHAR(2),
  func_fec_ing_sistema TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_funcionarios_veri (
  fuve_func_sec NUMERIC(23, 0),
  fuve_func_rut NUMERIC,
  PRIMARY KEY (fuve_func_rut)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_periodos (
  peri_sec NUMERIC(23, 0),
  peri_nombre VARCHAR(80),
  peri_estado VARCHAR(30),
  peri_user_ing VARCHAR(50),
  peri_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  peri_user_mod VARCHAR(50),
  peri_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_fecha_evidencia TIMESTAMP WITHOUT TIME ZONE,
  sect_sec NUMERIC(23, 0),
  PRIMARY KEY (peri_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_peri_impu (
  pepu_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  pepu_monto NUMERIC(5, 2),
  pepu_user_ing VARCHAR(50),
  pepu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  pepu_user_mod VARCHAR(50),
  pepu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  pepu_codigo_bol VARCHAR(11),
  pepu_descripcion_bol VARCHAR(150),
  PRIMARY KEY (pepu_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_reporte_consolidado (
  peri_sec NUMERIC,
  sect_sec NUMERIC,
  reco_tipo_archivo VARCHAR(4),
  reco_registro TEXT,
  PRIMARY KEY (peri_sec, sect_sec, reco_tipo_archivo)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_reporte_nomina (
  peri_sec NUMERIC,
  sect_sec NUMERIC,
  unid_codigo VARCHAR(5),
  acti_area_cuenta VARCHAR(20),
  reno_registro TEXT,
  PRIMARY KEY (peri_sec, sect_sec, unid_codigo, acti_area_cuenta)
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_reporte_presupuesto (
  peri_sec NUMERIC,
  sect_sec NUMERIC,
  repr_registro TEXT
);

CREATE TABLE IF NOT EXISTS adm_obs.bho_reporte_transparencia (
  peri_sec NUMERIC,
  sect_sec NUMERIC,
  repr_registro TEXT
);

CREATE TABLE IF NOT EXISTS adm_obs.boletas_bkp_20230317 (
  bole_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  bole_nro_docto VARCHAR(30),
  bole_tipo_docto VARCHAR(30),
  bole_fecha_docto TIMESTAMP WITHOUT TIME ZONE,
  bole_ult_estado VARCHAR(30),
  bole_actividad VARCHAR(100),
  bole_horas BIGINT,
  bole_detalle VARCHAR(500),
  bole_neto NUMERIC(14, 2),
  bole_impuesto NUMERIC(14, 2),
  bole_total NUMERIC(14, 2),
  bole_user_ing VARCHAR(50),
  bole_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  bole_user_mod VARCHAR(50),
  bole_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  bole_unidad VARCHAR(100),
  acti_codigo VARCHAR(5),
  bole_ceco_cod VARCHAR(30),
  bole_conv_codigo VARCHAR(5),
  nobo_sec NUMERIC,
  sect_sec NUMERIC(23, 0),
  pepu_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.bole_302_230317_apro (
  bole_sec NUMERIC(23, 0),
  func_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  bole_nro_docto VARCHAR(30),
  bole_tipo_docto VARCHAR(30),
  bole_fecha_docto TIMESTAMP WITHOUT TIME ZONE,
  bole_ult_estado VARCHAR(30),
  bole_actividad VARCHAR(100),
  bole_horas BIGINT,
  bole_detalle VARCHAR(500),
  bole_neto NUMERIC(14, 2),
  bole_impuesto NUMERIC(14, 2),
  bole_total NUMERIC(14, 2),
  bole_user_ing VARCHAR(50),
  bole_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  bole_user_mod VARCHAR(50),
  bole_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  bole_unidad VARCHAR(100),
  acti_codigo VARCHAR(5),
  bole_ceco_cod VARCHAR(30),
  bole_conv_codigo VARCHAR(5),
  nobo_sec NUMERIC,
  sect_sec NUMERIC(23, 0),
  pepu_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.contrato (
  cont_cod VARCHAR(15),
  cont_nomb VARCHAR(200),
  cont_user_ing VARCHAR(15),
  cont_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cont_user_mod VARCHAR(15),
  cont_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (cont_cod)
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_01 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_02 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_03 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_04 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_05 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_06 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_07 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_08 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_09 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_10 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_11 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.dbg_logger_12 (
  logg_sec NUMERIC,
  logg_sec_proc NUMERIC,
  logg_tipo VARCHAR(30),
  logg_rutina VARCHAR(200),
  logg_fec_dbg TIMESTAMP WITHOUT TIME ZONE,
  logg_sec_padre NUMERIC,
  logg_client_id VARCHAR(200),
  logg_usuario VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param_obj TEXT,
  logg_cod_error NUMERIC,
  logg_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.establecimiento (
  esta_cod VARCHAR(15),
  esta_nomb VARCHAR(200),
  esta_user_ing VARCHAR(15),
  esta_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  esta_user_mod VARCHAR(15),
  esta_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  esta_col_orden VARCHAR(4),
  PRIMARY KEY (esta_cod)
);

CREATE TABLE IF NOT EXISTS adm_obs.estamiento (
  esmi_cod VARCHAR(15),
  esmi_nomb VARCHAR(200),
  esmi_cate VARCHAR(1),
  esmi_user_ing VARCHAR(15),
  esmi_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  esmi_user_mod VARCHAR(15),
  esmi_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (esmi_cod)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_argumento (
  argu_sec NUMERIC(23, 0),
  inic_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  argu_argumento VARCHAR(4000),
  argu_user_ing VARCHAR(50),
  argu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  argu_user_mod VARCHAR(50),
  argu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (argu_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_del_disponibilidad_ppto (
  dipp_sec NUMERIC(23, 0),
  dipp_nombre_proyecto VARCHAR(250),
  depa_sec NUMERIC,
  tifi_sec NUMERIC(23, 0),
  dipp_monto NUMERIC(23, 0),
  dipp_fecha TIMESTAMP WITHOUT TIME ZONE,
  dipp_estado VARCHAR(30),
  dipp_observacion VARCHAR(4000),
  dipp_glosa VARCHAR(200),
  dipp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_ing VARCHAR(60),
  dipp_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_mod VARCHAR(60),
  dipp_observacion_ppto VARCHAR(4000),
  dipp_observacion_ppto_daf VARCHAR(4000),
  ddip_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  ddip_user_ing NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_del_disponibilidad_ppto_log (
  dplg_sec NUMERIC(23, 0),
  dipp_sec NUMERIC(23, 0),
  dipp_nombre_proyecto VARCHAR(250),
  depa_sec NUMERIC,
  tifi_sec NUMERIC(23, 0),
  dipp_monto NUMERIC(23, 0),
  dipp_fecha TIMESTAMP WITHOUT TIME ZONE,
  dipp_estado VARCHAR(30),
  dipp_observacion VARCHAR(4000),
  dipp_glosa VARCHAR(200),
  dipp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_ing VARCHAR(60),
  dipp_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_mod VARCHAR(60),
  dipp_observacion_ppto VARCHAR(4000),
  dipp_observacion_ppto_daf VARCHAR(4000),
  ddpl_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  ddpl_user_ing NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_del_documentos_ppto (
  dopp_sec NUMERIC(23, 0),
  dopp_documentos BYTEA,
  dipp_sec NUMERIC,
  dopp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dopp_user_ing NUMERIC,
  dopp_nombre VARCHAR(100),
  ddpp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  ddpp_user_ing NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_departamento (
  depa_sec NUMERIC(23, 0),
  depa_nombre VARCHAR(100),
  depa_rut_resp BIGINT,
  depa_dv_rut_resp VARCHAR(1),
  depa_nombre_resp VARCHAR(100),
  depa_correo_resp VARCHAR(100),
  depa_user_ing VARCHAR(50),
  depa_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  depa_correo_resp_cc VARCHAR(100),
  depa_correo_resp_alter VARCHAR(100),
  depa_cnt_pers_atencion INTEGER,
  depa_estado VARCHAR(30),
  depa_imagen BYTEA,
  depa_ind_evaluac VARCHAR(2),
  depa_cod VARCHAR(2),
  depa_rut_subr NUMERIC,
  depa_dv_rut_subr VARCHAR(1),
  depa_nombre_subr VARCHAR(100),
  depa_firma_subr VARCHAR(2),
  depa_correo_subr VARCHAR(100),
  depa_orden NUMERIC,
  depa_rut_secretaria NUMERIC,
  depa_dv_rut_secretaria VARCHAR(1),
  depa_firma_secretaria VARCHAR(2),
  depa_permite_autoriza VARCHAR(2),
  PRIMARY KEY (depa_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_disponibilidad_ppto (
  dipp_sec NUMERIC(23, 0),
  dipp_nombre_proyecto VARCHAR(250),
  depa_sec NUMERIC,
  tifi_sec NUMERIC(23, 0),
  dipp_monto NUMERIC(23, 0),
  dipp_fecha TIMESTAMP WITHOUT TIME ZONE,
  dipp_estado VARCHAR(30),
  dipp_observacion VARCHAR(4000),
  dipp_glosa VARCHAR(500),
  dipp_observacion_ppto VARCHAR(4000),
  dipp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_ing VARCHAR(60),
  dipp_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_mod VARCHAR(60),
  dipp_observacion_ppto_daf VARCHAR(4000),
  dpto_sec NUMERIC(23, 0),
  dipp_orden_compra VARCHAR(2),
  PRIMARY KEY (dipp_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_disponibilidad_ppto_log (
  dplg_sec NUMERIC(23, 0),
  dipp_sec NUMERIC(23, 0),
  dipp_nombre_proyecto VARCHAR(250),
  depa_sec NUMERIC,
  tifi_sec NUMERIC(23, 0),
  dipp_monto NUMERIC(23, 0),
  dipp_fecha TIMESTAMP WITHOUT TIME ZONE,
  dipp_estado VARCHAR(30),
  dipp_observacion VARCHAR(4000),
  dipp_glosa VARCHAR(500),
  dipp_observacion_ppto VARCHAR(4000),
  dipp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_ing VARCHAR(60),
  dipp_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dipp_user_mod VARCHAR(60),
  dipp_observacion_ppto_daf VARCHAR(4000),
  dpto_sec NUMERIC(23, 0),
  dipp_orden_compra VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_disponibillidad_ppto_orden_comp (
  dpoc_sec NUMERIC(23, 0),
  dipp_sec NUMERIC(23, 0),
  dpoc_estado VARCHAR(30),
  dpoc_monto NUMERIC(23, 0),
  dpoc_fecha TIMESTAMP WITHOUT TIME ZONE,
  dpoc_observacion VARCHAR(4000),
  dpoc_observacion_ppto VARCHAR(4000),
  dpoc_observacion_ppto_daf VARCHAR(4000),
  dpoc_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dpoc_user_ing VARCHAR(60),
  dpoc_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dpoc_user_mod VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_disponibillidad_ppto_orden_comp_log (
  dpol_sec NUMERIC(23, 0),
  dpoc_sec NUMERIC(23, 0),
  dipp_sec NUMERIC(23, 0),
  dpol_estado VARCHAR(30),
  dpol_monto NUMERIC(23, 0),
  dpol_fecha TIMESTAMP WITHOUT TIME ZONE,
  dpol_observacion VARCHAR(4000),
  dpol_observacion_ppto VARCHAR(4000),
  dpol_observacion_ppto_daf VARCHAR(4000),
  dpol_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dpol_user_ing VARCHAR(60),
  dpol_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dpol_user_mod VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_documentos (
  docu_sec NUMERIC(23, 0),
  docu_documentos BYTEA,
  docu_key NUMERIC,
  docu_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  docu_user_ing NUMERIC,
  docu_nombre VARCHAR(100),
  PRIMARY KEY (docu_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_documentos_evaluador (
  doev_sec NUMERIC(23, 0),
  doev_documentos BYTEA,
  doev_key NUMERIC,
  doev_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doev_user_ing NUMERIC,
  doev_nombre VARCHAR(100),
  depa_sec NUMERIC(23, 0),
  PRIMARY KEY (doev_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_documentos_ppto (
  dopp_sec NUMERIC(23, 0),
  dopp_documentos BYTEA,
  dipp_sec NUMERIC,
  dopp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dopp_user_ing NUMERIC,
  dopp_nombre VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_evaluador_suplente (
  evsu_sec NUMERIC(23, 0),
  depa_sec NUMERIC,
  evsu_rut_supl NUMERIC,
  evsu_dv_rut_supl VARCHAR(1),
  evsu_nombre_supl VARCHAR(100),
  evsu_correo_supl VARCHAR(100),
  evsu_user_ing VARCHAR(50),
  evsu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  evsu_user_mod VARCHAR(50),
  evsu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  evsu_tipo VARCHAR(3),
  PRIMARY KEY (evsu_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_hoja_ruta (
  inic_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  horu_orden NUMERIC(23, 0),
  horu_estado VARCHAR(15),
  horu_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  horu_user_ing VARCHAR(50),
  horu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  horu_user_mod VARCHAR(50),
  horu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  horu_observacion BYTEA,
  horu_inc_doc_vb VARCHAR(2),
  PRIMARY KEY (inic_sec, depa_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_hoja_ruta_log (
  hrlg_sec NUMERIC(23, 0),
  inic_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  horu_orden NUMERIC(23, 0),
  horu_estado VARCHAR(12),
  horu_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  horu_user_ing VARCHAR(50),
  horu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  horu_user_mod VARCHAR(50),
  horu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  horu_observacion BYTEA,
  depa_sec_log NUMERIC,
  horu_inc_doc_vb VARCHAR(2),
  PRIMARY KEY (hrlg_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_iniciativa (
  inic_sec NUMERIC(23, 0),
  inic_nom_proyecto VARCHAR(200),
  depa_sec NUMERIC(23, 0),
  inic_monto NUMERIC(23, 0),
  inic_user_ing VARCHAR(50),
  inic_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  inic_estado VARCHAR(20),
  inic_observaciones BYTEA,
  inic_tipo_finan NUMERIC(23, 0),
  inic_folio VARCHAR(30),
  inic_obs_log BYTEA,
  inic_notificacion VARCHAR(4),
  inic_fecha_notificacion TIMESTAMP WITHOUT TIME ZONE,
  inic_obs_rev BYTEA,
  inic_ind_vb VARCHAR(2),
  inic_nom_doc_vb VARCHAR(500),
  inic_nom_usu_doc_vb VARCHAR(500),
  PRIMARY KEY (inic_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_iniciativa_log (
  inic_sec NUMERIC,
  mats_sec NUMERIC,
  inlo_estado VARCHAR(2),
  inlo_fecha TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (mats_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_registro_evaluador (
  reev_sec NUMERIC,
  evsu_sec NUMERIC,
  horu_orden NUMERIC,
  reev_estado VARCHAR(12),
  reev_observaciones BYTEA,
  reev_obser_deri VARCHAR(4000),
  reev_user_ins VARCHAR(50),
  reev_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  reev_user_mod VARCHAR(50),
  reev_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (reev_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_secuencia_depto (
  depa_sec NUMERIC(23, 0),
  sede_valor_secuencia NUMERIC(23, 0),
  sede_incremento NUMERIC,
  PRIMARY KEY (depa_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_tipo_financiamiento (
  tifi_sec NUMERIC(23, 0),
  tifi_nombre VARCHAR(250),
  tifi_finan_ult_estado VARCHAR(10),
  PRIMARY KEY (tifi_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.hr_usuario_folio (
  usfo_sec NUMERIC,
  usfo_rut VARCHAR(50),
  usfo_estado VARCHAR(12),
  usfo_user_ing VARCHAR(50),
  usfo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  usfo_user_mod VARCHAR(50),
  usfo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usfo_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.jdbc_store_email (
  indexid NUMERIC(23, 0),
  msg_id VARCHAR(200),
  message BYTEA,
  PRIMARY KEY (indexid)
);

CREATE TABLE IF NOT EXISTS adm_obs.jdbc_store_push (
  indexid NUMERIC(23, 0),
  msg_id VARCHAR(200),
  message BYTEA,
  PRIMARY KEY (indexid)
);

CREATE TABLE IF NOT EXISTS adm_obs.jdbc_store_sms (
  indexid NUMERIC(23, 0),
  msg_id VARCHAR(200),
  message BYTEA,
  PRIMARY KEY (indexid)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_compradores (
  comp_cod VARCHAR(20),
  comp_nombre VARCHAR(255),
  PRIMARY KEY (comp_cod)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_comp_unid (
  orca_sec_id NUMERIC,
  comp_cod VARCHAR(20),
  unid_cod_unidad VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_dom_estado_oc (
  dmeo_cod_estado NUMERIC,
  dmeo_desc VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_dom_forma_pago (
  dmfp_forma_pago VARCHAR(10),
  dmfd_desc VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_dom_tipo_despacho (
  dmtd_tipo_despacho VARCHAR(10),
  dmtd_desc VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_dom_tipo_moneda (
  dmtm_tipo_moneda VARCHAR(10),
  dmtm_desc VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_dom_tipo_oc (
  dmto_tipo_oc VARCHAR(2),
  dmto_abreviacion VARCHAR(10),
  dmto_desc VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_ordenes_cab (
  orca_sec_id NUMERIC,
  orca_cod_oc VARCHAR(50),
  orca_nombre VARCHAR(255),
  dmeo_cod_estado INTEGER,
  orca_codigo_licitacion VARCHAR(50),
  orca_desc_oc VARCHAR(2000),
  orca_codigo_tipo VARCHAR(80),
  dmto_tipo_oc VARCHAR(2),
  dmtm_tipo_moneda VARCHAR(10),
  orca_cod_estado_proveedor NUMERIC,
  orca_estado_proveedor VARCHAR(255),
  orca_fec_creacion TIMESTAMP WITHOUT TIME ZONE,
  orca_fec_envio TIMESTAMP WITHOUT TIME ZONE,
  orca_fec_aceptacion TIMESTAMP WITHOUT TIME ZONE,
  orca_fec_cancelacion TIMESTAMP WITHOUT TIME ZONE,
  orca_fec_ultima_mod TIMESTAMP WITHOUT TIME ZONE,
  orca_tiene_items VARCHAR(1),
  orca_promedio_calific NUMERIC,
  orca_eval_proveedor NUMERIC,
  orca_descuentos NUMERIC,
  orca_cargos NUMERIC,
  orca_total_neto NUMERIC,
  orca_iva NUMERIC,
  orca_impuestos NUMERIC,
  orca_total_oc NUMERIC,
  orca_financiamiento VARCHAR(255),
  orca_pais VARCHAR(255),
  dmtd_tipo_despacho VARCHAR(3),
  dmfp_forma_pago VARCHAR(3),
  comp_cod VARCHAR(50),
  prov_cod VARCHAR(20),
  orca_total_items NUMERIC,
  orca_version_api VARCHAR(10),
  orca_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  orca_user_ins VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_ordenes_det (
  orde_sec_id NUMERIC,
  orca_sec_id NUMERIC,
  ordet_correlativo NUMERIC,
  ordet_cod_categoria NUMERIC,
  ordet_categoria VARCHAR(400),
  ordet_cod_producto NUMERIC,
  ordet_producto VARCHAR(400),
  ordet_espec_comprador VARCHAR(1000),
  ordet_espec_proveedor VARCHAR(1000),
  ordet_cantidad NUMERIC,
  ordet_unidad VARCHAR(50),
  dmtm_tipo_moneda VARCHAR(10),
  ordet_precio_neto NUMERIC,
  ordet_total_cargos NUMERIC,
  ordet_total_descuentos NUMERIC,
  ordet_total_impuestos NUMERIC,
  ordet_total NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_ordenes_od (
  orod_sec_id NUMERIC,
  orca_sec_id NUMERIC,
  comp_cod VARCHAR(20),
  orod_cod_oc VARCHAR(50),
  orod_fec_sol TIMESTAMP WITHOUT TIME ZONE,
  orod_user_sol VARCHAR(25),
  orod_estado VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_orden_mpu_tb (
  q_name VARCHAR(128),
  msgid BYTEA,
  corrid VARCHAR(128),
  priority NUMERIC,
  state NUMERIC,
  delay TIMESTAMP WITHOUT TIME ZONE,
  expiration NUMERIC,
  time_manager_info TIMESTAMP WITHOUT TIME ZONE,
  local_order_no NUMERIC,
  chain_no NUMERIC,
  cscn NUMERIC,
  dscn NUMERIC,
  enq_time TIMESTAMP WITHOUT TIME ZONE,
  enq_uid VARCHAR(128),
  enq_tid VARCHAR(30),
  deq_time TIMESTAMP WITHOUT TIME ZONE,
  deq_uid VARCHAR(128),
  deq_tid VARCHAR(30),
  retry_count NUMERIC,
  exception_qschema VARCHAR(128),
  exception_queue VARCHAR(128),
  step_no NUMERIC,
  recipient_key NUMERIC,
  dequeue_msgid BYTEA,
  sender_name VARCHAR(128),
  sender_address VARCHAR(1024),
  sender_protocol NUMERIC,
  user_data TEXT,
  user_prop TEXT,
  PRIMARY KEY (msgid)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_orden_od_tb (
  q_name VARCHAR(128),
  msgid BYTEA,
  corrid VARCHAR(128),
  priority NUMERIC,
  state NUMERIC,
  delay TIMESTAMP WITHOUT TIME ZONE,
  expiration NUMERIC,
  time_manager_info TIMESTAMP WITHOUT TIME ZONE,
  local_order_no NUMERIC,
  chain_no NUMERIC,
  cscn NUMERIC,
  dscn NUMERIC,
  enq_time TIMESTAMP WITHOUT TIME ZONE,
  enq_uid VARCHAR(128),
  enq_tid VARCHAR(30),
  deq_time TIMESTAMP WITHOUT TIME ZONE,
  deq_uid VARCHAR(128),
  deq_tid VARCHAR(30),
  retry_count NUMERIC,
  exception_qschema VARCHAR(128),
  exception_queue VARCHAR(128),
  step_no NUMERIC,
  recipient_key NUMERIC,
  dequeue_msgid BYTEA,
  sender_name VARCHAR(128),
  sender_address VARCHAR(1024),
  sender_protocol NUMERIC,
  user_data TEXT,
  user_prop TEXT,
  PRIMARY KEY (msgid)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_param_app (
  paap_codigo VARCHAR(100),
  paap_desc VARCHAR(400),
  paap_valor VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_proveedores (
  prov_cod VARCHAR(20),
  prov_nombre VARCHAR(255),
  prov_actividad VARCHAR(255),
  PRIMARY KEY (prov_cod)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_prov_sucu (
  orca_sec_id NUMERIC,
  prov_cod VARCHAR(20),
  sucu_cod_sucursal VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_reprocesos (
  repr_sec_id NUMERIC,
  repr_sec_proc NUMERIC,
  repr_pauta VARCHAR(50),
  repr_fec_error TIMESTAMP WITHOUT TIME ZONE,
  repr_fec_retoma TIMESTAMP WITHOUT TIME ZONE,
  repr_estado VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_request_orden_mpu_tb (
  q_name VARCHAR(128),
  msgid BYTEA,
  corrid VARCHAR(128),
  priority NUMERIC,
  state NUMERIC,
  delay TIMESTAMP WITHOUT TIME ZONE,
  expiration NUMERIC,
  time_manager_info TIMESTAMP WITHOUT TIME ZONE,
  local_order_no NUMERIC,
  chain_no NUMERIC,
  cscn NUMERIC,
  dscn NUMERIC,
  enq_time TIMESTAMP WITHOUT TIME ZONE,
  enq_uid VARCHAR(128),
  enq_tid VARCHAR(30),
  deq_time TIMESTAMP WITHOUT TIME ZONE,
  deq_uid VARCHAR(128),
  deq_tid VARCHAR(30),
  retry_count NUMERIC,
  exception_qschema VARCHAR(128),
  exception_queue VARCHAR(128),
  step_no NUMERIC,
  recipient_key NUMERIC,
  dequeue_msgid BYTEA,
  sender_name VARCHAR(128),
  sender_address VARCHAR(1024),
  sender_protocol NUMERIC,
  user_data TEXT,
  user_prop TEXT,
  PRIMARY KEY (msgid)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_sucursales (
  prov_cod VARCHAR(20),
  sucu_cod_sucursal VARCHAR(20),
  sucu_nombre_sucursal VARCHAR(255),
  sucu_rut_sucursal VARCHAR(20),
  sucu_direccion VARCHAR(255),
  sucu_comuna VARCHAR(255),
  sucu_region VARCHAR(255),
  sucu_pais VARCHAR(255),
  sucu_nombre_contacto VARCHAR(255),
  sucu_cargo_contacto VARCHAR(255),
  sucu_fono_contacto VARCHAR(255),
  sucu_mail_contacto VARCHAR(255),
  PRIMARY KEY (prov_cod, sucu_cod_sucursal)
);

CREATE TABLE IF NOT EXISTS adm_obs.mpu_unidades (
  comp_cod VARCHAR(20),
  unid_cod_unidad VARCHAR(20),
  unid_rut_unidad VARCHAR(20),
  unid_nombre_unidad VARCHAR(255),
  unid_actividad VARCHAR(255),
  unid_direccion_unidad VARCHAR(255),
  unid_comuna_unidad VARCHAR(255),
  unid_region_unidad VARCHAR(255),
  unid_pais VARCHAR(255),
  unid_nombre_contacto VARCHAR(255),
  unid_cargo_contacto VARCHAR(255),
  unid_fono_contacto VARCHAR(100),
  unid_mail_contacto VARCHAR(50),
  PRIMARY KEY (comp_cod, unid_cod_unidad)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_archivos (
  arch_sec NUMERIC,
  arch_nombre VARCHAR(400),
  plan_sec NUMERIC,
  arch_total_lineas NUMERIC,
  arch_dom_estado_archivo VARCHAR(2),
  arch_fec_carga TIMESTAMP WITHOUT TIME ZONE,
  arch_usr_ing VARCHAR(50),
  arch_checksum VARCHAR(100),
  PRIMARY KEY (arch_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_arch_errores (
  arch_sec NUMERIC,
  arer_cod_error NUMERIC,
  arer_gls_error VARCHAR(500),
  arer_nro_linea NUMERIC,
  arer_linea VARCHAR(4000),
  arer_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  arer_tipo_error INTEGER
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_atributo (
  plan_sec NUMERIC(23, 0),
  atri_nombre VARCHAR(200),
  atri_pos INTEGER,
  atri_desc VARCHAR(200),
  PRIMARY KEY (plan_sec, atri_nombre)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_carpetas_rem (
  care_sec NUMERIC(23, 0),
  care_nombre VARCHAR(20),
  care_estado VARCHAR(10),
  care_user_ing VARCHAR(50),
  care_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  care_user_mod VARCHAR(50),
  care_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (care_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_certificado (
  cert_sec NUMERIC(23, 0),
  unid_codigo VARCHAR(5),
  cert_cod_certificado VARCHAR(6),
  cert_nombre_paciente VARCHAR(100),
  cert_paterno_paciente VARCHAR(100),
  cert_materno_paciente VARCHAR(100),
  cert_rut NUMERIC,
  cert_dv VARCHAR(1),
  cert_dias NUMERIC,
  cert_fecha_desde TIMESTAMP WITHOUT TIME ZONE,
  cert_fecha_hasta TIMESTAMP WITHOUT TIME ZONE,
  cert_fecha_impresion TIMESTAMP WITHOUT TIME ZONE,
  cert_user_ing VARCHAR(50),
  cert_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  cert_user_mod VARCHAR(50),
  cert_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  cert_cod_verif VARCHAR(12),
  cert_html BYTEA,
  cert_correo_paciente VARCHAR(100),
  cert_dni VARCHAR(50),
  PRIMARY KEY (cert_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_certificado_eleccion (
  ceel_sec NUMERIC(23, 0),
  unid_codigo VARCHAR(5),
  ceel_cod_certificado VARCHAR(6),
  ceel_nombre_paciente VARCHAR(100),
  ceel_paterno_paciente VARCHAR(100),
  ceel_materno_paciente VARCHAR(100),
  ceel_rut_paciente BIGINT,
  ceel_dv_paciente VARCHAR(1),
  ceel_fecha_registro TIMESTAMP WITHOUT TIME ZONE,
  ceel_fecha_impresion TIMESTAMP WITHOUT TIME ZONE,
  ceel_cod_verif VARCHAR(12),
  ceel_html BYTEA,
  ceel_rut_cuidador NUMERIC,
  ceel_dv_cuidador VARCHAR(1),
  ceel_nombre_cuidador VARCHAR(100),
  ceel_paterno_cuidador VARCHAR(100),
  ceel_materno_cuidador VARCHAR(100),
  ceel_medico VARCHAR(300),
  ceel_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  ceel_user_ing VARCHAR(50),
  ceel_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  ceel_user_mod VARCHAR(50),
  PRIMARY KEY (ceel_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_datos_solicitud (
  daso_sec NUMERIC(23, 0),
  daso_tipo_docto VARCHAR(30),
  daso_rut BIGINT,
  daso_dv VARCHAR(1),
  daso_pasaporte VARCHAR(100),
  daso_nombre VARCHAR(100),
  daso_ape_pat VARCHAR(60),
  daso_ape_mat VARCHAR(60),
  daso_celular VARCHAR(15),
  daso_email VARCHAR(100),
  depa_sec NUMERIC(23, 0),
  daso_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  daho_hora VARCHAR(10),
  detr_sec NUMERIC(23, 0),
  daso_flag_envio_wsp VARCHAR(1),
  daso_flag_envio_email VARCHAR(1),
  daso_fec_envio_wsp TIMESTAMP WITHOUT TIME ZONE,
  daso_fec_envio_email TIMESTAMP WITHOUT TIME ZONE,
  daso_id_unico VARCHAR(32),
  daso_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  daso_estado VARCHAR(30),
  daso_observ VARCHAR(4000),
  PRIMARY KEY (daso_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_hora_solicitud (
  daho_nro INTEGER,
  daho_hora VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_investigadores (
  obin_id_invg VARCHAR(10),
  obts_sec NUMERIC(23, 0),
  obin_estado VARCHAR(10),
  obin_user_ing VARCHAR(50),
  obin_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  obin_user_mod VARCHAR(50),
  obin_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_mail_destinatario (
  made_sec NUMERIC(23, 0),
  rut_usuario NUMERIC(23, 0),
  correo VARCHAR(100),
  made_esta_remi VARCHAR(10),
  made_user_ing VARCHAR(50),
  made_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  made_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  made_user_mod VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_menu (
  menu_id NUMERIC,
  menu_desc VARCHAR(50),
  menu_id_padre NUMERIC,
  PRIMARY KEY (menu_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_menu_detalle (
  mede_id NUMERIC,
  menu_id NUMERIC,
  mede_desc VARCHAR(60),
  mede_label VARCHAR(60),
  mede_link VARCHAR(50),
  mede_ayuda VARCHAR(100),
  mede_target VARCHAR(50),
  mede_pos_padre NUMERIC,
  mede_pos_aplic NUMERIC,
  mede_icono VARCHAR(400),
  mede_usuario_ins VARCHAR(20),
  mede_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (mede_id, menu_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_parametros (
  para_codigo VARCHAR(50),
  para_desc VARCHAR(100),
  para_valor VARCHAR(2000),
  PRIMARY KEY (para_codigo)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_perfil_usuario (
  peu_sec NUMERIC(23, 0),
  usme_usuario NUMERIC,
  usme_menu VARCHAR(50),
  peu_fecha_ingreso TIMESTAMP WITHOUT TIME ZONE,
  peus_guardar VARCHAR(1),
  peus_eliminar VARCHAR(1),
  peus_editar VARCHAR(1),
  peus_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  peus_user_mod VARCHAR(50),
  PRIMARY KEY (peu_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_plantilla (
  plan_sec NUMERIC(23, 0),
  tipo_sec NUMERIC(23, 0),
  plan_nombre VARCHAR(200),
  PRIMARY KEY (plan_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_ref_codes (
  ref_dom VARCHAR(100),
  ref_low_val VARCHAR(240),
  ref_hig_val VARCHAR(240),
  ref_abr VARCHAR(240),
  ref_mng VARCHAR(240),
  ref_agr VARCHAR(2),
  ref_mod VARCHAR(2),
  PRIMARY KEY (ref_dom, ref_low_val)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_rela_unidire (
  unid_codigo VARCHAR(5),
  reud_rut NUMERIC,
  reud_dv VARCHAR(1),
  reud_nombre VARCHAR(100),
  reud_apellido_paterno VARCHAR(100),
  reud_apellido_materno VARCHAR(100),
  reud_firma BYTEA,
  PRIMARY KEY (unid_codigo, reud_rut)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_rem_log (
  relo_sec NUMERIC(23, 0),
  reem_sec NUMERIC(23, 0),
  care_sec NUMERIC(23, 0),
  sure_sec NUMERIC(23, 0),
  reem_ruta VARCHAR(50),
  unid_codigo VARCHAR(5),
  reem_observaciones VARCHAR(500),
  reem_estado VARCHAR(10),
  reem_user_ing VARCHAR(50),
  reem_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  reem_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  reem_user_mod VARCHAR(50),
  reem_nombre_archivo VARCHAR(250),
  reem_nombre_archivo_int VARCHAR(250),
  reem_observaciones_mod VARCHAR(500),
  reem_estado_fin VARCHAR(10),
  made_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_reportes_estadisticas_mensual (
  reem_sec NUMERIC(23, 0),
  care_sec NUMERIC(23, 0),
  sure_sec NUMERIC(23, 0),
  reem_ruta VARCHAR(50),
  unid_codigo VARCHAR(5),
  reem_observaciones VARCHAR(500),
  reem_estado VARCHAR(10),
  reem_user_ing VARCHAR(50),
  reem_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  reem_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  reem_user_mod VARCHAR(50),
  reem_nombre_archivo VARCHAR(250),
  reem_nombre_archivo_int VARCHAR(250),
  reem_observaciones_mod VARCHAR(500),
  reem_estado_fin VARCHAR(10),
  made_sec NUMERIC(23, 0),
  PRIMARY KEY (reem_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_reporte_epidem_tmp (
  reep_sec NUMERIC,
  reep_semana NUMERIC,
  reep_tipo_seguimiento VARCHAR(10),
  reep_cantidad NUMERIC,
  reep_user_ing VARCHAR(10),
  reep_fec_ing TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_rep_rrhh (
  rerr_sec NUMERIC,
  rerr_regi_fecha TIMESTAMP WITHOUT TIME ZONE,
  cont_cod VARCHAR(15),
  rerr_user_ing VARCHAR(50),
  rerr_fec_ing TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_rep_rrhh_det (
  rerr_sec NUMERIC,
  rerd_sec NUMERIC,
  esmi_cate VARCHAR(1),
  esmi_cod VARCHAR(15),
  esmi_nomb VARCHAR(100),
  e1 NUMERIC,
  e2 NUMERIC,
  e3 NUMERIC,
  e4 NUMERIC,
  e5 NUMERIC,
  e6 NUMERIC,
  e7 NUMERIC,
  e8 NUMERIC,
  e9 NUMERIC,
  e10 NUMERIC,
  e11 NUMERIC,
  e12 NUMERIC,
  e13 NUMERIC,
  e14 NUMERIC,
  rerd_tipo_bloque VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_rep_rrhh_res (
  rerr_sec NUMERIC,
  rrrr_sec NUMERIC,
  esmi_cate VARCHAR(100),
  esmi_cod VARCHAR(100),
  esmi_nomb VARCHAR(100),
  tf01 VARCHAR(200),
  tf02 VARCHAR(200),
  tf03 VARCHAR(200),
  tf04 VARCHAR(200),
  tf05 VARCHAR(200),
  tf06 VARCHAR(200),
  tf07 VARCHAR(200),
  tf08 VARCHAR(200),
  tf09 VARCHAR(200),
  tf10 VARCHAR(200),
  tf11 VARCHAR(200),
  tf12 VARCHAR(200),
  tf13 VARCHAR(200),
  tf14 VARCHAR(200),
  op01 VARCHAR(200),
  op02 VARCHAR(200),
  op03 VARCHAR(200),
  op04 VARCHAR(200),
  op05 VARCHAR(200),
  op06 VARCHAR(200),
  op07 VARCHAR(200),
  op08 VARCHAR(200),
  op09 VARCHAR(200),
  op10 VARCHAR(200),
  op11 VARCHAR(200),
  op12 VARCHAR(200),
  op13 VARCHAR(200),
  op14 VARCHAR(200),
  fl01 VARCHAR(200),
  fl02 VARCHAR(200),
  fl03 VARCHAR(200),
  fl04 VARCHAR(200),
  fl05 VARCHAR(200),
  fl06 VARCHAR(200),
  fl07 VARCHAR(200),
  fl08 VARCHAR(200),
  fl09 VARCHAR(200),
  fl10 VARCHAR(200),
  fl11 VARCHAR(200),
  fl12 VARCHAR(200),
  fl13 VARCHAR(200),
  fl14 VARCHAR(200),
  lm01 VARCHAR(200),
  lm02 VARCHAR(200),
  lm03 VARCHAR(200),
  lm04 VARCHAR(200),
  lm05 VARCHAR(200),
  lm06 VARCHAR(200),
  lm07 VARCHAR(200),
  lm08 VARCHAR(200),
  lm09 VARCHAR(200),
  lm10 VARCHAR(200),
  lm11 VARCHAR(200),
  lm12 VARCHAR(200),
  lm13 VARCHAR(200),
  lm14 VARCHAR(200),
  dp01 VARCHAR(200),
  dp02 VARCHAR(200),
  dp03 VARCHAR(200),
  dp04 VARCHAR(200),
  dp05 VARCHAR(200),
  dp06 VARCHAR(200),
  dp07 VARCHAR(200),
  dp08 VARCHAR(200),
  dp09 VARCHAR(200),
  dp10 VARCHAR(200),
  dp11 VARCHAR(200),
  dp12 VARCHAR(200),
  dp13 VARCHAR(200),
  dp14 VARCHAR(200),
  ce01 VARCHAR(200),
  ce02 VARCHAR(200),
  ce03 VARCHAR(200),
  ce04 VARCHAR(200),
  ce05 VARCHAR(200),
  ce06 VARCHAR(200),
  ce07 VARCHAR(200),
  ce08 VARCHAR(200),
  ce09 VARCHAR(200),
  ce10 VARCHAR(200),
  ce11 VARCHAR(200),
  ce12 VARCHAR(200),
  ce13 VARCHAR(200),
  ce14 VARCHAR(200),
  ec01 VARCHAR(200),
  ec02 VARCHAR(200),
  ec03 VARCHAR(200),
  ec04 VARCHAR(200),
  ec05 VARCHAR(200),
  ec06 VARCHAR(200),
  ec07 VARCHAR(200),
  ec08 VARCHAR(200),
  ec09 VARCHAR(200),
  ec10 VARCHAR(200),
  ec11 VARCHAR(200),
  ec12 VARCHAR(200),
  ec13 VARCHAR(200),
  ec14 VARCHAR(200),
  gr01 VARCHAR(200),
  gr02 VARCHAR(200),
  gr03 VARCHAR(200),
  gr04 VARCHAR(200),
  gr05 VARCHAR(200),
  gr06 VARCHAR(200),
  gr07 VARCHAR(200),
  gr08 VARCHAR(200),
  gr09 VARCHAR(200),
  gr10 VARCHAR(200),
  gr11 VARCHAR(200),
  gr12 VARCHAR(200),
  gr13 VARCHAR(200),
  gr14 VARCHAR(200),
  tt01 VARCHAR(200),
  tt02 VARCHAR(200),
  tt03 VARCHAR(200),
  tt04 VARCHAR(200),
  tt05 VARCHAR(200),
  tt06 VARCHAR(200),
  tt07 VARCHAR(200),
  tt08 VARCHAR(200),
  tt09 VARCHAR(200),
  tt10 VARCHAR(200),
  tt11 VARCHAR(200),
  tt12 VARCHAR(200),
  tt13 VARCHAR(200),
  tt14 VARCHAR(200),
  jp01 VARCHAR(200),
  jp02 VARCHAR(200),
  jp03 VARCHAR(200),
  jp04 VARCHAR(200),
  jp05 VARCHAR(200),
  jp06 VARCHAR(200),
  jp07 VARCHAR(200),
  jp08 VARCHAR(200),
  jp09 VARCHAR(200),
  jp10 VARCHAR(200),
  jp11 VARCHAR(200),
  jp12 VARCHAR(200),
  jp13 VARCHAR(200),
  jp14 VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_subcarpetas_rem (
  sure_sec NUMERIC(23, 0),
  sure_nombre VARCHAR(30),
  sure_estado VARCHAR(10),
  sure_user_ing VARCHAR(50),
  sure_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  sure_user_mod VARCHAR(50),
  sure_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (sure_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_sucursal_cmds (
  sucm_sec NUMERIC(23, 0),
  sucm_sucursal VARCHAR(60),
  sucm_direccion VARCHAR(100),
  sucm_cnt_modulo INTEGER,
  sucm_min_intervalo INTEGER,
  sucm_bloq_1_ini INTEGER,
  sucm_bloq_1_fin INTEGER,
  sucm_bloq_2_ini INTEGER,
  sucm_bloq_2_fin INTEGER,
  sucm_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  sucm_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  sucm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  sucm_user_ing VARCHAR(30),
  sucm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  sucm_user_mod VARCHAR(30),
  PRIMARY KEY (sucm_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_tipo (
  tipo_sec NUMERIC(23, 0),
  tipo_nombre VARCHAR(200),
  tipo_tabla_bd VARCHAR(200),
  tipo_reg VARCHAR(100),
  PRIMARY KEY (tipo_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_tmp_trazabilidad_covid (
  ttc_arch_sec NUMERIC(23, 0),
  ttc_sec NUMERIC(23, 0),
  ttc_nro_linea BIGINT,
  ttc_numero_folio VARCHAR(20),
  ttc_folio_indice VARCHAR(23),
  ttc_trazado_socialmente VARCHAR(2),
  ttc_fec_notificacion TIMESTAMP WITHOUT TIME ZONE,
  ttc_fec_ini_cuarentena TIMESTAMP WITHOUT TIME ZONE,
  ttc_fec_ter_cuarentena TIMESTAMP WITHOUT TIME ZONE,
  ttc_etapa_clinica VARCHAR(12),
  ttc_establec_salud VARCHAR(100),
  ttc_tipo_id VARCHAR(50),
  ttc_id_paciente VARCHAR(50),
  ttc_dv_paciente VARCHAR(1),
  ttc_nombres_paciente VARCHAR(60),
  ttc_ape_pat_paciente VARCHAR(60),
  ttc_ape_mat_paciente VARCHAR(60),
  ttc_genero VARCHAR(10),
  ttc_fec_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  ttc_edad VARCHAR(10),
  ttc_embarazo VARCHAR(1),
  ttc_sem_gesta NUMERIC,
  ttc_prevision VARCHAR(15),
  ttc_nacionalidad VARCHAR(100),
  ttc_via_residencia VARCHAR(8),
  ttc_direccion VARCHAR(100),
  ttc_num_residencia VARCHAR(50),
  ttc_num_depto VARCHAR(100),
  ttc_poblacion_villa VARCHAR(100),
  ttc_comuna_residencia VARCHAR(50),
  ttc_telefono_celular VARCHAR(15),
  ttc_correo VARCHAR(100),
  ttc_fec_primer_sintomas TIMESTAMP WITHOUT TIME ZONE,
  ttc_antece_viaje_intl VARCHAR(8),
  ttc_viaje_extranjero VARCHAR(8),
  ttc_fec_toma_muestra TIMESTAMP WITHOUT TIME ZONE,
  ttc_cant_contactos NUMERIC,
  ttc_comorbilidad VARCHAR(100),
  ttc_ce_sintomaticos VARCHAR(100),
  ttc_contactado VARCHAR(2),
  ttc_tipo_contacto VARCHAR(100),
  ttc_parentesco VARCHAR(50),
  ttc_observaciones VARCHAR(150),
  ttc_lic_medica VARCHAR(200),
  ttc_fecha_recepcion TIMESTAMP WITHOUT TIME ZONE,
  ttc_hora_recepcion VARCHAR(10),
  ttc_tipo_seguimiento VARCHAR(10),
  ttc_contactos_por_caso NUMERIC,
  ttc_cesfam VARCHAR(15),
  ttc_sector VARCHAR(6),
  ttc_num_id VARCHAR(10),
  ttc_estado_seguimiento VARCHAR(50),
  ttc_sintomas VARCHAR(1000),
  ttc_suspendido VARCHAR(30),
  ttc_n_ce NUMERIC,
  ttc_seguidor VARCHAR(15),
  ttc_linea VARCHAR(4000),
  ttc_estado_linea VARCHAR(3),
  ttc_correlativo NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_tramites_dptos (
  detr_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  detr_tramite VARCHAR(100),
  detr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  detr_user_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_trazabilidad (
  obtr_folio VARCHAR(23),
  obtr_folio_indice VARCHAR(23),
  obtr_fecha_notificacion TIMESTAMP WITHOUT TIME ZONE,
  obtr_hora_notificacion VARCHAR(5),
  obtr_fecha_inicio_cuarentena TIMESTAMP WITHOUT TIME ZONE,
  obtr_fecha_fin_cuarentena TIMESTAMP WITHOUT TIME ZONE,
  obtr_etapa_clinica VARCHAR(15),
  obtr_tipo_identificacion VARCHAR(50),
  obtr_id_paciente VARCHAR(50),
  obtr_dv_paciente VARCHAR(1),
  obtr_nombres VARCHAR(60),
  obtr_app_paterno VARCHAR(60),
  obtr_app_materno VARCHAR(60),
  obtr_genero VARCHAR(2),
  obtr_edad_paciente NUMERIC(23, 0),
  obtr_dire_paciente VARCHAR(150),
  obtr_comuna VARCHAR(60),
  obtr_telefono VARCHAR(15),
  obtr_trazador VARCHAR(100),
  obtr_seguidor VARCHAR(100),
  obtr_trazado VARCHAR(2),
  obtr_tipo_seguimiento VARCHAR(10),
  obtr_user_ing VARCHAR(50),
  obtr_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  obtr_user_mod VARCHAR(50),
  obtr_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  obtr_unidad VARCHAR(3),
  obtr_sec_sector NUMERIC,
  obtr_confirmado VARCHAR(2),
  obtr_fecha_confirm TIMESTAMP WITHOUT TIME ZONE,
  obtr_usuario_confirm VARCHAR(10),
  obtr_estado_invg VARCHAR(10),
  obtr_ind_cronico VARCHAR(2),
  obtr_establ_salud VARCHAR(100),
  obtr_embarazo VARCHAR(2),
  obtr_sem_gesta VARCHAR(10),
  obtr_prevision VARCHAR(15),
  obtr_nacionalidad VARCHAR(50),
  obtr_via_residencia VARCHAR(10),
  obtr_num_residencia VARCHAR(50),
  obtr_fec_primer_sintoma TIMESTAMP WITHOUT TIME ZONE,
  obtr_antece_viaje_intl VARCHAR(8),
  obtr_viaje_extranjero VARCHAR(2),
  obtr_fec_toma_muestra TIMESTAMP WITHOUT TIME ZONE,
  obtr_cant_contactos NUMERIC,
  obtr_fec_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  obtr_poblacion_villa VARCHAR(100),
  obtr_es_contacto VARCHAR(2),
  arch_sec NUMERIC(23, 0),
  obtr_cer_ter VARCHAR(2),
  obtr_num_cer VARCHAR(100),
  obtr_nivel VARCHAR(2),
  obtr_correo VARCHAR(100),
  obtr_derivado VARCHAR(2),
  obtr_observacion_deri VARCHAR(500),
  obtr_correlativo NUMERIC(23, 0),
  obtr_obs_cronico VARCHAR(4000),
  PRIMARY KEY (obtr_folio, obtr_tipo_seguimiento)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_trazabilidad_mov (
  obtrm_sec NUMERIC(23, 0),
  obtre_sec NUMERIC(23, 0),
  obtm_contacto VARCHAR(2),
  obtm_tipo_contacto VARCHAR(10),
  obtm_observacion VARCHAR(500),
  obtm_user_ing VARCHAR(50),
  obtm_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  obtm_user_mod VARCHAR(50),
  obtm_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  obtr_seguidor VARCHAR(10),
  obtre_triage VARCHAR(2),
  obtre_tipo_operacion VARCHAR(2),
  obtm_situacion VARCHAR(2),
  obtm_estado VARCHAR(2),
  obtm_estamento VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_trazabilidad_respon (
  obtre_sec NUMERIC,
  obtr_folio VARCHAR(23),
  obtre_num_dia NUMERIC,
  obtr_fecha_notificacion TIMESTAMP WITHOUT TIME ZONE,
  obtre_estado VARCHAR(10),
  obtre_user_ing VARCHAR(50),
  obtre_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  obtre_user_mod VARCHAR(50),
  obtre_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  obtr_tipo_seguimiento VARCHAR(10),
  PRIMARY KEY (obtre_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_traza_mov_accion (
  obtma_sec NUMERIC(23, 0),
  obtrm_sec NUMERIC(23, 0),
  obtma_tipo_accion VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_traza_mov_proc (
  obtmp_sec NUMERIC(23, 0),
  obtrm_sec NUMERIC(23, 0),
  obtmp_tipo_proc VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_traza_sector (
  obts_sec NUMERIC(23, 0),
  obts_descripcion VARCHAR(50),
  obts_tipo_seguimiento VARCHAR(10),
  obts_estado VARCHAR(10),
  obts_user_ing VARCHAR(50),
  obts_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  obts_user_mod VARCHAR(50),
  obts_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_traza_sector_encargado (
  obtse_sec NUMERIC(23, 0),
  obts_sec NUMERIC(23, 0),
  obtse_id_encargado VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_traza_unidades (
  obtu_codigo_unidad VARCHAR(3),
  obtu_descripcion VARCHAR(50),
  obtu_estado VARCHAR(10),
  obtu_user_ing VARCHAR(50),
  obtu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  obtu_user_mod VARCHAR(50),
  obtu_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_users_admin (
  usad_rut BIGINT,
  PRIMARY KEY (usad_rut)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_user_menu (
  usme_usuario NUMERIC,
  usme_menu VARCHAR(50),
  PRIMARY KEY (usme_usuario, usme_menu)
);

CREATE TABLE IF NOT EXISTS adm_obs.obs_usuarios (
  usme_usuario NUMERIC,
  unid_codigo VARCHAR(5),
  sect_sec NUMERIC,
  usme_user_ing VARCHAR(50),
  usme_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  usme_user_mod VARCHAR(50),
  usme_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usme_usuario, sect_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos (
  adju_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  adju_nombre VARCHAR(100),
  adju_user_ing VARCHAR(50),
  adju_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  adju_user_mod VARCHAR(50),
  adju_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  adju_nombre_inte VARCHAR(500),
  adju_ruta VARCHAR(2000),
  PRIMARY KEY (adju_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_230711 (
  adju_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  adju_nombre VARCHAR(100),
  adju_user_ing VARCHAR(50),
  adju_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  adju_user_mod VARCHAR(50),
  adju_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_aud (
  adju_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  adju_nombre VARCHAR(100),
  adju_user_ing VARCHAR(50),
  adju_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  adju_user_mod VARCHAR(50),
  adju_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  adju_nombre_inte VARCHAR(500),
  adju_ruta VARCHAR(2000),
  alau_usuario VARCHAR(50),
  alau_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_bkp_0307202 (
  adju_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  adju_nombre VARCHAR(100),
  adju_user_ing VARCHAR(50),
  adju_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  adju_user_mod VARCHAR(50),
  adju_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  adju_nombre_inte VARCHAR(500),
  adju_ruta VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_imagen (
  adim_sec NUMERIC(23, 0),
  adju_sec NUMERIC(23, 0),
  adim_docu BYTEA,
  adim_docu_nombre VARCHAR(400),
  PRIMARY KEY (adim_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_imagen_230711 (
  adim_sec NUMERIC(23, 0),
  adju_sec NUMERIC(23, 0),
  adim_docu BYTEA
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_imagen_bkp_0307202 (
  adim_sec NUMERIC(23, 0),
  adju_sec NUMERIC(23, 0),
  adim_docu BYTEA,
  adim_docu_nombre VARCHAR(400)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_log (
  adju_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  adju_nombre VARCHAR(100),
  adju_user_ing VARCHAR(50),
  adju_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  adju_user_mod VARCHAR(50),
  adju_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  adju_nombre_inte VARCHAR(500),
  adju_ruta VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_log_aud (
  adju_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  adju_nombre VARCHAR(100),
  adju_user_ing VARCHAR(50),
  adju_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  adju_user_mod VARCHAR(50),
  adju_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  adju_nombre_inte VARCHAR(500),
  adju_ruta VARCHAR(2000),
  alau_usuario VARCHAR(50),
  alau_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_log_bkp_0307202 (
  adju_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  adju_nombre VARCHAR(100),
  adju_user_ing VARCHAR(50),
  adju_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  adju_user_mod VARCHAR(50),
  adju_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  adju_nombre_inte VARCHAR(500),
  adju_ruta VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_orden_servicio (
  aose_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  aose_nombre VARCHAR(100),
  aose_nombre_int VARCHAR(500),
  aose_ruta VARCHAR(2000),
  aose_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  aose_user_ing VARCHAR(20),
  aose_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  aose_user_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_orden_servicio_aud (
  aose_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  aose_nombre VARCHAR(100),
  aose_nombre_int VARCHAR(500),
  aose_ruta VARCHAR(2000),
  aose_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  aose_user_ing VARCHAR(20),
  aose_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  aose_user_mod VARCHAR(20),
  aoud_usuario VARCHAR(50),
  aoud_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_orden_servicio_bkp_0307202 (
  aose_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  aose_nombre VARCHAR(100),
  aose_nombre_int VARCHAR(500),
  aose_ruta VARCHAR(2000),
  aose_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  aose_user_ing VARCHAR(20),
  aose_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  aose_user_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_orse_log (
  aose_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  aose_nombre VARCHAR(100),
  aose_nombre_int VARCHAR(500),
  aose_ruta VARCHAR(2000),
  aose_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  aose_user_ing VARCHAR(20),
  aose_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  aose_user_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_orse_log_aud (
  aose_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  aose_nombre VARCHAR(100),
  aose_nombre_int VARCHAR(500),
  aose_ruta VARCHAR(2000),
  aose_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  aose_user_ing VARCHAR(20),
  aose_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  aose_user_mod VARCHAR(20),
  olud_usuario VARCHAR(50),
  olud_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_adjuntos_orse_log_bkp_0307202 (
  aose_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  aose_nombre VARCHAR(100),
  aose_nombre_int VARCHAR(500),
  aose_ruta VARCHAR(2000),
  aose_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  aose_user_ing VARCHAR(20),
  aose_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  aose_user_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_correo_saliente (
  cosa_serv_smtp VARCHAR(30),
  cosa_mail VARCHAR(100),
  cosa_pass VARCHAR(1000),
  cosa_puerto VARCHAR(4),
  cosa_puerto_salida VARCHAR(6),
  cosa_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_destinatarios (
  dest_sec NUMERIC(23, 0),
  dest_nombre VARCHAR(300),
  dest_area VARCHAR(50),
  dest_user_ing VARCHAR(50),
  dest_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  dest_user_mod VARCHAR(50),
  dest_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  dest_nombre_ref VARCHAR(200),
  dest_mail VARCHAR(50),
  dest_rut VARCHAR(15),
  dest_dv VARCHAR(1),
  depa_sec NUMERIC(23, 0),
  dest_estado VARCHAR(10),
  dest_ind_reenvio VARCHAR(2),
  PRIMARY KEY (dest_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_destinatarios_230711 (
  dest_sec NUMERIC(23, 0),
  dest_nombre VARCHAR(300),
  dest_area VARCHAR(50),
  dest_user_ing VARCHAR(50),
  dest_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  dest_user_mod VARCHAR(50),
  dest_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  dest_nombre_ref VARCHAR(200),
  dest_mail VARCHAR(50),
  dest_rut VARCHAR(15),
  dest_dv VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_dm_tipo_orden_servicio (
  tios_sec NUMERIC,
  tios_nombre VARCHAR(50),
  tios_principal VARCHAR(1),
  PRIMARY KEY (tios_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_documentos (
  docu_sec NUMERIC(23, 0),
  docu_orden NUMERIC(23, 0),
  docu_nro VARCHAR(100),
  docu_fecha TIMESTAMP WITHOUT TIME ZONE,
  docu_materia VARCHAR(2000),
  docu_tipo_docu VARCHAR(30),
  docu_ult_estado VARCHAR(30),
  docu_remi_sec NUMERIC(23, 0),
  docu_obs VARCHAR(2000),
  docu_user_ing VARCHAR(50),
  docu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  docu_user_mod VARCHAR(50),
  docu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  docu_tipo_docu_ref VARCHAR(100),
  docu_remi_tipo VARCHAR(10),
  docu_privado VARCHAR(2),
  PRIMARY KEY (docu_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_documentos_230711 (
  docu_sec NUMERIC(23, 0),
  docu_orden VARCHAR(30),
  docu_nro VARCHAR(100),
  docu_fecha TIMESTAMP WITHOUT TIME ZONE,
  docu_materia VARCHAR(300),
  docu_tipo_docu VARCHAR(30),
  docu_ult_estado VARCHAR(30),
  remi_sec NUMERIC(23, 0),
  docu_obs VARCHAR(2000),
  docu_user_ing VARCHAR(50),
  docu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  docu_user_mod VARCHAR(50),
  docu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  docu_tipo_docu_ref VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_documentos_aud (
  docu_sec NUMERIC(23, 0),
  docu_orden NUMERIC(23, 0),
  docu_nro VARCHAR(100),
  docu_fecha TIMESTAMP WITHOUT TIME ZONE,
  docu_materia VARCHAR(2000),
  docu_tipo_docu VARCHAR(30),
  docu_ult_estado VARCHAR(30),
  docu_remi_sec NUMERIC(23, 0),
  docu_obs VARCHAR(2000),
  docu_user_ing VARCHAR(50),
  docu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  docu_user_mod VARCHAR(50),
  docu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  docu_tipo_docu_ref VARCHAR(100),
  docu_remi_tipo VARCHAR(10),
  docu_privado VARCHAR(2),
  docu_usuario VARCHAR(50),
  docu_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_documentos_bkp_0307202 (
  docu_sec NUMERIC(23, 0),
  docu_orden NUMERIC(23, 0),
  docu_nro VARCHAR(100),
  docu_fecha TIMESTAMP WITHOUT TIME ZONE,
  docu_materia VARCHAR(300),
  docu_tipo_docu VARCHAR(30),
  docu_ult_estado VARCHAR(30),
  docu_remi_sec NUMERIC(23, 0),
  docu_obs VARCHAR(2000),
  docu_user_ing VARCHAR(50),
  docu_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  docu_user_mod VARCHAR(50),
  docu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  docu_tipo_docu_ref VARCHAR(100),
  docu_remi_tipo VARCHAR(10),
  docu_privado VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_flujo (
  fluj_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  fluj_estado VARCHAR(100),
  fluj_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  dest_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  fluj_observaciones VARCHAR(2000),
  fluj_reenv_sec NUMERIC(23, 0),
  fluj_tipo_reenv VARCHAR(5),
  fluj_tipo_dest VARCHAR(5),
  fluj_user_ing VARCHAR(50),
  fluj_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fluj_user_mod VARCHAR(50),
  fluj_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (fluj_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_flujo_230711 (
  docu_sec NUMERIC(23, 0),
  fluj_estado VARCHAR(100),
  fluj_fecha_ini TIMESTAMP WITHOUT TIME ZONE,
  fluj_fecha_ter TIMESTAMP WITHOUT TIME ZONE,
  dest_sec NUMERIC(23, 0),
  fluj_user_ing VARCHAR(50),
  fluj_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fluj_user_mod VARCHAR(50),
  fluj_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_flujo_aud (
  fluj_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  fluj_estado VARCHAR(100),
  fluj_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  dest_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  fluj_observaciones VARCHAR(2000),
  fluj_reenv_sec NUMERIC(23, 0),
  fluj_tipo_reenv VARCHAR(5),
  fluj_tipo_dest VARCHAR(5),
  fluj_user_ing VARCHAR(50),
  fluj_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fluj_user_mod VARCHAR(50),
  fluj_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  flau_usuario VARCHAR(50),
  flau_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_flujo_bkp_03072024 (
  docu_sec NUMERIC(23, 0),
  fluj_estado VARCHAR(100),
  fluj_fecha_ini TIMESTAMP WITHOUT TIME ZONE,
  fluj_fecha_ter TIMESTAMP WITHOUT TIME ZONE,
  dest_sec NUMERIC(23, 0),
  fluj_user_ing VARCHAR(50),
  fluj_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fluj_user_mod VARCHAR(50),
  fluj_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_gen_nomina (
  peri_sec NUMERIC(23, 0),
  geno_tipo_txt VARCHAR(8),
  geno_fecha_pago TIMESTAMP WITHOUT TIME ZONE,
  geno_registro TEXT,
  nobo_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_mail_to_send (
  mats_sec NUMERIC,
  mats_nombre_from VARCHAR(400),
  mats_from VARCHAR(400),
  mats_to VARCHAR(4000),
  mats_subject VARCHAR(4000),
  mats_msg TEXT,
  PRIMARY KEY (mats_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_materia (
  mate_sec NUMERIC(23, 0),
  mate_nombre VARCHAR(200),
  mate_estado VARCHAR(10),
  mate_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  mate_user_ing VARCHAR(30),
  mate_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  mate_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_mov_documentos (
  modo_sec NUMERIC(23, 0),
  fluj_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  modo_estado VARCHAR(30),
  modo_obs VARCHAR(2000),
  dest_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  modo_tipo_flujo VARCHAR(3),
  modo_user_ing VARCHAR(50),
  modo_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  modo_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  modo_user_mod VARCHAR(50),
  PRIMARY KEY (modo_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_mov_documentos_230711 (
  modo_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  modo_user_ing VARCHAR(50),
  modo_estado VARCHAR(30),
  modo_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  modo_user_mod VARCHAR(50),
  modo_obs VARCHAR(2000),
  modo_accion VARCHAR(6),
  modo_remi_sec NUMERIC(23, 0),
  modo_dest_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_mov_documentos_aud (
  modo_sec NUMERIC(23, 0),
  fluj_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  modo_estado VARCHAR(30),
  modo_obs VARCHAR(2000),
  dest_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  modo_tipo_flujo VARCHAR(3),
  modo_user_ing VARCHAR(50),
  modo_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  modo_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  modo_user_mod VARCHAR(50),
  mdau_usuario VARCHAR(50),
  mdau_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_mov_documentos_bkp_0307202 (
  modo_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  modo_user_ing VARCHAR(50),
  modo_estado VARCHAR(30),
  modo_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  modo_user_mod VARCHAR(50),
  modo_obs VARCHAR(2000),
  modo_accion VARCHAR(6),
  modo_remi_sec NUMERIC(23, 0),
  modo_dest_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_nomina_boletas (
  nobo_sec NUMERIC(23, 0),
  peri_sec NUMERIC,
  nobo_estado VARCHAR(15),
  bono_user VARCHAR(100),
  bono_fecha TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_nomina_boletas_20230315 (
  nobo_sec NUMERIC(23, 0),
  peri_sec NUMERIC,
  nobo_estado VARCHAR(15),
  bono_user VARCHAR(100),
  bono_fecha TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_ofpa_derivados (
  ofde_sec NUMERIC(23, 0),
  fluj_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  fluj_estado VARCHAR(20),
  fluj_observaciones VARCHAR(2000),
  fluj_user_ing VARCHAR(20),
  fluj_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fluj_user_mod VARCHAR(20),
  fluj_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  fluj_tipo_reenv VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_ofpa_derivados_aud (
  ofde_sec NUMERIC(23, 0),
  fluj_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  fluj_estado VARCHAR(20),
  fluj_observaciones VARCHAR(2000),
  fluj_user_ing VARCHAR(20),
  fluj_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fluj_user_mod VARCHAR(20),
  fluj_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  fluj_tipo_reenv VARCHAR(5),
  odau_usuario VARCHAR(50),
  odau_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orden_servicio (
  orse_sec NUMERIC(23, 0),
  orse_doc_sec NUMERIC(23, 0),
  docu_numero VARCHAR(100),
  remi_sec NUMERIC(23, 0),
  orse_estado VARCHAR(30),
  orse_origen VARCHAR(3),
  orse_fecha_envio TIMESTAMP WITHOUT TIME ZONE,
  orse_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  orse_user_ing VARCHAR(30),
  orse_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  orse_user_mod VARCHAR(30),
  orde_descripcion BYTEA,
  orse_ind_rsva VARCHAR(2),
  orse_prioridad VARCHAR(5),
  orse_ind_ofpa NUMERIC,
  tios_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orden_servicio_aud (
  orse_sec NUMERIC(23, 0),
  orse_doc_sec NUMERIC(23, 0),
  docu_numero VARCHAR(100),
  remi_sec NUMERIC(23, 0),
  orse_estado VARCHAR(30),
  orse_origen VARCHAR(3),
  orse_fecha_envio TIMESTAMP WITHOUT TIME ZONE,
  orse_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  orse_user_ing VARCHAR(30),
  orse_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  orse_user_mod VARCHAR(30),
  orde_descripcion BYTEA,
  orse_ind_rsva VARCHAR(2),
  orse_prioridad VARCHAR(5),
  orse_ind_ofpa NUMERIC,
  osud_usuario VARCHAR(50),
  osud_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orden_servicio_bkp_0307202 (
  orse_sec NUMERIC(23, 0),
  orse_doc_sec NUMERIC(23, 0),
  docu_numero VARCHAR(100),
  remi_sec NUMERIC(23, 0),
  orse_estado VARCHAR(30),
  orse_origen VARCHAR(3),
  orse_fecha_envio TIMESTAMP WITHOUT TIME ZONE,
  orse_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  orse_user_ing VARCHAR(30),
  orse_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  orse_user_mod VARCHAR(30),
  orde_descripcion BYTEA
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orden_servicio_mov (
  osmo_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  osmo_estado VARCHAR(20),
  osmo_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  osmo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_ing VARCHAR(20),
  osmo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_mod VARCHAR(20),
  osmo_descripcion BYTEA,
  osmo_sec_deriv NUMERIC(23, 0),
  osmo_tipo_deriv VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orden_servicio_mov_aud (
  osmo_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  osmo_estado VARCHAR(20),
  osmo_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  osmo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_ing VARCHAR(20),
  osmo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_mod VARCHAR(20),
  osmo_descripcion BYTEA,
  osmo_sec_deriv NUMERIC(23, 0),
  osmo_tipo_deriv VARCHAR(5),
  omud_usuario VARCHAR(50),
  omud_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orden_servicio_mov_bkp_0307202 (
  osmo_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  osmo_estado VARCHAR(20),
  osmo_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  osmo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_ing VARCHAR(20),
  osmo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_mod VARCHAR(20),
  osmo_descripcion BYTEA,
  osmo_sec_deriv NUMERIC(23, 0),
  osmo_tipo_deriv VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_derivados (
  osde_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  osmo_sec NUMERIC(23, 0),
  osde_estado VARCHAR(20),
  osde_observaciones BYTEA,
  osde_user_ing VARCHAR(20),
  osde_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osde_user_mod VARCHAR(20),
  osde_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dest_sec NUMERIC(23, 0),
  osde_tipo_deriv VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_derivados_aud (
  osde_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  osmo_sec NUMERIC(23, 0),
  osde_estado VARCHAR(20),
  osde_observaciones BYTEA,
  osde_user_ing VARCHAR(20),
  osde_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osde_user_mod VARCHAR(20),
  osde_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dest_sec NUMERIC(23, 0),
  osde_tipo_deriv VARCHAR(5),
  odud_usuario VARCHAR(50),
  odud_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_derivados_bkp_0307202 (
  osde_sec NUMERIC(23, 0),
  depa_sec NUMERIC(23, 0),
  osmo_sec NUMERIC(23, 0),
  osde_estado VARCHAR(20),
  osde_observaciones BYTEA,
  osde_user_ing VARCHAR(20),
  osde_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osde_user_mod VARCHAR(20),
  osde_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dest_sec NUMERIC(23, 0),
  osde_tipo_deriv VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_materia (
  orse_sec NUMERIC(23, 0),
  mate_sec NUMERIC(23, 0),
  osma_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osma_user_ing VARCHAR(30),
  osma_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osma_user_mod VARCHAR(30),
  PRIMARY KEY (orse_sec, mate_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_materia_aud (
  orse_sec NUMERIC(23, 0),
  mate_sec NUMERIC(23, 0),
  osma_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osma_user_ing VARCHAR(30),
  osma_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osma_user_mod VARCHAR(30),
  omud_usuario VARCHAR(50),
  omud_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_materia_bkp_0307202 (
  orse_sec NUMERIC(23, 0),
  mate_sec NUMERIC(23, 0),
  osma_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osma_user_ing VARCHAR(30),
  osma_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osma_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_mov_log (
  orml_sec NUMERIC(23, 0),
  osmo_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  osmo_estado VARCHAR(20),
  osmo_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  osmo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_ing VARCHAR(20),
  osmo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_mod VARCHAR(20),
  osmo_descripcion BYTEA
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_mov_log_aud (
  orml_sec NUMERIC(23, 0),
  osmo_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  osmo_estado VARCHAR(20),
  osmo_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  osmo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_ing VARCHAR(20),
  osmo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_mod VARCHAR(20),
  osmo_descripcion BYTEA,
  omud_usuario VARCHAR(50),
  omud_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_orse_mov_log_bkp_0307202 (
  orml_sec NUMERIC(23, 0),
  osmo_sec NUMERIC(23, 0),
  orse_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  dest_sec NUMERIC(23, 0),
  osmo_estado VARCHAR(20),
  osmo_fecha_rpta TIMESTAMP WITHOUT TIME ZONE,
  osmo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_ing VARCHAR(20),
  osmo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  osmo_user_mod VARCHAR(20),
  osmo_descripcion BYTEA
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_remitentes (
  remi_sec NUMERIC(23, 0),
  remi_rut VARCHAR(15),
  remi_dv VARCHAR(1),
  remi_razon_social VARCHAR(200),
  remi_tipo VARCHAR(30),
  remi_tel VARCHAR(50),
  remi_contacto VARCHAR(50),
  remi_user_ing VARCHAR(50),
  remi_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  remi_user_mod VARCHAR(50),
  remi_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  remi_razon_social_ref VARCHAR(200),
  remi_mail VARCHAR(50),
  PRIMARY KEY (remi_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_remitentes_230711 (
  remi_sec NUMERIC(23, 0),
  remi_rut VARCHAR(15),
  remi_dv VARCHAR(1),
  remi_razon_social VARCHAR(200),
  remi_tipo VARCHAR(30),
  remi_tel VARCHAR(50),
  remi_contacto VARCHAR(50),
  remi_user_ing VARCHAR(50),
  remi_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  remi_user_mod VARCHAR(50),
  remi_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  remi_razon_social_ref VARCHAR(200),
  remi_mail VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_text_mail (
  tema_tipo VARCHAR(50),
  tema_subject VARCHAR(500),
  tema_cuerpo TEXT,
  PRIMARY KEY (tema_tipo)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_tipo_disponibilidad_ppto (
  dpto_sec NUMERIC(23, 0),
  dpto_id VARCHAR(50),
  dpto_nombre VARCHAR(4000),
  dpto_estado VARCHAR(30),
  dpto_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dpto_user_ing VARCHAR(60),
  dpto_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dpto_user_mod VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_tipo_documentos (
  tido_sec NUMERIC(23, 0),
  tido_tipo_docu VARCHAR(30),
  tido_desc_docu VARCHAR(100),
  tido_ult_estado VARCHAR(2),
  tido_user_ing VARCHAR(50),
  tido_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  tido_user_mod VARCHAR(50),
  tido_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (tido_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_valorados (
  docu_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  valo_neto NUMERIC(16, 2),
  valo_iva NUMERIC(16, 2),
  valo_total NUMERIC(16, 2),
  valo_ind_oc VARCHAR(1),
  valo_oc VARCHAR(30),
  valo_user_ing VARCHAR(50),
  valo_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  valo_user_mod VARCHAR(50),
  valo_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (docu_sec, remi_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_valorados_230711 (
  docu_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  valo_neto NUMERIC(16, 2),
  valo_iva NUMERIC(16, 2),
  valo_total NUMERIC(16, 2),
  valo_ind_oc VARCHAR(1),
  valo_oc VARCHAR(30),
  valo_user_ing VARCHAR(50),
  valo_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  valo_user_mod VARCHAR(50),
  valo_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_valorados_aud (
  docu_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  valo_neto NUMERIC(16, 2),
  valo_iva NUMERIC(16, 2),
  valo_total NUMERIC(16, 2),
  valo_ind_oc VARCHAR(1),
  valo_oc VARCHAR(30),
  valo_user_ing VARCHAR(50),
  valo_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  valo_user_mod VARCHAR(50),
  valo_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  valo_usuario VARCHAR(50),
  valo_fec_delete TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.opa_valorados_bkp_0307202 (
  docu_sec NUMERIC(23, 0),
  remi_sec NUMERIC(23, 0),
  valo_neto NUMERIC(16, 2),
  valo_iva NUMERIC(16, 2),
  valo_total NUMERIC(16, 2),
  valo_ind_oc VARCHAR(1),
  valo_oc VARCHAR(30),
  valo_user_ing VARCHAR(50),
  valo_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  valo_user_mod VARCHAR(50),
  valo_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_archivos_ot (
  arot_sec_id NUMERIC,
  ortr_id NUMERIC,
  arot_logico VARCHAR(400),
  arot_fisico VARCHAR(400),
  arot_tamanio NUMERIC,
  arot_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  arot_usuario_ins VARCHAR(50),
  PRIMARY KEY (arot_sec_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_contratistas (
  cont_rut NUMERIC,
  cont_dv VARCHAR(1),
  cont_razon_social VARCHAR(200),
  cont_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  cont_user_ins VARCHAR(20),
  cont_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  cont_user_upd VARCHAR(20),
  PRIMARY KEY (cont_rut)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_dom_estados_ot (
  doeo_id NUMERIC,
  doeo_estado VARCHAR(50),
  PRIMARY KEY (doeo_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_dom_tipo_ot (
  doto_id NUMERIC,
  doto_desc VARCHAR(50),
  PRIMARY KEY (doto_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_dom_ubicaciones (
  doub_id INTEGER,
  doub_lugar VARCHAR(50),
  PRIMARY KEY (doub_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_financiamiento (
  fina_id NUMERIC,
  sect_sec NUMERIC,
  tifi_sec NUMERIC,
  fina_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  fina_user_ins VARCHAR(20),
  fina_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  fina_user_upd VARCHAR(20),
  PRIMARY KEY (fina_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_items_contratista (
  cont_rut NUMERIC,
  itse_id NUMERIC,
  itco_precio_neto NUMERIC,
  itco_iva NUMERIC,
  itco_precio_bruto NUMERIC,
  itco_anio NUMERIC,
  itco_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  itco_user_ins VARCHAR(20),
  itco_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  itco_user_upd VARCHAR(20),
  PRIMARY KEY (cont_rut, itse_id, itco_anio)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_item_servicio (
  itse_id NUMERIC,
  itse_codigo VARCHAR(20),
  itse_nombre VARCHAR(50),
  itse_desc VARCHAR(500),
  itse_unidad VARCHAR(50),
  itse_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  itse_user_ins VARCHAR(20),
  itse_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  itse_user_upd VARCHAR(20),
  PRIMARY KEY (itse_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_orden_trabajo (
  ortr_id NUMERIC,
  zona_id NUMERIC,
  ortr_monto_neto NUMERIC,
  ortr_iva NUMERIC,
  ortr_monto_bruto NUMERIC,
  doeo_id NUMERIC,
  ortra_anio NUMERIC,
  ortra_fec_cre TIMESTAMP WITHOUT TIME ZONE,
  usot_rut NUMERIC,
  ortr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  ortr_user_ins VARCHAR(20),
  ortr_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  ortr_user_upd VARCHAR(20),
  doto_id NUMERIC,
  ortr_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  ortr_fec_ter TIMESTAMP WITHOUT TIME ZONE,
  ortr_obs VARCHAR(500),
  PRIMARY KEY (ortr_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_orden_trabajo_det (
  ortd_id NUMERIC,
  ortr_id NUMERIC,
  zoun_id NUMERIC,
  itse_id NUMERIC,
  ortd_cantidad NUMERIC,
  ortd_precio_neto NUMERIC,
  ortd_iva NUMERIC,
  ortd_precio_bruto NUMERIC,
  ortd_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  ortd_user_ins VARCHAR(20),
  ortd_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  ortd_user_upd VARCHAR(20),
  PRIMARY KEY (ortd_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_tmp_paso1 (
  cont_rut NUMERIC,
  codigo VARCHAR(20),
  item VARCHAR(50),
  monto NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_tmp_paso2 (
  cont_rut NUMERIC,
  zona NUMERIC,
  codigo VARCHAR(20),
  monto VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_tmp_paso3 (
  cont_rut NUMERIC,
  zona NUMERIC,
  codigo VARCHAR(20),
  ubicacion NUMERIC,
  fian NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_usuarios_ot (
  usot_rut NUMERIC,
  usot_dv VARCHAR(1),
  usot_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usot_user_ins VARCHAR(20),
  PRIMARY KEY (usot_rut)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_usuarios_sector (
  usot_rut NUMERIC,
  sect_sec NUMERIC,
  usse_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usse_user_ins VARCHAR(20),
  PRIMARY KEY (usot_rut, sect_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_zonas (
  zona_id NUMERIC,
  sect_sec NUMERIC,
  zona_num INTEGER,
  cont_rut NUMERIC,
  doub_id INTEGER,
  zona_monto_neto NUMERIC,
  zona_iva NUMERIC,
  zona_monto_bruto NUMERIC,
  zona_anio NUMERIC,
  zona_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  zona_user_ins VARCHAR(20),
  zona_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  zona_user_upd VARCHAR(20),
  PRIMARY KEY (zona_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.otr_zona_unidad (
  zoun_id NUMERIC,
  zona_id NUMERIC,
  unid_sec NUMERIC,
  fina_id NUMERIC,
  zoun_monto_neto NUMERIC,
  zoun_iva NUMERIC,
  zoun_monto_bruto NUMERIC,
  zoun_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  zoun_user_ins VARCHAR(20),
  zoun_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  zoun_user_upd VARCHAR(20),
  PRIMARY KEY (zoun_id)
);

CREATE TABLE IF NOT EXISTS adm_obs.registro (
  regi_sec NUMERIC,
  regi_fecha TIMESTAMP WITHOUT TIME ZONE,
  esta_cod VARCHAR(15),
  esmi_cod VARCHAR(15),
  cont_cod VARCHAR(15),
  regi_total_func NUMERIC(23, 0),
  regi_func_o NUMERIC(23, 0),
  regi_func_fl NUMERIC(23, 0),
  regi_func_lm NUMERIC(23, 0),
  regi_func_dp NUMERIC(23, 0),
  regi_func_ce NUMERIC(23, 0),
  regi_fun_esquema_c NUMERIC(23, 0),
  regi_fun_grupo_r NUMERIC(23, 0),
  regi_fun_tt NUMERIC(23, 0),
  regi_func_jp_hd NUMERIC(23, 0),
  regi_user_ing VARCHAR(15),
  regi_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  regi_user_mod VARCHAR(15),
  regi_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  regi_sec_ori VARCHAR(23),
  regi_estado VARCHAR(1),
  PRIMARY KEY (regi_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.sal_campana (
  camp_sec NUMERIC(23, 0),
  camp_desc VARCHAR(100),
  camp_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  camp_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  camp_estado VARCHAR(30),
  camp_cnt_cupo NUMERIC(23, 0),
  camp_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  camp_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (camp_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.sal_campana_cupo (
  camp_sec NUMERIC(23, 0),
  cacu_nro_atencion BIGINT,
  cacu_fec_crea TIMESTAMP WITHOUT TIME ZONE,
  fipa_rut BIGINT,
  cacu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  cacu_estado VARCHAR(30),
  PRIMARY KEY (camp_sec, cacu_nro_atencion)
);

CREATE TABLE IF NOT EXISTS adm_obs.sal_especialidad (
  espe_cod VARCHAR(20),
  espe_desc VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_obs.sal_ficha_paciente (
  camp_sec NUMERIC(23, 0),
  cacu_nro_atencion BIGINT,
  espe_cod VARCHAR(20),
  fipa_rut BIGINT,
  fipa_dv VARCHAR(1),
  fipa_nombres VARCHAR(100),
  fipa_ape_pat VARCHAR(60),
  fipa_ape_mat VARCHAR(60),
  fipa_edad INTEGER,
  fipa_genero VARCHAR(5),
  fipa_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  fipa_direccion VARCHAR(200),
  fipa_fono VARCHAR(15),
  fipa_celular VARCHAR(15),
  fipa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fipa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (camp_sec, cacu_nro_atencion, fipa_rut)
);

CREATE TABLE IF NOT EXISTS adm_obs.sba_clientes (
  clie_sec NUMERIC(23, 0),
  clie_nombre VARCHAR(100),
  clie_unidad VARCHAR(100),
  clie_sector VARCHAR(100),
  clie_user_ing VARCHAR(50),
  clie_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  clie_user_mod VARCHAR(50),
  clie_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  clie_sec_sector NUMERIC(23, 0),
  PRIMARY KEY (clie_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.sba_clie_serv (
  clse_sec NUMERIC(23, 0),
  clie_sec NUMERIC(23, 0),
  serv_sec NUMERIC(23, 0),
  clse_nro_cliente VARCHAR(50),
  clse_nro_medidor VARCHAR(50),
  clse_user_ing VARCHAR(50),
  clse_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  clse_user_mod VARCHAR(50),
  clse_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  clse_descripcion VARCHAR(250),
  PRIMARY KEY (clse_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.sba_consumos (
  cons_sec NUMERIC,
  clse_sec NUMERIC,
  cons_nro_docto VARCHAR(30),
  cons_tipo_docto VARCHAR(30),
  cons_fecha_emsion TIMESTAMP WITHOUT TIME ZONE,
  cons_ult_estado VARCHAR(30),
  cons_ult_lectura NUMERIC,
  cons_lectura_ant NUMERIC,
  cons_fecha_lectura TIMESTAMP WITHOUT TIME ZONE,
  cons_consumo NUMERIC,
  cons_prox_lectura TIMESTAMP WITHOUT TIME ZONE,
  cons_fecha_vcto TIMESTAMP WITHOUT TIME ZONE,
  cons_demanda NUMERIC,
  cons_iva NUMERIC,
  cons_intereses NUMERIC,
  cons_otros NUMERIC,
  cons_monto_total NUMERIC,
  cons_fecha_pago TIMESTAMP WITHOUT TIME ZONE,
  cons_nro_comprob VARCHAR(30),
  cons_nro_nomina NUMERIC,
  cons_user_ing VARCHAR(50),
  cons_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  cons_user_mod VARCHAR(50),
  cons_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  clie_sec NUMERIC(23, 0),
  PRIMARY KEY (cons_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.sba_flujo_estado (
  fles_sec NUMERIC(23, 0),
  cons_sec NUMERIC(23, 0),
  fles_estado VARCHAR(30),
  fles_fecha_ini TIMESTAMP WITHOUT TIME ZONE,
  fles_fecha_ter TIMESTAMP WITHOUT TIME ZONE,
  fles_user_ing VARCHAR(50),
  fles_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  fles_user_mod VARCHAR(50),
  fles_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (fles_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.sba_servicios (
  serv_sec NUMERIC(23, 0),
  serv_cod VARCHAR(30),
  serv_desc VARCHAR(50),
  serv_inf_cont VARCHAR(100),
  serv_tipo VARCHAR(30),
  serv_user_ing VARCHAR(50),
  serv_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  serv_user_mod VARCHAR(50),
  serv_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (serv_sec)
);

CREATE TABLE IF NOT EXISTS adm_obs.tmp_bho_funcionarios (
  func_rut BIGINT,
  func_dv VARCHAR(1),
  func_nombres VARCHAR(500),
  func_ap_paterno VARCHAR(100),
  func_ap_materno VARCHAR(100),
  func_mail VARCHAR(50),
  func_formacion VARCHAR(100),
  func_sector VARCHAR(100),
  func_banco VARCHAR(100),
  func_tipo_cta VARCHAR(30),
  func_nro_cta VARCHAR(100),
  func_user_mod VARCHAR(50),
  func_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  func_cod_formacion VARCHAR(25),
  func_sec_sector NUMERIC(23, 0),
  func_estado VARCHAR(5),
  fun_cer_inha VARCHAR(2),
  fun_cer_ante VARCHAR(2),
  cont_fecha_ini TIMESTAMP WITHOUT TIME ZONE,
  cont_fecha_term TIMESTAMP WITHOUT TIME ZONE,
  cont_vig VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS adm_obs.x_bol_hononor (
  ncliente VARCHAR(300),
  dv VARCHAR(300),
  nombre VARCHAR(300),
  codunidad1 VARCHAR(300),
  sector1 VARCHAR(300),
  estamento VARCHAR(300),
  codigo VARCHAR(300),
  banco VARCHAR(300),
  tipocuenta VARCHAR(300),
  tipo_cta VARCHAR(300),
  ndocto VARCHAR(300),
  monto VARCHAR(300),
  estado VARCHAR(300),
  tipo VARCHAR(300),
  fecharecep VARCHAR(300),
  fechaemision VARCHAR(300),
  subtotal VARCHAR(300),
  iva VARCHAR(300),
  ccosto1 VARCHAR(300),
  codser VARCHAR(300),
  nombreser VARCHAR(300),
  descripcion1 VARCHAR(300),
  cuenta VARCHAR(300),
  cargo VARCHAR(300),
  ccosto2 VARCHAR(300),
  res VARCHAR(300),
  fecha VARCHAR(300),
  contacto VARCHAR(300),
  ano VARCHAR(300),
  sector2 VARCHAR(300),
  vigencia VARCHAR(300),
  unidad1 VARCHAR(300),
  jornada VARCHAR(300),
  periodo VARCHAR(300),
  unidad2 VARCHAR(300),
  num VARCHAR(300),
  codunidad2 VARCHAR(300),
  codcenco VARCHAR(300),
  descripcion2 VARCHAR(300),
  domicilio VARCHAR(300),
  codsector VARCHAR(300),
  ccosto VARCHAR(300),
  codest VARCHAR(300),
  nombreest VARCHAR(300),
  dom_unidad VARCHAR(10),
  sec_carga NUMERIC,
  dom_sector VARCHAR(10),
  dom_tipo_cta VARCHAR(10),
  func_sec NUMERIC,
  periodo_bol VARCHAR(20),
  dom_banco VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_obs.x_bol_hononor_edu (
  ncliente1 VARCHAR(300),
  ncliente2 VARCHAR(300),
  dv VARCHAR(300),
  nombre VARCHAR(300),
  nombres VARCHAR(300),
  paterno VARCHAR(300),
  codunidad VARCHAR(300),
  materno VARCHAR(300),
  sector1 VARCHAR(300),
  estamento VARCHAR(300),
  codigo VARCHAR(300),
  banco VARCHAR(300),
  tipo_cuenta VARCHAR(300),
  ndocto VARCHAR(300),
  monto VARCHAR(300),
  estado VARCHAR(300),
  tipo VARCHAR(300),
  fecharecep VARCHAR(300),
  fechaemision VARCHAR(300),
  subtotal VARCHAR(300),
  iva VARCHAR(300),
  ccosto1 VARCHAR(300),
  codser VARCHAR(300),
  nombreser VARCHAR(300),
  descripcion VARCHAR(300),
  cuenta VARCHAR(300),
  cargo VARCHAR(300),
  ccosto2 VARCHAR(300),
  res VARCHAR(300),
  fecha VARCHAR(300),
  contacto VARCHAR(300),
  ano VARCHAR(300),
  sector2 VARCHAR(300),
  jornada VARCHAR(300),
  periodo VARCHAR(300),
  unidad VARCHAR(300),
  autorizada VARCHAR(300),
  num VARCHAR(300),
  escolaridad VARCHAR(300),
  calificacion VARCHAR(300),
  sec_carga NUMERIC,
  dom_banco VARCHAR(20),
  unidad_univ VARCHAR(100),
  dom_tipo_cta VARCHAR(100),
  periodo_bol VARCHAR(20),
  func_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.x_correspondencia (
  numorden VARCHAR(100),
  fecharec VARCHAR(100),
  fechadoc VARCHAR(100),
  tipodoc VARCHAR(300),
  remitente VARCHAR(300),
  materia VARCHAR(300),
  fechasal VARCHAR(100),
  destinatario VARCHAR(300),
  dia VARCHAR(100),
  mes VARCHAR(100),
  ano VARCHAR(100),
  ndocto VARCHAR(300),
  estado VARCHAR(300),
  fecha VARCHAR(100),
  unidad VARCHAR(300),
  observacion VARCHAR(4000),
  cc VARCHAR(300),
  rut VARCHAR(300),
  razon VARCHAR(300),
  ccosto VARCHAR(300),
  montobruto VARCHAR(100),
  iva VARCHAR(100),
  montoneto VARCHAR(100),
  dv VARCHAR(300),
  ctapresup VARCHAR(300),
  estadopresup VARCHAR(300),
  numoc VARCHAR(100),
  exenta VARCHAR(300),
  correlativo VARCHAR(300),
  financiamiento VARCHAR(300),
  ctacontable VARCHAR(300),
  adjoc VARCHAR(300),
  area VARCHAR(300),
  id VARCHAR(100),
  sec_carga NUMERIC,
  tipo_docto_unif VARCHAR(100),
  dom_tipo_doc VARCHAR(20),
  remi_sec NUMERIC,
  remitente_razon VARCHAR(200),
  dv_rut_remi VARCHAR(1),
  rut_remi VARCHAR(10),
  destinatario_unif VARCHAR(200),
  dest_sec NUMERIC,
  docu_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_obs.x_servicios (
  ncliente VARCHAR(300),
  nombre VARCHAR(300),
  codunidad VARCHAR(300),
  nmedidor VARCHAR(300),
  promedio VARCHAR(300),
  codser VARCHAR(300),
  sector VARCHAR(300),
  nclienteantiguo VARCHAR(300),
  ndocto VARCHAR(300),
  monto VARCHAR(300),
  estado VARCHAR(300),
  tipo VARCHAR(300),
  fecharecep VARCHAR(300),
  ulectura VARCHAR(300),
  alectura VARCHAR(300),
  fechalectura VARCHAR(300),
  consumo VARCHAR(300),
  fechaemision VARCHAR(300),
  fechapago VARCHAR(300),
  ncpbte VARCHAR(300),
  subtotal VARCHAR(300),
  demanda VARCHAR(300),
  iva VARCHAR(300),
  intereses VARCHAR(300),
  otro VARCHAR(300),
  fechaven VARCHAR(300),
  fechaproxlec VARCHAR(300),
  cuenta VARCHAR(300),
  rut VARCHAR(300),
  ccosto1 VARCHAR(300),
  nomina VARCHAR(300),
  autorizada VARCHAR(300),
  rol VARCHAR(300),
  codcenco VARCHAR(300),
  descripcion VARCHAR(300),
  domicilio VARCHAR(300),
  poblacion VARCHAR(300),
  telefono VARCHAR(300),
  codsector VARCHAR(300),
  ccosto2 VARCHAR(300),
  usuario VARCHAR(300),
  financiamiento VARCHAR(300),
  dom_unidad VARCHAR(10),
  clie_sec NUMERIC,
  dom_sector VARCHAR(10),
  serv_sec NUMERIC,
  sec_carga NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.aq__padlog_queue_table_h (
  msgid BYTEA,
  subscriber_ NUMERIC,
  name VARCHAR(512),
  address_ NUMERIC,
  dequeue_time TIMESTAMP WITHOUT TIME ZONE,
  transaction_id VARCHAR(30),
  dequeue_user VARCHAR(128),
  propagated_msgid BYTEA,
  retry_count NUMERIC,
  hint VARCHAR(10),
  spare BYTEA,
  PRIMARY KEY (msgid, subscriber_, name, address_)
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_01 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_02 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_03 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_04 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_05 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_06 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_07 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_08 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_09 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_10 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_11 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_logger2_12 (
  log_sec NUMERIC,
  log_time TIMESTAMP WITHOUT TIME ZONE,
  log_time_1 TIMESTAMP WITHOUT TIME ZONE,
  log_time_2 TIMESTAMP WITHOUT TIME ZONE,
  log_level VARCHAR(20),
  log_procedure VARCHAR(256),
  log_client VARCHAR(256),
  log_session_db VARCHAR(256),
  log_session_id VARCHAR(256),
  log_sec_proc NUMERIC,
  log_padre VARCHAR(256),
  log_message VARCHAR(4000),
  log_params VARCHAR(4000),
  log_error_stack VARCHAR(4000),
  log_cod_error NUMERIC,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS padlog.padlog_queue_table (
  q_name VARCHAR(128),
  msgid BYTEA,
  corrid VARCHAR(128),
  priority NUMERIC,
  state NUMERIC,
  delay TIMESTAMP WITHOUT TIME ZONE,
  expiration NUMERIC,
  time_manager_info TIMESTAMP WITHOUT TIME ZONE,
  local_order_no NUMERIC,
  chain_no NUMERIC,
  cscn NUMERIC,
  dscn NUMERIC,
  enq_time TIMESTAMP WITHOUT TIME ZONE,
  enq_uid VARCHAR(128),
  enq_tid VARCHAR(30),
  deq_time TIMESTAMP WITHOUT TIME ZONE,
  deq_uid VARCHAR(128),
  deq_tid VARCHAR(30),
  retry_count NUMERIC,
  exception_qschema VARCHAR(128),
  exception_queue VARCHAR(128),
  step_no NUMERIC,
  recipient_key NUMERIC,
  dequeue_msgid BYTEA,
  sender_name VARCHAR(128),
  sender_address VARCHAR(1024),
  sender_protocol NUMERIC,
  user_data TEXT,
  user_prop TEXT,
  PRIMARY KEY (msgid)
);

CREATE TABLE IF NOT EXISTS adm_educa.a_rut (
  nro_orden BIGINT,
  rut BIGINT
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_adge_adtf (
  dgtf_sec NUMERIC(23, 0),
  adtf_sec NUMERIC(23, 0),
  adge_sec NUMERIC(23, 0),
  dgtf_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  dgtf_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  dgtf_es_obligatorio VARCHAR(2),
  dgtf_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dgtf_user_ing VARCHAR(30),
  dgtf_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  dgtf_user_mod VARCHAR(30),
  PRIMARY KEY (dgtf_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_adtf_func_det (
  tffd_sec NUMERIC(23, 0),
  tffe_sec NUMERIC(23, 0),
  adge_sec NUMERIC(23, 0),
  adxf_sec NUMERIC(23, 0),
  tffd_estado_docto VARCHAR(30),
  tffd_fec_ini_visador TIMESTAMP WITHOUT TIME ZONE,
  tffd_fec_fin_visador TIMESTAMP WITHOUT TIME ZONE,
  tffd_flag_elim VARCHAR(2),
  tffd_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tffd_user_ing VARCHAR(30),
  tffd_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tffd_user_mod VARCHAR(30),
  tffd_motivo_rech VARCHAR(2000),
  PRIMARY KEY (tffd_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_adtf_func_enc (
  tffe_sec NUMERIC(23, 0),
  esad_cod VARCHAR(30),
  apes_sec NUMERIC(23, 0),
  afun_sec NUMERIC(23, 0),
  adtf_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tffe_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tffe_user_ing VARCHAR(30),
  tffe_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tffe_user_mod VARCHAR(30),
  PRIMARY KEY (tffe_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_adtf_func_estab (
  tfes_sec NUMERIC(23, 0),
  tffe_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  tfes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tfes_user_ing VARCHAR(30),
  tfes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tfes_user_mod VARCHAR(30),
  PRIMARY KEY (tfes_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_arch_func_tmp (
  esad_cod VARCHAR(30),
  arfu_rut BIGINT,
  arfu_dv VARCHAR(1),
  arfu_nombre VARCHAR(100),
  arfu_paterno VARCHAR(60),
  arfu_materno VARCHAR(60),
  arfu_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  arfu_sexo VARCHAR(10),
  arfu_tipo_cont VARCHAR(60),
  arfu_fec_ini_cont TIMESTAMP WITHOUT TIME ZONE,
  arfu_direccion VARCHAR(200),
  arfu_telefono VARCHAR(60),
  arfu_cargo VARCHAR(200),
  arfu_afp VARCHAR(200),
  arfu_inst_salud VARCHAR(200),
  arfu_procesado VARCHAR(2),
  arfu_fec_carga TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_docto_gestion (
  adge_sec NUMERIC(23, 0),
  esad_cod VARCHAR(30),
  adge_cod VARCHAR(10),
  adge_descripcion VARCHAR(100),
  adge_duracion_docto INTEGER,
  adge_tiempo_soli_docto INTEGER,
  adge_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  adge_user_ing VARCHAR(30),
  adge_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  adge_user_mod VARCHAR(30),
  adge_tipo_vig VARCHAR(10),
  PRIMARY KEY (adge_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_docto_x_func (
  adxf_sec NUMERIC(23, 0),
  afun_sec NUMERIC(23, 0),
  adge_sec NUMERIC(23, 0),
  adxf_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  adxf_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  adxf_fec_carga TIMESTAMP WITHOUT TIME ZONE,
  adxf_nom_arch_real VARCHAR(512),
  adxf_nom_arch_inte VARCHAR(512),
  adxf_tamano_arch BIGINT,
  adxf_purgado VARCHAR(2),
  adxf_fec_purgado TIMESTAMP WITHOUT TIME ZONE,
  adxf_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  adxf_user_ing VARCHAR(30),
  adxf_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  adxf_user_mod VARCHAR(30),
  PRIMARY KEY (adxf_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_funcionarios (
  afun_sec NUMERIC(23, 0),
  esad_cod VARCHAR(30),
  afun_rut BIGINT,
  afun_dv VARCHAR(1),
  afun_nombre VARCHAR(100),
  afun_ape_pat VARCHAR(60),
  afun_ape_mat VARCHAR(60),
  afun_genero VARCHAR(5),
  afun_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  pers_sec NUMERIC(23, 0),
  afun_direccion VARCHAR(200),
  afun_telefono VARCHAR(60),
  afun_email_inst VARCHAR(255),
  afun_email_personal VARCHAR(255),
  afun_cod_cargo VARCHAR(10),
  afun_tipo_contrato VARCHAR(10),
  afun_fec_ini_cont TIMESTAMP WITHOUT TIME ZONE,
  afun_fec_fin_cont TIMESTAMP WITHOUT TIME ZONE,
  afun_cod_afp VARCHAR(10),
  afun_tipo_inst_salud VARCHAR(20),
  afun_cod_isapre VARCHAR(10),
  afun_estado VARCHAR(30),
  afun_existe_educa VARCHAR(2),
  afun_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  afun_user_ing VARCHAR(30),
  afun_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  afun_user_mod VARCHAR(30),
  afun_acceso_espec_login VARCHAR(2),
  afun_fec_fin_aelogin TIMESTAMP WITHOUT TIME ZONE,
  afun_fec_fin_aelogin_log TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (afun_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_mensajeria_docto (
  esad_cod VARCHAR(30),
  apes_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tffd_sec NUMERIC(23, 0),
  admd_mensaje VARCHAR(4000),
  admd_fecha_proc TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (esad_cod, apes_sec, usua_usuarios, tffd_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_periodos_sost (
  apes_sec NUMERIC(23, 0),
  esad_cod VARCHAR(30),
  apes_anno INTEGER,
  apes_descripcion VARCHAR(200),
  apes_estado VARCHAR(30),
  apes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  apes_user_ing VARCHAR(30),
  apes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  apes_user_mod VARCHAR(30),
  PRIMARY KEY (apes_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_tipo_funcionario (
  adtf_sec NUMERIC(23, 0),
  esad_cod VARCHAR(30),
  adtf_cod_cargo VARCHAR(10),
  adtf_descripcion VARCHAR(100),
  adtf_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  adtf_user_ing VARCHAR(30),
  adtf_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  adtf_user_mod VARCHAR(30),
  PRIMARY KEY (adtf_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_adm_usuarios_sost (
  esad_cod VARCHAR(30),
  usua_usuarios BIGINT,
  usso_bloqueo VARCHAR(2),
  usso_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  usso_user_ing VARCHAR(30),
  usso_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  usso_user_mod VARCHAR(30),
  usso_clave VARCHAR(256),
  PRIMARY KEY (esad_cod, usua_usuarios)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_agenda_recursos (
  agre_sec NUMERIC(23, 0),
  rees_sec NUMERIC(23, 0),
  usua_usuario BIGINT,
  agre_titulo VARCHAR(100),
  agre_desc VARCHAR(200),
  agre_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  agre_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  agre_recurrencia VARCHAR(1),
  agre_periodo_recu VARCHAR(5),
  agre_info_recu VARCHAR(5),
  agre_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  agre_user_ing VARCHAR(30),
  agre_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  agre_user_mod VARCHAR(30),
  agre_color_agenda VARCHAR(30),
  agre_responsable VARCHAR(60),
  PRIMARY KEY (agre_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_alumnos_cursos (
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_fec_incorp TIMESTAMP WITHOUT TIME ZONE,
  alcu_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  alcu_orden BIGINT,
  alcu_estado VARCHAR(30),
  alcu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  alcu_user_ing VARCHAR(30),
  alcu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  alcu_user_mod VARCHAR(30),
  alcu_situ_final VARCHAR(2),
  tien_cod_dest VARCHAR(10),
  grte_cod_dest VARCHAR(10),
  alcu_sec NUMERIC(23, 0),
  maal_sec NUMERIC(23, 0),
  alcu_tiene_excedente VARCHAR(5),
  alcu_derecho_subven VARCHAR(5),
  alcu_nro_resolucion VARCHAR(20),
  alcu_fec_resolucion TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (alcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_alumno_classroom (
  alcl_sec VARCHAR(256),
  cuas_id_classroom VARCHAR(256),
  alcl_nombre VARCHAR(256),
  alcl_correo VARCHAR(256),
  PRIMARY KEY (alcl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_aplicaciones (
  apli_cod VARCHAR(50),
  apli_desc VARCHAR(60),
  apli_label VARCHAR(50),
  apli_padre VARCHAR(50),
  apli_link VARCHAR(100),
  apli_icono VARCHAR(100),
  apli_ayuda VARCHAR(50),
  apli_target VARCHAR(50),
  sist_cod VARCHAR(10),
  apli_pos_aplic INTEGER,
  apli_pos_padre INTEGER,
  apli_icono_padre VARCHAR(100),
  apli_icono_home VARCHAR(100),
  apli_estado_peri VARCHAR(5),
  aplo_cod VARCHAR(20),
  apli_version VARCHAR(10),
  PRIMARY KEY (apli_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_aplic_logicas (
  aplo_cod VARCHAR(20),
  aplo_descripcion VARCHAR(200),
  aplo_desc_corta VARCHAR(60),
  PRIMARY KEY (aplo_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_aplic_mas_usadas_v (
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  apli_cod VARCHAR(50),
  apli_label VARCHAR(50),
  apli_icono VARCHAR(100),
  apli_icono_home VARCHAR(100),
  apli_link VARCHAR(500),
  cnt_apli NUMERIC,
  orden NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_apli_usua_usada (
  auus_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuario BIGINT,
  apli_cod VARCHAR(50),
  auus_orden INTEGER,
  auus_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  auus_user_ing VARCHAR(30),
  auus_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  auus_user_mod VARCHAR(30),
  prfl_cod VARCHAR(20),
  PRIMARY KEY (auus_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_aplo_corp (
  aplo_cod VARCHAR(20),
  esad_cod VARCHAR(30),
  apli_cod VARCHAR(50),
  alco_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  alco_user_ing VARCHAR(30),
  alco_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  alco_user_mod VARCHAR(30),
  PRIMARY KEY (aplo_cod, esad_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_aplo_estab (
  esed_sec NUMERIC(23, 0),
  apli_cod VARCHAR(50),
  ales_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ales_user_ing VARCHAR(30),
  PRIMARY KEY (esed_sec, apli_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_archivos (
  arch_sec NUMERIC(23, 0),
  arch_nombre VARCHAR(400),
  esde_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  arch_total_lineas NUMERIC(23, 0),
  arch_estado VARCHAR(30),
  arch_fec_carga TIMESTAMP WITHOUT TIME ZONE,
  arch_usr_ing VARCHAR(50),
  arch_checksum VARCHAR(100),
  arch_tipo_arch VARCHAR(10),
  PRIMARY KEY (arch_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_archivo_estab_tmp (
  peri_anno INTEGER,
  cod_rbd VARCHAR(10),
  esde_sec NUMERIC(23, 0),
  cod_tipo_ense VARCHAR(10),
  cod_grado VARCHAR(10),
  cod_curso VARCHAR(10),
  desc_grado VARCHAR(100),
  letra_curso VARCHAR(5),
  pers_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  es_nuevo VARCHAR(10),
  rut_alumno BIGINT,
  dv_alumno VARCHAR(1),
  genero VARCHAR(5),
  nombre VARCHAR(100),
  ape_pat VARCHAR(60),
  ape_mat VARCHAR(60),
  direc VARCHAR(200),
  cod_region VARCHAR(20),
  comuna_desc VARCHAR(100),
  cod_comuna VARCHAR(20),
  telefono VARCHAR(30),
  celular VARCHAR(30),
  email VARCHAR(100),
  fecha_nac TIMESTAMP WITHOUT TIME ZONE,
  cod_etnia VARCHAR(10),
  fec_ing_curso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (peri_anno, cod_rbd, cod_curso, letra_curso, rut_alumno)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_contacto_alum (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  arca_rut_apod BIGINT,
  arca_dv_apod VARCHAR(1),
  arca_nom_apod VARCHAR(100),
  arca_apat_apod VARCHAR(60),
  arca_amat_apod VARCHAR(60),
  arca_genero_apod VARCHAR(5),
  arca_fec_nac_apod TIMESTAMP WITHOUT TIME ZONE,
  arca_celu_apod VARCHAR(50),
  arca_mail_apod VARCHAR(100),
  arca_parent_apo VARCHAR(20),
  arca_estado VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_decreto (
  cod_decreto VARCHAR(10),
  nom_decreto VARCHAR(100),
  fecha_decreto VARCHAR(20),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  asig_cod VARCHAR(20),
  horas NUMERIC(5, 2),
  es_obligatorio VARCHAR(2),
  formacion VARCHAR(100),
  orden_asig INTEGER
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_deta_estab (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  arde_anno_admi INTEGER,
  cod_region VARCHAR(10),
  pers_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  arde_rut BIGINT,
  arde_dv VARCHAR(1),
  arde_nombre VARCHAR(100),
  arde_ape_pat VARCHAR(60),
  arde_ape_mat VARCHAR(60),
  arde_cod_tien VARCHAR(10),
  arde_cod_grado VARCHAR(10),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  arde_letra_curso VARCHAR(5),
  arde_cod_espec VARCHAR(10),
  arde_cod_nivel VARCHAR(10),
  arde_nivel VARCHAR(100),
  arde_nom_apod VARCHAR(100),
  arde_celu_apod VARCHAR(50),
  arde_fono_apod VARCHAR(50),
  arde_mail_apod VARCHAR(100),
  arde_cod_clasif VARCHAR(10),
  arde_desc_clasif VARCHAR(100),
  arde_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  arde_user_ing VARCHAR(30),
  arde_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  arde_user_mod VARCHAR(30),
  arde_estado_reg VARCHAR(5),
  grcu_sec NUMERIC(23, 0),
  arde_estado_admision VARCHAR(20),
  PRIMARY KEY (esed_sec, peri_sec, arde_rut)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_grado_estab (
  arge_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  arge_anno INTEGER,
  arge_cod_rbd VARCHAR(10),
  tien_cod VARCHAR(10),
  arge_cod_grado VARCHAR(10),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  arge_letra_curso VARCHAR(5),
  pers_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  arge_es_nuevo VARCHAR(10),
  arge_rut BIGINT,
  arge_dv VARCHAR(1),
  arge_genero VARCHAR(5),
  arge_nombre VARCHAR(100),
  arge_ape_pat VARCHAR(60),
  arge_ape_mat VARCHAR(60),
  arge_direc VARCHAR(200),
  regi_cod VARCHAR(20),
  arge_comuna_desc VARCHAR(100),
  comu_cod VARCHAR(20),
  arge_telefono VARCHAR(30),
  arge_celular VARCHAR(30),
  arge_email VARCHAR(100),
  arge_fecha_nac TIMESTAMP WITHOUT TIME ZONE,
  arge_cod_etnia VARCHAR(10),
  arge_fec_ing_curso TIMESTAMP WITHOUT TIME ZONE,
  arge_estado_reg VARCHAR(5),
  arge_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  arge_user_ing VARCHAR(30),
  arge_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  arge_user_mod VARCHAR(30),
  arch_sec NUMERIC(23, 0),
  maal_sec NUMERIC(23, 0),
  PRIMARY KEY (arge_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_grado_estab_log (
  arch_sec NUMERIC(23, 0),
  arge_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  agel_anno INTEGER,
  agel_cod_rbd VARCHAR(10),
  tien_cod VARCHAR(10),
  agel_cod_grado VARCHAR(10),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  agel_letra_curso VARCHAR(5),
  pers_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  agel_es_nuevo VARCHAR(10),
  agel_rut BIGINT,
  agel_dv VARCHAR(1),
  agel_genero VARCHAR(5),
  agel_nombre VARCHAR(100),
  agel_ape_pat VARCHAR(60),
  agel_ape_mat VARCHAR(60),
  agel_observacion VARCHAR(4000),
  agel_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  agel_user_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_lineas (
  arch_sec NUMERIC(23, 0),
  arli_nro_linea INTEGER,
  arli_linea VARCHAR(4000),
  PRIMARY KEY (arch_sec, arli_nro_linea)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_prog_estudio (
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  asig_cod VARCHAR(20),
  asig_cod_padre VARCHAR(20),
  cod_modulo INTEGER,
  desc_modulo VARCHAR(4000),
  cod_unid INTEGER,
  nom_unid VARCHAR(500),
  cod_ambito VARCHAR(10),
  desc_ambito VARCHAR(4000),
  ambito_transversal VARCHAR(2),
  cod_nucleo VARCHAR(10),
  desc_nucleo VARCHAR(4000),
  cod_obj VARCHAR(10),
  desc_obj VARCHAR(4000),
  cod_indi INTEGER,
  desc_ind VARCHAR(4000),
  cod_crit_eval VARCHAR(20),
  desc_crit_eval VARCHAR(4000),
  cod_obj_generico VARCHAR(20),
  desc_obj_generico VARCHAR(4000),
  es_prioridad_oa VARCHAR(2),
  tipo_dato VARCHAR(30),
  nro_orden INTEGER,
  formacion VARCHAR(10),
  tipo_carga VARCHAR(10),
  fec_carga TIMESTAMP WITHOUT TIME ZONE,
  estado_procesado VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_telefonos_cmds (
  artc_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  artc_nro_telefono BIGINT,
  artc_nro_chips VARCHAR(100),
  artc_tipo_plan VARCHAR(50),
  artc_empresa VARCHAR(100),
  artc_estado VARCHAR(5),
  artc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  artc_user_ing VARCHAR(30),
  artc_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  artc_user_mod VARCHAR(30),
  PRIMARY KEY (artc_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_arch_telefonos_paso (
  esed_sec NUMERIC(23, 0),
  paso_nro_telefono BIGINT,
  paso_nro_chips VARCHAR(100),
  PRIMARY KEY (esed_sec, paso_nro_telefono, paso_nro_chips)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asbl_asig_electiva (
  gael_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  grte_desc VARCHAR(100),
  grcu_letra_curso VARCHAR(2),
  abae_nro_bloque INTEGER,
  fial_sec NUMERIC(23, 0),
  abae_nro_lista BIGINT,
  abae_nom_alumno VARCHAR(500),
  abae_tipo_peri VARCHAR(10),
  abae_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  abae_asistencia VARCHAR(30),
  abae_justific VARCHAR(20),
  abae_observ VARCHAR(200),
  abae_hora_llega VARCHAR(10),
  abae_estado VARCHAR(30),
  abae_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  abae_user_ing VARCHAR(30),
  abae_tipo_asistencia VARCHAR(15),
  alcu_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asbl_asig_electiva_obs (
  gael_sec NUMERIC(23, 0),
  abeo_nro_bloque INTEGER,
  abeo_tipo_peri VARCHAR(10),
  abeo_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  abeo_observ VARCHAR(200),
  abeo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  abeo_user_ing VARCHAR(30),
  abeo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  abeo_user_mod VARCHAR(30),
  PRIMARY KEY (gael_sec, abeo_nro_bloque, abeo_tipo_peri, abeo_fec_asistencia)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ases_paso (
  cod_asig VARCHAR(30),
  cod_estab VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asignacion_sms (
  assm_sms_sec NUMERIC,
  cosm_sms_sec NUMERIC,
  esed_cod NUMERIC,
  assm_total_sms_asignado NUMERIC,
  assm_usuario_ing VARCHAR(30),
  assm_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  assm_usuario_mod VARCHAR(30),
  assm_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (assm_sms_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asignaturas (
  asig_cod VARCHAR(20),
  asig_descripcion VARCHAR(200),
  asig_tipo VARCHAR(5),
  PRIMARY KEY (asig_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asignat_estab (
  esed_sec NUMERIC(23, 0),
  asig_cod VARCHAR(20),
  ases_orden_jerar INTEGER,
  ases_estado VARCHAR(30),
  ases_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ases_user_ing VARCHAR(30),
  ases_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ases_user_mod VARCHAR(30),
  ases_abrev_asig VARCHAR(5),
  ases_es_prioritaria VARCHAR(2),
  ases_color VARCHAR(60),
  PRIMARY KEY (esed_sec, asig_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asig_profesor (
  prof_sec NUMERIC(23, 0),
  asig_cod VARCHAR(20),
  aspr_estado VARCHAR(30),
  aspr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  aspr_user_ing VARCHAR(30),
  aspr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  aspr_user_mod VARCHAR(30),
  PRIMARY KEY (prof_sec, asig_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_bloque (
  cuas_sec NUMERIC(23, 0),
  asbl_nro_bloque INTEGER,
  fial_sec NUMERIC(23, 0),
  asbl_nro_lista BIGINT,
  asbl_tipo_peri VARCHAR(10),
  asbl_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  asbl_asistencia VARCHAR(30),
  asbl_justific VARCHAR(20),
  asbl_observ VARCHAR(200),
  asbl_hora_llega VARCHAR(10),
  asbl_estado VARCHAR(30),
  asbl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  asbl_user_ing VARCHAR(30),
  asbl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  asbl_user_mod VARCHAR(30),
  asbl_tipo_asistencia VARCHAR(15),
  alcu_sec NUMERIC(23, 0),
  asbl_estado_sige VARCHAR(20),
  asbl_cod_verificacion VARCHAR(100),
  PRIMARY KEY (cuas_sec, asbl_nro_bloque, fial_sec, alcu_sec, asbl_tipo_peri, asbl_fec_asistencia)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_bloque_log (
  cuas_sec NUMERIC(23, 0),
  ablo_nro_bloque INTEGER,
  fial_sec NUMERIC(23, 0),
  ablo_nro_lista BIGINT,
  ablo_tipo_peri VARCHAR(10),
  ablo_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  ablo_asistencia VARCHAR(30),
  ablo_fec_upd_reg TIMESTAMP WITHOUT TIME ZONE,
  ablo_justific VARCHAR(20),
  ablo_observ VARCHAR(200),
  ablo_hora_llega VARCHAR(10),
  ablo_estado VARCHAR(30),
  ablo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ablo_user_ing VARCHAR(30),
  ablo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ablo_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_bloque_obs (
  cuas_sec NUMERIC(23, 0),
  ablo_nro_bloque INTEGER,
  ablo_tipo_peri VARCHAR(10),
  ablo_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  ablo_observ VARCHAR(4000),
  ablo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ablo_user_ing VARCHAR(30),
  ablo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ablo_user_mod VARCHAR(30),
  PRIMARY KEY (cuas_sec, ablo_nro_bloque, ablo_tipo_peri, ablo_fec_asistencia)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_bloque_temp (
  cuas_sec NUMERIC(23, 0),
  abtm_nro_bloque INTEGER,
  fial_sec NUMERIC(23, 0),
  abtm_nro_lista BIGINT,
  abtm_tipo_peri VARCHAR(10),
  abtm_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  abtm_asistencia VARCHAR(30),
  abtm_justific VARCHAR(20),
  abtm_observ VARCHAR(200),
  abtm_hora_llega VARCHAR(10),
  abtm_estado VARCHAR(30),
  abtm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  abtm_user_ing VARCHAR(30),
  abtm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  abtm_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_curso (
  cuas_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  ascu_tipo_peri VARCHAR(10),
  ascu_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  ascu_asistencia VARCHAR(30),
  ascu_justific VARCHAR(20),
  ascu_observ VARCHAR(200),
  ascu_hora_llega VARCHAR(10),
  ascu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ascu_user_ing VARCHAR(30),
  ascu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ascu_user_mod VARCHAR(30),
  ascu_nro_lista BIGINT,
  ascu_estado VARCHAR(30),
  ascu_tipo_asistencia VARCHAR(15),
  alcu_sec NUMERIC(23, 0),
  ascu_estado_sige VARCHAR(20),
  ascu_cod_verificacion VARCHAR(100),
  PRIMARY KEY (cuas_sec, fial_sec, alcu_sec, ascu_tipo_peri, ascu_fec_asistencia)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_curso_obs (
  cuas_sec NUMERIC(23, 0),
  acuo_tipo_peri VARCHAR(10),
  acuo_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  acuo_observ VARCHAR(4000),
  acuo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  acuo_user_ing VARCHAR(30),
  acuo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  acuo_user_mod VARCHAR(30),
  PRIMARY KEY (cuas_sec, acuo_tipo_peri, acuo_fec_asistencia)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_post_det (
  apde_sec NUMERIC(23, 0),
  apen_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  apde_nro_lista BIGINT,
  apde_motivo VARCHAR(500),
  apde_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  apde_user_ing VARCHAR(30),
  apde_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  apde_user_mod VARCHAR(30),
  PRIMARY KEY (apde_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asistencia_post_enc (
  apen_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  apen_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  apen_hora_bloque VARCHAR(6),
  apen_nombre_asist_post VARCHAR(500),
  apen_nro_bloque INTEGER,
  apen_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  apen_user_ing VARCHAR(30),
  apen_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  apen_user_mod VARCHAR(30),
  PRIMARY KEY (apen_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asist_bloque_313_datos5d_en_5c (
  cuas_sec NUMERIC(23, 0),
  asbl_nro_bloque INTEGER,
  fial_sec NUMERIC(23, 0),
  asbl_nro_lista BIGINT,
  asbl_tipo_peri VARCHAR(10),
  asbl_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  asbl_asistencia VARCHAR(30),
  asbl_justific VARCHAR(20),
  asbl_observ VARCHAR(200),
  asbl_hora_llega VARCHAR(10),
  asbl_estado VARCHAR(30),
  asbl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  asbl_user_ing VARCHAR(30),
  asbl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  asbl_user_mod VARCHAR(30),
  asbl_tipo_asistencia VARCHAR(15),
  alcu_sec NUMERIC(23, 0),
  asbl_estado_sige VARCHAR(20),
  asbl_cod_verificacion VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asist_curso_porc (
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  acpo_nro_lista INTEGER,
  acpo_tipo_peri VARCHAR(10),
  acpo_estado VARCHAR(30),
  acpo_porc_asist NUMERIC(5, 2),
  acpo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  acpo_user_ing VARCHAR(30),
  acpo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  acpo_user_mod VARCHAR(30),
  acpo_porc_asis_sis NUMERIC(5, 2),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (grcu_sec, fial_sec, alcu_sec, acpo_tipo_peri)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asist_grcu_elim (
  asge_tipo_asist VARCHAR(30),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  asge_nro_bloque INTEGER,
  alcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  asge_nro_lista BIGINT,
  asge_tipo_peri VARCHAR(10),
  asge_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  asge_asistencia VARCHAR(30),
  asge_justific VARCHAR(20),
  asge_observ VARCHAR(200),
  asge_hora_llega VARCHAR(10),
  asge_estado VARCHAR(30),
  asge_tipo_asistencia VARCHAR(15),
  asge_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  asge_user_ing VARCHAR(30),
  asge_fec_elim TIMESTAMP WITHOUT TIME ZONE,
  asge_user_elim VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_asist_respaldo_retiro (
  maal_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  asrr_nro_bloque INTEGER,
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  asrr_tipo_peri VARCHAR(10),
  asrr_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  asrr_asistencia VARCHAR(30),
  asrr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  asrr_user_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_becas (
  beca_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  beca_nombre VARCHAR(60),
  cobe_sec NUMERIC(23, 0),
  beca_tipo_dscto VARCHAR(20),
  beca_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  beca_user_ing VARCHAR(30),
  beca_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  beca_user_mod VARCHAR(30),
  PRIMARY KEY (beca_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_becas_alumnos (
  beal_sec NUMERIC(23, 0),
  beca_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  beal_monto NUMERIC(15, 2),
  beal_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  beal_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  beal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  beal_user_ing VARCHAR(30),
  beal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  beal_user_mod VARCHAR(30),
  PRIMARY KEY (beal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_biblioteca_curso (
  bicu_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  bicu_fec_solicitud TIMESTAMP WITHOUT TIME ZONE,
  bicu_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  bicu_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  bicu_cod_texto VARCHAR(100),
  bicu_texto VARCHAR(4000),
  bicu_fec_devolucion TIMESTAMP WITHOUT TIME ZONE,
  bicu_estado VARCHAR(30),
  bicu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  bicu_user_ing VARCHAR(30),
  bicu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  bicu_user_mod VARCHAR(30),
  bicu_observ VARCHAR(4000),
  PRIMARY KEY (bicu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_bloqueo_asist_estab (
  blas_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  blas_mes VARCHAR(2),
  blas_fec_bloqueo TIMESTAMP WITHOUT TIME ZONE,
  blas_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  blas_user_ing VARCHAR(30),
  blas_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  blas_user_mod VARCHAR(30),
  PRIMARY KEY (blas_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_bloqueo_asist_estab_log (
  balo_accion VARCHAR(30),
  balo_fec_accion TIMESTAMP WITHOUT TIME ZONE,
  balo_user_accion VARCHAR(30),
  blas_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  blas_mes VARCHAR(2),
  blas_fec_bloqueo TIMESTAMP WITHOUT TIME ZONE,
  blas_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  blas_user_ing VARCHAR(30),
  blas_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  blas_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_bloqueo_asist_excep (
  baex_sec NUMERIC(23, 0),
  blas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  baex_fec_fin_excep TIMESTAMP WITHOUT TIME ZONE,
  baex_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  baex_user_ing VARCHAR(30),
  baex_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  baex_user_mod VARCHAR(30),
  PRIMARY KEY (baex_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_bloqueo_asist_excep_log (
  bael_accion VARCHAR(30),
  bael_fec_accion TIMESTAMP WITHOUT TIME ZONE,
  bael_user_accion VARCHAR(30),
  baex_sec NUMERIC(23, 0),
  blas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  baex_fec_fin_excep TIMESTAMP WITHOUT TIME ZONE,
  baex_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  baex_user_ing VARCHAR(30),
  baex_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  baex_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_calificacion_sein (
  sein_sec NUMERIC(23, 0),
  case_cod VARCHAR(15),
  case_desc VARCHAR(200),
  case_orden BIGINT,
  case_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  case_user_ing VARCHAR(30),
  case_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  case_user_mod VARCHAR(30),
  PRIMARY KEY (sein_sec, case_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_carga_arch_nota_estab (
  cane_sec NUMERIC(23, 0),
  tipo_periodo VARCHAR(2),
  desc_tipo_periodo VARCHAR(30),
  esed_sec NUMERIC(23, 0),
  cod_rbd VARCHAR(41),
  esed_descripcion VARCHAR(200),
  cuas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  grcu_letra_curso VARCHAR(2),
  fial_sec NUMERIC(23, 0),
  rut_alumno VARCHAR(15),
  nom_alumno VARCHAR(100),
  nro_lista INTEGER,
  alcu_estado VARCHAR(30),
  asig_cod VARCHAR(20),
  asig_descripcion VARCHAR(200),
  nota_1 VARCHAR(2),
  nota_2 VARCHAR(2),
  nota_3 VARCHAR(2),
  nota_4 VARCHAR(2),
  nota_5 VARCHAR(2),
  nota_6 VARCHAR(2),
  nota_7 VARCHAR(2),
  nota_8 VARCHAR(2),
  nota_9 VARCHAR(2),
  nota_10 VARCHAR(2),
  nota_11 VARCHAR(2),
  nota_12 VARCHAR(2),
  nota_13 VARCHAR(2),
  nota_14 VARCHAR(2),
  nota_15 VARCHAR(2),
  nota_16 VARCHAR(2),
  nota_17 VARCHAR(2),
  nota_18 VARCHAR(2),
  nota_19 VARCHAR(2),
  nota_20 VARCHAR(2),
  prom_parcial VARCHAR(2),
  prom_final VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_carga_grados_log (
  esed_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  grcu_letra_curso VARCHAR(2),
  cglo_observacion VARCHAR(4000),
  cglo_fec_carga TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_cargos_estab (
  esed_sec NUMERIC(23, 0),
  caes_cod VARCHAR(15),
  caes_descripcion VARCHAR(100),
  caes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  caes_user_ing VARCHAR(30),
  caes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  caes_user_mod VARCHAR(30),
  caes_cod_ministerial VARCHAR(5),
  PRIMARY KEY (esed_sec, caes_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_casos_acciones (
  caac_sec NUMERIC(23, 0),
  caso_sec NUMERIC(23, 0),
  caac_tipo_accion VARCHAR(10),
  caac_desc VARCHAR(4000),
  caac_fecha TIMESTAMP WITHOUT TIME ZONE,
  caac_estado VARCHAR(30),
  caac_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  caac_user_ing VARCHAR(30),
  caac_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  caac_user_mod VARCHAR(30),
  caac_causa_accion VARCHAR(5),
  caac_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  caac_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  caac_duracion_dias INTEGER,
  PRIMARY KEY (caac_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_casos_alumnos (
  caal_sec NUMERIC(23, 0),
  caso_sec NUMERIC(23, 0),
  caal_tipo_pers VARCHAR(10),
  pers_sec NUMERIC(23, 0),
  caal_tipo VARCHAR(10),
  caal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  caal_user_ing VARCHAR(30),
  caal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  caal_user_mod VARCHAR(30),
  caal_declar_testigo VARCHAR(4000),
  grcu_sec NUMERIC(23, 0),
  caal_con_anot_neg VARCHAR(2),
  PRIMARY KEY (caal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_casos_alum_accion (
  caal_sec NUMERIC(23, 0),
  caac_sec NUMERIC(23, 0),
  caaa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  caaa_user_ing VARCHAR(30),
  PRIMARY KEY (caal_sec, caac_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_casos_estab (
  caso_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  caso_descrip VARCHAR(200),
  caso_tipo_caso VARCHAR(10),
  caso_caso_desc VARCHAR(4000),
  caso_estado VARCHAR(30),
  caso_fec_caso TIMESTAMP WITHOUT TIME ZONE,
  caso_hora_caso VARCHAR(10),
  lues_sec NUMERIC(23, 0),
  caso_tipo_reporta VARCHAR(10),
  pers_sec_reporta NUMERIC(23, 0),
  pers_sec_asignado NUMERIC(23, 0),
  caso_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  caso_user_ing VARCHAR(30),
  caso_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  caso_user_mod VARCHAR(30),
  caso_tipo_negativa VARCHAR(5),
  caso_momento_incidente VARCHAR(5),
  caso_lugar_incidente VARCHAR(10),
  caso_aspecto_manual VARCHAR(4000),
  caso_tercero_afectado VARCHAR(2),
  caso_tipo_lesion VARCHAR(5),
  caso_tipo_arma VARCHAR(5),
  caso_costo_asociado VARCHAR(500),
  caso_requiere_notif VARCHAR(2),
  caso_tiene_accion VARCHAR(2),
  caso_tipo_func VARCHAR(2),
  prof_sec NUMERIC(23, 0),
  coes_sec NUMERIC(23, 0),
  PRIMARY KEY (caso_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_caso_fotos (
  cafo_sec NUMERIC(23, 0),
  caso_sec NUMERIC(23, 0),
  cafo_imagen BYTEA,
  cafo_nom_arch VARCHAR(500),
  cafo_tam_arch VARCHAR(100),
  cafo_descrip_docto VARCHAR(500),
  PRIMARY KEY (cafo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_citaciones_apoderados (
  ciap_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  ciap_nro_lista INTEGER,
  ciap_fec_citacion TIMESTAMP WITHOUT TIME ZONE,
  ciap_hora_citacion VARCHAR(10),
  ciap_tipo_docente VARCHAR(5),
  ciap_coes_prof NUMERIC(23, 0),
  coal_sec NUMERIC(23, 0),
  ciap_texto VARCHAR(4000),
  ciap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ciap_user_ing VARCHAR(30),
  ciap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ciap_user_mod VARCHAR(30),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (ciap_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_cobros_estab (
  cobe_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  cobe_desc VARCHAR(60),
  cobe_requer VARCHAR(2),
  cobe_mto_cobro NUMERIC(15, 2),
  cobe_nro_cuotas INTEGER,
  cobe_estado VARCHAR(30),
  cobe_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cobe_user_ing VARCHAR(30),
  cobe_aplic_dscto_fam VARCHAR(2),
  PRIMARY KEY (cobe_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_compra_sms (
  cosm_sms_sec NUMERIC,
  esad_cod VARCHAR(30),
  cosm_cant_sms NUMERIC,
  cosm_total_sms NUMERIC,
  cosm_n_factura NUMERIC,
  cosm_usuario_ing VARCHAR(30),
  cosm_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  cosm_usuario_mod VARCHAR(30),
  cosm_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (cosm_sms_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_comunas (
  comu_cod VARCHAR(20),
  comu_descrip VARCHAR(200),
  regi_cod VARCHAR(20),
  comu_cod_ministerial VARCHAR(20),
  PRIMARY KEY (comu_cod, regi_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_concepto_repo_dinam (
  cord_tipo_concepto VARCHAR(5),
  cord_nro_concepto BIGINT,
  cord_desc_concepto VARCHAR(200),
  cord_campo_vista VARCHAR(100),
  PRIMARY KEY (cord_tipo_concepto, cord_nro_concepto)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_condicion_matricula (
  fial_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  coma_tiene_excedente VARCHAR(5),
  coma_derecho_subven VARCHAR(5),
  coma_estudiante_nuevo VARCHAR(5),
  coma_con_matricula VARCHAR(5),
  coma_intercambio VARCHAR(5),
  coma_en_practica VARCHAR(5),
  coma_estudiante_prov VARCHAR(5),
  coma_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  coma_user_ing VARCHAR(30),
  coma_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  coma_user_mod VARCHAR(30),
  coma_nro_resolucion VARCHAR(20),
  coma_fec_resolucion TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (fial_sec, esed_sec, peri_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_contacto_alumnos (
  coal_sec NUMERIC(23, 0),
  fiel_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  coal_fono VARCHAR(15),
  coal_celular VARCHAR(15),
  coal_email VARCHAR(60),
  coal_parentesco VARCHAR(60),
  coal_es_apode VARCHAR(5),
  coal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  coal_user_ing VARCHAR(30),
  coal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  coal_user_mod VARCHAR(30),
  coal_sostenedor VARCHAR(2),
  coal_contacto_emerg VARCHAR(2),
  coal_retira_alumno VARCHAR(2),
  coal_vive_con_alum VARCHAR(2),
  coal_tipo_acred_resi VARCHAR(10),
  coal_tipo_acred_datos VARCHAR(10),
  coal_cod_etnia VARCHAR(10),
  coal_tipo_direc VARCHAR(10),
  coal_direccion VARCHAR(200),
  coal_nro_depto VARCHAR(30),
  regi_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  comu_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  coal_cod_postal VARCHAR(10),
  coal_tipo_email VARCHAR(10),
  coal_pasaporte_dni VARCHAR(60),
  coal_apode_principal VARCHAR(2),
  coal_nivel_educ_cont VARCHAR(10),
  PRIMARY KEY (coal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_contacto_empr (
  coem_sec NUMERIC(23, 0),
  emes_sec NUMERIC(23, 0),
  coem_rut BIGINT,
  coem_dv VARCHAR(1),
  coem_nombres VARCHAR(100),
  coem_ape_pat VARCHAR(60),
  coem_ape_mat VARCHAR(60),
  coem_genero VARCHAR(5),
  coem_celular VARCHAR(30),
  coem_email VARCHAR(60),
  coem_cargo VARCHAR(20),
  coem_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  coem_user_ing VARCHAR(30),
  coem_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  coem_user_mod VARCHAR(30),
  PRIMARY KEY (coem_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_contacto_estab (
  coes_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  coes_fono VARCHAR(15),
  coes_celular VARCHAR(15),
  coes_email VARCHAR(60),
  caes_cod VARCHAR(15),
  coes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  coes_user_ing VARCHAR(30),
  coes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  coes_user_mod VARCHAR(30),
  coes_envio_mail_notif VARCHAR(2),
  coes_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  coes_tipo_acred_resi VARCHAR(10),
  coes_tipo_acred_datos VARCHAR(10),
  coes_cod_etnia VARCHAR(10),
  coes_cod_postal VARCHAR(10),
  coes_tipo_email VARCHAR(10),
  coes_pasaporte_dni VARCHAR(60),
  coes_nivel_estudio VARCHAR(10),
  coes_cod_cargo_min VARCHAR(10),
  PRIMARY KEY (coes_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_contacto_firmas (
  coes_sec NUMERIC(23, 0),
  cofi_firma BYTEA,
  PRIMARY KEY (coes_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ctrl_atrasos_alumnos (
  atal_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  atal_fecha_atraso TIMESTAMP WITHOUT TIME ZONE,
  atal_hora_atraso VARCHAR(6),
  atal_observacion VARCHAR(400),
  atal_responsable_atraso VARCHAR(5),
  coal_sec NUMERIC(23, 0),
  atal_rut_resp BIGINT,
  atal_dv_resp VARCHAR(1),
  atal_nombre_resp VARCHAR(100),
  atal_ape_pat_resp VARCHAR(60),
  atal_ape_mat_resp VARCHAR(60),
  atal_nro_bloque INTEGER,
  cuas_sec NUMERIC(23, 0),
  cths_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cths_user_ing VARCHAR(30),
  cths_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  cths_user_mod VARCHAR(30),
  PRIMARY KEY (atal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ctrl_horario_salida (
  cths_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  cths_tipo_salida VARCHAR(5),
  coal_sec NUMERIC(23, 0),
  cths_rut_retira BIGINT,
  cths_dv_retira VARCHAR(1),
  cths_nombre_retira VARCHAR(100),
  cths_ape_pat_retira VARCHAR(60),
  cths_ape_mat_retira VARCHAR(60),
  cths_fecha_salida TIMESTAMP WITHOUT TIME ZONE,
  cths_hora_salida VARCHAR(6),
  cths_hora_regreso VARCHAR(6),
  cths_observacion VARCHAR(400),
  cths_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cths_user_ing VARCHAR(30),
  cths_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  cths_user_mod VARCHAR(30),
  PRIMARY KEY (cths_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ctrl_horario_salida_tmp (
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  cths_tipo_salida VARCHAR(5),
  cths_fecha_salida TIMESTAMP WITHOUT TIME ZONE,
  cths_hora_salida VARCHAR(6),
  cths_observacion VARCHAR(400),
  cths_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cths_user_ing VARCHAR(30),
  cths_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  cths_user_mod VARCHAR(30),
  coal_sec NUMERIC(23, 0),
  cths_rut_retira BIGINT,
  cths_dv_retira VARCHAR(1),
  cths_nombre_retira VARCHAR(100),
  cths_ape_pat_retira VARCHAR(60),
  cths_ape_mat_retira VARCHAR(60),
  cths_hora_regreso VARCHAR(6)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ctrl_hora_sali_docto (
  hsdo_sec NUMERIC(23, 0),
  cths_sec NUMERIC(23, 0),
  hsdo_docto BYTEA,
  hsdo_nom_docto VARCHAR(100),
  PRIMARY KEY (hsdo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_cuas_paso (
  cod_estab VARCHAR(30),
  asig_desc VARCHAR(200),
  cod_asig VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_curso_asignatura (
  cuas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  asig_cod VARCHAR(20),
  cuas_tipo_peri VARCHAR(10),
  cuas_cod_padre VARCHAR(20),
  cuas_tipo_calif VARCHAR(10),
  cuas_aplica_prom VARCHAR(5),
  cuas_aplica_informe VARCHAR(5),
  cuas_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cuas_user_ing VARCHAR(30),
  cuas_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  cuas_user_mod VARCHAR(30),
  cuas_orden_h INTEGER,
  cuas_flag_notas_h VARCHAR(5),
  cuas_id_classroom VARCHAR(256),
  cuas_orden_info INTEGER,
  cuas_horas_asig NUMERIC(5, 2),
  cuas_calculo_prom VARCHAR(2),
  cuas_tipo_ponderacion VARCHAR(2),
  cuas_metodo_asig VARCHAR(5),
  cuas_tipo_alum_asig VARCHAR(5),
  cuas_idioma_asig VARCHAR(5),
  cuas_acta_sige VARCHAR(2),
  PRIMARY KEY (cuas_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_curso_asig_paso (
  cod_rbd VARCHAR(10),
  esed_sec NUMERIC(23, 0),
  cod_tipo_educa VARCHAR(10),
  grte_cod VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  cod_asig VARCHAR(30),
  cnt_alumn NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_curso_asig_tipo_calif_bkp (
  esed_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  grcu_letra_curso VARCHAR(2),
  asig_cod VARCHAR(20),
  asig_descripcion VARCHAR(200),
  cuas_tipo_calif VARCHAR(10),
  cuas_aplica_prom VARCHAR(5),
  cuas_tipo_peri VARCHAR(10),
  cuas_cod_padre VARCHAR(20),
  cuas_aplica_informe VARCHAR(5),
  cuas_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cuas_user_ing VARCHAR(30),
  cuas_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  cuas_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_curso_profesores (
  cuas_sec NUMERIC(23, 0),
  prof_sec NUMERIC(23, 0),
  cupr_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  cupr_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  cupr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cupr_user_ing VARCHAR(30),
  cupr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  cupr_user_mod VARCHAR(30),
  cupr_es_principal VARCHAR(2),
  PRIMARY KEY (cuas_sec, prof_sec, cupr_fec_ini)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_datos_docto (
  dado_sec NUMERIC(23, 0),
  usua_usuario BIGINT,
  esed_sec NUMERIC(23, 0),
  dado_nom_docto VARCHAR(100),
  dado_descrip VARCHAR(500),
  dado_tipo_docto VARCHAR(10),
  dado_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dado_user_ing VARCHAR(60),
  dado_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  dado_user_mod VARCHAR(60),
  dado_ext_docto VARCHAR(15),
  dado_asignatura VARCHAR(100),
  dado_nivel_grado VARCHAR(100),
  dado_url VARCHAR(100),
  PRIMARY KEY (dado_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_actitudes (
  acti_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  acti_cod INTEGER,
  acti_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_ambitos (
  ambi_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  ambi_cod VARCHAR(10),
  ambi_desc VARCHAR(4000),
  ambi_es_transversal VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_conoci (
  cono_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  cono_cod INTEGER,
  cono_desc VARCHAR(4000),
  cono_tipo_cono VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_conoci_hijo (
  cohi_sec NUMERIC(23, 0),
  cono_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  cohi_cod INTEGER,
  cohi_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_contenidos (
  cont_sec NUMERIC(23, 0),
  obje_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  cont_cod INTEGER,
  cont_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_criterio_eval (
  crev_sec NUMERIC(23, 0),
  indi_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  crev_cod VARCHAR(5),
  crev_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_eje_obj (
  ejob_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  obje_cod VARCHAR(10),
  ejob_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_estudio (
  pres_cod VARCHAR(10),
  pres_desc VARCHAR(500),
  pres_anno INTEGER,
  pres_estado VARCHAR(20),
  pres_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pres_user_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_grado_asig (
  gras_sec NUMERIC(23, 0),
  pres_cod VARCHAR(10),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  asig_cod VARCHAR(20),
  gras_estado VARCHAR(20),
  gras_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gras_user_ing VARCHAR(30),
  asig_cod_padre VARCHAR(20),
  gras_formacion VARCHAR(10),
  gras_modalidad VARCHAR(10),
  PRIMARY KEY (gras_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_habi (
  habi_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  habi_cod INTEGER,
  habi_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_indicadores (
  indi_sec NUMERIC(23, 0),
  obje_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  indi_cod INTEGER,
  indi_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_mencion (
  menc_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  menc_cod INTEGER,
  menc_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_modulo (
  modu_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  modu_cod INTEGER,
  modu_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_nucleos (
  nucl_sec NUMERIC(23, 0),
  ambi_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  nucl_cod INTEGER,
  nucl_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_objetivos (
  obje_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  obje_cod VARCHAR(10),
  obje_desc VARCHAR(4000),
  obje_es_priori VARCHAR(2),
  obje_tipo_obje VARCHAR(5),
  nucl_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_obj_generico (
  obge_sec NUMERIC(23, 0),
  crev_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  obge_cod VARCHAR(5),
  obge_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_palab_claves (
  plcl_sec NUMERIC(23, 0),
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  plcl_cod INTEGER,
  plcl_desc VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dato_prog_unidad (
  unid_sec NUMERIC(23, 0),
  gras_sec NUMERIC(23, 0),
  unid_cod INTEGER,
  unid_desc VARCHAR(4000),
  modu_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_debitar_det (
  dede_sec NUMERIC(23, 0),
  deen_sec NUMERIC(23, 0),
  pade_sec NUMERIC(23, 0),
  dede_nro_cuota INTEGER,
  dede_mto_a_pagar NUMERIC(15, 2),
  dede_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dede_user_ing VARCHAR(30),
  PRIMARY KEY (dede_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_debitar_enc (
  deen_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  deen_monto VARCHAR(20),
  deen_fecha TIMESTAMP WITHOUT TIME ZONE,
  deen_token VARCHAR(64),
  deen_vci VARCHAR(20),
  deen_amount VARCHAR(20),
  deen_status VARCHAR(64),
  deen_buy_orden VARCHAR(64),
  deen_session_id VARCHAR(64),
  deen_card_detail VARCHAR(19),
  deen_accounting_date VARCHAR(4),
  deen_transaction_date VARCHAR(30),
  deen_authorization_code VARCHAR(6),
  deen_payment_type_code VARCHAR(4),
  deen_response_code VARCHAR(2),
  deeb_instllments_amount VARCHAR(17),
  deeb_instllments_number VARCHAR(2),
  deen_balance VARCHAR(17),
  deen_url_boleta VARCHAR(100),
  deen_url_nota_credito VARCHAR(100),
  deen_url_ref VARCHAR(100),
  deen_estado VARCHAR(30),
  deen_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  deen_user_ing VARCHAR(30),
  pers_sec_sostenedor NUMERIC(23, 0),
  PRIMARY KEY (deen_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_decretos (
  decr_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  decr_cod VARCHAR(20),
  decr_texto VARCHAR(4000),
  decr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  decr_user_ing VARCHAR(30),
  decr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  decr_user_mod VARCHAR(30),
  decr_fec_decreto TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (decr_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_decreto_ministerio (
  decm_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  decm_cod VARCHAR(10),
  decm_nombre VARCHAR(100),
  decm_estado VARCHAR(30),
  decm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  decm_user_ing VARCHAR(30),
  decm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  decm_user_mod VARCHAR(30),
  decm_fecha_decreto TIMESTAMP WITHOUT TIME ZONE,
  decm_tipo VARCHAR(2),
  PRIMARY KEY (decm_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_det_documento (
  dedo_sec NUMERIC(23, 0),
  endo_sec NUMERIC(23, 0),
  pade_sec NUMERIC(23, 0),
  dedo_num_item BIGINT,
  dedo_cod_prod VARCHAR(30),
  dedo_nom_prod VARCHAR(100),
  dedo_cantidad BIGINT,
  dedo_precio_unit NUMERIC(18, 2),
  dedo_monto_dscto NUMERIC(18, 2),
  dedo_monto_total NUMERIC(18, 2),
  dedo_user_mod VARCHAR(50),
  dedo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (dedo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_alumnos (
  doal_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  doal_tipo_docto VARCHAR(10),
  doal_nom_docto VARCHAR(100),
  doal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  doal_user_ing VARCHAR(30),
  doal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  doal_user_mod VARCHAR(30),
  doal_nom_arch VARCHAR(512),
  doal_nom_arch_int VARCHAR(512),
  doal_tamano_arch BIGINT,
  doal_tipo_carga VARCHAR(2),
  PRIMARY KEY (doal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_alum_det (
  dade_sec NUMERIC(23, 0),
  doal_sec NUMERIC(23, 0),
  dade_docto BYTEA,
  PRIMARY KEY (dade_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_curso (
  dccu_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  dccu_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  dccu_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  dado_sec NUMERIC(23, 0),
  dccu_con_evaluacion VARCHAR(5),
  dccu_mensaje VARCHAR(500),
  dccu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dccu_user_ing VARCHAR(60),
  dccu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  dccu_user_mod VARCHAR(60),
  PRIMARY KEY (dccu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_log (
  dolo_sec NUMERIC,
  dado_sec NUMERIC,
  dolo_nom_docto VARCHAR(60),
  dolo_descrip VARCHAR(600),
  dolo_user_login VARCHAR(60),
  dolo_fec_download TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_prof_deta (
  dpen_sec NUMERIC(23, 0),
  dpde_docto BYTEA,
  dpde_cod_clave VARCHAR(256),
  PRIMARY KEY (dpen_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_prof_enca (
  dpen_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  dccu_sec NUMERIC(23, 0),
  usua_usuario BIGINT,
  dpen_estado VARCHAR(5),
  dpen_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dpen_user_ing VARCHAR(30),
  dpen_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  dpen_user_mod VARCHAR(30),
  dpen_ext_docto VARCHAR(15),
  PRIMARY KEY (dpen_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_verificado (
  dove_sec NUMERIC(23, 0),
  tepo_sec NUMERIC(23, 0),
  dove_cod VARCHAR(10),
  fial_sec NUMERIC(23, 0),
  dove_fec_soli TIMESTAMP WITHOUT TIME ZONE,
  dove_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  dove_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dove_user_ing VARCHAR(30),
  PRIMARY KEY (dove_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_verif_arch (
  dove_sec NUMERIC(23, 0),
  dova_docto BYTEA,
  dova_cod_clave VARCHAR(256),
  PRIMARY KEY (dove_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_docto_verif_arch_verif (
  dove_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_documentos (
  dado_sec NUMERIC(23, 0),
  docu_docto BYTEA,
  docu_cod_clave VARCHAR(256),
  PRIMARY KEY (dado_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_dscto_x_familia (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  dsfa_cod VARCHAR(30),
  dsfa_desc VARCHAR(100),
  dsfa_desde INTEGER,
  dsfa_hasta INTEGER,
  dsfa_tipo_dscto VARCHAR(10),
  dsfa_monto NUMERIC(15, 2),
  dsfa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dsfa_user_ing VARCHAR(30),
  dsfa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  dsfa_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, peri_sec, dsfa_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_empresa_estab (
  emes_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  emes_rut BIGINT,
  emes_dv VARCHAR(1),
  emes_nom_empr VARCHAR(100),
  emes_direccion VARCHAR(100),
  regi_cod VARCHAR(20),
  comu_cod VARCHAR(20),
  emes_telefono VARCHAR(30),
  emes_email VARCHAR(60),
  emes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  emes_user_ing VARCHAR(30),
  emes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  emes_user_mod VARCHAR(30),
  PRIMARY KEY (emes_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_enc_documento (
  endo_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  endo_folio NUMERIC(23, 0),
  endo_tipo VARCHAR(5),
  endo_origen VARCHAR(30),
  endo_ult_estado VARCHAR(20),
  endo_clie_rut BIGINT,
  endo_clie_dv VARCHAR(1),
  endo_razon_social VARCHAR(100),
  endo_giro VARCHAR(100),
  endo_direccion VARCHAR(200),
  endo_fono VARCHAR(50),
  endo_comuna VARCHAR(30),
  endo_ciudad VARCHAR(30),
  endo_fec_emision TIMESTAMP WITHOUT TIME ZONE,
  endo_fec_vcto TIMESTAMP WITHOUT TIME ZONE,
  endo_forma_pago VARCHAR(20),
  endo_subtotal NUMERIC(18, 2),
  endo_dscto NUMERIC(18, 2),
  endo_neto NUMERIC(18, 2),
  endo_iva NUMERIC(18, 2),
  endo_total NUMERIC(18, 2),
  endo_doc_orig_tipo VARCHAR(5),
  endo_doc_orig_seq NUMERIC(23, 0),
  endo_url_doc VARCHAR(2000),
  endo_url_acepta VARCHAR(2000),
  endo_url_resp VARCHAR(2000),
  endo_xml_doc TEXT,
  endo_user_mod VARCHAR(50),
  endo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  deen_sec NUMERIC(23, 0),
  endo_motivo VARCHAR(20),
  PRIMARY KEY (endo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_enfermeria_curso (
  encu_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  encu_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  encu_hora_atencion VARCHAR(10),
  encu_tipo_atencion VARCHAR(10),
  encu_peso_kg BIGINT,
  encu_estatura_cm NUMERIC(10, 2),
  encu_motivo_ing VARCHAR(500),
  encu_obs_tratamiento VARCHAR(4000),
  encu_nom_profesional VARCHAR(100),
  encu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  encu_user_ing VARCHAR(30),
  encu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  encu_user_mod VARCHAR(30),
  encu_imc NUMERIC(10, 2),
  PRIMARY KEY (encu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_entrega_classroom (
  excl_sec VARCHAR(256),
  alcl_sec VARCHAR(256),
  encl_fecha TIMESTAMP WITHOUT TIME ZONE,
  encl_hora VARCHAR(5),
  encl_nota VARCHAR(4),
  encl_entrego VARCHAR(2),
  encl_tarde VARCHAR(2),
  encl_tipo VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_envio_mail (
  enma_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  enma_proceso VARCHAR(30),
  enma_fecha_registro TIMESTAMP WITHOUT TIME ZONE,
  enma_fecha_envio TIMESTAMP WITHOUT TIME ZONE,
  enma_esta_cod VARCHAR(200),
  enma_destinatario VARCHAR(1000),
  enma_texto_msg VARCHAR(4000),
  endo_sec NUMERIC(23, 0),
  PRIMARY KEY (enma_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_especialidad (
  espe_cod VARCHAR(20),
  espe_descrip VARCHAR(200),
  sect_cod VARCHAR(20),
  espe_cod_ministerial VARCHAR(10),
  PRIMARY KEY (espe_cod, sect_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_admin (
  esad_cod VARCHAR(30),
  esad_descripcion VARCHAR(200),
  esad_desc_corta VARCHAR(100),
  esad_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  esad_cod_postal VARCHAR(30),
  esad_rut_resp BIGINT,
  esad_dv_resp VARCHAR(1),
  esad_nom_resp VARCHAR(100),
  esad_ape_pat_resp VARCHAR(60),
  esad_ape_mat_resp VARCHAR(60),
  esad_fono VARCHAR(15),
  esad_celular VARCHAR(15),
  esad_email VARCHAR(60),
  esad_sitio_web VARCHAR(100),
  esad_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  esad_user_ing VARCHAR(30),
  esad_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  esad_user_mod VARCHAR(30),
  esad_credencial VARCHAR(4000),
  esad_correo VARCHAR(100),
  esad_id_google VARCHAR(4000),
  esad_vigente VARCHAR(1),
  esad_glosa_vig VARCHAR(64),
  esad_cliente_id NUMERIC(23, 0),
  esad_conv_id NUMERIC(23, 0),
  esad_conv_token VARCHAR(100),
  PRIMARY KEY (esad_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_apps (
  esed_sec NUMERIC(23, 0),
  tiap_cod VARCHAR(10),
  esap_vigencia VARCHAR(1),
  esap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  esap_user_ing VARCHAR(30),
  esap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  esap_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, tiap_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_docto (
  esdo_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  esdo_nom_docto VARCHAR(200),
  esdo_docto BYTEA,
  PRIMARY KEY (esdo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_educa (
  esed_sec NUMERIC(23, 0),
  esed_cod VARCHAR(30),
  esad_cod VARCHAR(30),
  esed_descripcion VARCHAR(200),
  esed_desc_corta VARCHAR(100),
  esed_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  esed_nro_resol VARCHAR(20),
  esed_fec_resol TIMESTAMP WITHOUT TIME ZONE,
  esed_cod_postal VARCHAR(30),
  esed_fono VARCHAR(15),
  esed_celular VARCHAR(15),
  esed_email VARCHAR(60),
  esed_genero VARCHAR(10),
  esed_sitio_web VARCHAR(100),
  esed_geo_longitud VARCHAR(30),
  esed_geo_latitud VARCHAR(30),
  esed_referen_direc VARCHAR(100),
  esed_aut_inter_elect VARCHAR(5),
  esde_pago_matricula VARCHAR(30),
  esde_pago_mensual VARCHAR(30),
  esde_ori_religiosa VARCHAR(60),
  esde_centro_padre VARCHAR(5),
  esde_personalidad_jur VARCHAR(5),
  esed_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  esed_user_ing VARCHAR(30),
  esed_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  esed_user_mod VARCHAR(30),
  esde_tipo_periodo VARCHAR(5),
  esde_dv VARCHAR(10),
  esde_decreto_estado VARCHAR(60),
  esde_fec_decreto TIMESTAMP WITHOUT TIME ZONE,
  esde_tipo_asistencia VARCHAR(2),
  esde_credencial VARCHAR(4000),
  esde_correo VARCHAR(100),
  esde_id_google VARCHAR(4000),
  esde_sms_disponible NUMERIC,
  esed_rut_estab BIGINT,
  esed_dv_estab VARCHAR(1),
  esed_giro_cod VARCHAR(15),
  esed_libro_digital VARCHAR(2),
  esde_estado_estab VARCHAR(10),
  esde_fec_cierre TIMESTAMP WITHOUT TIME ZONE,
  esed_area_geografica VARCHAR(5),
  esed_fec_ini_peri_acad TIMESTAMP WITHOUT TIME ZONE,
  esed_fec_fin_peri_acad TIMESTAMP WITHOUT TIME ZONE,
  esed_tipo_ref_estab VARCHAR(5),
  esed_dependencia_estab VARCHAR(5),
  esed_tipo_incremento VARCHAR(5),
  esed_valor_porc_basica NUMERIC(5, 2),
  esed_valor_proc_media NUMERIC(5, 2),
  esed_porcentaje_ive NUMERIC(5, 2),
  esed_estado_internet VARCHAR(5),
  esed_metodo_ensenanza VARCHAR(5),
  esed_vigente VARCHAR(1),
  esed_glosa_vig VARCHAR(64),
  PRIMARY KEY (esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_educa_logo (
  esed_sec NUMERIC(23, 0),
  eelo_imagen BYTEA,
  PRIMARY KEY (esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_actitudes (
  epac_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epac_cod INTEGER,
  epac_desc VARCHAR(4000),
  epac_tipo VARCHAR(5),
  PRIMARY KEY (epac_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_ambitos (
  epam_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epam_cod VARCHAR(10),
  epam_desc VARCHAR(4000),
  epam_tipo VARCHAR(5),
  epam_es_transversal VARCHAR(2),
  PRIMARY KEY (epam_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_conoci (
  epco_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epco_cod INTEGER,
  epco_desc VARCHAR(4000),
  epco_tipo VARCHAR(5),
  epco_tipo_conoci VARCHAR(10),
  PRIMARY KEY (epco_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_conoci_hijo (
  epch_sec NUMERIC(23, 0),
  epco_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epch_cod INTEGER,
  epch_desc VARCHAR(4000),
  epch_tipo VARCHAR(5),
  PRIMARY KEY (epch_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_contenidos (
  epct_sec NUMERIC(23, 0),
  epob_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epct_cod INTEGER,
  epct_desc VARCHAR(4000),
  epct_tipo VARCHAR(5),
  PRIMARY KEY (epct_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_criterio_eval (
  epce_sec NUMERIC(23, 0),
  epin_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epce_cod VARCHAR(5),
  epce_desc VARCHAR(4000),
  epce_tipo VARCHAR(5),
  PRIMARY KEY (epce_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_eje_obj (
  epeo_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epob_cod VARCHAR(10),
  epeo_desc VARCHAR(4000),
  epeo_tipo VARCHAR(5),
  PRIMARY KEY (epeo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_grado_asig (
  epga_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  pres_cod VARCHAR(10),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  asig_cod VARCHAR(20),
  epga_estado VARCHAR(20),
  epga_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  epga_user_ing VARCHAR(30),
  asig_cod_padre VARCHAR(20),
  epga_formacion VARCHAR(10),
  epga_modalidad VARCHAR(10),
  epga_tipo VARCHAR(2),
  PRIMARY KEY (epga_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_habi (
  epha_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epha_cod INTEGER,
  epha_desc VARCHAR(4000),
  epha_tipo VARCHAR(5),
  PRIMARY KEY (epha_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_indicadores (
  epin_sec NUMERIC(23, 0),
  epob_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epin_cod INTEGER,
  epin_desc VARCHAR(4000),
  epin_tipo VARCHAR(5),
  PRIMARY KEY (epin_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_mencion (
  epme_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epme_cod INTEGER,
  epme_desc VARCHAR(4000),
  epme_tipo VARCHAR(5),
  PRIMARY KEY (epme_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_modulo (
  epmo_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epmo_cod INTEGER,
  epmo_desc VARCHAR(4000),
  epmo_tipo VARCHAR(5),
  peri_sec NUMERIC(23, 0),
  PRIMARY KEY (epmo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_nucleos (
  epnu_sec NUMERIC(23, 0),
  epam_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epnu_cod INTEGER,
  epnu_desc VARCHAR(4000),
  epnu_tipo VARCHAR(5),
  PRIMARY KEY (epnu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_objetivos (
  epob_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epob_cod VARCHAR(10),
  epob_desc VARCHAR(4000),
  epob_es_priori VARCHAR(2),
  epob_tipo VARCHAR(5),
  epob_tipo_obje VARCHAR(5),
  epnu_sec NUMERIC(23, 0),
  PRIMARY KEY (epob_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_obj_generico (
  epog_sec NUMERIC(23, 0),
  epce_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epog_cod VARCHAR(5),
  epog_desc VARCHAR(4000),
  epog_tipo VARCHAR(5),
  PRIMARY KEY (epog_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_palab_clave (
  eppc_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  eppc_cod INTEGER,
  eppc_desc VARCHAR(4000),
  eppc_tipo VARCHAR(5),
  PRIMARY KEY (eppc_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_estab_prog_unidad (
  epun_sec NUMERIC(23, 0),
  epga_sec NUMERIC(23, 0),
  epun_cod INTEGER,
  epun_desc VARCHAR(4000),
  epun_tipo VARCHAR(5),
  peri_sec NUMERIC(23, 0),
  epmo_sec NUMERIC(23, 0),
  PRIMARY KEY (epun_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_evaluacion_ines (
  evin_sec NUMERIC(23, 0),
  ines_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_fec_incorp TIMESTAMP WITHOUT TIME ZONE,
  evin_fec_eval TIMESTAMP WITHOUT TIME ZONE,
  evin_obs VARCHAR(4000),
  evin_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  evin_user_ing VARCHAR(30),
  evin_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  evin_user_mod VARCHAR(30),
  evin_estado VARCHAR(30),
  evin_pers_sec_f1 NUMERIC(23, 0),
  evin_pers_sec_f2 NUMERIC(23, 0),
  evin_pers_sec_f3 NUMERIC(23, 0),
  evin_pers_sec_f4 NUMERIC(23, 0),
  plev_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (evin_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_evaluacion_prof (
  evin_sec NUMERIC(23, 0),
  ines_sec NUMERIC(23, 0),
  prof_sec NUMERIC(23, 0),
  evpr_fec_eval TIMESTAMP WITHOUT TIME ZONE,
  plev_sec NUMERIC(23, 0),
  evpr_obs VARCHAR(4000),
  evpr_estado VARCHAR(30),
  evpr_pers_sec_f1 NUMERIC(23, 0),
  evpr_pers_sec_f2 NUMERIC(23, 0),
  evpr_pers_sec_f3 NUMERIC(23, 0),
  evpr_pers_sec_f4 NUMERIC(23, 0),
  evpr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  evpr_user_ing VARCHAR(30),
  evpr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  evpr_user_mod VARCHAR(30),
  PRIMARY KEY (evin_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_eventos (
  even_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  even_usuario BIGINT,
  even_asunto VARCHAR(100),
  even_texto VARCHAR(4000),
  even_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  even_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  even_recurrencia VARCHAR(1),
  even_periodo_recu VARCHAR(5),
  even_info_recu VARCHAR(5),
  even_tipo_usua VARCHAR(5),
  even_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  even_user_ing VARCHAR(30),
  even_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  even_user_mod VARCHAR(30),
  even_color VARCHAR(60),
  PRIMARY KEY (even_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_examen_classroom (
  excl_sec VARCHAR(256),
  cuas_id_classroom VARCHAR(256),
  excl_nombre VARCHAR(256),
  excl_fecha TIMESTAMP WITHOUT TIME ZONE,
  excl_hora VARCHAR(5),
  excl_nota VARCHAR(4),
  PRIMARY KEY (excl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_fecha_postulacion (
  fepo_nro INTEGER,
  fepo_fecha TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_fecha_postulacion_2020 (
  fepo_nro INTEGER,
  fepo_fecha TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_fecha_postulacion_202203 (
  fepo_nro INTEGER,
  fepo_fecha TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_festivos_estab (
  fees_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  fees_fecha TIMESTAMP WITHOUT TIME ZONE,
  fees_observacion VARCHAR(4000),
  fees_asunto VARCHAR(50),
  fees_color VARCHAR(10),
  fees_tipo_evento VARCHAR(10),
  PRIMARY KEY (fees_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_fial_prob_apren (
  fapa_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  fapa_cod VARCHAR(5),
  fapa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fapa_user_ing VARCHAR(30),
  PRIMARY KEY (fapa_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ficha_alumno (
  fial_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  fial_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  fial_email VARCHAR(60),
  fial_fono VARCHAR(15),
  fial_celular VARCHAR(15),
  fial_cod_etnia VARCHAR(10),
  fial_fec_incorporacion TIMESTAMP WITHOUT TIME ZONE,
  fial_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  fial_estado VARCHAR(30),
  fial_es_prioritario VARCHAR(2),
  fial_es_preferente VARCHAR(2),
  fial_nro_matr_estab VARCHAR(30),
  fial_nro_matr_sistema VARCHAR(30),
  fial_prog_integ_escolar VARCHAR(30),
  fial_obs_medica VARCHAR(100),
  fial_obs_alergia VARCHAR(100),
  fial_obs_enfermedad VARCHAR(100),
  fial_grupo_sanguineo VARCHAR(60),
  fial_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fial_user_ing VARCHAR(30),
  fial_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fial_user_mod VARCHAR(30),
  pais_cod VARCHAR(20),
  fial_esta_dato_sige VARCHAR(15),
  fial_email_corp VARCHAR(100),
  fial_observ_retiro VARCHAR(500),
  fial_tipo_residencia VARCHAR(10),
  fial_tipo_visa VARCHAR(10),
  fial_tipo_acred_resi VARCHAR(10),
  fial_tipo_acred_datos VARCHAR(10),
  fial_cod_postal VARCHAR(10),
  fial_tipo_email VARCHAR(10),
  fial_pasaporte_dni VARCHAR(60),
  fial_tipo_tel VARCHAR(5),
  fial_problema_aprendizaje VARCHAR(5),
  fial_tipo_inst_salud VARCHAR(2),
  fial_tramo_fonasa VARCHAR(2),
  fial_cod_isapre VARCHAR(10),
  fial_tipo_vivienda VARCHAR(20),
  fial_padece_enfermedad VARCHAR(2),
  fial_nombre_enfermedad VARCHAR(200),
  fial_ingiere_medicamento VARCHAR(2),
  fial_nombre_medicamento VARCHAR(200),
  fial_alergico_medic_antib VARCHAR(2),
  fial_nombre_antibiotico VARCHAR(200),
  PRIMARY KEY (fial_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ficha_alum_fotos (
  fial_sec NUMERIC(23, 0),
  fafo_imagen BYTEA,
  fafo_cod_clave VARCHAR(256),
  PRIMARY KEY (fial_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ficha_alum_pie (
  fiap_sec NUMERIC(23, 0),
  fiap_ini TIMESTAMP WITHOUT TIME ZONE,
  fiap_fin TIMESTAMP WITHOUT TIME ZONE,
  fial_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fiap_edad INTEGER,
  fiap_nom_tutor VARCHAR(100),
  fiap_peso_kg BIGINT,
  fiap_estatura_cm NUMERIC(10, 2),
  fiap_reg_clinico VARCHAR(4000),
  fiap_diagnostico VARCHAR(4000),
  fiap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fiap_user_ing VARCHAR(30),
  fiap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fiap_user_mod VARCHAR(30),
  PRIMARY KEY (fiap_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ficha_paso_tmp (
  cod_rbd VARCHAR(30),
  rut_alumno BIGINT,
  fial_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ficha_profesores (
  prof_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  prof_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  prof_email VARCHAR(255),
  prof_fono VARCHAR(15),
  prof_celular VARCHAR(15),
  prof_fec_incorporacion TIMESTAMP WITHOUT TIME ZONE,
  prof_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  prof_estado VARCHAR(30),
  prof_obs_medica VARCHAR(100),
  prof_obs_alergia VARCHAR(100),
  prof_obs_enfermedad VARCHAR(100),
  prof_grupo_sanguineo VARCHAR(60),
  prof_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prof_user_ing VARCHAR(30),
  prof_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  prof_user_mod VARCHAR(30),
  pais_cod VARCHAR(20),
  prof_tipo_acred_resi VARCHAR(10),
  prof_tipo_acred_datos VARCHAR(10),
  prof_cod_etnia VARCHAR(10),
  prof_cod_postal VARCHAR(10),
  prof_tipo_email VARCHAR(10),
  prof_pasaporte_dni VARCHAR(60),
  prof_nivel_estudio VARCHAR(10),
  prof_tipo_acceso VARCHAR(5),
  PRIMARY KEY (prof_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ficha_prof_fotos (
  prof_sec NUMERIC(23, 0),
  prfo_imagen BYTEA,
  PRIMARY KEY (prof_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ficha_prof_paso (
  cod_rbd VARCHAR(30),
  pers_rut BIGINT,
  pers_dv VARCHAR(1),
  pers_nombre VARCHAR(100),
  pers_ape_pat VARCHAR(100),
  pers_ape_mat VARCHAR(100),
  pers_genero VARCHAR(2),
  pers_fec_nac TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_folio (
  folio_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  endo_tipo VARCHAR(5),
  folio_num NUMERIC(23, 0),
  endo_sec NUMERIC(23, 0),
  folio_estado VARCHAR(10),
  PRIMARY KEY (folio_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_forma_academica_coes (
  face_sec NUMERIC(23, 0),
  coes_sec NUMERIC(23, 0),
  face_tipo_forma_acad VARCHAR(10),
  face_nom_forma_acad VARCHAR(200),
  face_insti_forma_acad VARCHAR(100),
  face_anno_forma_acad INTEGER,
  face_docto_forma_acad VARCHAR(10),
  face_forma_acad_princ VARCHAR(2),
  PRIMARY KEY (face_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_forma_academica_prof (
  fapr_sec NUMERIC(23, 0),
  prof_sec NUMERIC(23, 0),
  fapr_tipo_forma_acad VARCHAR(10),
  fapr_nom_forma_acad VARCHAR(200),
  fapr_insti_forma_acad VARCHAR(100),
  fapr_anno_forma_acad INTEGER,
  fapr_docto_forma_acad VARCHAR(10),
  fapr_forma_acad_princ VARCHAR(2),
  fapr_idoneidad_docente VARCHAR(2),
  PRIMARY KEY (fapr_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_funcionalidad (
  func_cod VARCHAR(20),
  func_descripcion VARCHAR(200),
  func_desc_corta VARCHAR(60),
  PRIMARY KEY (func_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_func_apli (
  func_cod VARCHAR(20),
  apli_cod VARCHAR(50),
  fuap_valor INTEGER,
  fuap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fuap_user_ing VARCHAR(30),
  fuap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fuap_user_mod VARCHAR(30),
  PRIMARY KEY (func_cod, apli_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_func_corp (
  func_cod VARCHAR(20),
  esad_cod VARCHAR(30),
  apli_cod VARCHAR(50),
  fuco_valor INTEGER,
  fuco_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fuco_user_ing VARCHAR(30),
  fuco_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fuco_user_mod VARCHAR(30),
  PRIMARY KEY (func_cod, esad_cod, apli_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_func_estab (
  func_cod VARCHAR(20),
  esed_sec NUMERIC(23, 0),
  apli_cod VARCHAR(50),
  fues_valor INTEGER,
  fues_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fues_user_ing VARCHAR(30),
  fues_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fues_user_mod VARCHAR(30),
  PRIMARY KEY (func_cod, esed_sec, apli_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grados_cursos (
  grcu_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  grcu_letra_curso VARCHAR(2),
  grcu_tipo_peri VARCHAR(10),
  grcu_jornada VARCHAR(20),
  sect_cod VARCHAR(20),
  espe_cod VARCHAR(20),
  menc_cod VARCHAR(20),
  grcu_estado VARCHAR(30),
  prof_sec NUMERIC(23, 0),
  grcu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  grcu_user_ing VARCHAR(30),
  grcu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  grcu_user_mod VARCHAR(30),
  decr_sec NUMERIC(23, 0),
  ples_sec NUMERIC(23, 0),
  grcu_cnt_vacantes BIGINT,
  plho_sec NUMERIC(23, 0),
  grcu_tipo_asist VARCHAR(5),
  grcu_tipo_bloque VARCHAR(5),
  grcu_nro_bloque INTEGER,
  pldm_sec NUMERIC(23, 0),
  grcu_tipo_curso VARCHAR(10),
  grcu_idioma_curso VARCHAR(5),
  grcu_estado_sige VARCHAR(20),
  PRIMARY KEY (grcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grados_documentos (
  grcu_sec NUMERIC(23, 0),
  grdo_nombre_carga VARCHAR(256),
  grdo_nom_arch_real VARCHAR(512),
  grdo_nom_arch_inte VARCHAR(512),
  grdo_tamano_arch BIGINT,
  grdo_purgado VARCHAR(2),
  grdo_fec_purgado TIMESTAMP WITHOUT TIME ZONE,
  grdo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  grdo_user_ing VARCHAR(30),
  grdo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  grdo_user_mod VARCHAR(30),
  grdo_fec_carga TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (grcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grados_tien (
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  grte_cod_int VARCHAR(10),
  repr_cod VARCHAR(20),
  grte_es_especialidad VARCHAR(2),
  grte_cod_ministerial VARCHAR(10),
  grte_desc_ministerial VARCHAR(100),
  grte_cod_sige VARCHAR(10),
  PRIMARY KEY (tien_cod, grte_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grado_profesores (
  grcu_sec NUMERIC(23, 0),
  prof_sec NUMERIC(23, 0),
  gpro_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  gpro_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  gpro_es_principal VARCHAR(2),
  gpro_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gpro_user_ing VARCHAR(30),
  gpro_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  gpro_user_mod VARCHAR(30),
  PRIMARY KEY (grcu_sec, prof_sec, gpro_fec_ini)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grado_promovido (
  esed_sec NUMERIC(23, 0),
  tien_cod_orig VARCHAR(10),
  grte_cod_orig VARCHAR(10),
  grte_cod_dest VARCHAR(10),
  grpr_grcu_desc VARCHAR(100),
  tien_cod_dest VARCHAR(10),
  PRIMARY KEY (esed_sec, tien_cod_orig, grte_cod_orig)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grae_alumnos (
  aeal_sec NUMERIC(23, 0),
  gael_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  aeal_nro_lista INTEGER,
  aeal_fec_incorp TIMESTAMP WITHOUT TIME ZONE,
  aeal_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  aeal_estado VARCHAR(30),
  aeal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  aeal_user_ing VARCHAR(30),
  aeal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  aeal_user_mod VARCHAR(30),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (aeal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grae_dia_bloque (
  gadb_sec NUMERIC(23, 0),
  gael_sec NUMERIC(23, 0),
  gadb_nro_dia INTEGER,
  gadb_nro_bloque INTEGER,
  gadb_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gadb_user_ing VARCHAR(30),
  gadb_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  gadb_user_mod VARCHAR(30),
  PRIMARY KEY (gadb_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grcu_alum_noval_sige (
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  gcal_glosa_error VARCHAR(4000),
  gcal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gcal_user_ing VARCHAR(30),
  PRIMARY KEY (grcu_sec, fial_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grupos_capacitacion (
  grca_cod BIGINT,
  grca_nombre VARCHAR(100),
  grca_agrupacion VARCHAR(255),
  grca_cnt_cupos BIGINT,
  grca_cnt_partic BIGINT,
  grca_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  grca_user_ing VARCHAR(30),
  grca_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  grca_user_mod VARCHAR(30),
  PRIMARY KEY (grca_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grupos_capacitacion_280726 (
  grca_cod BIGINT,
  grca_nombre VARCHAR(100),
  grca_agrupacion VARCHAR(255),
  grca_cnt_cupos BIGINT,
  grca_cnt_partic BIGINT,
  grca_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  grca_user_ing VARCHAR(30),
  grca_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  grca_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grupos_capac_usuarios (
  grca_cod BIGINT,
  usua_usuarios BIGINT,
  gcus_ind_matri VARCHAR(2),
  gcus_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gcus_user_ing VARCHAR(30),
  gcus_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  gcus_user_mod VARCHAR(30),
  PRIMARY KEY (usua_usuarios)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grupo_alumnos (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  gral_cod VARCHAR(30),
  fial_sec NUMERIC(23, 0),
  gral_orden INTEGER,
  gral_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gral_user_ing VARCHAR(30),
  gral_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  gral_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, peri_sec, fial_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grupo_asel_profesores (
  gael_sec NUMERIC(23, 0),
  prof_sec NUMERIC(23, 0),
  gaep_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  gaep_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  gaep_es_principal VARCHAR(2),
  gaep_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gaep_user_ing VARCHAR(30),
  gaep_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  gaep_user_mod VARCHAR(30),
  PRIMARY KEY (gael_sec, prof_sec, gaep_fec_ini)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_grupo_asig_electiva (
  gael_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  gael_nom_grupo VARCHAR(100),
  asig_cod VARCHAR(50),
  gael_estado VARCHAR(30),
  gael_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  gael_user_ing VARCHAR(30),
  gael_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  gael_user_mod VARCHAR(30),
  prof_sec NUMERIC(23, 0),
  PRIMARY KEY (gael_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_horarios_cursos (
  grcu_sec NUMERIC(23, 0),
  hocu_tipo_peri VARCHAR(5),
  hocu_bloque INTEGER,
  hocu_asig_lu VARCHAR(20),
  hocu_asig_ma VARCHAR(20),
  hocu_asig_mi VARCHAR(20),
  hocu_asig_ju VARCHAR(20),
  hocu_asig_vi VARCHAR(20),
  hocu_asig_sa VARCHAR(20),
  hocu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  hocu_user_ing VARCHAR(30),
  hocu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  hocu_user_mod VARCHAR(30),
  PRIMARY KEY (grcu_sec, hocu_tipo_peri, hocu_bloque)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_horario_deta_dia (
  hodd_sec NUMERIC(23, 0),
  hodi_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  hodd_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  hodd_user_ing VARCHAR(30),
  hodd_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  hodd_user_mod VARCHAR(30),
  PRIMARY KEY (hodd_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_horario_dia (
  hodi_sec NUMERIC(23, 0),
  hopc_sec NUMERIC(23, 0),
  pldh_sec NUMERIC(23, 0),
  hodi_dia INTEGER,
  hodi_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  hodi_user_ing VARCHAR(30),
  PRIMARY KEY (hodi_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_horario_plant_curso (
  hopc_sec NUMERIC(23, 0),
  plho_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  hopc_tipo_peri VARCHAR(30),
  hopc_estado VARCHAR(30),
  hopc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  hopc_user_ing VARCHAR(30),
  hopc_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  hopc_user_mod VARCHAR(30),
  hopc_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  hopc_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (hopc_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_hora_postulacion (
  hopo_nro INTEGER,
  hopo_hora VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_hora_postulacion_2020 (
  hopo_nro INTEGER,
  hopo_hora VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_hora_postulacion_202203 (
  hopo_nro INTEGER,
  hopo_hora VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_informacion_notas (
  cuas_sec NUMERIC(23, 0),
  inno_tipo_peri VARCHAR(10),
  inno_nro_nota INTEGER,
  inno_nombre VARCHAR(20),
  inno_tipo_eval VARCHAR(10),
  inno_fec_eval TIMESTAMP WITHOUT TIME ZONE,
  inno_coeficiente INTEGER,
  inno_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  inno_user_ing VARCHAR(30),
  inno_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  inno_user_mod VARCHAR(30),
  inno_considera_nee VARCHAR(2),
  inno_es_ponderable VARCHAR(2),
  PRIMARY KEY (cuas_sec, inno_tipo_peri, inno_nro_nota)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_informe_estab (
  ines_sec NUMERIC(23, 0),
  ines_nom_info VARCHAR(200),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  ines_estado VARCHAR(30),
  ines_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ines_user_ing VARCHAR(30),
  ines_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ines_user_mod VARCHAR(30),
  ines_cargo_f1 VARCHAR(15),
  ines_cargo_f2 VARCHAR(15),
  ines_cargo_f3 VARCHAR(15),
  ines_cargo_f4 VARCHAR(15),
  ines_tipo_asig VARCHAR(2),
  PRIMARY KEY (ines_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_invi_classroom_log (
  cuas_id_classroom VARCHAR(256),
  fial_sec NUMERIC(23, 0),
  iclo_email_alumno VARCHAR(100),
  iclo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  iclo_user_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_archivos (
  arch_sec NUMERIC,
  esed_sec NUMERIC,
  arch_usuario_gen VARCHAR(100),
  arch_fec_generacion TIMESTAMP WITHOUT TIME ZONE,
  arch_estado VARCHAR(1),
  peri_sec NUMERIC(23, 0),
  PRIMARY KEY (arch_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_01 (
  arge_sec NUMERIC,
  organization_id NUMERIC,
  name VARCHAR(400),
  ref_organization_type_id NUMERIC,
  short_name VARCHAR(400),
  region_geo_json VARCHAR(4000),
  grcu_sec NUMERIC,
  asig_cod VARCHAR(20),
  PRIMARY KEY (arge_sec, organization_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_02 (
  arge_sec NUMERIC,
  organization_relational_id NUMERIC,
  parent_organization_id NUMERIC,
  organization_id NUMERIC,
  ref_organization_relational_id NUMERIC,
  PRIMARY KEY (arge_sec, organization_relational_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_03 (
  arge_sec NUMERIC,
  org_identifier_id NUMERIC,
  identifier VARCHAR(200),
  ref_org_ident_systems_id NUMERIC,
  organizationid NUMERIC,
  ref_org_ident_type_id NUMERIC,
  PRIMARY KEY (arge_sec, org_identifier_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_04 (
  arge_sec NUMERIC,
  org_location_id NUMERIC,
  organization_id NUMERIC,
  location_id NUMERIC,
  ref_org_location_type_id NUMERIC,
  PRIMARY KEY (arge_sec, org_location_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_05 (
  arge_sec NUMERIC,
  organization_email_id NUMERIC,
  organization_id NUMERIC,
  electronic_mail_address VARCHAR(500),
  ref_email_type_id NUMERIC,
  PRIMARY KEY (arge_sec, organization_email_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_06 (
  arge_sec NUMERIC,
  org_telephone_id NUMERIC,
  organization_id NUMERIC,
  telephone_number VARCHAR(200),
  primary_tele_number_indicator NUMERIC,
  ref_institution_tele_type_id NUMERIC,
  PRIMARY KEY (arge_sec, org_telephone_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_07 (
  arge_sec NUMERIC,
  organization_id NUMERIC,
  website VARCHAR(1000),
  PRIMARY KEY (arge_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_08 (
  arge_sec NUMERIC,
  person_id NUMERIC,
  first_name VARCHAR(300),
  middle_name VARCHAR(300),
  last_name VARCHAR(300),
  second_last_name VARCHAR(300),
  generation_code VARCHAR(300),
  prefix VARCHAR(300),
  birthdate VARCHAR(10),
  ref_sex_id NUMERIC,
  hispa_latino_ethnicity NUMERIC,
  ref_us_citi_ship_status_id NUMERIC,
  ref_visa_type_id NUMERIC,
  ref_state_residence_id NUMERIC,
  ref_proof_residency_type_id NUMERIC,
  ref_highest_educ_level_comp_id NUMERIC,
  ref_pers_inf_verification_id NUMERIC,
  birthdate_verification VARCHAR(10),
  ref_tribal_affiliation_id VARCHAR(10),
  tipo_persona VARCHAR(20),
  pers_sec NUMERIC,
  secuencia NUMERIC,
  cargo_persona VARCHAR(10),
  PRIMARY KEY (arge_sec, person_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_09 (
  arge_sec NUMERIC,
  person_identifier_id NUMERIC,
  person_id NUMERIC,
  identifier VARCHAR(50),
  ref_pers_ident_system_id NUMERIC,
  ref_pers_inf_veri_id NUMERIC,
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, person_identifier_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_10 (
  arge_sec NUMERIC,
  person_address_id NUMERIC,
  person_id NUMERIC,
  ref_pers_location_type_id VARCHAR(10),
  street_number_name VARCHAR(1000),
  apartment_room_suite_num VARCHAR(20),
  city VARCHAR(300),
  ref_state_id VARCHAR(30),
  postal_code VARCHAR(40),
  address_county_name VARCHAR(40),
  ref_county_id VARCHAR(40),
  ref_country_id VARCHAR(40),
  latitude NUMERIC,
  longitude NUMERIC,
  ref_pers_info_veri_id NUMERIC,
  PRIMARY KEY (arge_sec, person_address_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_11 (
  arge_sec NUMERIC,
  pers_email_address_id NUMERIC,
  person_id NUMERIC,
  email_address VARCHAR(300),
  ref_email_type_id VARCHAR(10),
  PRIMARY KEY (arge_sec, pers_email_address_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_12 (
  arge_sec NUMERIC,
  school_grade_offered_id NUMERIC,
  organization_id NUMERIC,
  ref_grade_level_id NUMERIC,
  PRIMARY KEY (arge_sec, school_grade_offered_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_13 (
  arge_sec NUMERIC,
  organization_id NUMERIC,
  school_type VARCHAR(3),
  school_level VARCHAR(3),
  adm_fun_control_id VARCHAR(3),
  charter_school_ind VARCHAR(3),
  ref_char_school_type_ind VARCHAR(3),
  ref_inc_lea_time_type_id VARCHAR(3),
  ref_state_poverty_desi_id VARCHAR(3),
  charter_school_appr_year VARCHAR(10),
  ref_char_sch_app_agen_type_id VARCHAR(3),
  accreditation_agency_name VARCHAR(100),
  char_school_open_enr_ind VARCHAR(3),
  char_sch_cont_approval_date VARCHAR(10),
  char_sch_cont_id_number VARCHAR(50),
  char_sch_cont_renewal_date VARCHAR(10),
  ref_char_sch_mana_org_type_id VARCHAR(3),
  PRIMARY KEY (arge_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_14 (
  arge_sec NUMERIC,
  organization_id NUMERIC,
  ref_mag_spe_program_id VARCHAR(1),
  ref_alter_sch_focus_id VARCHAR(1),
  ref_internet_access_id VARCHAR(3),
  ref_restruct_action_id VARCHAR(1),
  ref_title_isch_status_id VARCHAR(1),
  consoli_mep_funds_status VARCHAR(3),
  ref_nati_sch_lunch_prog_sta_id VARCHAR(1),
  ref_virtual_school_status_id VARCHAR(3),
  PRIMARY KEY (arge_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_15 (
  arge_sec NUMERIC,
  org_pers_role_id NUMERIC,
  organization_id NUMERIC,
  person_id NUMERIC,
  role_id NUMERIC,
  entry_date VARCHAR(255),
  exit_date VARCHAR(255),
  tipo_carga VARCHAR(100),
  cuas_sec NUMERIC(23, 0),
  nro_bloque INTEGER,
  tipo_peri VARCHAR(10),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  grcu_sec NUMERIC(23, 0),
  atal_sec NUMERIC(23, 0),
  cths_sec NUMERIC(23, 0),
  PRIMARY KEY (arge_sec, org_pers_role_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_16 (
  arge_sec NUMERIC,
  org_per_role_id NUMERIC,
  ref_entry_grade_leve_lid VARCHAR(3),
  ref_public_school_residence VARCHAR(3),
  ref_enrollment_status_id VARCHAR(3),
  ref_entry_type VARCHAR(3),
  ref_exit_grade_level VARCHAR(3),
  ref_exi_tor_withdrawalsta_id VARCHAR(3),
  ref_exi_tor_withdrawal_type_id VARCHAR(3),
  displaced_student_status VARCHAR(3),
  ref_end_of_term_status_id VARCHAR(3),
  ref_promotion_reason_id VARCHAR(3),
  ref_non_promo_reason_id VARCHAR(3),
  ref_food_servi_eligibility_id VARCHAR(3),
  first_entry_date_intous_sch VARCHAR(50),
  ref_dire_inf_block_sta_id VARCHAR(3),
  nslp_direct_certi_indi VARCHAR(3),
  ref_studentenrol_acc_type_id VARCHAR(3),
  student_list_number NUMERIC,
  PRIMARY KEY (arge_sec, org_per_role_id, student_list_number)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_17 (
  arge_sec NUMERIC,
  org_per_role_id NUMERIC,
  ref_staff_classification_id VARCHAR(3),
  ref_profess_edu_job_classi_id VARCHAR(3),
  ref_teaching_assig_role_id NUMERIC,
  primary_assignment NUMERIC,
  teacher_of_record NUMERIC,
  ref_classroom_pos_type_id VARCHAR(3),
  full_time_equivalency VARCHAR(3),
  contribution_percentage NUMERIC,
  itinerant_teacher NUMERIC,
  highly_quali_dteach_indicator NUMERIC,
  special_education_teacher NUMERIC,
  ref_special_educ_staffcate_id NUMERIC,
  special_educa_rela_servi_perso NUMERIC,
  special_education_paraprofes NUMERIC,
  ref_spec_educa_age_group_taugh VARCHAR(20),
  ref_mep_staff_category_id NUMERIC,
  ref_title_iprogr_staff_cate_id NUMERIC,
  recordstartdatetime VARCHAR(10),
  recordenddatetime VARCHAR(10),
  PRIMARY KEY (arge_sec, org_per_role_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_18 (
  arge_sec NUMERIC,
  organization_id NUMERIC,
  description VARCHAR(100),
  subject_abbreviation VARCHAR(100),
  sced_sequence__course VARCHAR(20),
  instructional_minutes NUMERIC,
  ref_course_level_charac_id VARCHAR(20),
  ref_course_credit_unit_id NUMERIC,
  credit_value VARCHAR(20),
  ref_instruction_language NUMERIC,
  certification_description VARCHAR(20),
  ref_course_appli_educa_levl_id VARCHAR(20),
  repeatability_max_number NUMERIC,
  PRIMARY KEY (arge_sec, organization_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_19 (
  arge_sec NUMERIC,
  organization_id NUMERIC,
  avai_carnegie_unit_credit VARCHAR(30),
  ref_course_sec_deli_mode_id NUMERIC,
  ref_sin_sex_class_status_id NUMERIC,
  time_required_for_completion NUMERIC,
  course_id NUMERIC,
  ref_add_credit_type_id NUMERIC,
  ref_instruction_lang_id NUMERIC,
  virtual_indicator NUMERIC,
  org_calendar_session_id VARCHAR(30),
  ref_credit_type_earned_id NUMERIC,
  ref_advan_place_course_code_id NUMERIC,
  maximum_capacity NUMERIC,
  related_compe_frame_items VARCHAR(30),
  PRIMARY KEY (arge_sec, organization_id, course_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_20 (
  arge_sec NUMERIC,
  person_degree_orcerti_id NUMERIC,
  person_id NUMERIC,
  degree_certi_title_sub VARCHAR(200),
  ref_degree_or_certi_type_id VARCHAR(10),
  award_date BIGINT,
  name_of_institution VARCHAR(300),
  ref_hig_edu_inst_accred_sta_id VARCHAR(10),
  ref_edu_veri_method_id VARCHAR(10),
  PRIMARY KEY (arge_sec, person_degree_orcerti_id, person_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_21 (
  arge_sec NUMERIC,
  person_rela_ship_id NUMERIC,
  person_id NUMERIC,
  related_person_id NUMERIC,
  ref_person_rela_id VARCHAR(30),
  custodial_rela_indic VARCHAR(30),
  emergency_contact_ind NUMERIC,
  contact_priority_number NUMERIC,
  retirar_estudiante_indi VARCHAR(30),
  contact_restrictions VARCHAR(30),
  lives_with_indicator VARCHAR(30),
  primary_contact_indicator NUMERIC,
  PRIMARY KEY (arge_sec, person_rela_ship_id, person_id, related_person_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_22 (
  arge_sec NUMERIC(23, 0),
  organization_calendar_id NUMERIC(23, 0),
  organization_id NUMERIC(23, 0),
  calendar_code VARCHAR(200),
  calendar_description VARCHAR(500),
  calendar_year INTEGER,
  record_start_date_time VARCHAR(200),
  record_end_date_time VARCHAR(200),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  PRIMARY KEY (arge_sec, organization_calendar_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_23 (
  arge_sec NUMERIC(23, 0),
  location_id NUMERIC(23, 0),
  record_start_date_time VARCHAR(200),
  record_end_date_time VARCHAR(200),
  PRIMARY KEY (arge_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_24 (
  arge_sec NUMERIC(23, 0),
  location_id NUMERIC(23, 0),
  street_number_and_name VARCHAR(2000),
  apartment_roomorsuite_number VARCHAR(2000),
  building_site_number VARCHAR(2000),
  city VARCHAR(2000),
  ref_state_id VARCHAR(10),
  postal_code VARCHAR(200),
  county_name VARCHAR(2000),
  ref_country_id VARCHAR(2000),
  ref_county_id VARCHAR(10),
  latitude VARCHAR(200),
  longitude VARCHAR(200),
  refers_rural_urban_continuum_codeid VARCHAR(200),
  facility_block_number_area VARCHAR(200),
  facility_census_tract VARCHAR(200),
  record_start_date_time VARCHAR(200),
  record_end_date_time VARCHAR(200),
  PRIMARY KEY (arge_sec, location_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_25 (
  arge_sec NUMERIC,
  person_id NUMERIC,
  city VARCHAR(2000),
  ref_state_id VARCHAR(10),
  ref_country_id VARCHAR(2000),
  record_start_date_time VARCHAR(200),
  record_end_date_time VARCHAR(200),
  PRIMARY KEY (arge_sec, person_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_26 (
  arge_sec NUMERIC(23, 0),
  person_degree_certificate_id NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  degree_certificate_title_subject VARCHAR(200),
  ref_degree_certificatetype_id VARCHAR(10),
  award_date VARCHAR(20),
  name_of_institution VARCHAR(100),
  ref_higher_educ_instaccre_status_id VARCHAR(100),
  ref_educverif_method_id VARCHAR(10),
  idoneidad_docente VARCHAR(100),
  record_start_date_time VARCHAR(200),
  record_end_date_time VARCHAR(200),
  PRIMARY KEY (arge_sec, person_degree_certificate_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_27 (
  arge_sec NUMERIC(23, 0),
  incident_id NUMERIC(23, 0),
  incident_identifier VARCHAR(50),
  incident_date VARCHAR(20),
  incident_time VARCHAR(10),
  ref_incident_timedescrip_code_id VARCHAR(5),
  incident_description VARCHAR(4000),
  refincident_behavior_id VARCHAR(5),
  refincident_behavior_secondaryid VARCHAR(100),
  refincident_injury_typeid VARCHAR(5),
  refweapon_typeid VARCHAR(5),
  incident_cost VARCHAR(500),
  organization_person_role_id NUMERIC(23, 0),
  incident_reporter_id NUMERIC(23, 0),
  refincident_reporter_typeid VARCHAR(2),
  refincident_location_id VARCHAR(10),
  reffirearm_type_id VARCHAR(5),
  regulation_violated_description VARCHAR(4000),
  related_to_disability_manifestation_ind VARCHAR(500),
  reported_to_law_enforcement_ind VARCHAR(2),
  refincident_multiple_offense_typeid VARCHAR(500),
  refincident_perpetrat_orinjury_typeid VARCHAR(5),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  organization_id NUMERIC(23, 0),
  tipo_incidente VARCHAR(5),
  secuencia NUMERIC(23, 0),
  PRIMARY KEY (arge_sec, incident_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_28 (
  arge_sec NUMERIC(23, 0),
  incident_id NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  identifier VARCHAR(50),
  refincident_person_role_typeid VARCHAR(100),
  refincident_person_typeid VARCHAR(100),
  date_incident VARCHAR(100),
  files_can_base64 VARCHAR(4000),
  digital_random_key VARCHAR(200),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, incident_id, person_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_29 (
  arge_sec NUMERIC(23, 0),
  k12student_discipline_id NUMERIC(23, 0),
  organization_person_role_id NUMERIC(23, 0),
  refdiscipline_reason_id VARCHAR(20),
  refdisciplinary_action_takenid VARCHAR(10),
  disciplinary_action_start_date VARCHAR(20),
  disciplinary_action_end_date VARCHAR(20),
  duration_of_disciplinary_action VARCHAR(10),
  refdisp_length_diff_reason_id VARCHAR(10),
  full_year_expulsion VARCHAR(50),
  short_ened_expulsion VARCHAR(50),
  educat_services_after_removal VARCHAR(50),
  refidea_interim_removal_id VARCHAR(50),
  refidea_inter_remov_reason_id VARCHAR(50),
  relat_zero_tolerance_policy VARCHAR(50),
  incident_id NUMERIC(23, 0),
  iepplacement_meeting_indicator VARCHAR(50),
  refdiscip_method_firearmsid VARCHAR(50),
  refdiscip_methodo_fcwdid VARCHAR(50),
  refidea_discipl_meth_firearmid VARCHAR(50),
  person_id NUMERIC(23, 0),
  record_start_date_time VARCHAR(50),
  record_end_date_time VARCHAR(50),
  PRIMARY KEY (arge_sec, k12student_discipline_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_30 (
  arge_sec NUMERIC(23, 0),
  person_telephone_id NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  telephone_number VARCHAR(50),
  primary_telephone_numb_ind VARCHAR(10),
  refpers_telep_numb_type_id VARCHAR(10),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, person_telephone_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_31 (
  arge_sec NUMERIC(23, 0),
  person_status_id NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  refperson_status_typeid VARCHAR(50),
  status_value VARCHAR(10),
  status_start_date VARCHAR(20),
  status_end_date VARCHAR(20),
  doc_number VARCHAR(4000),
  description VARCHAR(4000),
  files_canbase64 NUMERIC(23, 0),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  doal_sec NUMERIC(23, 0),
  PRIMARY KEY (arge_sec, person_status_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_32 (
  arge_sec NUMERIC(23, 0),
  assessment_id NUMERIC(23, 0),
  identifier VARCHAR(60),
  identification_system VARCHAR(100),
  guid VARCHAR(60),
  title VARCHAR(100),
  short_name VARCHAR(4000),
  refacademic_subject_id VARCHAR(20),
  objective VARCHAR(20),
  provider VARCHAR(20),
  refassessment_purpose_id VARCHAR(10),
  refassessment_type_id VARCHAR(10),
  refassessment_type_children VARCHAR(10),
  assessment_revision_date VARCHAR(20),
  assessment_family_title VARCHAR(20),
  assessment_family_shortname VARCHAR(20),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  cuas_sec NUMERIC(23, 0),
  inno_tipo_peri VARCHAR(5),
  inno_nro_nota INTEGER,
  PRIMARY KEY (arge_sec, assessment_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_33 (
  arge_sec NUMERIC(23, 0),
  assessment_admin_id NUMERIC(23, 0),
  assessment_id NUMERIC(23, 0),
  name_assessment VARCHAR(4000),
  code VARCHAR(60),
  start_date VARCHAR(20),
  start_time VARCHAR(20),
  finish_date VARCHAR(20),
  finish_time VARCHAR(20),
  refasse_reporting_method_id VARCHAR(60),
  assessment_secure_indicator VARCHAR(60),
  assessment_admin_period_desc VARCHAR(60),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  cuas_sec NUMERIC(23, 0),
  inno_tipo_peri VARCHAR(5),
  inno_nro_nota INTEGER,
  inno_fec_eval TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (arge_sec, assessment_admin_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_34 (
  arge_sec NUMERIC(23, 0),
  assessment_admin_org_id NUMERIC(23, 0),
  assessment_admin_id NUMERIC(23, 0),
  organization_id NUMERIC(23, 0),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  cuas_sec NUMERIC(23, 0),
  inno_tipo_peri VARCHAR(5),
  inno_nro_nota INTEGER,
  PRIMARY KEY (arge_sec, assessment_admin_org_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_35 (
  arge_sec NUMERIC(23, 0),
  assessment_assessm_admin_id NUMERIC(23, 0),
  assessment_id NUMERIC(23, 0),
  assessment_admin_id NUMERIC(23, 0),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, assessment_assessm_admin_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_36 (
  arge_sec NUMERIC(23, 0),
  document_id NUMERIC(23, 0),
  files_canbase64 TEXT,
  grdo_nom_arch_inte VARCHAR(512),
  grcu_sec NUMERIC(23, 0),
  PRIMARY KEY (arge_sec, document_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_37 (
  arge_sec NUMERIC(23, 0),
  assessment_registration_id NUMERIC(23, 0),
  creation_date VARCHAR(20),
  ds_inst_prior_to_assessment VARCHAR(20),
  score_publish_date VARCHAR(20),
  test_attempt_identifier VARCHAR(20),
  retest_indicator VARCHAR(20),
  course_section_org_id NUMERIC(23, 0),
  refassess_parti_indicator_id VARCHAR(20),
  testing_indicator VARCHAR(20),
  refassessment_purpose_id VARCHAR(20),
  refassess_reason_not_test_id VARCHAR(20),
  refassess_reason_not_comp_id VARCHAR(20),
  refgrade_level_tobe_asses_id VARCHAR(20),
  refgrade_level_when_asses_id VARCHAR(20),
  person_id NUMERIC(23, 0),
  assessment_form_id VARCHAR(20),
  organization_id NUMERIC(23, 0),
  school_organization_id VARCHAR(20),
  lea_organization_id VARCHAR(20),
  assessment_admin_id NUMERIC(23, 0),
  assigned_by_person_id NUMERIC(23, 0),
  assess_regcom_stat_date_time VARCHAR(20),
  refassess_regcom_status_id VARCHAR(20),
  leafull_academic_year VARCHAR(20),
  school_full_academic_year VARCHAR(20),
  state_full_academic_year VARCHAR(20),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  cuas_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  nacu_tipo_peri VARCHAR(5),
  inno_nro_nota BIGINT,
  inno_fec_eval TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (arge_sec, assessment_registration_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_38 (
  arge_sec NUMERIC(23, 0),
  assessment_result_id NUMERIC(23, 0),
  score_value VARCHAR(10),
  refscore_metric_type_id VARCHAR(10),
  preliminary_indicator VARCHAR(20),
  refassess_pret_out_comeid VARCHAR(20),
  number_of_responses VARCHAR(20),
  diagnostic_statement VARCHAR(20),
  diagnostic_statement_source VARCHAR(20),
  descrip_feedback VARCHAR(20),
  descrip_feedback_source VARCHAR(20),
  instruct_recommendation VARCHAR(20),
  includedinay_pcalculation VARCHAR(20),
  date_updated VARCHAR(20),
  date_created VARCHAR(20),
  assessment_subtest_id VARCHAR(20),
  assessment_registration_id NUMERIC(23, 0),
  refel_outcom_level_id VARCHAR(20),
  refout_cometime_point_id VARCHAR(20),
  assess_resdesc_fb_date_time VARCHAR(20),
  assess_resscore_stan_error VARCHAR(20),
  refassess_res_data_type_id VARCHAR(20),
  refassess_res_score_type_id VARCHAR(20),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, assessment_result_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_39 (
  arge_sec NUMERIC(23, 0),
  assessment_session_id NUMERIC(23, 0),
  assessment_admin_id NUMERIC(23, 0),
  scheduled_start_date_time VARCHAR(60),
  scheduled_end_date_time VARCHAR(60),
  actual_start_date_time VARCHAR(60),
  actual_end_date_time VARCHAR(60),
  allotted_time VARCHAR(30),
  refassess_session_type_id VARCHAR(60),
  security_issue VARCHAR(60),
  refassess_speccir_type_id VARCHAR(60),
  special_event_description VARCHAR(60),
  location VARCHAR(60),
  organization_id NUMERIC(23, 0),
  lea_organization_id VARCHAR(60),
  school_organization_id VARCHAR(60),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, assessment_session_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_40 (
  arge_sec NUMERIC(23, 0),
  role_attend_event_id NUMERIC(23, 0),
  org_pers_role_id NUMERIC(23, 0),
  date_reg VARCHAR(100),
  refattend_event_type_id VARCHAR(20),
  refattend_status_id VARCHAR(20),
  refabsent_attend_categ_id VARCHAR(20),
  refpres_attend_categ_id VARCHAR(20),
  refleave_event_type_id VARCHAR(20),
  digital_random_key VARCHAR(100),
  files_canbase64 TEXT,
  observaciones VARCHAR(500),
  virtual_indicator VARCHAR(30),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  oprid_ratificador VARCHAR(50),
  firma_ratificador VARCHAR(50),
  fecha_ratificador VARCHAR(50),
  digital_random_key_date VARCHAR(50),
  digital_random_key_opr VARCHAR(50),
  PRIMARY KEY (arge_sec, role_attend_event_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_41 (
  arge_sec NUMERIC(23, 0),
  course_section_loc NUMERIC(23, 0),
  location_id NUMERIC(23, 0),
  organization_id NUMERIC(23, 0),
  refinstruc_loc_type_id VARCHAR(5),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, course_section_loc)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_42 (
  arge_sec NUMERIC(23, 0),
  org_calendar_session_id NUMERIC(23, 0),
  designator VARCHAR(10),
  begin_date VARCHAR(20),
  end_date VARCHAR(20),
  ref_session_type_id VARCHAR(5),
  instruction_alminutes VARCHAR(10),
  code VARCHAR(30),
  description VARCHAR(4000),
  marking_termindicator VARCHAR(5),
  scheduling_termindicator VARCHAR(5),
  attendance_termindicator VARCHAR(5),
  organization_calendar_id NUMERIC(23, 0),
  day_sin_session BIGINT,
  first_instruction_date VARCHAR(20),
  last_instruction_date VARCHAR(20),
  minutes_per_day VARCHAR(10),
  session_start_time VARCHAR(20),
  session_end_time VARCHAR(20),
  clase_recuperada_id VARCHAR(5),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  numero_rex VARCHAR(5),
  fecha_rex VARCHAR(20),
  files_canbase64 TEXT,
  cuas_sec NUMERIC(23, 0),
  PRIMARY KEY (arge_sec, org_calendar_session_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_43 (
  arge_sec NUMERIC(23, 0),
  course_sect_schedule_id NUMERIC(23, 0),
  organization_id NUMERIC(23, 0),
  class_meeting_days VARCHAR(20),
  class_beginning_time VARCHAR(10),
  class_ending_time VARCHAR(10),
  class_period VARCHAR(10),
  time_day_identifier VARCHAR(5),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, course_sect_schedule_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_44 (
  arge_sec NUMERIC(23, 0),
  pie_course_org_id NUMERIC(23, 0),
  organization_id NUMERIC(23, 0),
  files_canbase64 NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  date_carga VARCHAR(20),
  digital_random_key VARCHAR(60),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  grcu_sec NUMERIC(23, 0),
  grdo_nom_arch_inte VARCHAR(512),
  PRIMARY KEY (arge_sec, pie_course_org_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_45 (
  arge_sec NUMERIC(23, 0),
  person_allergy_id NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  ref_allergy_type_id INTEGER,
  ref_allergy_severity_id INTEGER,
  reaction_description VARCHAR(2000),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, person_allergy_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_46 (
  arge_sec NUMERIC(23, 0),
  person_health_id NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  vision_screening_date VARCHAR(20),
  ref_vision_scr_status_id VARCHAR(5),
  hearing_screening_date VARCHAR(20),
  ref_hearing_scr_status_id VARCHAR(5),
  dental_screening_date VARCHAR(20),
  ref_dental_scr_status_id VARCHAR(5),
  ref_health_ins_coverage_id VARCHAR(5),
  ref_dental_ins_cov_type_id VARCHAR(5),
  ref_medical_alert_ind_id VARCHAR(5),
  health_scr_equipment_used VARCHAR(300),
  health_scr_follow_up_reco VARCHAR(60),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  description VARCHAR(4000),
  PRIMARY KEY (arge_sec, person_health_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_47 (
  arge_sec NUMERIC(23, 0),
  learner_activity_id NUMERIC(23, 0),
  person_id NUMERIC(23, 0),
  assessment_registration_id NUMERIC(23, 0),
  course_section_id NUMERIC(23, 0),
  org_calendar_session_id NUMERIC(23, 0),
  title VARCHAR(60),
  description VARCHAR(300),
  pre_requisite VARCHAR(300),
  ref_learner_activity_type_id VARCHAR(20),
  rubricurl VARCHAR(300),
  creation_date VARCHAR(60),
  maximum_time_allowed VARCHAR(20),
  ref_leactmaxtime_allow_units_id VARCHAR(20),
  due_date VARCHAR(20),
  due_time VARCHAR(20),
  maximum_attempts_allowed VARCHAR(20),
  ref_leact_addgrade_book_flag_id VARCHAR(20),
  release_date VARCHAR(20),
  weight VARCHAR(20),
  possible_points VARCHAR(20),
  ref_language_id VARCHAR(20),
  assigned_by_person_id VARCHAR(10),
  school_organization_id VARCHAR(10),
  lea_organization_id VARCHAR(10),
  record_start_date_time VARCHAR(50),
  record_end_date_time VARCHAR(50),
  digital_random_key VARCHAR(60),
  date_digital_random_key VARCHAR(50),
  person_id_digital_random_key VARCHAR(20),
  PRIMARY KEY (arge_sec, learner_activity_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_48 (
  arge_sec NUMERIC(23, 0),
  role_attendance_id NUMERIC(23, 0),
  org_pers_role_id NUMERIC(23, 0),
  number_days_in_attendance VARCHAR(10),
  number_days_absent VARCHAR(10),
  attendance_rate VARCHAR(10),
  record_start_date_time VARCHAR(20),
  record_end_date_time VARCHAR(20),
  PRIMARY KEY (arge_sec, role_attendance_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_arch_generados (
  arge_sec NUMERIC,
  arch_sec NUMERIC,
  tiar_id VARCHAR(3),
  arge_estado VARCHAR(3),
  PRIMARY KEY (arge_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_dic_tipo_archivos (
  tiar_id VARCHAR(3),
  dtar_orden_col NUMERIC,
  dtar_nombre_campo VARCHAR(200),
  PRIMARY KEY (tiar_id, dtar_orden_col)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_estado_arch_ld (
  esed_sec NUMERIC(23, 0),
  ldea_estado VARCHAR(15),
  ldea_path_arch VARCHAR(4000),
  ldea_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ldea_user_ing VARCHAR(30),
  ldea_fec_ter TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lcd_tipo_archivo (
  tiar_id VARCHAR(3),
  tiar_nombre_fisico VARCHAR(200),
  tiar_desc VARCHAR(1000),
  tiar_tabla VARCHAR(100),
  tiar_vista VARCHAR(100),
  tiar_genera_arch VARCHAR(2),
  PRIMARY KEY (tiar_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_leccionario_clases (
  leas_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  leas_fecha TIMESTAMP WITHOUT TIME ZONE,
  leas_texto VARCHAR(4000),
  leas_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  leas_user_ing VARCHAR(30),
  leas_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  leas_user_mod VARCHAR(30),
  leas_objetivo VARCHAR(4000),
  leas_horas INTEGER,
  leas_es_lecc_pie VARCHAR(2),
  PRIMARY KEY (leas_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_leccionario_clases_log (
  leas_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  lclo_fecha TIMESTAMP WITHOUT TIME ZONE,
  lclo_accion VARCHAR(30),
  lclo_fec_accion TIMESTAMP WITHOUT TIME ZONE,
  lclo_texto VARCHAR(4000),
  lclo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lclo_user_ing VARCHAR(30),
  lclo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  lclo_user_mod VARCHAR(30),
  lclo_objetivo VARCHAR(4000),
  lclo_horas INTEGER,
  lclo_es_lecc_pie VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_leccionario_parv (
  lepa_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  lepa_fecha TIMESTAMP WITHOUT TIME ZONE,
  lepa_horas INTEGER,
  lepa_nucleo VARCHAR(4000),
  lepa_objetivo VARCHAR(4000),
  lepa_experiencia VARCHAR(4000),
  lepa_contenido VARCHAR(4000),
  lepa_instrumento VARCHAR(4000),
  lepa_evalu_sumativa VARCHAR(2),
  lepa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lepa_user_ing VARCHAR(30),
  lepa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  lepa_user_mod VARCHAR(30),
  lepa_ambito VARCHAR(4000),
  lepa_es_lecc_pie VARCHAR(2),
  lepa_objetivo_prog VARCHAR(4000),
  PRIMARY KEY (lepa_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_leccionario_parv_log (
  lepa_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  lpal_fecha TIMESTAMP WITHOUT TIME ZONE,
  lpal_accion VARCHAR(30),
  lpal_fec_accion TIMESTAMP WITHOUT TIME ZONE,
  lpal_horas INTEGER,
  lpal_nucleo VARCHAR(4000),
  lpal_objetivo VARCHAR(4000),
  lpal_experiencia VARCHAR(4000),
  lpal_contenido VARCHAR(4000),
  lpal_instrumento VARCHAR(4000),
  lpal_evalu_sumativa VARCHAR(2),
  lpal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lpal_user_ing VARCHAR(30),
  lpal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  lpal_user_mod VARCHAR(30),
  lpal_es_lecc_pie VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lecc_parv_ambito (
  lpam_sec NUMERIC(23, 0),
  lepa_sec NUMERIC(23, 0),
  epam_sec NUMERIC(23, 0),
  lpam_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lpam_user_ing VARCHAR(30),
  PRIMARY KEY (lpam_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lecc_parv_nucleo (
  lpnu_sec NUMERIC(23, 0),
  lepa_sec NUMERIC(23, 0),
  lpam_sec NUMERIC(23, 0),
  epnu_sec NUMERIC(23, 0),
  lpnu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lpnu_user_ing VARCHAR(30),
  PRIMARY KEY (lpnu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lecc_parv_objetivo (
  lpob_sec NUMERIC(23, 0),
  lepa_sec NUMERIC(23, 0),
  lpnu_sec NUMERIC(23, 0),
  epob_sec NUMERIC(23, 0),
  lpob_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lpob_user_ing VARCHAR(30),
  PRIMARY KEY (lpob_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_libros_estab (
  lies_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  lies_cod_txt VARCHAR(100),
  lies_nom_txt VARCHAR(4000),
  lies_autor_txt VARCHAR(255),
  lies_observ VARCHAR(4000),
  lies_estado VARCHAR(60),
  lies_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lies_user_ing VARCHAR(30),
  lies_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  lies_user_mod VARCHAR(30),
  PRIMARY KEY (lies_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_logo_login_dom (
  lldo_id BIGINT,
  lldo_nom_dominio VARCHAR(500),
  lldo_logo_b64 TEXT,
  lldo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lldo_user_ing VARCHAR(30),
  esad_cod VARCHAR(30),
  lldo_ico_b64 TEXT,
  lldo_logo_esad_b64 TEXT,
  PRIMARY KEY (lldo_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_lugares_estab (
  lues_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  lues_nom_lugar VARCHAR(60),
  lues_desc_coment VARCHAR(500),
  lues_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  lues_user_ing VARCHAR(30),
  lues_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  lues_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_maal_prob_apren (
  mapa_sec NUMERIC(23, 0),
  maal_sec NUMERIC(23, 0),
  mapa_cod VARCHAR(5),
  mapa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mapa_user_ing VARCHAR(30),
  PRIMARY KEY (mapa_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_material_classroom (
  macl_sec VARCHAR(256),
  cuas_id_classroom VARCHAR(256),
  macl_tipo VARCHAR(100),
  PRIMARY KEY (macl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_matricula_alumnos (
  maal_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  maal_fec_matri TIMESTAMP WITHOUT TIME ZONE,
  maal_nro_matri NUMERIC(23, 0),
  maal_estado VARCHAR(30),
  maal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  maal_user_ing VARCHAR(30),
  maal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  maal_user_mod VARCHAR(30),
  maal_letra_dest VARCHAR(2),
  mail_fing_curso TIMESTAMP WITHOUT TIME ZONE,
  tien_cod_orig VARCHAR(10),
  grte_cod_orig VARCHAR(10),
  maal_letra_orig VARCHAR(2),
  pers_sec_alum NUMERIC(23, 0),
  maal_rut_alum BIGINT,
  maal_dv_alum VARCHAR(1),
  maal_nom_alum VARCHAR(100),
  maal_apat_alum VARCHAR(60),
  maal_amat_alum VARCHAR(60),
  maal_fec_nac_alum TIMESTAMP WITHOUT TIME ZONE,
  maal_genero_alum VARCHAR(2),
  maal_cod_etnia VARCHAR(15),
  pais_cod_alum VARCHAR(20),
  maal_direc_alum VARCHAR(200),
  regi_cod_alum VARCHAR(10),
  comu_cod_alum VARCHAR(10),
  maal_cel_alum VARCHAR(15),
  maal_email_alum VARCHAR(60),
  maal_es_nuevo VARCHAR(2),
  pers_sec_apod NUMERIC(23, 0),
  maal_rut_apod BIGINT,
  maal_dv_apod VARCHAR(1),
  maal_nom_apod VARCHAR(100),
  maal_apat_apod VARCHAR(60),
  maal_amat_apod VARCHAR(60),
  maal_fec_nac_apod TIMESTAMP WITHOUT TIME ZONE,
  maal_genero_apod VARCHAR(2),
  pais_cod_apod VARCHAR(20),
  maal_direc_apod VARCHAR(200),
  regi_cod_apod VARCHAR(10),
  comu_cod_apod VARCHAR(10),
  maal_cel_apod VARCHAR(15),
  maal_email_apod VARCHAR(60),
  maal_esta_proc_fin VARCHAR(2),
  maal_pasaporte_dni_alum VARCHAR(60),
  maal_pasaporte_dni_apod VARCHAR(60),
  maal_parentesco_apod VARCHAR(60),
  maal_esta_matric VARCHAR(30),
  maal_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  maal_obs_retiro VARCHAR(500),
  maal_nom_alum_social VARCHAR(100),
  maal_es_prioritario VARCHAR(2),
  maal_es_preferente VARCHAR(2),
  maal_prog_integ_escolar VARCHAR(30),
  maal_tipo_tel VARCHAR(5),
  maal_problema_aprendizaje VARCHAR(5),
  maal_tiene_excedente VARCHAR(5),
  maal_derecho_subven VARCHAR(5),
  maal_nro_resolucion VARCHAR(20),
  maal_fec_resolucion TIMESTAMP WITHOUT TIME ZONE,
  maal_tipo_inst_salud VARCHAR(2),
  maal_tramo_fonasa VARCHAR(2),
  maal_cod_isapre VARCHAR(10),
  maal_tipo_vivienda VARCHAR(20),
  maal_padece_enfermedad VARCHAR(2),
  maal_nombre_enfermedad VARCHAR(200),
  maal_ingiere_medicamento VARCHAR(2),
  maal_nombre_medicamento VARCHAR(200),
  maal_alergico_medic_antib VARCHAR(2),
  maal_nombre_antibiotico VARCHAR(200),
  PRIMARY KEY (maal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_matricula_alumnos_log (
  mall_fec_elim TIMESTAMP WITHOUT TIME ZONE,
  mall_user_elim VARCHAR(30),
  maal_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  maal_fec_matri TIMESTAMP WITHOUT TIME ZONE,
  maal_nro_matri NUMERIC(23, 0),
  maal_estado VARCHAR(30),
  maal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  maal_user_ing VARCHAR(30),
  maal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  maal_user_mod VARCHAR(30),
  maal_letra_dest VARCHAR(2),
  mail_fing_curso TIMESTAMP WITHOUT TIME ZONE,
  tien_cod_orig VARCHAR(10),
  grte_cod_orig VARCHAR(10),
  maal_letra_orig VARCHAR(2),
  pers_sec_alum NUMERIC(23, 0),
  maal_rut_alum BIGINT,
  maal_dv_alum VARCHAR(1),
  maal_nom_alum VARCHAR(100),
  maal_apat_alum VARCHAR(60),
  maal_amat_alum VARCHAR(60),
  maal_fec_nac_alum TIMESTAMP WITHOUT TIME ZONE,
  maal_genero_alum VARCHAR(2),
  maal_cod_etnia VARCHAR(15),
  pais_cod_alum VARCHAR(20),
  maal_direc_alum VARCHAR(200),
  regi_cod_alum VARCHAR(10),
  comu_cod_alum VARCHAR(10),
  maal_cel_alum VARCHAR(15),
  maal_email_alum VARCHAR(60),
  maal_es_nuevo VARCHAR(2),
  pers_sec_apod NUMERIC(23, 0),
  maal_rut_apod BIGINT,
  maal_dv_apod VARCHAR(1),
  maal_nom_apod VARCHAR(100),
  maal_apat_apod VARCHAR(60),
  maal_amat_apod VARCHAR(60),
  maal_fec_nac_apod TIMESTAMP WITHOUT TIME ZONE,
  maal_genero_apod VARCHAR(2),
  pais_cod_apod VARCHAR(20),
  maal_direc_apod VARCHAR(200),
  regi_cod_apod VARCHAR(10),
  comu_cod_apod VARCHAR(10),
  maal_cel_apod VARCHAR(15),
  maal_email_apod VARCHAR(60),
  maal_esta_proc_fin VARCHAR(2),
  maal_pasaporte_dni_alum VARCHAR(60),
  maal_pasaporte_dni_apod VARCHAR(60),
  maal_parentesco_apod VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_matricula_alumnos_tmp (
  maal_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  maal_fec_matri TIMESTAMP WITHOUT TIME ZONE,
  maal_nro_matri VARCHAR(20),
  maal_estado VARCHAR(30),
  maal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  maal_user_ing VARCHAR(30),
  maal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  maal_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_menciones (
  menc_cod VARCHAR(20),
  menc_descrip VARCHAR(200),
  espe_cod VARCHAR(20),
  sect_cod VARCHAR(20),
  PRIMARY KEY (menc_cod, espe_cod, sect_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_mensajes (
  mens_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuario BIGINT,
  mens_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  mens_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  mens_texto TEXT,
  mens_cnt_veces INTEGER,
  mens_estado VARCHAR(60),
  mens_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mens_user_ing VARCHAR(30),
  mens_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  mens_user_mod VARCHAR(30),
  mens_flag_tipo VARCHAR(5),
  plme_sec NUMERIC(23, 0),
  mens_sms VARCHAR(1),
  mens_email VARCHAR(1),
  mens_whatsapp VARCHAR(1),
  mens_tipo_canal VARCHAR(5),
  mens_total_pers_send NUMERIC,
  mens_total_sms_send NUMERIC,
  PRIMARY KEY (mens_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_mensaje_respuesta (
  mens_usua_sec NUMERIC(23, 0),
  id_sms_proveedor VARCHAR(100),
  status_sms VARCHAR(5),
  fecha_sms TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (mens_usua_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_mensaje_resp_estado (
  id_sms_proveedor VARCHAR(100),
  status_sms VARCHAR(5),
  fecha_registro TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_mens_envio_esed (
  mens_sec NUMERIC(23, 0),
  esed_sec_dest NUMERIC(23, 0),
  mees_envio_admin VARCHAR(5),
  mees_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mees_user_ing VARCHAR(30),
  PRIMARY KEY (mens_sec, esed_sec_dest)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_mens_envio_usua (
  mens_sec NUMERIC(23, 0),
  usua_usuario_dest BIGINT,
  meus_cnt_visto INTEGER,
  meus_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  meus_user_ing VARCHAR(30),
  esed_sec NUMERIC(23, 0),
  notificado_push VARCHAR(1),
  meus_texto_fmt TEXT,
  meus_enviado VARCHAR(1),
  meus_celular VARCHAR(15),
  meus_email VARCHAR(100),
  meus_total_sms NUMERIC(23, 0),
  meus_codigo_sms VARCHAR(10),
  meus_desc_sms VARCHAR(250),
  meus_fec_sms TIMESTAMP WITHOUT TIME ZONE,
  mens_usua_sec NUMERIC(23, 0),
  PRIMARY KEY (mens_sec, usua_usuario_dest, esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_mens_envio_usua_tmp (
  mens_sec NUMERIC(23, 0),
  usua_usuario_dest BIGINT,
  meus_cnt_visto INTEGER,
  meus_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  meus_user_ing VARCHAR(30),
  esed_sec NUMERIC(23, 0),
  notificado_push VARCHAR(1),
  meus_texto_fmt TEXT,
  meus_enviado VARCHAR(1),
  meus_celular VARCHAR(15),
  meus_email VARCHAR(100),
  meus_total_sms NUMERIC,
  meus_codigo_sms VARCHAR(10),
  meus_desc_sms VARCHAR(250),
  meus_fec_sms TIMESTAMP WITHOUT TIME ZONE,
  mens_usua_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_mens_usua_int (
  mens_sec NUMERIC(23, 0),
  usin_usuario_dest BIGINT,
  usin_cnt_visto INTEGER,
  usin_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  usin_user_ing VARCHAR(30),
  esed_sec NUMERIC(23, 0),
  notificado_push VARCHAR(1),
  usin_texto_fmt TEXT,
  usin_enviado VARCHAR(1),
  usin_celular VARCHAR(15),
  usin_email VARCHAR(100),
  usin_total_sms NUMERIC,
  usin_codigo_sms VARCHAR(10),
  usin_desc_sms VARCHAR(250),
  usin_fec_sms TIMESTAMP WITHOUT TIME ZONE,
  mens_usua_sec NUMERIC(23, 0),
  PRIMARY KEY (mens_sec, usin_usuario_dest, esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_modulos_alumnos (
  mopr_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  moal_estado VARCHAR(30),
  moal_nota_fin VARCHAR(10),
  moal_situ_final VARCHAR(30),
  moal_observ VARCHAR(100),
  moal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  moal_user_ing VARCHAR(30),
  moal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  moal_user_mod VARCHAR(30),
  PRIMARY KEY (mopr_sec, fial_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_modulos_asistencia (
  mopr_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  moas_fec_asist TIMESTAMP WITHOUT TIME ZONE,
  moas_asistencia VARCHAR(30),
  moas_estado VARCHAR(30),
  moas_obs VARCHAR(100),
  moas_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  moas_user_ing VARCHAR(30),
  moas_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  moas_user_mod VARCHAR(30),
  PRIMARY KEY (mopr_sec, fial_sec, moas_fec_asist)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_modulos_hora_dia (
  mopr_sec NUMERIC(23, 0),
  mohd_nro_dia INTEGER,
  mohd_hora_ini VARCHAR(5),
  mohd_hora_fin VARCHAR(5),
  mohd_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mohd_user_ing VARCHAR(30),
  mohd_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  mohd_user_mod VARCHAR(30),
  PRIMARY KEY (mopr_sec, mohd_nro_dia)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_modulos_practica (
  mopr_sec NUMERIC(23, 0),
  emes_sec NUMERIC(23, 0),
  mopr_nombre VARCHAR(60),
  mopr_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  mopr_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  coem_sec NUMERIC(23, 0),
  prof_sec NUMERIC(23, 0),
  mopr_tipo_mod VARCHAR(60),
  mopr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mopr_user_ing VARCHAR(30),
  mopr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  mopr_user_mod VARCHAR(30),
  PRIMARY KEY (mopr_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_modulo_tel (
  mtel_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  mtel_fecha TIMESTAMP WITHOUT TIME ZONE,
  mtel_hora_ini VARCHAR(10),
  mtel_hora_fin VARCHAR(10),
  mtel_modalidad VARCHAR(10),
  mtel_contenido VARCHAR(4000),
  mtel_reg_obs VARCHAR(4000),
  mtel_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mtel_user_ing VARCHAR(30),
  mtel_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  mtel_user_mod VARCHAR(30),
  PRIMARY KEY (mtel_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_modulo_tel_alum (
  mtal_sec NUMERIC(23, 0),
  mtel_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  mtal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mtal_user_ing VARCHAR(30),
  PRIMARY KEY (mtal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_modulo_tel_nivel (
  mtni_sec NUMERIC(23, 0),
  mtel_sec NUMERIC(23, 0),
  mtni_cod VARCHAR(5),
  mtni_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mtni_user_ing VARCHAR(30),
  PRIMARY KEY (mtni_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_notas_asig_curso (
  cuas_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  nacu_tipo_peri VARCHAR(10),
  nacu_nota_1 VARCHAR(2),
  nacu_nota_2 VARCHAR(2),
  nacu_nota_3 VARCHAR(2),
  nacu_nota_4 VARCHAR(2),
  nacu_nota_5 VARCHAR(2),
  nacu_nota_6 VARCHAR(2),
  nacu_nota_7 VARCHAR(2),
  nacu_nota_8 VARCHAR(2),
  nacu_nota_9 VARCHAR(2),
  nacu_nota_10 VARCHAR(2),
  nacu_nota_11 VARCHAR(2),
  nacu_nota_12 VARCHAR(2),
  nacu_nota_13 VARCHAR(2),
  nacu_nota_14 VARCHAR(2),
  nacu_nota_15 VARCHAR(2),
  nacu_nota_16 VARCHAR(2),
  nacu_nota_17 VARCHAR(2),
  nacu_nota_18 VARCHAR(2),
  nacu_nota_19 VARCHAR(2),
  nacu_nota_20 VARCHAR(2),
  nacu_nota_examen VARCHAR(2),
  nacu_prom_parc VARCHAR(10),
  nacu_prom_sist VARCHAR(10),
  nacu_prom_final VARCHAR(10),
  nacu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  nacu_user_ing VARCHAR(30),
  nacu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  nacu_user_mod VARCHAR(20),
  nacu_nro_lista INTEGER,
  nacu_estado VARCHAR(30),
  nacu_eximido VARCHAR(1),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (cuas_sec, fial_sec, alcu_sec, nacu_tipo_peri)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_notas_asig_electiva (
  gael_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  grte_desc VARCHAR(100),
  grcu_letra_curso VARCHAR(2),
  nael_tipo_peri VARCHAR(10),
  fial_sec NUMERIC(23, 0),
  nael_nro_lista INTEGER,
  nael_nom_alumno VARCHAR(500),
  nacu_nota_1 VARCHAR(2),
  nacu_nota_2 VARCHAR(2),
  nacu_nota_3 VARCHAR(2),
  nacu_nota_4 VARCHAR(2),
  nacu_nota_5 VARCHAR(2),
  nacu_nota_6 VARCHAR(2),
  nacu_nota_7 VARCHAR(2),
  nacu_nota_8 VARCHAR(2),
  nacu_nota_9 VARCHAR(2),
  nacu_nota_10 VARCHAR(2),
  nacu_nota_11 VARCHAR(2),
  nacu_nota_12 VARCHAR(2),
  nacu_nota_13 VARCHAR(2),
  nacu_nota_14 VARCHAR(2),
  nacu_nota_15 VARCHAR(2),
  nacu_nota_16 VARCHAR(2),
  nacu_nota_17 VARCHAR(2),
  nacu_nota_18 VARCHAR(2),
  nacu_nota_19 VARCHAR(2),
  nacu_nota_20 VARCHAR(2),
  nael_nota_examen VARCHAR(2),
  nael_prom_parc VARCHAR(10),
  nael_prom_sist VARCHAR(10),
  nael_prom_final VARCHAR(10),
  nael_estado VARCHAR(30),
  nael_eximido VARCHAR(1),
  nael_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  nael_user_ing VARCHAR(30),
  alcu_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_observacion_alum (
  obal_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  obal_observacion VARCHAR(4000),
  obal_tipo_obs VARCHAR(20),
  obal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  obal_user_ing VARCHAR(30),
  obal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  obal_user_mod VARCHAR(30),
  obal_estado VARCHAR(30),
  obal_fecha_obs TIMESTAMP WITHOUT TIME ZONE,
  obal_hora_obs VARCHAR(10),
  caso_sec NUMERIC(23, 0),
  obal_tipo_func VARCHAR(2),
  prof_sec NUMERIC(23, 0),
  coes_sec NUMERIC(23, 0),
  maal_sec NUMERIC(23, 0),
  obal_tipo_reporta VARCHAR(10),
  obal_tipo_negativa VARCHAR(5),
  obal_momento_incidente VARCHAR(5),
  obal_lugar_incidente VARCHAR(10),
  obal_pers_sec_reporta NUMERIC(23, 0),
  PRIMARY KEY (obal_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_pagos_deta (
  pade_sec NUMERIC(23, 0),
  paen_sec NUMERIC(23, 0),
  pade_nro_cuota INTEGER,
  pade_mto_cobro NUMERIC(15, 2),
  pade_dscto_beca NUMERIC(15, 2),
  pade_dscto_fam NUMERIC(15, 2),
  pade_otros_dscto NUMERIC(15, 2),
  pade_mto_a_pagar NUMERIC(15, 2),
  pade_fecha_vcto TIMESTAMP WITHOUT TIME ZONE,
  pade_estado VARCHAR(30),
  pade_fecha_pago TIMESTAMP WITHOUT TIME ZONE,
  pade_medio_pago VARCHAR(30),
  pade_id_tbk VARCHAR(60),
  pade_cod_err NUMERIC(23, 0),
  pade_obs VARCHAR(4000),
  pade_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pade_user_ing VARCHAR(30),
  pade_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pade_user_mod VARCHAR(30),
  PRIMARY KEY (pade_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_pagos_enc (
  paen_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  cobe_sec NUMERIC(23, 0),
  paen_cnt_cuota INTEGER,
  paen_estado VARCHAR(30),
  paen_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paen_user_ing VARCHAR(30),
  paen_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paen_user_mod VARCHAR(30),
  PRIMARY KEY (paen_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_paises (
  pais_cod VARCHAR(20),
  pais_descrip VARCHAR(200),
  PRIMARY KEY (pais_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_parametros (
  para_codigo VARCHAR(50),
  para_desc VARCHAR(100),
  para_valor VARCHAR(2000),
  PRIMARY KEY (para_codigo)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_param_corp (
  esad_cod VARCHAR(30),
  pcor_cod VARCHAR(50),
  pcor_desc VARCHAR(100),
  pcor_valor VARCHAR(2000),
  PRIMARY KEY (esad_cod, pcor_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_par_prom_grcu (
  grcu_sec NUMERIC(23, 0),
  ppcu_tipo_prom VARCHAR(5),
  ppcu_cnt_decimal INTEGER,
  ppcu_tipo_aprox VARCHAR(5),
  ppcu_estado VARCHAR(30),
  ppcu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppcu_user_ing VARCHAR(30),
  ppcu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppcu_user_mod VARCHAR(30),
  PRIMARY KEY (grcu_sec, ppcu_tipo_prom)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_par_prom_grcu_asig (
  grcu_sec NUMERIC(23, 0),
  ppca_tipo_prom VARCHAR(5),
  asig_cod VARCHAR(20),
  ppca_cnt_decimal INTEGER,
  ppca_tipo_aprox VARCHAR(5),
  ppca_estado VARCHAR(30),
  ppca_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppca_user_ing VARCHAR(30),
  ppca_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppca_user_mod VARCHAR(30),
  PRIMARY KEY (grcu_sec, ppca_tipo_prom, asig_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_par_prom_grte (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  tien_cod VARCHAR(20),
  grte_cod VARCHAR(20),
  ppgt_tipo_prom VARCHAR(5),
  ppgt_cnt_decimal INTEGER,
  ppgt_tipo_aprox VARCHAR(5),
  ppgt_estado VARCHAR(30),
  ppgt_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppgt_user_ing VARCHAR(30),
  ppgt_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppgt_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, peri_sec, tien_cod, grte_cod, ppgt_tipo_prom)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_par_prom_grte_asig (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  tien_cod VARCHAR(20),
  grte_cod VARCHAR(20),
  ppga_tipo_prom VARCHAR(5),
  asig_cod VARCHAR(20),
  ppga_cnt_decimal INTEGER,
  ppga_tipo_aprox VARCHAR(5),
  ppga_estado VARCHAR(30),
  ppga_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppga_user_ing VARCHAR(30),
  ppga_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppga_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, peri_sec, tien_cod, grte_cod, ppga_tipo_prom, asig_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_par_prom_tien (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  tien_cod VARCHAR(20),
  ppte_tipo_prom VARCHAR(5),
  ppte_cnt_decimal INTEGER,
  ppte_tipo_aprox VARCHAR(5),
  ppte_formcal_gral VARCHAR(5),
  ppte_estado VARCHAR(30),
  ppte_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppte_user_ing VARCHAR(30),
  ppte_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppte_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, peri_sec, tien_cod, ppte_tipo_prom)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_par_prom_tien_asig (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  tien_cod VARCHAR(20),
  ppta_tipo_prom VARCHAR(5),
  asig_cod VARCHAR(20),
  ppta_cnt_decimal INTEGER,
  ppta_tipo_aprox VARCHAR(5),
  ppta_estado VARCHAR(30),
  ppta_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppta_user_ing VARCHAR(30),
  ppta_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppta_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, peri_sec, tien_cod, ppta_tipo_prom, asig_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_perfil (
  prfl_sec NUMERIC(23, 0),
  prfl_cod VARCHAR(20),
  prfl_desc VARCHAR(100),
  esed_sec NUMERIC(23, 0),
  prfl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prfl_user_ing VARCHAR(30),
  PRIMARY KEY (prfl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_perfil_apli (
  prfl_sec NUMERIC(23, 0),
  apli_cod VARCHAR(50),
  peap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  peap_user_ing VARCHAR(30),
  peap_guardar VARCHAR(1),
  peap_editar VARCHAR(1),
  peap_eliminar VARCHAR(1),
  peap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  peap_user_mod VARCHAR(30),
  PRIMARY KEY (prfl_sec, apli_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_periodos (
  peri_sec NUMERIC(23, 0),
  peri_desc_corta VARCHAR(60),
  peri_desc_larga VARCHAR(200),
  peri_estado VARCHAR(30),
  peri_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  peri_user_ing VARCHAR(30),
  peri_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_user_mod VARCHAR(30),
  esed_sec NUMERIC(23, 0),
  PRIMARY KEY (peri_sec, esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_periodo_postulacion (
  ppos_sec NUMERIC(23, 0),
  ppos_anno INTEGER,
  ppos_desc VARCHAR(100),
  ppos_estado VARCHAR(30),
  ppos_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppos_user_ing VARCHAR(30),
  ppos_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppos_user_mod VARCHAR(30),
  PRIMARY KEY (ppos_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_periodo_tien (
  pete_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  pete_tipo_peri VARCHAR(10),
  pete_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  pete_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  pete_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pete_user_ing VARCHAR(30),
  pete_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pete_user_mod VARCHAR(30),
  PRIMARY KEY (pete_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_peri_post_estab (
  esed_sec NUMERIC(23, 0),
  ppes_tipo_post VARCHAR(5),
  ppes_ver VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_persec_a_eliminar (
  pers_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_personas (
  pers_sec NUMERIC(23, 0),
  pers_rut BIGINT,
  pers_dv VARCHAR(1),
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(60),
  pers_ape_mat VARCHAR(60),
  pers_genero VARCHAR(5),
  pers_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  pers_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pers_user_ing VARCHAR(30),
  pers_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pers_user_mod VARCHAR(30),
  pers_nombre_social VARCHAR(100),
  PRIMARY KEY (pers_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_pers_firmas (
  pers_sec NUMERIC(23, 0),
  pefi_firma BYTEA,
  PRIMARY KEY (pers_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_acti (
  paac_sec NUMERIC(23, 0),
  paun_sec NUMERIC(23, 0),
  epac_sec NUMERIC(23, 0),
  paac_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paac_user_ing VARCHAR(30),
  paac_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paac_user_mod VARCHAR(30),
  PRIMARY KEY (paac_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_conoci (
  paco_sec NUMERIC(23, 0),
  paun_sec NUMERIC(23, 0),
  epco_sec NUMERIC(23, 0),
  paco_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paco_user_ing VARCHAR(30),
  paco_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paco_user_mod VARCHAR(30),
  PRIMARY KEY (paco_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_conoci_hijo (
  pach_sec NUMERIC(23, 0),
  paco_sec NUMERIC(23, 0),
  epch_sec NUMERIC(23, 0),
  pach_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pach_user_ing VARCHAR(30),
  pach_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pach_user_mod VARCHAR(30),
  PRIMARY KEY (pach_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_conten (
  pact_sec NUMERIC(23, 0),
  paob_sec NUMERIC(23, 0),
  epct_sec NUMERIC(23, 0),
  pact_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pact_user_ing VARCHAR(30),
  pact_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pact_user_mod VARCHAR(30),
  PRIMARY KEY (pact_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_crit_eval (
  pace_sec NUMERIC(23, 0),
  pain_sec NUMERIC(23, 0),
  epce_sec NUMERIC(23, 0),
  pace_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pace_user_ing VARCHAR(30),
  pace_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pace_user_mod VARCHAR(30),
  PRIMARY KEY (pace_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_habi (
  paha_sec NUMERIC(23, 0),
  paun_sec NUMERIC(23, 0),
  epha_sec NUMERIC(23, 0),
  paha_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paha_user_ing VARCHAR(30),
  paha_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paha_user_mod VARCHAR(30),
  PRIMARY KEY (paha_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_indi (
  pain_sec NUMERIC(23, 0),
  paob_sec NUMERIC(23, 0),
  epin_sec NUMERIC(23, 0),
  pain_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pain_user_ing VARCHAR(30),
  pain_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pain_user_mod VARCHAR(30),
  PRIMARY KEY (pain_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_menc (
  pame_sec NUMERIC(23, 0),
  paun_sec NUMERIC(23, 0),
  epme_sec NUMERIC(23, 0),
  pame_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pame_user_ing VARCHAR(30),
  pame_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pame_user_mod VARCHAR(30),
  PRIMARY KEY (pame_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_obje (
  paob_sec NUMERIC(23, 0),
  paun_sec NUMERIC(23, 0),
  epob_sec NUMERIC(23, 0),
  epeo_sec NUMERIC(23, 0),
  paob_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paob_user_ing VARCHAR(30),
  paob_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paob_user_mod VARCHAR(30),
  PRIMARY KEY (paob_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_obje_alum (
  paob_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  paoa_nivel_logro VARCHAR(5),
  paoa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paoa_user_ing VARCHAR(30),
  paoa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paoa_user_mod VARCHAR(30),
  paoa_puntaje INTEGER,
  PRIMARY KEY (paob_sec, fial_sec, alcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_obje_docto (
  paob_sec NUMERIC(23, 0),
  paod_nombre_carga VARCHAR(256),
  paod_nom_arch_real VARCHAR(512),
  paod_nom_arch_inte VARCHAR(512),
  paod_tamano_arch BIGINT,
  paod_purgado VARCHAR(2),
  paod_fec_purgado TIMESTAMP WITHOUT TIME ZONE,
  paod_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paod_user_ing VARCHAR(30),
  paod_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paod_user_mod VARCHAR(30),
  paod_fec_carga TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (paob_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_obje_trans (
  paot_sec NUMERIC(23, 0),
  paob_sec NUMERIC(23, 0),
  epob_sec NUMERIC(23, 0),
  paot_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paot_user_ing VARCHAR(30),
  paot_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paot_user_mod VARCHAR(30),
  epob_sec_padre NUMERIC(23, 0),
  PRIMARY KEY (paot_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_obj_gene (
  paog_sec NUMERIC(23, 0),
  pace_sec NUMERIC(23, 0),
  epog_sec NUMERIC(23, 0),
  paog_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paog_user_ing VARCHAR(30),
  paog_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paog_user_mod VARCHAR(30),
  PRIMARY KEY (paog_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_pacl (
  papc_sec NUMERIC(23, 0),
  paun_sec NUMERIC(23, 0),
  eppc_sec NUMERIC(23, 0),
  papc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  papc_user_ing VARCHAR(30),
  papc_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  papc_user_mod VARCHAR(30),
  PRIMARY KEY (papc_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_unid (
  paun_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  epun_sec NUMERIC(23, 0),
  paun_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  paun_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  paun_cnt_horas INTEGER,
  paun_cnt_clases INTEGER,
  paun_actividad VARCHAR(4000),
  paun_recursos VARCHAR(4000),
  paun_proce_eval VARCHAR(4000),
  paun_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paun_user_ing VARCHAR(30),
  paun_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  paun_user_mod VARCHAR(30),
  paun_sec_origen NUMERIC(23, 0),
  PRIMARY KEY (paun_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_asig_unid_msj (
  paun_sec NUMERIC(23, 0),
  punm_nro INTEGER,
  punm_mensaje VARCHAR(4000),
  punm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  punm_user_ing VARCHAR(30),
  punm_es_nuevo VARCHAR(5),
  PRIMARY KEY (paun_sec, punm_nro)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_cnt_clase (
  pccl_sec NUMERIC(23, 0),
  paun_sec NUMERIC(23, 0),
  pccl_nro INTEGER,
  pccl_fecha TIMESTAMP WITHOUT TIME ZONE,
  pccl_orden_clase INTEGER,
  pccl_esta_clase VARCHAR(10),
  pccl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pccl_user_ing VARCHAR(30),
  pccl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pccl_user_mod VARCHAR(30),
  pccl_minutos INTEGER,
  pccl_fec_realizada TIMESTAMP WITHOUT TIME ZONE,
  pccl_nivel_logro VARCHAR(5),
  pccl_puntaje INTEGER,
  PRIMARY KEY (pccl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_cnt_clase_msj (
  pccl_sec NUMERIC(23, 0),
  pclm_nro INTEGER,
  pclm_mensaje VARCHAR(4000),
  pclm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pclm_user_ing VARCHAR(30),
  pclm_es_nuevo VARCHAR(5),
  PRIMARY KEY (pccl_sec, pclm_nro)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_deta_clase (
  pdcl_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  pdcl_inicio VARCHAR(4000),
  pdcl_desarrollo VARCHAR(4000),
  pdcl_cierre VARCHAR(4000),
  pdcl_proc_eval VARCHAR(4000),
  pdcl_princ_dua VARCHAR(4000),
  pdcl_recurso VARCHAR(4000),
  pdcl_obj_clase VARCHAR(4000),
  pccl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pccl_user_ing VARCHAR(30),
  pccl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pccl_user_mod VARCHAR(30),
  PRIMARY KEY (pdcl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_acti (
  pdcl_sec NUMERIC(23, 0),
  paac_sec NUMERIC(23, 0),
  PRIMARY KEY (pdcl_sec, paac_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_conoci (
  pdcl_sec NUMERIC(23, 0),
  paco_sec NUMERIC(23, 0),
  PRIMARY KEY (pdcl_sec, paco_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_conoci_hijo (
  pdcl_sec NUMERIC(23, 0),
  paco_sec NUMERIC(23, 0),
  pach_sec NUMERIC(23, 0),
  PRIMARY KEY (pdcl_sec, paco_sec, pach_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_cont (
  pcct_sec NUMERIC(23, 0),
  pcob_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  pact_sec NUMERIC(23, 0),
  PRIMARY KEY (pcct_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_crit_eval (
  pcce_sec NUMERIC(23, 0),
  pcin_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  pace_sec NUMERIC(23, 0),
  PRIMARY KEY (pcce_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_habi (
  pdcl_sec NUMERIC(23, 0),
  paha_sec NUMERIC(23, 0),
  PRIMARY KEY (pdcl_sec, paha_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_indi (
  pcin_sec NUMERIC(23, 0),
  pcob_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  pain_sec NUMERIC(23, 0),
  PRIMARY KEY (pcin_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_menc (
  pdcl_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  pame_sec NUMERIC(23, 0),
  PRIMARY KEY (pdcl_sec, pccl_sec, pame_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_obje (
  pcob_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  paob_sec NUMERIC(23, 0),
  PRIMARY KEY (pcob_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_obje_trans (
  pcot_sec NUMERIC(23, 0),
  pcob_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  paot_sec NUMERIC(23, 0),
  PRIMARY KEY (pcot_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_obj_gene (
  pcog_sec NUMERIC(23, 0),
  pcce_sec NUMERIC(23, 0),
  pccl_sec NUMERIC(23, 0),
  paog_sec NUMERIC(23, 0),
  PRIMARY KEY (pcog_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plani_pccl_pacl (
  pdcl_sec NUMERIC(23, 0),
  papc_sec NUMERIC(23, 0),
  PRIMARY KEY (pdcl_sec, papc_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plantilla_dethor (
  pldh_sec NUMERIC(23, 0),
  plho_sec NUMERIC(23, 0),
  pldh_bloque VARCHAR(5),
  tibl_sec NUMERIC(23, 0),
  pldh_duracion INTEGER,
  pldh_hrs_ini VARCHAR(20),
  pldh_hrs_fin VARCHAR(20),
  pldh_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pldh_user_ing VARCHAR(30),
  pldh_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pldh_user_mod VARCHAR(30),
  PRIMARY KEY (pldh_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plantilla_horario (
  plho_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  plho_nombre VARCHAR(100),
  plho_estado VARCHAR(30),
  plho_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  plho_user_ing VARCHAR(30),
  PRIMARY KEY (plho_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plantilla_mensaje (
  plme_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  plme_desc VARCHAR(100),
  plme_texto VARCHAR(4000),
  plme_tipo VARCHAR(10),
  plme_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  plme_user_ing VARCHAR(30),
  plme_tipo_canal VARCHAR(5),
  PRIMARY KEY (plme_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plan_decm (
  pldm_sec NUMERIC(23, 0),
  decm_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  pldm_estado VARCHAR(30),
  pldm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pldm_user_ing VARCHAR(30),
  pldm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pldm_user_mod VARCHAR(30),
  PRIMARY KEY (pldm_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plan_estudio (
  ples_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  ples_cod VARCHAR(20),
  ples_texto VARCHAR(4000),
  ples_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ples_user_ing VARCHAR(30),
  ples_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ples_user_mod VARCHAR(30),
  ples_fec_plan TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (ples_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plan_evaluacion (
  plev_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  plev_nombre VARCHAR(100),
  plev_descrip VARCHAR(500),
  plev_estado VARCHAR(30),
  plev_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  plev_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  plev_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  plev_user_ing VARCHAR(30),
  plev_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  plev_user_mod VARCHAR(30),
  plev_tipo_asig VARCHAR(2),
  PRIMARY KEY (plev_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plan_eval_det (
  pled_sec NUMERIC(23, 0),
  plev_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  ines_sec NUMERIC(23, 0),
  pled_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pled_user_ing VARCHAR(30),
  pled_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pled_user_mod VARCHAR(30),
  PRIMARY KEY (pled_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_pldm_asignatura (
  pldm_sec NUMERIC(23, 0),
  asig_cod VARCHAR(20),
  plas_horas NUMERIC(5, 2),
  plas_obligatorio VARCHAR(2),
  plas_formacion VARCHAR(10),
  plas_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  plas_user_ing VARCHAR(30),
  plas_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  plas_user_mod VARCHAR(30),
  plas_orden INTEGER,
  PRIMARY KEY (pldm_sec, asig_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_plho_grado (
  phgr_sec NUMERIC(23, 0),
  plho_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  phgr_estado VARCHAR(30),
  phgr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  phgr_user_ing VARCHAR(30),
  phgr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  phgr_user_mod VARCHAR(30),
  PRIMARY KEY (phgr_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ponderacion_notas (
  pono_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  pono_tipo_peri VARCHAR(10),
  pono_nombre VARCHAR(20),
  pono_descripcion VARCHAR(200),
  pono_valor_pond INTEGER,
  pono_tipo_aprox VARCHAR(5),
  pono_cnt_decimal INTEGER,
  pono_fecha TIMESTAMP WITHOUT TIME ZONE,
  pono_tiene_p_deta VARCHAR(2),
  pono_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pono_user_ing VARCHAR(30),
  pono_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pono_user_mod VARCHAR(30),
  PRIMARY KEY (pono_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ponde_formula_asig (
  cuas_sec NUMERIC(23, 0),
  pofa_tipo_peri VARCHAR(10),
  pofa_formula VARCHAR(4000),
  pofa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pofa_user_ing VARCHAR(30),
  PRIMARY KEY (cuas_sec, pofa_tipo_peri)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ponde_notas_deta (
  pnde_sec NUMERIC(23, 0),
  pono_sec NUMERIC(23, 0),
  pnde_nro_nota INTEGER,
  pnde_valor_pond INTEGER,
  pnde_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pnde_user_ing VARCHAR(30),
  pnde_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pnde_user_mod VARCHAR(30),
  PRIMARY KEY (pnde_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postulacion_estab (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  poes_rut BIGINT,
  poes_dv VARCHAR(1),
  poes_nombres VARCHAR(100),
  poes_ape_pat VARCHAR(60),
  poes_ape_mat VARCHAR(60),
  poes_genero VARCHAR(5),
  poes_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  poes_direccion VARCHAR(200),
  poes_email VARCHAR(60),
  poes_fono VARCHAR(15),
  poes_celular VARCHAR(15),
  poes_cod_etnia VARCHAR(10),
  poes_estado VARCHAR(30),
  poes_es_prioritario VARCHAR(2),
  poes_es_preferente VARCHAR(2),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  poes_observacion VARCHAR(4000),
  poes_cert_anual_notas VARCHAR(1),
  poes_certif_nac VARCHAR(1),
  poes_orden_judicial VARCHAR(1),
  poes_ident_prov_escolar VARCHAR(1),
  poes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  poes_user_ing VARCHAR(30),
  poes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  poes_user_mod VARCHAR(30),
  poes_letra_curso VARCHAR(2),
  poes_otros VARCHAR(1),
  poes_codigo_verificacion VARCHAR(50),
  PRIMARY KEY (esed_sec, poes_rut)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postulacion_estab_2022 (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  poes_rut BIGINT,
  poes_dv VARCHAR(1),
  poes_nombres VARCHAR(100),
  poes_ape_pat VARCHAR(60),
  poes_ape_mat VARCHAR(60),
  poes_genero VARCHAR(5),
  poes_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  poes_direccion VARCHAR(200),
  poes_email VARCHAR(60),
  poes_fono VARCHAR(15),
  poes_celular VARCHAR(15),
  poes_cod_etnia VARCHAR(10),
  poes_estado VARCHAR(30),
  poes_es_prioritario VARCHAR(2),
  poes_es_preferente VARCHAR(2),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  poes_observacion VARCHAR(4000),
  poes_cert_anual_notas VARCHAR(1),
  poes_certif_nac VARCHAR(1),
  poes_orden_judicial VARCHAR(1),
  poes_ident_prov_escolar VARCHAR(1),
  poes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  poes_user_ing VARCHAR(30),
  poes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  poes_user_mod VARCHAR(30),
  poes_letra_curso VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postulacion_portal (
  ppor_rut BIGINT,
  ppor_dv VARCHAR(1),
  ppor_nombres VARCHAR(100),
  ppor_ape_pat VARCHAR(60),
  ppor_ape_mat VARCHAR(60),
  ppor_genero VARCHAR(5),
  ppor_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  ppor_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  ppor_desc_grado VARCHAR(60),
  ppor_rut_cont BIGINT,
  ppor_dv_cont VARCHAR(1),
  ppor_nom_cont VARCHAR(100),
  ppor_ape_pat_cont VARCHAR(60),
  ppor_ape_mat_cont VARCHAR(60),
  ppor_email_cont VARCHAR(60),
  ppor_fono_cont VARCHAR(15),
  ppor_celular_cont VARCHAR(15),
  sucm_sec VARCHAR(60),
  ppor_nro_atencion NUMERIC(23, 0),
  ppor_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  ppor_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppor_user_ing VARCHAR(30),
  ppor_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppor_user_mod VARCHAR(30),
  suhp_sec NUMERIC(23, 0),
  ppor_flag_envio_wsp VARCHAR(1),
  ppor_fec_envio_wsp TIMESTAMP WITHOUT TIME ZONE,
  ppor_id_unico VARCHAR(32),
  ppor_cnt_alum INTEGER,
  PRIMARY KEY (ppor_rut)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postulacion_portal_202208 (
  ppor_rut BIGINT,
  ppor_dv VARCHAR(1),
  ppor_nombres VARCHAR(100),
  ppor_ape_pat VARCHAR(60),
  ppor_ape_mat VARCHAR(60),
  ppor_genero VARCHAR(5),
  ppor_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  ppor_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  ppor_desc_grado VARCHAR(60),
  ppor_rut_cont BIGINT,
  ppor_dv_cont VARCHAR(1),
  ppor_nom_cont VARCHAR(100),
  ppor_ape_pat_cont VARCHAR(60),
  ppor_ape_mat_cont VARCHAR(60),
  ppor_email_cont VARCHAR(60),
  ppor_fono_cont VARCHAR(15),
  ppor_celular_cont VARCHAR(15),
  sucm_sec VARCHAR(60),
  ppor_nro_atencion NUMERIC(23, 0),
  ppor_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  ppor_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppor_user_ing VARCHAR(30),
  ppor_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppor_user_mod VARCHAR(30),
  suhp_sec NUMERIC(23, 0),
  ppor_flag_envio_wsp VARCHAR(1),
  ppor_fec_envio_wsp TIMESTAMP WITHOUT TIME ZONE,
  ppor_id_unico VARCHAR(32)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postulacion_portal_peri_may_jul (
  ppor_rut BIGINT,
  ppor_dv VARCHAR(1),
  ppor_nombres VARCHAR(100),
  ppor_ape_pat VARCHAR(60),
  ppor_ape_mat VARCHAR(60),
  ppor_genero VARCHAR(5),
  ppor_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  ppor_direccion VARCHAR(200),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  ppor_desc_grado VARCHAR(60),
  ppor_rut_cont BIGINT,
  ppor_dv_cont VARCHAR(1),
  ppor_nom_cont VARCHAR(100),
  ppor_ape_pat_cont VARCHAR(60),
  ppor_ape_mat_cont VARCHAR(60),
  ppor_email_cont VARCHAR(60),
  ppor_fono_cont VARCHAR(15),
  ppor_celular_cont VARCHAR(15),
  sucm_sec VARCHAR(60),
  ppor_nro_atencion NUMERIC(23, 0),
  ppor_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  ppor_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ppor_user_ing VARCHAR(30),
  ppor_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ppor_user_mod VARCHAR(30),
  suhp_sec NUMERIC(23, 0),
  ppor_flag_envio_wsp VARCHAR(1),
  ppor_fec_envio_wsp TIMESTAMP WITHOUT TIME ZONE,
  ppor_id_unico VARCHAR(32),
  ppor_cnt_alum INTEGER
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postu_docto_parv_adul (
  ppad_sec NUMERIC(23, 0),
  popa_sec NUMERIC(23, 0),
  ppad_tipo_docto VARCHAR(10),
  ppad_docto BYTEA,
  ppad_nom_docto VARCHAR(100),
  PRIMARY KEY (ppad_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postu_docto_parv_adul_102024 (
  ppad_sec NUMERIC(23, 0),
  popa_sec NUMERIC(23, 0),
  ppad_tipo_docto VARCHAR(10),
  ppad_docto BYTEA,
  ppad_nom_docto VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postu_parvulo_adulto (
  popa_sec NUMERIC(23, 0),
  ppos_sec NUMERIC(23, 0),
  popa_tipo_post VARCHAR(5),
  tien_cod VARCHAR(20),
  grte_descrip VARCHAR(100),
  popa_rut BIGINT,
  popa_dv VARCHAR(1),
  popa_nombres VARCHAR(100),
  popa_ape_pat VARCHAR(60),
  popa_ape_mat VARCHAR(60),
  popa_genero VARCHAR(5),
  popa_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  pais_cod VARCHAR(20),
  esed_sec_1_op NUMERIC(23, 0),
  esed_sec_2_op NUMERIC(23, 0),
  popa_tiene_neep VARCHAR(2),
  popa_nom_cont VARCHAR(100),
  popa_ape_pat_cont VARCHAR(60),
  popa_ape_mat_cont VARCHAR(60),
  popa_tipo_docto_ident VARCHAR(5),
  popa_rut_cont BIGINT,
  popa_dv_cont VARCHAR(1),
  popa_nro_pasaporte VARCHAR(60),
  popa_parentesco VARCHAR(10),
  popa_fono_cont VARCHAR(15),
  popa_email_cont VARCHAR(60),
  popa_estado_post VARCHAR(10),
  popa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  popa_user_ing VARCHAR(30),
  popa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  popa_user_mod VARCHAR(30),
  PRIMARY KEY (popa_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_postu_parvulo_adulto_102024 (
  popa_sec NUMERIC(23, 0),
  ppos_sec NUMERIC(23, 0),
  popa_tipo_post VARCHAR(5),
  tien_cod VARCHAR(20),
  grte_descrip VARCHAR(100),
  popa_rut BIGINT,
  popa_dv VARCHAR(1),
  popa_nombres VARCHAR(100),
  popa_ape_pat VARCHAR(60),
  popa_ape_mat VARCHAR(60),
  popa_genero VARCHAR(5),
  popa_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  pais_cod VARCHAR(20),
  esed_sec_1_op NUMERIC(23, 0),
  esed_sec_2_op NUMERIC(23, 0),
  popa_tiene_neep VARCHAR(2),
  popa_nom_cont VARCHAR(100),
  popa_ape_pat_cont VARCHAR(60),
  popa_ape_mat_cont VARCHAR(60),
  popa_tipo_docto_ident VARCHAR(5),
  popa_rut_cont BIGINT,
  popa_dv_cont VARCHAR(1),
  popa_nro_pasaporte VARCHAR(60),
  popa_parentesco VARCHAR(10),
  popa_fono_cont VARCHAR(15),
  popa_email_cont VARCHAR(60),
  popa_estado_post VARCHAR(10),
  popa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  popa_user_ing VARCHAR(30),
  popa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  popa_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_post_estab_eliminados (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  poee_rut BIGINT,
  poee_dv VARCHAR(1),
  poee_nombres VARCHAR(100),
  poee_ape_pat VARCHAR(60),
  poee_ape_mat VARCHAR(60),
  poee_genero VARCHAR(5),
  poee_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  poee_direccion VARCHAR(200),
  poee_email VARCHAR(60),
  poee_fono VARCHAR(15),
  poee_celular VARCHAR(15),
  poee_cod_etnia VARCHAR(10),
  poee_es_prioritario VARCHAR(2),
  poee_es_preferente VARCHAR(2),
  comu_cod VARCHAR(10),
  ciud_cod VARCHAR(10),
  regi_cod VARCHAR(10),
  pais_cod VARCHAR(20),
  poee_observacion VARCHAR(4000),
  poee_cert_anual_notas VARCHAR(1),
  poee_certif_nac VARCHAR(1),
  poee_orden_judicial VARCHAR(1),
  poee_ident_prov_escolar VARCHAR(1),
  poee_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  poee_user_ing VARCHAR(30),
  PRIMARY KEY (esed_sec, poee_rut, poee_fec_ing)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_preguntas_sein (
  prse_sec NUMERIC(23, 0),
  sein_sec NUMERIC(23, 0),
  prse_txt_preg VARCHAR(4000),
  prse_orden BIGINT,
  prse_aplica_info VARCHAR(2),
  prse_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prse_user_ing VARCHAR(30),
  prse_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  prse_user_mod VARCHAR(30),
  PRIMARY KEY (prse_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_programa_escolar (
  fial_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  pres_preferente VARCHAR(5),
  pres_prioritario VARCHAR(5),
  pres_integracion_escolar VARCHAR(5),
  pres_beca_residencia VARCHAR(5),
  pres_beca_bare VARCHAR(5),
  pres_presid_republica VARCHAR(5),
  pres_programa_puente VARCHAR(5),
  pres_pro_retencion VARCHAR(5),
  pres_apoyo_aprendizaje VARCHAR(5),
  pres_programa_junaeb VARCHAR(5),
  pres_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pres_user_ing VARCHAR(30),
  pres_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pres_user_mod VARCHAR(30),
  PRIMARY KEY (fial_sec, esed_sec, peri_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_promedio_final_asig (
  cuas_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  prfa_nro_lista INTEGER,
  prfa_prom_final VARCHAR(10),
  prfa_estado VARCHAR(30),
  prfa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prfa_user_ing VARCHAR(30),
  prfa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  prfa_user_mod VARCHAR(30),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (cuas_sec, fial_sec, alcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_promedio_gral_alum (
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  prga_nro_lista INTEGER,
  prga_prom_1_st VARCHAR(10),
  prga_prom_2_st VARCHAR(10),
  prga_prom_3_tr VARCHAR(10),
  prga_prom_gral VARCHAR(10),
  prga_estado VARCHAR(30),
  prga_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prga_user_ing VARCHAR(30),
  prga_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  prga_user_mod VARCHAR(30),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (grcu_sec, fial_sec, alcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_promocion_alumnos (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  pral_tipo_peri VARCHAR(10),
  pral_cnt_rojo_nor INTEGER,
  pral_cnt_rojo_pri INTEGER,
  pral_aprob_x_notas VARCHAR(2),
  pral_prom_notas INTEGER,
  pral_aprob_x_asist VARCHAR(2),
  pral_porc_asist NUMERIC(5, 2),
  pral_situacion_final VARCHAR(5),
  pral_estado VARCHAR(20),
  pral_fecha_proceso TIMESTAMP WITHOUT TIME ZONE,
  pral_nro_lista INTEGER,
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (esed_sec, peri_sec, grcu_sec, fial_sec, pral_tipo_peri)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_recursos_estab (
  rees_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  rees_cod VARCHAR(15),
  rees_desc VARCHAR(200),
  rees_tipo_recurso VARCHAR(60),
  rees_estado VARCHAR(30),
  rees_responsable VARCHAR(200),
  rees_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  rees_user_ing VARCHAR(30),
  rees_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  rees_user_mod VARCHAR(30),
  PRIMARY KEY (rees_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ref_codes (
  ref_dom VARCHAR(100),
  ref_low_val VARCHAR(240),
  ref_hig_val VARCHAR(240),
  ref_abr VARCHAR(240),
  ref_mng VARCHAR(240),
  ref_agr VARCHAR(2),
  ref_mod VARCHAR(2),
  PRIMARY KEY (ref_dom, ref_low_val)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ref_codes_esed (
  ref_dom VARCHAR(100),
  ref_low_val VARCHAR(240),
  ref_hig_val VARCHAR(240),
  ref_abr VARCHAR(240),
  ref_mng VARCHAR(240),
  ref_agr VARCHAR(2),
  ref_mod VARCHAR(2),
  esed_sec NUMERIC(23, 0),
  tien_cod VARCHAR(100),
  grte_cod VARCHAR(10),
  ref_orden BIGINT
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_ref_rango_esed (
  rres_sec VARCHAR(100),
  rres_anno INTEGER,
  rres_cod_logro VARCHAR(10),
  rres_rango_ini INTEGER,
  rres_rango_fin INTEGER,
  esed_sec NUMERIC(23, 0),
  tien_cod VARCHAR(100),
  grte_cod VARCHAR(100),
  rres_orden BIGINT,
  rres_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  rres_user_ing VARCHAR(30),
  rres_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  rres_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_regiones (
  regi_cod VARCHAR(20),
  regi_num_rom VARCHAR(20),
  regi_descrip VARCHAR(200),
  regi_orden INTEGER,
  regi_cod_ministerial VARCHAR(20),
  PRIMARY KEY (regi_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_reglas_promocion (
  repr_cod VARCHAR(20),
  repr_desc VARCHAR(200),
  repr_porc_asist NUMERIC(5, 2),
  repr_cnt_asig_rojo_1 INTEGER,
  repr_prom_rojo_1 INTEGER,
  repr_cnt_asig_rojo_2 INTEGER,
  repr_prom_rojo_2 INTEGER,
  repr_prom_rojo_pr INTEGER,
  repr_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  repr_user_ing VARCHAR(30),
  repr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  repr_user_mod VARCHAR(30),
  PRIMARY KEY (repr_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_respuesta_evin (
  evin_sec NUMERIC(23, 0),
  prse_sec NUMERIC(23, 0),
  reev_evaluacion VARCHAR(15),
  reev_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  reev_user_ing VARCHAR(30),
  reev_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reev_user_mod VARCHAR(30),
  PRIMARY KEY (evin_sec, prse_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_respuesta_prof (
  evin_sec NUMERIC(23, 0),
  prse_sec NUMERIC(23, 0),
  rpro_evaluacion VARCHAR(15),
  rpro_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  rpro_user_ing VARCHAR(30),
  rpro_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  rpro_user_mod VARCHAR(30),
  PRIMARY KEY (evin_sec, prse_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_resumen_estado_asbl (
  reab_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  reab_nro_bloque INTEGER,
  reab_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  reab_estado VARCHAR(15),
  reab_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  reab_user_ing VARCHAR(30),
  reab_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reab_user_mod VARCHAR(30),
  reab_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  gael_sec NUMERIC(23, 0),
  PRIMARY KEY (reab_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_resumen_estado_asdi (
  read_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  read_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  read_estado VARCHAR(15),
  read_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  read_user_ing VARCHAR(30),
  read_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  read_user_mod VARCHAR(30),
  read_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (read_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_resumen_estado_atal (
  reaa_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  atal_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  reaa_fecha_atraso TIMESTAMP WITHOUT TIME ZONE,
  reaa_hora_atraso VARCHAR(6),
  reaa_observacion VARCHAR(400),
  reaa_estado VARCHAR(15),
  reaa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  reaa_user_ing VARCHAR(30),
  reaa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reaa_user_mod VARCHAR(30),
  reaa_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (reaa_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_resumen_estado_leno (
  reln_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  leas_sec NUMERIC(23, 0),
  reln_nro_cont NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  reln_fecha TIMESTAMP WITHOUT TIME ZONE,
  reln_estado VARCHAR(15),
  reln_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  reln_user_ing VARCHAR(30),
  reln_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reln_user_mod VARCHAR(30),
  reln_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  reln_es_lecc_pie VARCHAR(2),
  PRIMARY KEY (reln_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_resumen_estado_lepa (
  relp_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  lepa_sec NUMERIC(23, 0),
  relp_nro_cont NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  relp_fecha TIMESTAMP WITHOUT TIME ZONE,
  relp_estado VARCHAR(15),
  relp_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  relp_user_ing VARCHAR(30),
  relp_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  relp_user_mod VARCHAR(30),
  relp_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  relp_es_lecc_pie VARCHAR(2),
  PRIMARY KEY (relp_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_resumen_matri_estab (
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  rmes_cupos_decla BIGINT,
  rmes_cnt_cursos BIGINT,
  rmes_prematri_peri BIGINT,
  rmes_cupos_diponibles BIGINT,
  rmes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  rmes_user_ing VARCHAR(60),
  rmes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  rmes_user_mod VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_rut_sin_fecha_tmp (
  rsft_rut BIGINT,
  rsft_dv VARCHAR(1),
  sucm_sec NUMERIC(23, 0),
  rsft_nom_sucursal VARCHAR(500),
  rsft_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  rsft_hora_atencion VARCHAR(10),
  rsft_reg_upd VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_rut_suc_hora_tmp (
  rush_rut BIGINT,
  suhp_sec NUMERIC(23, 0),
  rush_upd_reg VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_salida_cursos_det (
  scen_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  scde_nro_lista INTEGER,
  scde_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  scde_user_ing VARCHAR(30),
  alcu_sec NUMERIC(23, 0),
  scde_asiste VARCHAR(5),
  scde_observacion VARCHAR(100),
  PRIMARY KEY (scen_sec, fial_sec, alcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_salida_cursos_enc (
  scen_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  scen_fec_salida TIMESTAMP WITHOUT TIME ZONE,
  scen_hora_ini VARCHAR(10),
  scen_hora_fin VARCHAR(10),
  scen_tipo_docente VARCHAR(5),
  scen_coes_prof NUMERIC(23, 0),
  scen_motivo VARCHAR(500),
  scen_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  scen_user_ing VARCHAR(30),
  scen_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  scen_user_mod VARCHAR(30),
  PRIMARY KEY (scen_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_salida_cursos_respons (
  scen_sec NUMERIC(23, 0),
  scre_rut VARCHAR(20),
  scre_nom_ape VARCHAR(100),
  scre_tipo_responsable VARCHAR(5),
  scre_cargo_transpor VARCHAR(10),
  scre_patente_vehiculo VARCHAR(20),
  scre_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  scre_user_ing VARCHAR(30),
  scre_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  scre_user_mod VARCHAR(30),
  PRIMARY KEY (scen_sec, scre_rut, scre_tipo_responsable)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_seccion_ines (
  sein_sec NUMERIC(23, 0),
  ines_sec NUMERIC(23, 0),
  sein_nom_seccion VARCHAR(200),
  sein_orden BIGINT,
  sein_aplica_info VARCHAR(2),
  sein_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  sein_user_ing VARCHAR(30),
  sein_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  sein_user_mod VARCHAR(30),
  PRIMARY KEY (sein_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sectores (
  sect_cod VARCHAR(20),
  sect_descrip VARCHAR(200),
  tien_tipo_rama VARCHAR(10),
  PRIMARY KEY (sect_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_asistencia (
  sias_sec NUMERIC,
  esad_cod VARCHAR(30),
  esed_sec NUMERIC(23, 0),
  esed_descripcion VARCHAR(200),
  esed_cod VARCHAR(30),
  tien_cod VARCHAR(10),
  tien_descripcion VARCHAR(200),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  grcu_sec NUMERIC(23, 0),
  grcu_letra_curso VARCHAR(2),
  peri_sec NUMERIC,
  sias_anio NUMERIC,
  sias_mes INTEGER,
  sias_tipo_asistencia VARCHAR(2),
  sias_d01 VARCHAR(3),
  sias_d02 VARCHAR(3),
  sias_d03 VARCHAR(3),
  sias_d04 VARCHAR(3),
  sias_d05 VARCHAR(3),
  sias_d06 VARCHAR(3),
  sias_d07 VARCHAR(3),
  sias_d08 VARCHAR(3),
  sias_d09 VARCHAR(3),
  sias_d10 VARCHAR(3),
  sias_d11 VARCHAR(3),
  sias_d12 VARCHAR(3),
  sias_d13 VARCHAR(3),
  sias_d14 VARCHAR(3),
  sias_d15 VARCHAR(3),
  sias_d16 VARCHAR(3),
  sias_d17 VARCHAR(3),
  sias_d18 VARCHAR(3),
  sias_d19 VARCHAR(3),
  sias_d20 VARCHAR(3),
  sias_d21 VARCHAR(3),
  sias_d22 VARCHAR(3),
  sias_d23 VARCHAR(3),
  sias_d24 VARCHAR(3),
  sias_d25 VARCHAR(3),
  sias_d26 VARCHAR(3),
  sias_d27 VARCHAR(3),
  sias_d28 VARCHAR(3),
  sias_d29 VARCHAR(3),
  sias_d30 VARCHAR(3),
  sias_d31 VARCHAR(3),
  sias_token VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_asistencia_out (
  siao_sec NUMERIC,
  sias_sec NUMERIC,
  esad_cod VARCHAR(30),
  esed_sec NUMERIC,
  tien_cod VARCHAR(10),
  grcu_sec NUMERIC,
  grte_cod VARCHAR(10),
  siao_anio_escolar NUMERIC,
  siao_mes_escolar NUMERIC,
  siao_rbd NUMERIC,
  siao_codigo_tipo_ensenanza NUMERIC,
  siao_codigo_grado NUMERIC,
  siao_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  siao_tipo_asistencia VARCHAR(20),
  siao_letra_curso VARCHAR(10),
  siao_numero NUMERIC,
  siao_dv VARCHAR(1),
  siao_semilla VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_asist_tmp (
  sifi_sec NUMERIC,
  esad_cod VARCHAR(30),
  esed_sec NUMERIC,
  tien_cod VARCHAR(10),
  grcu_sec NUMERIC,
  grte_cod VARCHAR(10),
  siat_letra_curso VARCHAR(10),
  siat_anio_escolar NUMERIC,
  siat_mes_escolar NUMERIC,
  siat_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_envia_asist (
  siea_sec NUMERIC,
  sias_sec NUMERIC,
  siea_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  siea_token VARCHAR(200),
  siea_xml TEXT,
  siea_fec_envio TIMESTAMP WITHOUT TIME ZONE,
  siar_usu_ing VARCHAR(30),
  siea_estado VARCHAR(10),
  siea_cod_resp NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_errores (
  sier_tipo VARCHAR(30),
  sier_error NUMERIC,
  sier_desc VARCHAR(200),
  sier_cod_matriz NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_error_envio (
  siea_sec NUMERIC,
  siee_msg_error VARCHAR(4000),
  siee_fec_error TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_estab (
  esad_cod VARCHAR(30),
  esed_sec NUMERIC,
  PRIMARY KEY (esad_cod, esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_filtros (
  sifi_sec NUMERIC,
  esad_cod VARCHAR(30),
  esed_sec VARCHAR(30),
  sifi_anio NUMERIC,
  sifi_mes INTEGER,
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  grcu_sec VARCHAR(10),
  sifi_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  sifi_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  sifi_user_ing VARCHAR(30),
  sifi_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  sifi_estado VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_lock (
  silo_mes NUMERIC,
  silo_fec_limite TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_log_asistencia (
  loas_sec_proc NUMERIC,
  loas_fec_proc TIMESTAMP WITHOUT TIME ZONE,
  esad_cod VARCHAR(30),
  loas_mes_proc NUMERIC,
  loas_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  loas_fec_ter TIMESTAMP WITHOUT TIME ZONE,
  loas_tiempo_total NUMERIC,
  loas_total_reg NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_obs_mov (
  siom_sec NUMERIC,
  siea_sec NUMERIC,
  sias_sec NUMERIC,
  siom_fec_env_xml TIMESTAMP WITHOUT TIME ZONE,
  siom_fec_resp_reporte TIMESTAMP WITHOUT TIME ZONE,
  siom_estado_reporte VARCHAR(10),
  siom_tiempo_total NUMERIC,
  siom_estado VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_parametros (
  sipa_codigo VARCHAR(100),
  sipa_valor VARCHAR(1000),
  sipa_desc VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_semillas (
  sise_client_id NUMERIC,
  sise_conv_id NUMERIC,
  sise_conv_token VARCHAR(100),
  sise_semilla VARCHAR(200),
  sise_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  sise_nro_usos NUMERIC,
  sise_expirado VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sige_times (
  siea_sec NUMERIC,
  siti_fecha_asist TIMESTAMP WITHOUT TIME ZONE,
  siti_estado VARCHAR(10),
  siti_accion VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sistemas (
  sist_cod VARCHAR(10),
  sist_desc VARCHAR(40),
  sist_label VARCHAR(20),
  PRIMARY KEY (sist_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_soli_cambio_notas_det (
  socn_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  scnd_nro_lista INTEGER,
  scnd_estado_alum VARCHAR(30),
  scnd_nota_ant VARCHAR(2),
  scnd_nota_new VARCHAR(2),
  scnd_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  scnd_user_ing VARCHAR(30),
  scnd_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  scnd_user_mod VARCHAR(30),
  alcu_sec NUMERIC(23, 0),
  PRIMARY KEY (socn_sec, fial_sec, alcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_soli_cambio_notas_enc (
  socn_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  socn_observacion VARCHAR(500),
  cuas_sec NUMERIC(23, 0),
  socn_tipo_peri VARCHAR(10),
  socn_nro_nota INTEGER,
  socn_estado VARCHAR(30),
  socn_usuario_val VARCHAR(30),
  socn_codigo_tkn VARCHAR(30),
  socn_cod_tkn_md5 VARCHAR(100),
  tblo_fec_zh_val VARCHAR(100),
  plho_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  plho_user_ing VARCHAR(30),
  plho_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  plho_user_mod VARCHAR(30),
  PRIMARY KEY (socn_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_sucursal_cmds (
  sucm_sec NUMERIC(23, 0),
  sucm_sucursal VARCHAR(60),
  sucm_direccion VARCHAR(100),
  sucm_cnt_modulo INTEGER,
  sucm_min_intervalo INTEGER,
  sucm_bloq_1_ini INTEGER,
  sucm_bloq_1_fin INTEGER,
  sucm_bloq_2_ini INTEGER,
  sucm_bloq_2_fin INTEGER,
  sucm_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  sucm_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  sucm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  sucm_user_ing VARCHAR(30),
  sucm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  sucm_user_mod VARCHAR(30),
  sucm_estado VARCHAR(30),
  PRIMARY KEY (sucm_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_suc_hora_post (
  suhp_sec NUMERIC(23, 0),
  sucm_sec NUMERIC(23, 0),
  suhp_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  suhp_hora_atencion VARCHAR(10),
  suhp_estado VARCHAR(30),
  suhp_fec_solicitud TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (suhp_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_suc_hora_post_202203 (
  suhp_sec NUMERIC(23, 0),
  sucm_sec NUMERIC(23, 0),
  suhp_fec_atencion TIMESTAMP WITHOUT TIME ZONE,
  suhp_hora_atencion VARCHAR(10),
  suhp_estado VARCHAR(30),
  suhp_fec_solicitud TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_telef_pers_estab (
  tpes_sec NUMERIC(23, 0),
  artc_sec NUMERIC(23, 0),
  tpes_tipo_pers VARCHAR(5),
  pers_sec NUMERIC(23, 0),
  tpes_estado VARCHAR(5),
  tpes_fec_entrega TIMESTAMP WITHOUT TIME ZONE,
  tpes_txt_entr VARCHAR(4000),
  tpes_fec_devolucion TIMESTAMP WITHOUT TIME ZONE,
  tpes_txt_devo VARCHAR(4000),
  tpes_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tpes_user_ing VARCHAR(30),
  tpes_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tpes_user_mod VARCHAR(30),
  PRIMARY KEY (tpes_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_temporal_classroom (
  cuas_id_classroom VARCHAR(256),
  tecl_tabla VARCHAR(60),
  tecl_campo1 VARCHAR(256),
  tecl_campo2 VARCHAR(256),
  tecl_campo3 VARCHAR(256),
  tecl_campo4 VARCHAR(256),
  tecl_campo5 VARCHAR(256),
  tecl_campo6 VARCHAR(256),
  tecl_campo7 VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tiempo_sesion (
  pers_sec NUMERIC(23, 0),
  tise_tiempo BIGINT,
  tise_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tise_user_ing VARCHAR(30),
  tise_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tise_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tien_estab (
  esed_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  tees_estado VARCHAR(20),
  tees_nro_aut VARCHAR(20),
  tees_fec_aut TIMESTAMP WITHOUT TIME ZONE,
  tees_jornada_manana VARCHAR(2),
  tees_hrs_ini_manana VARCHAR(10),
  tees_hrs_fin_manana VARCHAR(10),
  tees_jornada_tarde VARCHAR(2),
  tees_hrs_ini_tarde VARCHAR(10),
  tees_hrs_fin_tarde VARCHAR(10),
  tees_jornada_man_tar VARCHAR(2),
  tees_hrs_ini_man_tar VARCHAR(10),
  tees_hrs_fin_man_tar VARCHAR(10),
  tees_jornada_vespert VARCHAR(2),
  tees_hrs_ini_vespert VARCHAR(10),
  tees_hrs_fin_vespert VARCHAR(10),
  tees_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tees_user_ing VARCHAR(30),
  tees_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tees_user_mod VARCHAR(30),
  tees_tipo_eval_final VARCHAR(10),
  tees_dias_clases VARCHAR(2),
  peri_sec NUMERIC(23, 0),
  tees_estado_sige VARCHAR(20),
  PRIMARY KEY (esed_sec, peri_sec, tien_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tipos_bloque (
  tibl_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  tibl_cod VARCHAR(10),
  tibl_desc VARCHAR(60),
  tibl_estado VARCHAR(30),
  tibl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tibl_user_ing VARCHAR(30),
  tibl_eliminar VARCHAR(2),
  tibl_min_bloque INTEGER,
  PRIMARY KEY (tibl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tipo_apps (
  tiap_cod VARCHAR(10),
  tiap_desc VARCHAR(60),
  prfl_cod VARCHAR(20),
  tiap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tiap_user_ing VARCHAR(30),
  PRIMARY KEY (tiap_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tipo_ensenanza (
  tien_cod VARCHAR(10),
  tien_descripcion VARCHAR(200),
  tien_cod_interno VARCHAR(10),
  tien_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tien_user_ing VARCHAR(30),
  tien_tipo_modalidad VARCHAR(10),
  tien_tipo_nivel VARCHAR(10),
  tien_tipo_rama VARCHAR(10),
  PRIMARY KEY (tien_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tipo_ensenanza_tmp (
  tien_cod VARCHAR(10),
  tien_descripcion VARCHAR(200),
  tien_cod_interno VARCHAR(10),
  tien_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tien_user_ing VARCHAR(30),
  tien_tipo_modalidad VARCHAR(10),
  tien_tipo_nivel VARCHAR(10),
  tien_tipo_rama VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tipo_reportes (
  tire_cod VARCHAR(10),
  tire_descripcion VARCHAR(200),
  PRIMARY KEY (tire_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tipo_repo_estab (
  esed_sec NUMERIC(23, 0),
  tire_cod VARCHAR(10),
  tres_firma_1 VARCHAR(1),
  tres_cargo_f1 VARCHAR(15),
  tres_firma_2 VARCHAR(1),
  tres_cargo_f2 VARCHAR(15),
  tres_firma_3 VARCHAR(1),
  tres_cargo_f3 VARCHAR(15),
  tres_firma_4 VARCHAR(1),
  tres_cargo_f4 VARCHAR(15),
  tres_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tres_user_ing VARCHAR(30),
  tres_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tres_user_mod VARCHAR(30),
  PRIMARY KEY (esed_sec, tire_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_tire_esed_portal (
  tepo_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  tire_cod VARCHAR(10),
  tepo_ver_portal VARCHAR(1),
  tepo_ver_movil VARCHAR(1),
  tepo_dias_vig INTEGER,
  tepo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tepo_user_ing VARCHAR(30),
  tepo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tepo_user_mod VARCHAR(30),
  tepo_ver_pie_pag VARCHAR(1),
  PRIMARY KEY (tepo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asbl (
  cuas_sec NUMERIC(23, 0),
  toab_nro_bloque INTEGER,
  toab_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  toab_rut_usuario VARCHAR(15),
  toab_codigo_tkn VARCHAR(30),
  toab_fec_zh VARCHAR(100),
  toab_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  toab_user_ing VARCHAR(30),
  toab_estado_token VARCHAR(10),
  toab_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  toab_user_mod VARCHAR(30),
  PRIMARY KEY (cuas_sec, toab_nro_bloque, toab_fec_asistencia, toab_rut_usuario)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asbl_log (
  cuas_sec NUMERIC(23, 0),
  tblo_nro_bloque INTEGER,
  tblo_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  tblo_rut_usuario VARCHAR(15),
  tblo_codigo_tkn VARCHAR(30),
  tblo_fec_zh VARCHAR(100),
  tblo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tblo_user_ing VARCHAR(30),
  tblo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tblo_user_mod VARCHAR(30),
  tblo_estado_token VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asdi (
  cuas_sec NUMERIC(23, 0),
  toad_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  toad_rut_usuario VARCHAR(15),
  toad_codigo_tkn VARCHAR(30),
  toad_fec_zh VARCHAR(100),
  toad_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  toad_user_ing VARCHAR(30),
  toad_estado_token VARCHAR(10),
  toad_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  toad_user_mod VARCHAR(30),
  PRIMARY KEY (cuas_sec, toad_fec_asistencia, toad_rut_usuario)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asdi_log (
  cuas_sec NUMERIC(23, 0),
  tdlo_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  tdlo_rut_usuario VARCHAR(15),
  tdlo_codigo_tkn VARCHAR(30),
  tdlo_fec_zh VARCHAR(100),
  tdlo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tdlo_user_ing VARCHAR(30),
  tdlo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tdlo_user_mod VARCHAR(30),
  tdlo_estado_token VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asig_electiva (
  gael_sec NUMERIC(23, 0),
  tael_nro_bloque INTEGER,
  tael_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  tael_rut_usuario VARCHAR(15),
  tael_codigo_tkn VARCHAR(30),
  tael_fec_zh VARCHAR(100),
  tael_estado_token VARCHAR(10),
  tael_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tael_user_ing VARCHAR(30),
  tael_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tael_user_mod VARCHAR(30),
  PRIMARY KEY (gael_sec, tael_nro_bloque, tael_fec_asistencia)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asig_electiva_log (
  gael_sec NUMERIC(23, 0),
  tell_nro_bloque INTEGER,
  tell_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  tell_rut_usuario VARCHAR(15),
  tell_codigo_tkn VARCHAR(30),
  tell_fec_zh VARCHAR(100),
  tell_estado_token VARCHAR(10),
  tell_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tell_user_ing VARCHAR(30),
  tell_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tell_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asist_post (
  apen_sec NUMERIC(23, 0),
  tapo_rut_usuario VARCHAR(15),
  tapo_codigo_tkn VARCHAR(30),
  tapo_fec_zh VARCHAR(100),
  tapo_estado_token VARCHAR(10),
  tapo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tapo_user_ing VARCHAR(30),
  tapo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tapo_user_mod VARCHAR(30),
  PRIMARY KEY (apen_sec, tapo_rut_usuario)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_asist_post_log (
  apen_sec NUMERIC(23, 0),
  tapl_rut_usuario VARCHAR(15),
  tapl_codigo_tkn VARCHAR(30),
  tapl_fec_zh VARCHAR(100),
  tapl_estado_token VARCHAR(10),
  tapl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tapl_user_ing VARCHAR(30),
  tapl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tapl_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_atrasos_alum (
  atal_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  toaa_fecha_atraso TIMESTAMP WITHOUT TIME ZONE,
  toaa_rut_usuario VARCHAR(15),
  toaa_codigo_tkn VARCHAR(30),
  toaa_fec_zh VARCHAR(100),
  toaa_estado_token VARCHAR(10),
  toaa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  toaa_user_ing VARCHAR(30),
  PRIMARY KEY (atal_sec, grcu_sec, fial_sec, alcu_sec, toaa_fecha_atraso)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_atrasos_alum_log (
  atal_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  alcu_sec NUMERIC(23, 0),
  taal_fecha_atraso TIMESTAMP WITHOUT TIME ZONE,
  taal_rut_usuario VARCHAR(15),
  taal_codigo_tkn VARCHAR(30),
  taal_fec_zh VARCHAR(100),
  taal_estado_token VARCHAR(10),
  taal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  taal_user_ing VARCHAR(30),
  taal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  taal_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_grcu_docto (
  grcu_sec NUMERIC(23, 0),
  tgdo_fecha TIMESTAMP WITHOUT TIME ZONE,
  tgdo_rut_usuario VARCHAR(15),
  tgdo_codigo_tkn VARCHAR(30),
  tgdo_fec_zh VARCHAR(100),
  tgdo_estado_token VARCHAR(10),
  tgdo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tgdo_user_ing VARCHAR(30),
  PRIMARY KEY (grcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_grcu_docto_log (
  grcu_sec NUMERIC(23, 0),
  tgdl_fecha TIMESTAMP WITHOUT TIME ZONE,
  tgdl_rut_usuario VARCHAR(15),
  tgdl_codigo_tkn VARCHAR(30),
  tgdl_fec_zh VARCHAR(100),
  tgdl_estado_token VARCHAR(10),
  tgdl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tgdl_user_ing VARCHAR(30),
  tgdl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tgdl_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_leccionario (
  leas_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  tolc_fecha TIMESTAMP WITHOUT TIME ZONE,
  tolc_rut_usuario VARCHAR(15),
  tolc_codigo_tkn VARCHAR(30),
  tolc_fec_zh VARCHAR(100),
  tolc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tolc_user_ing VARCHAR(30),
  tolc_estado_token VARCHAR(10),
  PRIMARY KEY (leas_sec, cuas_sec, tolc_fecha, tolc_rut_usuario)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_leccionario_log (
  leas_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  tllo_fecha TIMESTAMP WITHOUT TIME ZONE,
  tllo_rut_usuario VARCHAR(15),
  tllo_codigo_tkn VARCHAR(30),
  tllo_fec_zh VARCHAR(100),
  tllo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tllo_user_ing VARCHAR(30),
  tllo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tllo_user_mod VARCHAR(30),
  tllo_estado_token VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_leccion_parv (
  lepa_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tlpa_fecha TIMESTAMP WITHOUT TIME ZONE,
  tlpa_rut_usuario VARCHAR(15),
  tlpa_codigo_tkn VARCHAR(30),
  tlpa_fec_zh VARCHAR(100),
  tlpa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tlpa_user_ing VARCHAR(30),
  tlpa_estado_token VARCHAR(10),
  PRIMARY KEY (lepa_sec, grcu_sec, tlpa_fecha, tlpa_rut_usuario)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_leccion_parv_log (
  lepa_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tlpl_fecha TIMESTAMP WITHOUT TIME ZONE,
  tlpl_rut_usuario VARCHAR(15),
  tlpl_codigo_tkn VARCHAR(30),
  tlpl_fec_zh VARCHAR(100),
  tlpl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tlpl_user_ing VARCHAR(30),
  tlpl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tlpl_user_mod VARCHAR(30),
  tlpl_estado_token VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_modulo_tel (
  mtel_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tmte_fecha TIMESTAMP WITHOUT TIME ZONE,
  tmte_rut_usuario VARCHAR(15),
  tmte_codigo_tkn VARCHAR(30),
  tmte_fec_zh VARCHAR(100),
  tmte_estado_token VARCHAR(10),
  tmte_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tmte_user_ing VARCHAR(30),
  PRIMARY KEY (mtel_sec, grcu_sec, tmte_fecha, tmte_rut_usuario)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_modulo_tel_log (
  mtel_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tmtl_fecha TIMESTAMP WITHOUT TIME ZONE,
  tmtl_rut_usuario VARCHAR(15),
  tmtl_codigo_tkn VARCHAR(30),
  tmtl_fec_zh VARCHAR(100),
  tmtl_estado_token VARCHAR(10),
  tmtl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tmtl_user_ing VARCHAR(30),
  tmtl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tmtl_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_socn (
  socn_sec NUMERIC(23, 0),
  tscn_rut_usuario VARCHAR(15),
  tscn_codigo_tkn VARCHAR(30),
  tscn_fec_zh VARCHAR(100),
  tscn_estado_token VARCHAR(10),
  tscn_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tscn_user_ing VARCHAR(30),
  tscn_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tscn_user_mod VARCHAR(30),
  PRIMARY KEY (socn_sec, tscn_rut_usuario)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_token_socn_log (
  socn_sec NUMERIC(23, 0),
  tcnl_rut_usuario VARCHAR(15),
  tcnl_codigo_tkn VARCHAR(30),
  tcnl_fec_zh VARCHAR(100),
  tcnl_estado_token VARCHAR(10),
  tcnl_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tcnl_user_ing VARCHAR(30),
  tcnl_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tcnl_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__01 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__02 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__03 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__04 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__05 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__06 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__07 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__08 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__09 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__10 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__11 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_trace_aplic_log__12 (
  tral_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  usua_usuarios BIGINT,
  tral_user_oracle VARCHAR(30),
  tral_fecha TIMESTAMP WITHOUT TIME ZONE,
  tral_tipo_oper VARCHAR(30),
  apli_link VARCHAR(500),
  tral_nivel_usuario VARCHAR(60),
  tral_nro_ip VARCHAR(60),
  PRIMARY KEY (tral_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usuarios (
  usua_usuarios BIGINT,
  usua_clave VARCHAR(256),
  usua_es_nuevo VARCHAR(1),
  usua_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pers_sec NUMERIC(23, 0),
  usua_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  usua_user_mod VARCHAR(30),
  PRIMARY KEY (usua_usuarios)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usuarios_eventos (
  even_sec NUMERIC(23, 0),
  usev_usuario BIGINT,
  usev_tipo_usua VARCHAR(5),
  usev_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  usev_user_ing VARCHAR(30),
  usev_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  usev_user_mod VARCHAR(30),
  PRIMARY KEY (even_sec, usev_usuario, usev_tipo_usua)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usuarios_portal (
  uspo_usuarios BIGINT,
  uspo_clave VARCHAR(256),
  uspo_es_nuevo VARCHAR(1),
  uspo_bloqueo VARCHAR(1),
  uspo_tipo_usua VARCHAR(5),
  pers_sec NUMERIC(23, 0),
  uspo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  uspo_user_ing VARCHAR(30),
  uspo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  uspo_user_mod VARCHAR(30),
  PRIMARY KEY (uspo_usuarios, uspo_tipo_usua)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usuarios_sae (
  ussa_usuarios BIGINT,
  ussa_clave VARCHAR(256),
  ussa_es_nuevo VARCHAR(1),
  ussa_bloqueo VARCHAR(1),
  pers_sec NUMERIC(23, 0),
  ussa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ussa_user_ing VARCHAR(30),
  ussa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ussa_user_mod VARCHAR(30),
  PRIMARY KEY (ussa_usuarios)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usua_apli (
  usua_usuarios BIGINT,
  apli_cod VARCHAR(50),
  esed_sec NUMERIC(23, 0),
  usap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  usap_user_ing VARCHAR(30),
  usap_guardar VARCHAR(1),
  usap_editar VARCHAR(1),
  usap_eliminar VARCHAR(1),
  usap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  usap_user_mod VARCHAR(30),
  PRIMARY KEY (usua_usuarios, apli_cod, esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usua_estab (
  usua_usuarios BIGINT,
  esed_sec NUMERIC(23, 0),
  uses_bloqueo VARCHAR(1),
  uses_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  uses_user_ing VARCHAR(30),
  uses_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  uses_user_mod VARCHAR(30),
  PRIMARY KEY (usua_usuarios, esed_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usua_estab_apps (
  usua_usuarios BIGINT,
  esed_sec NUMERIC(23, 0),
  tiap_cod VARCHAR(10),
  ueap_bloqueo VARCHAR(1),
  ueap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ueap_user_ing VARCHAR(30),
  ueap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ueap_user_mod VARCHAR(30),
  ueap_usua_sost VARCHAR(2),
  PRIMARY KEY (usua_usuarios, esed_sec, tiap_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.edc_usua_perfil (
  usua_usuarios BIGINT,
  prfl_sec NUMERIC(23, 0),
  uspe_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  uspe_user_ing VARCHAR(30),
  PRIMARY KEY (usua_usuarios, prfl_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.jcc_alum_mal_matric (
  maal_sec NUMERIC(23, 0),
  esed_sec_mat NUMERIC(23, 0),
  esed_sec_fic NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  fial_sec_new NUMERIC,
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  maal_fec_matri TIMESTAMP WITHOUT TIME ZONE,
  maal_nro_matri NUMERIC(23, 0),
  maal_estado VARCHAR(30),
  maal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  maal_user_ing VARCHAR(30),
  maal_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  maal_user_mod VARCHAR(30),
  maal_letra_dest VARCHAR(2),
  mail_fing_curso TIMESTAMP WITHOUT TIME ZONE,
  tien_cod_orig VARCHAR(10),
  grte_cod_orig VARCHAR(10),
  maal_letra_orig VARCHAR(2),
  pers_sec_alum NUMERIC(23, 0),
  maal_rut_alum BIGINT,
  maal_dv_alum VARCHAR(1),
  maal_nom_alum VARCHAR(100),
  maal_apat_alum VARCHAR(60),
  maal_amat_alum VARCHAR(60),
  maal_fec_nac_alum TIMESTAMP WITHOUT TIME ZONE,
  maal_genero_alum VARCHAR(2),
  maal_cod_etnia VARCHAR(15),
  pais_cod_alum VARCHAR(20),
  maal_direc_alum VARCHAR(200),
  regi_cod_alum VARCHAR(10),
  comu_cod_alum VARCHAR(10),
  maal_cel_alum VARCHAR(15),
  maal_email_alum VARCHAR(60),
  maal_es_nuevo VARCHAR(2),
  pers_sec_apod NUMERIC(23, 0),
  maal_rut_apod BIGINT,
  maal_dv_apod VARCHAR(1),
  maal_nom_apod VARCHAR(100),
  maal_apat_apod VARCHAR(60),
  maal_amat_apod VARCHAR(60),
  maal_fec_nac_apod TIMESTAMP WITHOUT TIME ZONE,
  maal_genero_apod VARCHAR(2),
  pais_cod_apod VARCHAR(20),
  maal_direc_apod VARCHAR(200),
  regi_cod_apod VARCHAR(10),
  comu_cod_apod VARCHAR(10),
  maal_cel_apod VARCHAR(15),
  maal_email_apod VARCHAR(60),
  maal_esta_proc_fin VARCHAR(2),
  maal_pasaporte_dni_alum VARCHAR(60),
  maal_pasaporte_dni_apod VARCHAR(60),
  maal_parentesco_apod VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS adm_educa.jdbc_store_email (
  indexid NUMERIC(23, 0),
  msg_id VARCHAR(200),
  message BYTEA,
  PRIMARY KEY (indexid)
);

CREATE TABLE IF NOT EXISTS adm_educa.jdbc_store_push (
  indexid NUMERIC(23, 0),
  msg_id VARCHAR(200),
  message BYTEA,
  PRIMARY KEY (indexid)
);

CREATE TABLE IF NOT EXISTS adm_educa.jdbc_store_sms (
  indexid NUMERIC(23, 0),
  msg_id VARCHAR(200),
  message BYTEA,
  PRIMARY KEY (indexid)
);

CREATE TABLE IF NOT EXISTS adm_educa.jph (
  nacu_nro_lista VARCHAR(20),
  nom_alum VARCHAR(100),
  rut_alum VARCHAR(15),
  pers_genero VARCHAR(10),
  pers_fec_nac VARCHAR(20),
  asig_1 VARCHAR(250),
  asig_2 VARCHAR(250),
  asig_3 VARCHAR(250),
  asig_4 VARCHAR(250),
  asig_5 VARCHAR(250),
  asig_6 VARCHAR(250),
  asig_7 VARCHAR(250),
  asig_8 VARCHAR(250),
  asig_9 VARCHAR(250),
  asig_10 VARCHAR(250),
  asig_11 VARCHAR(250),
  asig_12 VARCHAR(250),
  asig_13 VARCHAR(250),
  asig_14 VARCHAR(250),
  asig_15 VARCHAR(250),
  asig_16 VARCHAR(250),
  asig_17 VARCHAR(250),
  asig_18 VARCHAR(250),
  asig_19 VARCHAR(250),
  asig_20 VARCHAR(250),
  asig_21 VARCHAR(250),
  asig_22 VARCHAR(250),
  asig_23 VARCHAR(250),
  asig_24 VARCHAR(250),
  asig_25 VARCHAR(250),
  nacu_prom_final VARCHAR(20),
  porc_asist VARCHAR(20),
  situacion_final VARCHAR(20),
  observaciones VARCHAR(250),
  esed_sec NUMERIC(20, 0),
  grcu_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.lcs_decretos_mod (
  cod_decreto VARCHAR(10),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  asig_cod VARCHAR(20),
  horas NUMERIC(5, 2),
  es_obligatorio VARCHAR(2),
  formacion VARCHAR(100),
  orden_asig INTEGER
);

CREATE TABLE IF NOT EXISTS adm_educa.pdir_ab_tmp (
  cuas_sec NUMERIC,
  asbl_nro_bloque NUMERIC,
  asbl_fec_asistencia TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_educa.pdir_proc_res_1 (
  prre_sec_proc NUMERIC,
  prre_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  prre_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  prre_tiempo NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.pdir_proc_res_2 (
  prre_sec_proc NUMERIC,
  prre_tipo_proc VARCHAR(50),
  prre_ee_cod NUMERIC,
  prre_fec_res TIMESTAMP WITHOUT TIME ZONE,
  prre_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  prre_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  prre_tiempo NUMERIC,
  prre_regs_asdl_lecc NUMERIC,
  prre_regs_asdi_lepa NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.pdir_resumen_estado_asbl (
  reab_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  reab_nro_bloque INTEGER,
  reab_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  reab_estado VARCHAR(15),
  gael_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_educa.pdir_resumen_estado_asdi (
  read_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  read_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  read_estado VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS adm_educa.pdir_resumen_estado_lecc (
  reel_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  leas_sec NUMERIC(23, 0),
  reel_nro_cont NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  reel_fecha TIMESTAMP WITHOUT TIME ZONE,
  reel_estado VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS adm_educa.pdir_resumen_estado_lepa (
  reel_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  lepa_sec NUMERIC(23, 0),
  reel_nro_cont NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  reel_fecha TIMESTAMP WITHOUT TIME ZONE,
  reel_estado VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_acciones_imple (
  acim_sec NUMERIC,
  recu_sec NUMERIC,
  acim_profes TEXT,
  acim_profes_asist TEXT,
  acim_estudiantes TEXT,
  acim_familia TEXT,
  acim_comunidad TEXT,
  acim_obs TEXT,
  acim_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  acim_user_ing VARCHAR(30),
  acim_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  acim_user_mod VARCHAR(30),
  PRIMARY KEY (acim_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_acta_reunion (
  acre_sec NUMERIC,
  coea_sec NUMERIC,
  acre_motivo VARCHAR(4000),
  acre_acuerdos TEXT,
  acre_compromisos TEXT,
  acre_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  acre_user_ing VARCHAR(30),
  acre_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  acre_user_mod VARCHAR(30),
  PRIMARY KEY (acre_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_app_eval_estrategias (
  aees_sec NUMERIC,
  escu_sec NUMERIC,
  aees_periodos VARCHAR(50),
  aees_acciones TEXT,
  aees_evaluacion TEXT,
  aees_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  aess_user_ing VARCHAR(30),
  aees_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  aees_user_mod VARCHAR(30),
  PRIMARY KEY (aees_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_coord_equip_aula (
  coea_sec NUMERIC,
  esed_sec NUMERIC,
  peri_sec NUMERIC,
  recu_sec NUMERIC,
  coea_fecha TIMESTAMP WITHOUT TIME ZONE,
  coea_titulo VARCHAR(4000),
  coea_acuerdos TEXT,
  coea_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  coea_user_ing VARCHAR(30),
  coea_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  coea_user_mod VARCHAR(30),
  PRIMARY KEY (coea_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_dom_checks (
  doch_id NUMERIC,
  doop_id NUMERIC,
  doch_titulo VARCHAR(200),
  doch_orden NUMERIC,
  PRIMARY KEY (doch_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_dom_necesidad (
  dmne_tipo VARCHAR(20),
  dmne_nombre VARCHAR(100),
  dmne_orden NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_dom_options (
  doop_id NUMERIC,
  doop_tipo VARCHAR(100),
  doop_titulo VARCHAR(1000),
  doop_orden INTEGER,
  doop_tabla VARCHAR(500),
  PRIMARY KEY (doop_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_empresa_org (
  emor_sec NUMERIC,
  esed_sec NUMERIC,
  peri_sec NUMERIC,
  emor_nombre VARCHAR(100),
  emor_estado VARCHAR(50),
  emor_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  emor_user_ing VARCHAR(30),
  emor_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  emor_user_mod VARCHAR(30),
  PRIMARY KEY (emor_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_equi_aula (
  eqau_sec NUMERIC,
  recu_sec NUMERIC,
  equa_tipo_prof VARCHAR(1),
  eqau_prof_educa_sec NUMERIC,
  prpi_sec NUMERIC,
  eqau_contexto_aula VARCHAR(30),
  eqau_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  eqau_user_ing VARCHAR(30),
  eqau_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  eqau_user_mod VARCHAR(100),
  PRIMARY KEY (eqau_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_especialidad (
  espe_sec NUMERIC,
  esed_sec NUMERIC,
  peri_sec NUMERIC,
  espe_cod VARCHAR(100),
  espe_desc VARCHAR(1000),
  espe_estado VARCHAR(100),
  espe_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  espe_user_ing VARCHAR(30),
  espe_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  espe_user_mod VARCHAR(40),
  PRIMARY KEY (espe_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_estrategia_curso (
  escu_sec NUMERIC,
  recu_sec NUMERIC,
  escu_estrategia TEXT,
  escu_ambito TEXT,
  escu_periodo TEXT,
  escu_criterio TEXT,
  escu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  escu_user_ing VARCHAR(30),
  escu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  escu_user_mod VARCHAR(30),
  PRIMARY KEY (escu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_flex_cur (
  esfc_sec NUMERIC,
  recu_sec NUMERIC,
  doop_tipo VARCHAR(100),
  doop_id NUMERIC,
  esfc_prin_estrategia TEXT,
  esfc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  esfc_user_ing VARCHAR(30),
  esfc_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  esfc_user_mod VARCHAR(30),
  PRIMARY KEY (esfc_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_flex_cur_asig (
  esfc_sec NUMERIC,
  cuas_sec NUMERIC,
  PRIMARY KEY (esfc_sec, cuas_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_participacion (
  espa_sec NUMERIC,
  recu_sec NUMERIC,
  doop_tipo VARCHAR(100),
  doop_id NUMERIC,
  espa_otros VARCHAR(1000),
  espa_desc TEXT,
  espa_seguimiento TEXT,
  espa_evaluacion TEXT,
  espa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  espa_user_ing VARCHAR(30),
  espa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  espa_user_mod VARCHAR(30),
  PRIMARY KEY (espa_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_participacion_obs (
  espo_sec NUMERIC,
  recu_sec NUMERIC,
  espo_obs TEXT,
  espo_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  espo_user_ins VARCHAR(30),
  espo_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  espo_user_mod VARCHAR(30),
  PRIMARY KEY (espo_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_personas (
  etpe_tipo VARCHAR(20),
  etpe_sec_id NUMERIC,
  alcu_sec NUMERIC,
  PRIMARY KEY (etpe_tipo, etpe_sec_id, alcu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_proc_eva_a (
  epea_sec NUMERIC,
  recu_sec NUMERIC,
  doop_tipo VARCHAR(100),
  doop_id NUMERIC,
  epea_estrat_proc TEXT,
  epea_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  epea_user_ing VARCHAR(30),
  epea_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  epea_user_mod VARCHAR(30),
  PRIMARY KEY (epea_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_proc_eva_b (
  epeb_sec NUMERIC,
  recu_sec NUMERIC,
  epeb_observaciones TEXT,
  epeb_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  epeb_user_ing VARCHAR(30),
  epeb_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  epeb_user_mod VARCHAR(30),
  PRIMARY KEY (epeb_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_resp_dive_a (
  erda_sec NUMERIC,
  recu_sec NUMERIC,
  doop_tipo VARCHAR(100),
  doop_id NUMERIC,
  erda_otro TEXT,
  erda_como TEXT,
  erda_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  erda_user_ing VARCHAR(30),
  erda_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  erda_user_mod VARCHAR(30),
  PRIMARY KEY (erda_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_resp_dive_a_det (
  erda_sec NUMERIC,
  doch_id NUMERIC,
  PRIMARY KEY (erda_sec, doch_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_resp_dive_b (
  erdb_sec NUMERIC,
  recu_sec NUMERIC,
  doop_tipo VARCHAR(100),
  doop_id NUMERIC,
  erdb_otro TEXT,
  erdb_como TEXT,
  erdb_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  erdb_user_ing VARCHAR(30),
  erdb_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  erdb_user_mod VARCHAR(30),
  PRIMARY KEY (erdb_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_resp_dive_c (
  erdc_sec NUMERIC,
  recu_sec NUMERIC,
  erdc_para VARCHAR(4000),
  erdc_como TEXT,
  erdc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  erdc_user_ing VARCHAR(30),
  erdc_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  erdc_user_mod VARCHAR(30),
  PRIMARY KEY (erdc_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_est_resp_dive_d (
  erdd_sec NUMERIC,
  recu_sec NUMERIC,
  erdd_observacion TEXT,
  erdd_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  erdd_user_ing VARCHAR(30),
  erdd_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  erdd_user_mod VARCHAR(30),
  PRIMARY KEY (erdd_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_imagenes_app (
  imap_cod VARCHAR(30),
  imap_base64 TEXT,
  PRIMARY KEY (imap_cod)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_ins_dom_nece (
  esed_sec NUMERIC,
  peri_sec NUMERIC,
  PRIMARY KEY (esed_sec, peri_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_nece_estab (
  nees_sec NUMERIC,
  esed_sec NUMERIC,
  peri_sec NUMERIC,
  nees_tipo VARCHAR(100),
  nees_descripcion VARCHAR(4000),
  nees_contexto VARCHAR(30),
  nees_asociada VARCHAR(100),
  nees_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  nees_user_ing VARCHAR(30),
  nees_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  nees_user_mod VARCHAR(30),
  PRIMARY KEY (nees_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_organizacion_apoyo (
  orap_sec NUMERIC,
  recu_sec NUMERIC,
  orap_ambito VARCHAR(100),
  orap_hrs_aula NUMERIC,
  orap_hrs_fuera_aula NUMERIC,
  orap_tipos_apoyo TEXT,
  orap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  orap_user_ing VARCHAR(30),
  orap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  orap_user_mod VARCHAR(30),
  PRIMARY KEY (orap_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_panorama_curso (
  pacu_sec NUMERIC,
  recu_sec NUMERIC,
  pacu_estilo_modo TEXT,
  pacu_fortaleza TEXT,
  pacu_necesidad TEXT,
  pacu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  pacu_user_ing VARCHAR(30),
  pacu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pacu_user_mod VARCHAR(30),
  PRIMARY KEY (pacu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_participante_acta (
  paac_sec NUMERIC,
  acre_sec NUMERIC,
  tipo_func VARCHAR(30),
  identif_func NUMERIC,
  paac_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  paac_user_ing VARCHAR(30),
  PRIMARY KEY (paac_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_plan_apoyo_dias (
  plad_sec NUMERIC,
  plai_sec NUMERIC,
  plad_dia_sem VARCHAR(20),
  plad_hra_ini VARCHAR(5),
  plad_hra_ter VARCHAR(5),
  plad_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  plad_user_ing VARCHAR(30),
  plad_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  plad_user_mod VARCHAR(30),
  PRIMARY KEY (plad_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_plan_apoyo_indiv (
  plai_sec NUMERIC,
  plar_sec NUMERIC,
  espe_sec NUMERIC,
  paai_perm_ini TIMESTAMP WITHOUT TIME ZONE,
  plai_perm_ter TIMESTAMP WITHOUT TIME ZONE,
  plai_otros VARCHAR(1000),
  plai_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  plai_user_ins VARCHAR(30),
  plai_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  plau_user_mod VARCHAR(30),
  PRIMARY KEY (plai_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_plan_apoyo_recu (
  plar_sec NUMERIC,
  recu_sec NUMERIC,
  plar_obs TEXT,
  plar_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  plar_user_ing VARCHAR(30),
  plar_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  plar_user_mod VARCHAR(30),
  PRIMARY KEY (plar_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_profesionales_pie (
  prpi_sec NUMERIC,
  prpi_prof_educa VARCHAR(1),
  esed_sec NUMERIC,
  prpi_prof_educa_sec NUMERIC,
  prpi_tipo_prof VARCHAR(50),
  prpi_rut NUMERIC,
  prpi_dv VARCHAR(1),
  prpi_nivel VARCHAR(100),
  prpi_profesional VARCHAR(300),
  prpi_telefono VARCHAR(100),
  prpi_mail VARCHAR(100),
  prpi_estado VARCHAR(30),
  prpi_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prpi_user_ing VARCHAR(30),
  prpi_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  prpi_user_mod VARCHAR(30),
  PRIMARY KEY (prpi_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_profesional_espe (
  pres_sec NUMERIC,
  prpi_sec NUMERIC,
  espe_sec NUMERIC,
  PRIMARY KEY (pres_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_registro_acciones_obs (
  reao_sec NUMERIC,
  recu_sec NUMERIC,
  reoa_obs TEXT,
  reoa_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  reoa_user_ins VARCHAR(30),
  reoa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reoa_user_mod VARCHAR(30),
  PRIMARY KEY (reao_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_registro_acciones_prof (
  reap_sec NUMERIC,
  recu_sec NUMERIC,
  reap_fecha TIMESTAMP WITHOUT TIME ZONE,
  reap_horas NUMERIC,
  reap_actividades TEXT,
  reap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  reap_user_ing VARCHAR(30),
  reap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reap_user_mod VARCHAR(30),
  PRIMARY KEY (reap_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_registro_reunion (
  rere_sec NUMERIC,
  coea_sec NUMERIC,
  tipo_func VARCHAR(30),
  identif_func NUMERIC,
  rere_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  rere_user_ing VARCHAR(30),
  rere_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  rere_user_mod VARCHAR(30),
  PRIMARY KEY (rere_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_reg_apoyo_est (
  prae_sec NUMERIC,
  recu_sec NUMERIC,
  prae_objetivos TEXT,
  prae_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  prae_user_ins VARCHAR(30),
  prae_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  prae_user_mod VARCHAR(30),
  PRIMARY KEY (prae_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_reg_apoyo_est_det (
  prad_sec NUMERIC,
  prae_sec NUMERIC,
  prad_fec_act TIMESTAMP WITHOUT TIME ZONE,
  prad_hrs_pedagogicas NUMERIC,
  prad_lugar VARCHAR(4000),
  prad_actividades TEXT,
  prad_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prad_user_ing VARCHAR(30),
  prad_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  prad_user_mod VARCHAR(30),
  PRIMARY KEY (prad_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_reg_cursos (
  recu_sec NUMERIC,
  grcu_sec NUMERIC,
  recu_estado VARCHAR(30),
  recu_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  recu_user_ing VARCHAR(30),
  recu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  recu_user_mod VARCHAR(30),
  PRIMARY KEY (recu_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_reg_logro_aprend (
  rela_sec NUMERIC,
  recu_sec NUMERIC,
  rela_logros TEXT,
  rela_comentarios TEXT,
  rela_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  rela_user_ins VARCHAR(30),
  rela_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  rela_user_mod VARCHAR(30),
  PRIMARY KEY (rela_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_com_ent (
  trce_sec NUMERIC,
  tced_tipo VARCHAR(30),
  tced_sec_id NUMERIC,
  tkce_rut_usuario VARCHAR(30),
  tkce_codigo_tkn VARCHAR(1000),
  tkce_fec_zh VARCHAR(100),
  tkce_estado_token VARCHAR(100),
  tkce_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkce_user_ing VARCHAR(300),
  PRIMARY KEY (trce_sec, tced_tipo, tced_sec_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_com_ent_log (
  trce_sec NUMERIC,
  tced_tipo VARCHAR(30),
  tced_sec_id NUMERIC,
  tkce_rut_usuario VARCHAR(30),
  tkce_codigo_tkn VARCHAR(1000),
  tkce_fec_zh VARCHAR(100),
  tkce_estado_token VARCHAR(100),
  tkce_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkce_user_ing VARCHAR(300),
  tkce_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tkce_user_mod VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_equi_aula (
  eqau_sec NUMERIC,
  tkea_rut_usuario VARCHAR(30),
  tkea_codigo_tkn VARCHAR(1000),
  tkea_fec_zh VARCHAR(100),
  tkea_estado_token VARCHAR(100),
  tkea_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkea_user_ing VARCHAR(300),
  PRIMARY KEY (eqau_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_equi_aula_log (
  eqau_sec NUMERIC,
  tkea_rut_usuario VARCHAR(30),
  tkea_codigo_tkn VARCHAR(1000),
  tkea_fec_zh VARCHAR(100),
  tkea_estado_token VARCHAR(100),
  tkea_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkea_user_ing VARCHAR(300),
  tkea_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tkea_user_mod VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_fam_apo (
  trfa_sec NUMERIC,
  tfad_tipo VARCHAR(30),
  tfad_sec_id NUMERIC,
  tkfa_rut_usuario VARCHAR(30),
  tkfa_codigo_tkn VARCHAR(1000),
  tkfa_fec_zh VARCHAR(100),
  tkfa_estado_token VARCHAR(100),
  tkfa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkfa_user_ing VARCHAR(300),
  PRIMARY KEY (trfa_sec, tfad_tipo, tfad_sec_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_fam_apo_log (
  trfa_sec NUMERIC,
  tfad_tipo VARCHAR(30),
  tfad_sec_id NUMERIC,
  tkfa_rut_usuario VARCHAR(30),
  tkfa_codigo_tkn VARCHAR(1000),
  tkfa_fec_zh VARCHAR(100),
  tkfa_estado_token VARCHAR(100),
  tkfa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkfa_user_ing VARCHAR(300),
  tkfa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tkfa_user_mod VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_part_acta (
  paac_sec NUMERIC,
  tkpa_tipo_fun VARCHAR(30),
  tkpa_identif_func NUMERIC,
  tkpa_rut_usuario VARCHAR(30),
  tkpa_codigo_tkn VARCHAR(1000),
  tkpa_fec_zh VARCHAR(100),
  tkpa_estado_token VARCHAR(100),
  tkpa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkpa_user_ing VARCHAR(300),
  PRIMARY KEY (paac_sec, tkpa_tipo_fun, tkpa_identif_func)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_part_acta_log (
  paac_sec NUMERIC,
  tkpa_tipo_fun VARCHAR(30),
  tkpa_identif_func NUMERIC,
  tkpa_rut_usuario VARCHAR(30),
  tkpa_codigo_tkn VARCHAR(1000),
  tkpa_fec_zh VARCHAR(100),
  tkpa_estado_token VARCHAR(100),
  tkpa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  tkpa_user_ing VARCHAR(300),
  tkpa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tkpa_user_mod VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_reg_acc_prof (
  reap_sec NUMERIC,
  trap_rut_usuario VARCHAR(30),
  trap_codigo_tkn VARCHAR(1000),
  trap_fec_zh VARCHAR(100),
  trap_estado_token VARCHAR(100),
  trap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  trap_user_ing VARCHAR(300),
  PRIMARY KEY (reap_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_reg_acc_prof_log (
  reap_sec NUMERIC,
  trap_rut_usuario VARCHAR(30),
  trap_codigo_tkn VARCHAR(1000),
  trap_fec_zh VARCHAR(100),
  trap_estado_token VARCHAR(100),
  trap_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  trap_user_ing VARCHAR(300),
  trap_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  trap_user_mod VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_reg_apoyo_est (
  prad_sec NUMERIC,
  trae_rut_usuario VARCHAR(30),
  trae_codigo_tkn VARCHAR(1000),
  trae_fec_zh VARCHAR(100),
  trae_estado_token VARCHAR(100),
  trae_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  trae_user_ing VARCHAR(300),
  PRIMARY KEY (prad_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_token_reg_apoyo_est_log (
  prad_sec NUMERIC,
  trae_rut_usuario VARCHAR(30),
  trae_codigo_tkn VARCHAR(1000),
  trae_fec_zh VARCHAR(100),
  trae_estado_token VARCHAR(100),
  trae_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  trae_user_ing VARCHAR(300),
  trae_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  trae_user_mod VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_trabajo_com_ent (
  trce_sec NUMERIC,
  recu_sec NUMERIC,
  trce_fecha TIMESTAMP WITHOUT TIME ZONE,
  trce_objetivo TEXT,
  trce_actividad TEXT,
  trce_acuerdos TEXT,
  trce_resultados TEXT,
  trce_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  trce_user_ing VARCHAR(30),
  trce_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  trce_user_mod VARCHAR(30),
  PRIMARY KEY (trce_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_trabajo_com_ent_det (
  trce_sec NUMERIC,
  tced_tipo VARCHAR(30),
  tced_sec_id NUMERIC,
  PRIMARY KEY (trce_sec, tced_tipo, tced_sec_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_trabajo_fam_apo (
  trfa_sec NUMERIC,
  recu_sec NUMERIC,
  trfa_fecha TIMESTAMP WITHOUT TIME ZONE,
  trfa_objetivo TEXT,
  trfa_actividad TEXT,
  trfa_acuerdos TEXT,
  trfa_resultados TEXT,
  trfa_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  trfa_user_ing VARCHAR(30),
  trfa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  trfa_user_mod VARCHAR(30),
  PRIMARY KEY (trfa_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pie_trabajo_fam_apo_det (
  trfa_sec NUMERIC,
  tfad_tipo VARCHAR(30),
  tfad_sec_id NUMERIC,
  PRIMARY KEY (trfa_sec, tfad_tipo, tfad_sec_id)
);

CREATE TABLE IF NOT EXISTS adm_educa.pod_resumen_estado_asbl (
  reab_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  reab_nro_bloque INTEGER,
  reab_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  reab_estado VARCHAR(15),
  reab_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  reab_user_ing VARCHAR(30),
  reab_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reab_user_mod VARCHAR(30),
  reab_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  gael_sec NUMERIC(23, 0),
  PRIMARY KEY (reab_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pod_resumen_estado_asdi (
  read_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  read_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  read_estado VARCHAR(15),
  read_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  read_user_ing VARCHAR(30),
  read_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  read_user_mod VARCHAR(30),
  read_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (read_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pod_resumen_estado_leno (
  reln_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  leas_sec NUMERIC(23, 0),
  reln_nro_cont NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  cuas_sec NUMERIC(23, 0),
  reln_fecha TIMESTAMP WITHOUT TIME ZONE,
  reln_estado VARCHAR(15),
  reln_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  reln_user_ing VARCHAR(30),
  reln_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  reln_user_mod VARCHAR(30),
  reln_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (reln_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.pod_resumen_estado_lepa (
  relp_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  lepa_sec NUMERIC(23, 0),
  relp_nro_cont NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  relp_fecha TIMESTAMP WITHOUT TIME ZONE,
  relp_estado VARCHAR(15),
  relp_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  relp_user_ing VARCHAR(30),
  relp_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  relp_user_mod VARCHAR(30),
  relp_fec_proceso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (relp_sec)
);

CREATE TABLE IF NOT EXISTS adm_educa.sqln_explain_plan (
  statement_id VARCHAR(30),
  "timestamp" TIMESTAMP WITHOUT TIME ZONE,
  remarks VARCHAR(80),
  operation VARCHAR(30),
  options VARCHAR(30),
  object_node VARCHAR(128),
  object_owner VARCHAR(30),
  object_name VARCHAR(30),
  object_instance NUMERIC,
  object_type VARCHAR(30),
  optimizer VARCHAR(255),
  search_columns NUMERIC,
  id NUMERIC,
  parent_id NUMERIC,
  position NUMERIC,
  cost NUMERIC,
  cardinality NUMERIC,
  bytes NUMERIC,
  other_tag VARCHAR(255),
  partition_start VARCHAR(255),
  partition_stop VARCHAR(255),
  partition_id NUMERIC,
  other TEXT,
  distribution VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_baserenta_feb (
  sec_carga NUMERIC(23, 0),
  unidad NUMERIC,
  rut NUMERIC,
  dv VARCHAR(1),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  cod_haber NUMERIC,
  nombre_haber VARCHAR(200),
  monto_haber NUMERIC(23, 0),
  cod_descuento NUMERIC,
  nombre_descuento VARCHAR(200),
  monto_descuento NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_eh (
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  detalle VARCHAR(200),
  descripcion VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  hrs__contrato VARCHAR(200),
  hrs_extension VARCHAR(200),
  horas_pie VARCHAR(200),
  horas_sep VARCHAR(200),
  horas_gremiales VARCHAR(200),
  horas_sippe VARCHAR(200),
  hrs_extraescolar VARCHAR(200),
  total_jornada VARCHAR(200),
  procesa VARCHAR(200),
  codigo NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_eh_diciembre (
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  detalle VARCHAR(200),
  descripcion VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  hrs_contrato VARCHAR(200),
  hrs_extension VARCHAR(200),
  horas_pie VARCHAR(200),
  horas_sep VARCHAR(200),
  horas_gremiales VARCHAR(200),
  horas_sippe VARCHAR(200),
  hrs_extraescolar VARCHAR(200),
  total_jornada VARCHAR(200),
  procesa VARCHAR(200),
  codigo NUMERIC,
  sec_carga NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_eh_noviembre (
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  detalle VARCHAR(200),
  descripcion VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  hrs_contrato VARCHAR(200),
  hrs_extension VARCHAR(200),
  horas_pie VARCHAR(200),
  horas_sep VARCHAR(200),
  horas_gremiales VARCHAR(200),
  horas_sippe VARCHAR(200),
  hrs_extraescolar VARCHAR(200),
  total_jornada VARCHAR(200),
  procesa VARCHAR(200),
  codigo NUMERIC,
  sec_carga NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_eh_octubre (
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  detalle VARCHAR(200),
  descripcion VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  hrs_contrato VARCHAR(200),
  hrs_extension VARCHAR(200),
  horas_pie VARCHAR(200),
  horas_sep VARCHAR(200),
  horas_gremiales VARCHAR(200),
  horas_sippe VARCHAR(200),
  hrs_extraescolar VARCHAR(200),
  total_jornada VARCHAR(200),
  procesa VARCHAR(200),
  codigo NUMERIC,
  sec_carga NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_isapre (
  rut_empleado NUMERIC,
  isapre NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_personal (
  codigo_1 VARCHAR(300),
  nombre_sucursal VARCHAR(300),
  codigo_2 VARCHAR(300),
  nombre_unidad VARCHAR(300),
  rut_empleado VARCHAR(300),
  dv VARCHAR(300),
  paterno VARCHAR(300),
  materno VARCHAR(300),
  nombre VARCHAR(300),
  sexo VARCHAR(300),
  f_nacimiento VARCHAR(300),
  edad VARCHAR(300),
  detalle_1 VARCHAR(300),
  planta VARCHAR(300),
  escala VARCHAR(300),
  categoria VARCHAR(300),
  descripcion VARCHAR(300),
  horas VARCHAR(300),
  detalle_2 VARCHAR(300),
  bienios VARCHAR(300),
  prox_bienio VARCHAR(300),
  grado VARCHAR(300),
  letra VARCHAR(300),
  inicio VARCHAR(300),
  termino VARCHAR(300),
  antiguedad VARCHAR(300),
  vigencia VARCHAR(300),
  total_normal VARCHAR(300),
  total_invalida VARCHAR(300),
  total_maternal VARCHAR(300),
  e2 VARCHAR(300),
  r2 VARCHAR(300),
  porc VARCHAR(300),
  porc__adicional VARCHAR(300),
  inva VARCHAR(300),
  admin VARCHAR(300),
  rebaja VARCHAR(300),
  e1 VARCHAR(300),
  r1 VARCHAR(300),
  porc_fijo VARCHAR(300),
  monto_fijo VARCHAR(300),
  monto_peso VARCHAR(300),
  porc_aporte_pat VARCHAR(300),
  mto_aporte_pat VARCHAR(300),
  tot_haberes VARCHAR(300),
  tot_desctos VARCHAR(300),
  sdo_imponib VARCHAR(300),
  monto_imponi VARCHAR(300),
  mto_cotiza VARCHAR(300),
  mto_adic VARCHAR(300),
  mto_salud VARCHAR(300),
  tributa VARCHAR(300),
  dias_trab VARCHAR(300),
  mto_porcen VARCHAR(300),
  ces_empleado VARCHAR(300),
  ces_empleador VARCHAR(300),
  inv_empleador VARCHAR(300),
  direccion VARCHAR(300),
  telefono VARCHAR(300),
  nacionalidad VARCHAR(300),
  estado_civil VARCHAR(300),
  numero_cuenta VARCHAR(300),
  razon_social VARCHAR(300),
  escolaridad VARCHAR(300),
  cod_t VARCHAR(300),
  desc_titulo VARCHAR(300),
  cod_e VARCHAR(300),
  desc_espec VARCHAR(300),
  sec_carga NUMERIC,
  dom_sector VARCHAR(20),
  esta_sec NUMERIC,
  dom_tipo_contrato VARCHAR(25),
  dom_prevision VARCHAR(25),
  dom_salud VARCHAR(30),
  horas_jornada NUMERIC,
  trab_sec_new NUMERIC,
  pers_sec_new NUMERIC,
  tipo_ley VARCHAR(30),
  dom_estado_civil VARCHAR(30),
  dom_cargo VARCHAR(30),
  reec_sec NUMERIC,
  sueldo_base NUMERIC,
  dom_banco VARCHAR(30),
  cont_sec NUMERIC,
  rein_sec_salud NUMERIC,
  rein_sec_prev NUMERIC,
  trbprv_sec_salud NUMERIC,
  trbprv_sec_prev NUMERIC,
  diho_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_personal_dic (
  codigo_1 VARCHAR(200),
  nombre_sucursal VARCHAR(200),
  codigo_2 VARCHAR(200),
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento VARCHAR(200),
  edad VARCHAR(200),
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento VARCHAR(200),
  planta VARCHAR(200),
  escala VARCHAR(200),
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas VARCHAR(200),
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio VARCHAR(200),
  grado VARCHAR(200),
  letra VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  antiguedad VARCHAR(200),
  vigencia VARCHAR(200),
  total_normal VARCHAR(200),
  total_invalida VARCHAR(200),
  total_maternal VARCHAR(200),
  e2 VARCHAR(200),
  r2 VARCHAR(200),
  porc VARCHAR(200),
  porc_adicional VARCHAR(200),
  inva VARCHAR(200),
  admin VARCHAR(200),
  admin_uni VARCHAR(200),
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo VARCHAR(200),
  monto_fijo VARCHAR(200),
  monto_fijo_unif VARCHAR(200),
  monto_peso VARCHAR(200),
  porc_aporte_pat VARCHAR(200),
  mto_aporte_pat VARCHAR(200),
  sueldo_base VARCHAR(200),
  tot_haberes VARCHAR(200),
  tot_desctos VARCHAR(200),
  sdo_imponib VARCHAR(200),
  monto_imponi VARCHAR(200),
  mto_cotiza VARCHAR(200),
  mto_adic VARCHAR(200),
  mto_salud VARCHAR(200),
  tributa VARCHAR(200),
  dias_trab VARCHAR(200),
  mto_porcen VARCHAR(200),
  ces_empleado VARCHAR(200),
  ces_empleador VARCHAR(200),
  inv_empleador VARCHAR(200),
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura VARCHAR(200),
  carrera_docente VARCHAR(200),
  sec_carga NUMERIC,
  dom_sector VARCHAR(20),
  esta_sec NUMERIC,
  dom_tipo_contrato VARCHAR(25),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_prevision VARCHAR(25),
  dom_salud VARCHAR(30),
  trab_sec_new NUMERIC,
  pers_sec_new NUMERIC,
  trab_sec_old NUMERIC,
  pers_sec_old NUMERIC,
  reec_sec NUMERIC,
  dom_banco VARCHAR(30),
  cont_sec_new NUMERIC,
  cont_sec NUMERIC,
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  trbprv_sec_salud NUMERIC,
  trbprv_sec_prev NUMERIC,
  diho_sec NUMERIC,
  dom_cargo VARCHAR(30),
  dom_categoria VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_personal_ene (
  codigo_1 VARCHAR(200),
  nombre_sucursal VARCHAR(200),
  codigo_2 VARCHAR(200),
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento VARCHAR(200),
  edad VARCHAR(200),
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento VARCHAR(200),
  planta VARCHAR(200),
  escala VARCHAR(200),
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas VARCHAR(200),
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio VARCHAR(200),
  grado VARCHAR(200),
  letra VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  antiguedad VARCHAR(200),
  vigencia VARCHAR(200),
  total_normal VARCHAR(200),
  total_invalida VARCHAR(200),
  total_maternal VARCHAR(200),
  e2 VARCHAR(200),
  r2 VARCHAR(200),
  porc VARCHAR(200),
  porc_adicional VARCHAR(200),
  inva VARCHAR(200),
  admin VARCHAR(200),
  admin_uni VARCHAR(200),
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo VARCHAR(200),
  monto_fijo VARCHAR(200),
  monto_fijo_unif VARCHAR(200),
  monto_peso VARCHAR(200),
  porc_aporte_pat VARCHAR(200),
  mto_aporte_pat VARCHAR(200),
  sueldo_base VARCHAR(200),
  tot_haberes VARCHAR(200),
  tot_desctos VARCHAR(200),
  sdo_imponib VARCHAR(200),
  monto_imponi VARCHAR(200),
  mto_cotiza VARCHAR(200),
  mto_adic VARCHAR(200),
  mto_salud VARCHAR(200),
  tributa VARCHAR(200),
  dias_trab VARCHAR(200),
  mto_porcen VARCHAR(200),
  ces_empleado VARCHAR(200),
  ces_empleador VARCHAR(200),
  inv_empleador VARCHAR(200),
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura VARCHAR(200),
  carrera_docente VARCHAR(200),
  sec_carga NUMERIC,
  dom_sector VARCHAR(20),
  esta_sec NUMERIC,
  dom_tipo_contrato VARCHAR(25),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_prevision VARCHAR(25),
  dom_salud VARCHAR(30),
  trab_sec_new NUMERIC,
  pers_sec_new NUMERIC,
  trab_sec_old NUMERIC,
  pers_sec_old NUMERIC,
  reec_sec NUMERIC,
  dom_banco VARCHAR(30),
  cont_sec_new NUMERIC,
  cont_sec NUMERIC,
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  trbprv_sec_salud NUMERIC,
  trbprv_sec_prev NUMERIC,
  diho_sec NUMERIC,
  dom_cargo VARCHAR(30),
  dom_categoria VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_personal_feb (
  codigo_1 VARCHAR(200),
  nombre_sucursal VARCHAR(200),
  codigo_2 VARCHAR(200),
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento VARCHAR(200),
  edad VARCHAR(200),
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento VARCHAR(200),
  planta VARCHAR(200),
  escala VARCHAR(200),
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas VARCHAR(200),
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio VARCHAR(200),
  grado VARCHAR(200),
  letra VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  antiguedad VARCHAR(200),
  vigencia VARCHAR(200),
  total_normal VARCHAR(200),
  total_invalida VARCHAR(200),
  total_maternal VARCHAR(200),
  e2 VARCHAR(200),
  r2 VARCHAR(200),
  porc VARCHAR(200),
  porc_adicional VARCHAR(200),
  inva VARCHAR(200),
  admin VARCHAR(200),
  admin_uni VARCHAR(200),
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo VARCHAR(200),
  monto_fijo VARCHAR(200),
  monto_fijo_unif VARCHAR(200),
  monto_peso VARCHAR(200),
  porc_aporte_pat VARCHAR(200),
  mto_aporte_pat VARCHAR(200),
  sueldo_base VARCHAR(200),
  tot_haberes VARCHAR(200),
  tot_desctos VARCHAR(200),
  sdo_imponib VARCHAR(200),
  monto_imponi VARCHAR(200),
  mto_cotiza VARCHAR(200),
  mto_adic VARCHAR(200),
  mto_salud VARCHAR(200),
  tributa VARCHAR(200),
  dias_trab VARCHAR(200),
  mto_porcen VARCHAR(200),
  ces_empleado VARCHAR(200),
  ces_empleador VARCHAR(200),
  inv_empleador VARCHAR(200),
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura VARCHAR(200),
  carrera_docente VARCHAR(200),
  sec_carga NUMERIC,
  dom_sector VARCHAR(20),
  esta_sec NUMERIC,
  dom_tipo_contrato VARCHAR(25),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_prevision VARCHAR(25),
  dom_salud VARCHAR(30),
  trab_sec_new NUMERIC,
  pers_sec_new NUMERIC,
  trab_sec_old NUMERIC,
  pers_sec_old NUMERIC,
  reec_sec NUMERIC,
  dom_banco VARCHAR(30),
  cont_sec_new NUMERIC,
  cont_sec NUMERIC,
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  trbprv_sec_salud NUMERIC,
  trbprv_sec_prev NUMERIC,
  diho_sec NUMERIC,
  dom_cargo VARCHAR(30),
  dom_categoria VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_personal_mar_2020 (
  pers_rut NUMERIC,
  pers_div VARCHAR(1),
  pers_apell_pat VARCHAR(50),
  pers_apell_mat VARCHAR(50),
  pers_nombre VARCHAR(500),
  pers_dom_sexo VARCHAR(30),
  pers_fech_nac TIMESTAMP WITHOUT TIME ZONE,
  pers_email VARCHAR(100),
  dire_calle VARCHAR(400),
  dire_numero VARCHAR(6),
  dire_comuna VARCHAR(200),
  dire_ciudad VARCHAR(200),
  dire_pais VARCHAR(50),
  dire_dom_origen_dir VARCHAR(30),
  regi_sec NUMERIC,
  prov_sec NUMERIC,
  comu_sec NUMERIC,
  pais_sec NUMERIC,
  dire_nacional VARCHAR(1),
  pers_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_personal_nov (
  codigo_1 VARCHAR(200),
  nombre_sucursal VARCHAR(200),
  codigo_2 VARCHAR(200),
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento VARCHAR(200),
  edad VARCHAR(200),
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento VARCHAR(200),
  planta VARCHAR(200),
  escala VARCHAR(200),
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas VARCHAR(200),
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio VARCHAR(200),
  grado VARCHAR(200),
  letra VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  antiguedad VARCHAR(200),
  vigencia VARCHAR(200),
  total_normal VARCHAR(200),
  total_invalida VARCHAR(200),
  total_maternal VARCHAR(200),
  e2 VARCHAR(200),
  r2 VARCHAR(200),
  porc VARCHAR(200),
  porc_adicional VARCHAR(200),
  inva VARCHAR(200),
  admin VARCHAR(200),
  admin_uni VARCHAR(200),
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc__fijo VARCHAR(200),
  monto_fijo VARCHAR(200),
  monto_fijo_unif VARCHAR(200),
  monto_peso VARCHAR(200),
  _porc_aporte_pat VARCHAR(200),
  mto__aporte_pat VARCHAR(200),
  sueldo_base VARCHAR(200),
  tot_haberes VARCHAR(200),
  tot_desctos VARCHAR(200),
  sdo_imponib VARCHAR(200),
  monto_imponi VARCHAR(200),
  mto_cotiza VARCHAR(200),
  mto_adic VARCHAR(200),
  mto_salud VARCHAR(200),
  tributa VARCHAR(200),
  dias_trab VARCHAR(200),
  mto_porcen VARCHAR(200),
  ces_empleado VARCHAR(200),
  ces_empleador VARCHAR(200),
  inv_empleador VARCHAR(200),
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura VARCHAR(200),
  carrera_docente VARCHAR(200),
  sec_carga NUMERIC,
  dom_sector VARCHAR(20),
  esta_sec NUMERIC,
  dom_tipo_contrato VARCHAR(25),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_prevision VARCHAR(25),
  dom_salud VARCHAR(30),
  trab_sec_new NUMERIC,
  pers_sec_new NUMERIC,
  trab_sec_old NUMERIC,
  pers_sec_old NUMERIC,
  reec_sec NUMERIC,
  dom_banco VARCHAR(30),
  cont_sec_new NUMERIC,
  cont_sec NUMERIC,
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  trbprv_sec_salud NUMERIC,
  trbprv_sec_prev NUMERIC,
  diho_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_personal_oct (
  codigo_1 VARCHAR(200),
  nombre_sucursal VARCHAR(200),
  codigo_2 VARCHAR(200),
  nombre_unidad VARCHAR(200),
  rut_empleado VARCHAR(200),
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento VARCHAR(200),
  edad VARCHAR(200),
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento VARCHAR(200),
  planta VARCHAR(200),
  escala VARCHAR(200),
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas VARCHAR(200),
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio VARCHAR(200),
  grado VARCHAR(200),
  letra VARCHAR(200),
  inicio VARCHAR(200),
  termino VARCHAR(200),
  antiguedad VARCHAR(200),
  vigencia VARCHAR(200),
  total_normal VARCHAR(200),
  total_invalida VARCHAR(200),
  total_maternal VARCHAR(200),
  e2 VARCHAR(200),
  r2 VARCHAR(200),
  porc VARCHAR(200),
  porc_adicional VARCHAR(200),
  inva VARCHAR(200),
  admin VARCHAR(200),
  admin_uni VARCHAR(200),
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo VARCHAR(200),
  monto_fijo VARCHAR(200),
  monto_fijo_unif VARCHAR(200),
  monto_peso VARCHAR(200),
  porc_aporte_pat VARCHAR(200),
  mto_aporte_pat VARCHAR(200),
  sueldo_base VARCHAR(200),
  tot_haberes VARCHAR(200),
  tot_desctos VARCHAR(200),
  sdo_imponib VARCHAR(200),
  monto_imponi VARCHAR(200),
  mto_cotiza VARCHAR(200),
  mto_adic VARCHAR(200),
  mto_salud VARCHAR(200),
  tributa VARCHAR(200),
  dias_trab VARCHAR(200),
  mto_porcen VARCHAR(200),
  ces_empleado VARCHAR(200),
  ces_empleador VARCHAR(200),
  inv_empleador VARCHAR(200),
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura VARCHAR(200),
  carrera_docente VARCHAR(200),
  sec_carga NUMERIC,
  dom_sector VARCHAR(20),
  esta_sec NUMERIC,
  dom_tipo_contrato VARCHAR(25),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_prevision VARCHAR(25),
  dom_salud VARCHAR(30),
  trab_sec_new NUMERIC,
  pers_sec_new NUMERIC,
  trab_sec_old NUMERIC,
  pers_sec_old NUMERIC,
  reec_sec NUMERIC,
  dom_banco VARCHAR(30),
  cont_sec_new NUMERIC,
  cont_sec NUMERIC,
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  trbprv_sec_salud NUMERIC,
  trbprv_sec_prev NUMERIC,
  diho_sec NUMERIC,
  dom_cargo VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_per_fech_dic (
  rut_empleado NUMERIC,
  f_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  prox_bienio TIMESTAMP WITHOUT TIME ZONE,
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_sb (
  rut NUMERIC,
  monto_haber NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_sis_pago_pen (
  rut_empleado NUMERIC,
  pensionado VARCHAR(20),
  sis_pago VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.a_tipo_ley (
  rut_empleado NUMERIC,
  tipo_ley VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_ant_academicos (
  anac_sec_id NUMERIC,
  usbt_rut NUMERIC,
  anac_nombre VARCHAR(200),
  dota_tipo_antecedente NUMERIC,
  anac_desde TIMESTAMP WITHOUT TIME ZONE,
  anac_hasta TIMESTAMP WITHOUT TIME ZONE,
  anac_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  anac_usuario_ins VARCHAR(50),
  anac_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  anac_usuario_mod VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_archivos_bt (
  arbt_sec_id NUMERIC,
  usbt_rut NUMERIC,
  arbt_logico VARCHAR(400),
  arbt_fisico VARCHAR(400),
  arbt_tamanio NUMERIC,
  arbt_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  arbt_usuario_ins VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_archivos_postulante (
  arpo_sec_id NUMERIC,
  usbt_rut NUMERIC,
  tido_tipo_doc NUMERIC,
  arpo_logico VARCHAR(400),
  arpo_fisico VARCHAR(400),
  arpo_tamanio NUMERIC,
  arpo_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  arpo_usuario_ins VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_capacitaciones (
  capa_sec_id NUMERIC,
  usbt_rut NUMERIC,
  capa_nombre VARCHAR(200),
  capa_desde TIMESTAMP WITHOUT TIME ZONE,
  capa_hasta TIMESTAMP WITHOUT TIME ZONE,
  capa_nro_horas NUMERIC,
  capa_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  capa_usuario_ins VARCHAR(50),
  capa_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  capa_usuario_mod VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_det_publicacion (
  depu_sec_id NUMERIC,
  publ_sec_id NUMERIC,
  depu_desc_cargo VARCHAR(4000),
  depu_obs_experiencia VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_det_pub_estudios (
  depu_sec_id NUMERIC,
  does_estudios NUMERIC,
  dpes_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  dpes_usuario_ins VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_det_pub_experiencia (
  depu_sec_id NUMERIC,
  expe_experiencia NUMERIC,
  dtex_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  dtex_usuario_ins VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_cargo_funcion (
  docf_cargo_funcion NUMERIC,
  docf_nombre VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_estado_postulacion (
  espo_estado NUMERIC,
  espo_nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_estado_publicacion (
  espu_estado NUMERIC,
  espu_nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_estado_seleccion (
  esse_estado NUMERIC,
  esse_nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_estudios (
  does_estudios NUMERIC,
  does_nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_experiencia (
  expe_experiencia NUMERIC,
  expe_nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_tipo_antecedente (
  dota_tipo_antecedente NUMERIC,
  dota_nombre VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_tipo_documento (
  tido_tipo_doc NUMERIC,
  tido_nombre VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_tipo_duracion (
  dotd_tipo_duracion NUMERIC,
  dotd_nombre VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_tipo_trayectoria (
  dott_tipo_trajectoria NUMERIC,
  dott_nombre VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_dom_tipo_ult_cargo (
  douc_tipo_ult_cargo NUMERIC,
  douc_nombre VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_ee_postulacion (
  eepo_sec_id NUMERIC,
  post_sec_id NUMERIC,
  eepu_sec_id NUMERIC,
  eepo_prioridad NUMERIC,
  eepo_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  eepo_usuario_ins VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_ee_publicacion (
  eepu_sec_id NUMERIC,
  publ_sec_id NUMERIC,
  esta_sec NUMERIC,
  eepu_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  eepu_usuario_ins VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_litigios (
  liti_rut NUMERIC,
  liti_dv VARCHAR(1),
  liti_fec_litigio TIMESTAMP WITHOUT TIME ZONE,
  liti_obs VARCHAR(500),
  liti_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  liti_usuario_ins VARCHAR(20),
  liti_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  liti_usuario_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_mov_seleccion (
  mose_sec_id NUMERIC,
  sele_sec_id NUMERIC,
  mose_obs VARCHAR(500),
  esse_estado NUMERIC,
  mose_fec_estado TIMESTAMP WITHOUT TIME ZONE,
  mose_usuario_estado VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_perfil_cargo (
  peca_sec_id NUMERIC,
  publ_sec_id NUMERIC,
  peca_desc VARCHAR(4000),
  peca_logico VARCHAR(400),
  peca_fisico VARCHAR(400),
  peca_tamanio NUMERIC,
  peca_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  peca_usuario_ins VARCHAR(20),
  peca_fec_mos TIMESTAMP WITHOUT TIME ZONE,
  peca_usuario_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_postulaciones (
  post_sec_id NUMERIC,
  publ_sec_id NUMERIC,
  usbt_rut NUMERIC,
  post_fec_postulacion TIMESTAMP WITHOUT TIME ZONE,
  espo_estado NUMERIC,
  post_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  post_usuario_ins VARCHAR(20),
  post_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  pos_usuario_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_publicaciones (
  publ_sec_id NUMERIC,
  publ_titulo VARCHAR(200),
  publ_cargo VARCHAR(300),
  publ_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  publ_fec_ter TIMESTAMP WITHOUT TIME ZONE,
  publ_pefil_cargo VARCHAR(1),
  espu_estado NUMERIC,
  publ_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  publ_usuario_ins VARCHAR(20),
  publ_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  publ_usuario_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_seleccion (
  sele_sec_id NUMERIC,
  publ_sec_id NUMERIC,
  usbt_rut NUMERIC,
  esse_estado NUMERIC,
  sele_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  sele_usuario_ins VARCHAR(20),
  sele_fec_mos TIMESTAMP WITHOUT TIME ZONE,
  sele_usuario_mod VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_titulos (
  titu_sec_id NUMERIC,
  usbt_rut NUMERIC,
  titu_titulo VARCHAR(200),
  titu_tipo VARCHAR(1),
  titu_fec_ingreso TIMESTAMP WITHOUT TIME ZONE,
  titu_fec_termino TIMESTAMP WITHOUT TIME ZONE,
  titu_fec_titulacion TIMESTAMP WITHOUT TIME ZONE,
  titu_duracion_carrera NUMERIC,
  dotd_tipo_duracion NUMERIC,
  titu_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  titu_usuario_ins VARCHAR(50),
  titu_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  titu_usuatio_mod VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_trayectorias (
  tray_sec_id NUMERIC,
  usbt_rut NUMERIC,
  dott_tipo_trajectoria NUMERIC,
  tray_jefatura VARCHAR(200),
  tray_cargo VARCHAR(200),
  tray_inst_empresa VARCHAR(200),
  tray_nro_tel_contacto VARCHAR(50),
  tray_depto VARCHAR(200),
  tray_desde TIMESTAMP WITHOUT TIME ZONE,
  tray_hasta TIMESTAMP WITHOUT TIME ZONE,
  tray_durac_anios NUMERIC,
  tray_durac_meses NUMERIC,
  tray_desc_funciones VARCHAR(4000),
  tray_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tray_usuario_ins VARCHAR(50),
  tray_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  tray_usuario_mod VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_ultimos_cargos (
  ulca_sec_id NUMERIC,
  usbt_rut NUMERIC,
  douc_tipo_ult_cargo NUMERIC,
  ulca_jefatura VARCHAR(200),
  docf_cargo_funcion NUMERIC,
  ulca_cargo VARCHAR(200),
  ulca_inst_empresa VARCHAR(200),
  ulca_nro_tel_contacto VARCHAR(50),
  ulca_depto VARCHAR(200),
  ulca_desde TIMESTAMP WITHOUT TIME ZONE,
  ulca_hasta TIMESTAMP WITHOUT TIME ZONE,
  ulca_durac_anios NUMERIC,
  ulca_durac_meses NUMERIC,
  ulca_desc_funciones VARCHAR(4000),
  ulca_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  ulca_usuario_ins VARCHAR(50),
  ulca_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ulca_usuario_mod VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.btr_usuario_bt (
  usbt_rut NUMERIC,
  usbt_dv VARCHAR(1),
  usbt_nombres VARCHAR(200),
  usbt_apellidos VARCHAR(200),
  usbt_correo VARCHAR(200),
  usbt_telefono1 VARCHAR(50),
  usbt_telefono2 VARCHAR(50),
  usbt_movil VARCHAR(50),
  usbt_key_acceso VARCHAR(100),
  usbt_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usbt_usuario_ins VARCHAR(50),
  usbt_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  usbt_usuario_mod VARCHAR(50),
  usbt_primer_acceso TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_bienios (
  trab_sec NUMERIC(23, 0),
  trab_bienios INTEGER,
  trab_bienios_fin INTEGER,
  trab_fech_cum_bie TIMESTAMP WITHOUT TIME ZONE,
  bienios VARCHAR(200),
  prox_bienio TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_capacitacion (
  capa_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  capa_otec VARCHAR(30),
  capa_nom VARCHAR(100),
  capa_cant_hrs NUMERIC,
  capa_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  capa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  capa_franq VARCHAR(2),
  capa_sence VARCHAR(10),
  capa_cupos NUMERIC,
  capa_dom_tipo_moneda VARCHAR(30),
  capa_valor NUMERIC(6, 0),
  capa_nom_rela VARCHAR(300),
  capa_tel_rela VARCHAR(20),
  capa_email_rela VARCHAR(100),
  capa_dire VARCHAR(500),
  capa_sind VARCHAR(15),
  capa_dom_sector VARCHAR(30),
  capa_dom_cargo VARCHAR(30),
  capa_puntaje INTEGER,
  capa_fact_nivel NUMERIC(6, 0),
  capa_dom_nivel_capacitacion VARCHAR(30),
  capa_dom_estado_cap VARCHAR(30),
  capa_dom_origen_capacitacion VARCHAR(30),
  capa_observacion VARCHAR(300),
  capa_dom_modulo VARCHAR(30),
  capa_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  capa_user_mov NUMERIC,
  ceco_sec NUMERIC(30, 0),
  esta_sec NUMERIC(30, 0),
  coti_sec_aprob NUMERIC,
  capa_origen_txs VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_capacitacion_2906 (
  capa_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  capa_otec VARCHAR(30),
  capa_nom VARCHAR(100),
  capa_cant_hrs NUMERIC,
  capa_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  capa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  capa_franq VARCHAR(2),
  capa_sence VARCHAR(10),
  capa_cupos NUMERIC,
  capa_dom_tipo_moneda VARCHAR(30),
  capa_valor NUMERIC(6, 0),
  capa_nom_rela VARCHAR(300),
  capa_tel_rela VARCHAR(20),
  capa_email_rela VARCHAR(100),
  capa_dire VARCHAR(500),
  capa_sind VARCHAR(15),
  capa_dom_sector VARCHAR(30),
  capa_dom_cargo VARCHAR(30),
  capa_puntaje INTEGER,
  capa_fact_nivel NUMERIC(6, 0),
  capa_dom_nivel_capacitacion VARCHAR(30),
  capa_dom_estado_cap VARCHAR(30),
  capa_dom_origen_capacitacion VARCHAR(30),
  capa_observacion VARCHAR(300),
  capa_dom_modulo VARCHAR(30),
  capa_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  capa_user_mov NUMERIC,
  ceco_sec NUMERIC(30, 0),
  esta_sec NUMERIC(30, 0),
  coti_sec_aprob NUMERIC,
  capa_origen_txs VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_capac_trab (
  catr_sec NUMERIC(23, 0),
  capa_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  catr_nota NUMERIC(4, 2),
  catr_fact_nota NUMERIC(3, 2),
  catr_dom_estado_capa_trab VARCHAR(30),
  catr_origen_txs VARCHAR(30),
  catr_noti_mail_pendiente VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_capac_trab_2906 (
  catr_sec NUMERIC(23, 0),
  capa_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  catr_nota NUMERIC(4, 2),
  catr_fact_nota NUMERIC(3, 2),
  catr_dom_estado_capa_trab VARCHAR(30),
  catr_origen_txs VARCHAR(30),
  catr_noti_mail_pendiente VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_cargos (
  cargo VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_ca_20211105 (
  pers_sec NUMERIC,
  codigo NUMERIC,
  nombre_unidad VARCHAR(400),
  rut_empleado NUMERIC,
  dv VARCHAR(1),
  paterno VARCHAR(400),
  materno VARCHAR(400),
  nombre VARCHAR(400),
  categoria VARCHAR(1),
  descripcion VARCHAR(400),
  detalle VARCHAR(400),
  grado NUMERIC,
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE,
  inicio_05 TIMESTAMP WITHOUT TIME ZONE,
  termino_05 TIMESTAMP WITHOUT TIME ZONE,
  inicio_06 TIMESTAMP WITHOUT TIME ZONE,
  termino_06 TIMESTAMP WITHOUT TIME ZONE,
  inicio_07 TIMESTAMP WITHOUT TIME ZONE,
  termino_07 TIMESTAMP WITHOUT TIME ZONE,
  inicio_08 TIMESTAMP WITHOUT TIME ZONE,
  termino_08 TIMESTAMP WITHOUT TIME ZONE,
  inicio_09 TIMESTAMP WITHOUT TIME ZONE,
  termino_09 TIMESTAMP WITHOUT TIME ZONE,
  inicio_10 TIMESTAMP WITHOUT TIME ZONE,
  termino_10 TIMESTAMP WITHOUT TIME ZONE,
  inicio_11 TIMESTAMP WITHOUT TIME ZONE,
  termino_11 TIMESTAMP WITHOUT TIME ZONE,
  inicio_12 TIMESTAMP WITHOUT TIME ZONE,
  termino_12 TIMESTAMP WITHOUT TIME ZONE,
  inicio_13 TIMESTAMP WITHOUT TIME ZONE,
  termino_13 TIMESTAMP WITHOUT TIME ZONE,
  inicio_14 TIMESTAMP WITHOUT TIME ZONE,
  termino_14 TIMESTAMP WITHOUT TIME ZONE,
  inicio_15 TIMESTAMP WITHOUT TIME ZONE,
  termino_15 TIMESTAMP WITHOUT TIME ZONE,
  inicio_16 TIMESTAMP WITHOUT TIME ZONE,
  termino_16 TIMESTAMP WITHOUT TIME ZONE,
  inicio_17 TIMESTAMP WITHOUT TIME ZONE,
  termino_17 TIMESTAMP WITHOUT TIME ZONE,
  inicio_18 TIMESTAMP WITHOUT TIME ZONE,
  termino_18 TIMESTAMP WITHOUT TIME ZONE,
  inicio_19 TIMESTAMP WITHOUT TIME ZONE,
  termino_19 TIMESTAMP WITHOUT TIME ZONE,
  inicio_20 TIMESTAMP WITHOUT TIME ZONE,
  termino_20 TIMESTAMP WITHOUT TIME ZONE,
  inicio_21 TIMESTAMP WITHOUT TIME ZONE,
  termino_21 TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_eval_capacitacion (
  evca_sec NUMERIC,
  evca_year NUMERIC,
  capa_sec NUMERIC,
  trab_sec NUMERIC,
  evca_dom_categoria VARCHAR(30),
  evca_dom_nivel VARCHAR(30),
  eva_nota NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_eval_capacitacion_2906 (
  evca_sec NUMERIC,
  evca_year NUMERIC,
  capa_sec NUMERIC,
  trab_sec NUMERIC,
  evca_dom_categoria VARCHAR(30),
  evca_dom_nivel VARCHAR(30),
  eva_nota NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_mail_bad (
  mats_sec NUMERIC,
  mats_nombre_from VARCHAR(400),
  mats_from VARCHAR(400),
  mats_to VARCHAR(4000),
  mats_subject VARCHAR(4000),
  mats_msg TEXT
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_no_lic (
  num_lic NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_paglic (
  numero_de_licencia NUMERIC,
  rut_del_trabajador VARCHAR(100),
  numero_de_cheque VARCHAR(100),
  fecha_de_pago TIMESTAMP WITHOUT TIME ZONE,
  dias_pago NUMERIC,
  monto_del_pago NUMERIC,
  concepto_del_pago VARCHAR(100),
  numero_de_cuota NUMERIC,
  id_del_banco VARCHAR(100),
  tipo_documento VARCHAR(100),
  sec_num NUMERIC,
  rut_trab VARCHAR(20),
  new_rut VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_personal_cmds (
  sec_carga NUMERIC,
  codigo_1 NUMERIC,
  nombre_sucursal VARCHAR(200),
  codigo_2 NUMERIC,
  nombre_unidad VARCHAR(200),
  rut_empleado NUMERIC,
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  edad NUMERIC,
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  idoneidad_comunicado VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento NUMERIC,
  planta NUMERIC,
  escala NUMERIC,
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas NUMERIC,
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio TIMESTAMP WITHOUT TIME ZONE,
  grado NUMERIC,
  letra VARCHAR(200),
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE,
  vigencia VARCHAR(200),
  total_normal NUMERIC,
  total_invalida NUMERIC,
  total_maternal NUMERIC,
  e2 NUMERIC,
  r2 VARCHAR(200),
  porc NUMERIC,
  porc_adicional NUMERIC,
  inva VARCHAR(200),
  admin NUMERIC,
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo NUMERIC,
  monto_fijo NUMERIC,
  monto_peso NUMERIC,
  porc_aporte_pat NUMERIC,
  mto_aporte_pat NUMERIC,
  sueldo_base NUMERIC,
  tot_haberes NUMERIC,
  tot_desctos NUMERIC,
  sdo_imponib VARCHAR(200),
  monto_imponi NUMERIC,
  mto_cotiza NUMERIC,
  mto_adic NUMERIC,
  mto_salud NUMERIC,
  tributa NUMERIC,
  dias_trab NUMERIC,
  mto_porcen NUMERIC,
  ces_empleado NUMERIC,
  ces_empleador NUMERIC,
  inv_empleador NUMERIC,
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura NUMERIC,
  carrera_docente VARCHAR(200),
  pers_sec NUMERIC,
  trab_sec NUMERIC,
  cont_sec NUMERIC,
  dom_tipo_contrato VARCHAR(20),
  dom_prevision VARCHAR(30),
  dom_salud VARCHAR(30),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_banco VARCHAR(30),
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  flujo VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_personal_cmds_2023 (
  sec_carga NUMERIC,
  codigo_1 NUMERIC,
  nombre_sucursal VARCHAR(200),
  codigo_2 NUMERIC,
  nombre_unidad VARCHAR(200),
  rut_empleado NUMERIC,
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  edad NUMERIC,
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  idoneidad_comunicado VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento NUMERIC,
  planta NUMERIC,
  escala NUMERIC,
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas NUMERIC,
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio TIMESTAMP WITHOUT TIME ZONE,
  grado NUMERIC,
  letra VARCHAR(200),
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE,
  vigencia VARCHAR(200),
  total_normal NUMERIC,
  total_invalida NUMERIC,
  total_maternal NUMERIC,
  e2 NUMERIC,
  r2 VARCHAR(200),
  porc NUMERIC,
  porc_adicional NUMERIC,
  inva VARCHAR(200),
  admin NUMERIC,
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo NUMERIC,
  monto_fijo NUMERIC,
  monto_peso NUMERIC,
  porc_aporte_pat NUMERIC,
  mto_aporte_pat NUMERIC,
  sueldo_base NUMERIC,
  tot_haberes NUMERIC,
  tot_desctos NUMERIC,
  sdo_imponib VARCHAR(200),
  monto_imponi NUMERIC,
  mto_cotiza NUMERIC,
  mto_adic NUMERIC,
  mto_salud NUMERIC,
  tributa NUMERIC,
  dias_trab NUMERIC,
  mto_porcen NUMERIC,
  ces_empleado NUMERIC,
  ces_empleador NUMERIC,
  inv_empleador NUMERIC,
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura NUMERIC,
  carrera_docente VARCHAR(200),
  pers_sec NUMERIC,
  trab_sec NUMERIC,
  cont_sec NUMERIC,
  dom_tipo_contrato VARCHAR(20),
  dom_prevision VARCHAR(30),
  dom_salud VARCHAR(30),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_banco VARCHAR(30),
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  flujo VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_personal_cmds_educ_202408 (
  sec_carga NUMERIC,
  codigo_1 NUMERIC,
  nombre_sucursal VARCHAR(200),
  codigo_2 NUMERIC,
  nombre_unidad VARCHAR(200),
  rut_empleado NUMERIC,
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  edad NUMERIC,
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  idoneidad_comunicado VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento NUMERIC,
  planta NUMERIC,
  escala NUMERIC,
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas NUMERIC,
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio TIMESTAMP WITHOUT TIME ZONE,
  grado NUMERIC,
  letra VARCHAR(200),
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE,
  vigencia VARCHAR(200),
  total_normal NUMERIC,
  total_invalida NUMERIC,
  total_maternal NUMERIC,
  e2 NUMERIC,
  r2 VARCHAR(200),
  porc NUMERIC,
  porc_adicional NUMERIC,
  inva VARCHAR(200),
  admin NUMERIC,
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo NUMERIC,
  monto_fijo NUMERIC,
  monto_peso NUMERIC,
  porc_aporte_pat NUMERIC,
  mto_aporte_pat NUMERIC,
  sueldo_base NUMERIC,
  tot_haberes NUMERIC,
  tot_desctos NUMERIC,
  sdo_imponib VARCHAR(200),
  monto_imponi NUMERIC,
  mto_cotiza NUMERIC,
  mto_adic NUMERIC,
  mto_salud NUMERIC,
  tributa NUMERIC,
  dias_trab NUMERIC,
  mto_porcen NUMERIC,
  ces_empleado NUMERIC,
  ces_empleador NUMERIC,
  inv_empleador NUMERIC,
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura NUMERIC,
  carrera_docente VARCHAR(200),
  pers_sec NUMERIC,
  trab_sec NUMERIC,
  cont_sec NUMERIC,
  dom_tipo_contrato VARCHAR(20),
  dom_prevision VARCHAR(30),
  dom_salud VARCHAR(30),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_banco VARCHAR(30),
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  flujo VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_personal_cmds_salud_2024 (
  sec_carga NUMERIC,
  codigo_1 NUMERIC,
  nombre_sucursal VARCHAR(200),
  codigo_2 NUMERIC,
  nombre_unidad VARCHAR(200),
  rut_empleado NUMERIC,
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  edad NUMERIC,
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  idoneidad_comunicado VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento NUMERIC,
  planta NUMERIC,
  escala NUMERIC,
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas NUMERIC,
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio TIMESTAMP WITHOUT TIME ZONE,
  grado NUMERIC,
  letra VARCHAR(200),
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE,
  vigencia VARCHAR(200),
  total_normal NUMERIC,
  total_invalida NUMERIC,
  total_maternal NUMERIC,
  e2 NUMERIC,
  r2 VARCHAR(200),
  porc NUMERIC,
  porc_adicional NUMERIC,
  inva VARCHAR(200),
  admin NUMERIC,
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo NUMERIC,
  monto_fijo NUMERIC,
  monto_peso NUMERIC,
  porc_aporte_pat NUMERIC,
  mto_aporte_pat NUMERIC,
  sueldo_base NUMERIC,
  tot_haberes NUMERIC,
  tot_desctos NUMERIC,
  sdo_imponib VARCHAR(200),
  monto_imponi NUMERIC,
  mto_cotiza NUMERIC,
  mto_adic NUMERIC,
  mto_salud NUMERIC,
  tributa NUMERIC,
  dias_trab NUMERIC,
  mto_porcen NUMERIC,
  ces_empleado NUMERIC,
  ces_empleador NUMERIC,
  inv_empleador NUMERIC,
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura NUMERIC,
  carrera_docente VARCHAR(200),
  pers_sec NUMERIC,
  trab_sec NUMERIC,
  cont_sec NUMERIC,
  dom_tipo_contrato VARCHAR(20),
  dom_prevision VARCHAR(30),
  dom_salud VARCHAR(30),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_banco VARCHAR(30),
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  flujo VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_personal_cmds_salud_202408 (
  sec_carga NUMERIC,
  codigo_1 NUMERIC,
  nombre_sucursal VARCHAR(200),
  codigo_2 NUMERIC,
  nombre_unidad VARCHAR(200),
  rut_empleado NUMERIC,
  dv VARCHAR(200),
  paterno VARCHAR(200),
  materno VARCHAR(200),
  nombre VARCHAR(200),
  sexo VARCHAR(200),
  f_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  edad NUMERIC,
  pensionado VARCHAR(200),
  email_corporativo VARCHAR(200),
  con_convenio VARCHAR(200),
  certificado_idoneidad VARCHAR(200),
  idoneidad_comunicado VARCHAR(200),
  detalle VARCHAR(200),
  tipo_ley VARCHAR(200),
  tipo_documento NUMERIC,
  planta NUMERIC,
  escala NUMERIC,
  categoria VARCHAR(200),
  descripcion VARCHAR(200),
  cargo VARCHAR(200),
  horas NUMERIC,
  detalle_hora VARCHAR(200),
  bienios VARCHAR(200),
  prox_bienio TIMESTAMP WITHOUT TIME ZONE,
  grado NUMERIC,
  letra VARCHAR(200),
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE,
  vigencia VARCHAR(200),
  total_normal NUMERIC,
  total_invalida NUMERIC,
  total_maternal NUMERIC,
  e2 NUMERIC,
  r2 VARCHAR(200),
  porc NUMERIC,
  porc_adicional NUMERIC,
  inva VARCHAR(200),
  admin NUMERIC,
  rebaja VARCHAR(200),
  e1 VARCHAR(200),
  r1 VARCHAR(200),
  tipo_moneda VARCHAR(200),
  porc_fijo NUMERIC,
  monto_fijo NUMERIC,
  monto_peso NUMERIC,
  porc_aporte_pat NUMERIC,
  mto_aporte_pat NUMERIC,
  sueldo_base NUMERIC,
  tot_haberes NUMERIC,
  tot_desctos NUMERIC,
  sdo_imponib VARCHAR(200),
  monto_imponi NUMERIC,
  mto_cotiza NUMERIC,
  mto_adic NUMERIC,
  mto_salud NUMERIC,
  tributa NUMERIC,
  dias_trab NUMERIC,
  mto_porcen NUMERIC,
  ces_empleado NUMERIC,
  ces_empleador NUMERIC,
  inv_empleador NUMERIC,
  direccion VARCHAR(200),
  telefono VARCHAR(200),
  nacionalidad VARCHAR(200),
  estado_civil VARCHAR(200),
  numero_cuenta VARCHAR(200),
  razon_social VARCHAR(200),
  escolaridad VARCHAR(200),
  cod_t VARCHAR(200),
  desc_titulo VARCHAR(200),
  cod_e VARCHAR(200),
  desc_espec VARCHAR(200),
  rut_jefatura NUMERIC,
  carrera_docente VARCHAR(200),
  pers_sec NUMERIC,
  trab_sec NUMERIC,
  cont_sec NUMERIC,
  dom_tipo_contrato VARCHAR(20),
  dom_prevision VARCHAR(30),
  dom_salud VARCHAR(30),
  horas_jornada NUMERIC,
  dom_estado_civil VARCHAR(30),
  dom_banco VARCHAR(30),
  rein_sec_prev NUMERIC,
  rein_sec_salud NUMERIC,
  flujo VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.lcs_puntaje (
  rut NUMERIC,
  puntaje NUMERIC,
  nivel_inf NUMERIC,
  nivel_dom VARCHAR(30),
  trab_sec NUMERIC,
  categoria VARCHAR(30),
  nivel VARCHAR(30),
  bienios NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.mail_c_x_v (
  mats_sec NUMERIC,
  mats_nombre_from VARCHAR(400),
  mats_from VARCHAR(400),
  mats_to VARCHAR(4000),
  mats_subject VARCHAR(4000),
  mats_msg TEXT,
  mats_fec_mail TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.mail_trab_sec_resp (
  trab_sec NUMERIC(23, 0),
  trab_email_corp VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.mail_x_vencer_20211216 (
  mats_sec NUMERIC,
  mats_nombre_from VARCHAR(400),
  mats_from VARCHAR(400),
  mats_to VARCHAR(4000),
  mats_subject VARCHAR(4000),
  mats_msg TEXT
);

CREATE TABLE IF NOT EXISTS adm_rhu.pad_ext (
  cont_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.pad_lic_medica (
  sec_carga NUMERIC,
  pers_rut NUMERIC,
  pers_div VARCHAR(1),
  pers_apell_pat VARCHAR(50),
  pers_apell_mat VARCHAR(50),
  pers_nombre VARCHAR(500),
  lime_numero VARCHAR(20),
  lime_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  lime_dom_estado_licencia VARCHAR(30),
  lime_dom_modo_licencia VARCHAR(30),
  lime_fech_nac_hj TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_acc TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_conp TIMESTAMP WITHOUT TIME ZONE,
  lime_rut_hj NUMERIC,
  lime_dv_hj VARCHAR(1),
  lime_nom_hj VARCHAR(50),
  lime_ape_pat_hj VARCHAR(50),
  lime_ape_mat_hj VARCHAR(50),
  lime_dias NUMERIC,
  lime_cont_otra VARCHAR(2),
  lime_dom_tipo_licencia VARCHAR(30),
  lime_dom_tipo_reposo VARCHAR(30),
  lime_dom_tipo_reposo_parcial VARCHAR(30),
  lime_dom_lugar_reposo VARCHAR(30),
  lime_dom_salud VARCHAR(30),
  lime_dom_tipo_resolucion VARCHAR(30),
  lime_dom_causal_rec_lic VARCHAR(30),
  lime_fech_ini_ampl TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_fin_ampl TIMESTAMP WITHOUT TIME ZONE,
  lime_dias_autorizados NUMERIC,
  cont_sec NUMERIC,
  estado_carga NUMERIC,
  error_carga VARCHAR(4000),
  pers_sec NUMERIC,
  trab_sec NUMERIC,
  rein_sec NUMERIC,
  lime_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.r1_20230530 (
  dchis_rut BIGINT,
  dchis_fecha TIMESTAMP WITHOUT TIME ZONE,
  dchis_experiencia NUMERIC,
  dchis_capacitacion NUMERIC,
  dchis_merito NUMERIC,
  dchis_acumulado NUMERIC,
  dchis_nivel NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.r2_20230530 (
  chis_rut BIGINT,
  chis_dv VARCHAR(1),
  chis_nombres VARCHAR(500),
  chis_paterno VARCHAR(100),
  chis_materno VARCHAR(100),
  chis_cod_unidad INTEGER,
  chis_establecimiento VARCHAR(100),
  chis_cod_cat VARCHAR(1),
  chis_categoria VARCHAR(100),
  chisa_cod_planta INTEGER,
  chis_planta_glosa VARCHAR(100),
  chis_puntaje NUMERIC,
  chis_nivel INTEGER,
  chis_activo VARCHAR(2),
  chis_bienio_ago95 NUMERIC,
  chis_bienios NUMERIC,
  chis_fecha_ingres TIMESTAMP WITHOUT TIME ZONE,
  chis_prox_bienio TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.r3_20230530 (
  cafu_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  pecf_sec NUMERIC,
  cafu_fecha_ptje TIMESTAMP WITHOUT TIME ZONE,
  cafu_ptje_capa NUMERIC,
  cafu_saldo_categoria NUMERIC,
  cafu_saldo_capacitacion NUMERIC,
  cafu_bienios NUMERIC,
  cafu_ptje_bienios NUMERIC,
  cafu_ptje_acum NUMERIC,
  cafu_dom_categoria VARCHAR(30),
  cafu_dom_nivel VARCHAR(30),
  cafu_tipo_reg VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS adm_rhu.r4_20230530 (
  evca_sec NUMERIC,
  evca_year NUMERIC,
  capa_sec NUMERIC,
  trab_sec NUMERIC,
  evca_dom_categoria VARCHAR(30),
  evca_dom_nivel VARCHAR(30),
  eva_nota NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS adm_rhu.r5_20230530 (
  catr_sec NUMERIC(23, 0),
  capa_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  catr_nota NUMERIC(4, 2),
  catr_fact_nota NUMERIC(3, 2),
  catr_dom_estado_capa_trab VARCHAR(30),
  catr_origen_txs VARCHAR(30),
  catr_noti_mail_pendiente VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.r6_20230530 (
  capa_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  capa_otec VARCHAR(30),
  capa_nom VARCHAR(100),
  capa_cant_hrs NUMERIC,
  capa_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  capa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  capa_franq VARCHAR(2),
  capa_sence VARCHAR(10),
  capa_cupos NUMERIC,
  capa_dom_tipo_moneda VARCHAR(30),
  capa_valor NUMERIC(6, 0),
  capa_nom_rela VARCHAR(300),
  capa_tel_rela VARCHAR(20),
  capa_email_rela VARCHAR(100),
  capa_dire VARCHAR(500),
  capa_sind VARCHAR(15),
  capa_dom_sector VARCHAR(30),
  capa_dom_cargo VARCHAR(30),
  capa_puntaje INTEGER,
  capa_fact_nivel NUMERIC(6, 0),
  capa_dom_nivel_capacitacion VARCHAR(30),
  capa_dom_estado_cap VARCHAR(30),
  capa_dom_origen_capacitacion VARCHAR(30),
  capa_observacion VARCHAR(300),
  capa_dom_modulo VARCHAR(30),
  capa_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  capa_user_mov NUMERIC,
  ceco_sec NUMERIC(30, 0),
  esta_sec NUMERIC(30, 0),
  coti_sec_aprob NUMERIC,
  capa_origen_txs VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.r7_2023053 (
  pers_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  saldo_ptje NUMERIC,
  flag_proc INTEGER
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_accidente (
  acci_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  acci_fech_reg TIMESTAMP WITHOUT TIME ZONE,
  acci_dom_tipo_accidente VARCHAR(30),
  cont_sec NUMERIC(23, 0),
  acci_dom_estado_accidente VARCHAR(30),
  acci_observacion VARCHAR(500),
  esta_sec NUMERIC,
  acci_user_mov BIGINT,
  PRIMARY KEY (acci_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_anexo_contrato (
  anxct_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  anxct_dom_tipo_moneda VARCHAR(30),
  anxct_tipo_valor VARCHAR(30),
  anxct_valor NUMERIC(10, 2),
  anxct_vari_cod VARCHAR(20),
  anxct_fec_inicio TIMESTAMP WITHOUT TIME ZONE,
  anxct_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  anxct_dom_estado VARCHAR(30),
  anxct_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  anxct_usr_ing VARCHAR(50),
  anxct_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  anxct_usr_mod VARCHAR(50),
  PRIMARY KEY (anxct_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_anticipo (
  anti_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  anti_fech_sol TIMESTAMP WITHOUT TIME ZONE,
  anti_fech_entr TIMESTAMP WITHOUT TIME ZONE,
  anti_dom_estado_anticipo VARCHAR(30),
  anti_monto BIGINT,
  anti_observacion_mov VARCHAR(300),
  anti_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  anti_user_mov BIGINT,
  anti_excep VARCHAR(1),
  cont_sec NUMERIC(23, 0),
  vari_cod VARCHAR(20),
  anti_rut_jefe BIGINT,
  anti_origen_txs VARCHAR(30),
  PRIMARY KEY (anti_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_anticipo_mov (
  anmo_sec NUMERIC(23, 0),
  anti_sec NUMERIC(23, 0),
  anmo_fech_sol TIMESTAMP WITHOUT TIME ZONE,
  anmo_fech_entr TIMESTAMP WITHOUT TIME ZONE,
  anmo_dom_estado_anticipo VARCHAR(30),
  anmo_monto BIGINT,
  anmo_observacion_mov VARCHAR(300),
  anmo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  anmo_user_mov BIGINT,
  anmo_tipo_mov VARCHAR(1),
  PRIMARY KEY (anmo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_aplicaciones (
  apli_id VARCHAR(60),
  apli_desc VARCHAR(60),
  apli_label VARCHAR(60),
  apli_pos_aplic NUMERIC,
  apli_usuario_ins VARCHAR(20),
  apli_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  apli_padre VARCHAR(60),
  apli_pos_padre NUMERIC,
  apli_link VARCHAR(50),
  apli_ayuda VARCHAR(100),
  apli_target VARCHAR(50),
  apli_icono VARCHAR(400),
  PRIMARY KEY (apli_id)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_aplicaciones_bkp (
  apli_id VARCHAR(60),
  apli_desc VARCHAR(60),
  apli_label VARCHAR(60),
  apli_pos_aplic NUMERIC,
  apli_usuario_ins VARCHAR(20),
  apli_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  apli_padre VARCHAR(60),
  apli_pos_padre NUMERIC,
  apli_link VARCHAR(50),
  apli_ayuda VARCHAR(100),
  apli_target VARCHAR(50),
  apli_icono VARCHAR(400)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_app_domains (
  apdo_domain VARCHAR(50),
  apdo_key VARCHAR(30),
  apdo_valor VARCHAR(100),
  apdo_desc VARCHAR(100),
  apdo_pos NUMERIC,
  apdo_visible VARCHAR(1),
  apdo_letra VARCHAR(5),
  PRIMARY KEY (apdo_domain, apdo_key)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_app_domains_lcs (
  apdo_domain VARCHAR(50),
  apdo_key VARCHAR(30),
  apdo_valor VARCHAR(100),
  apdo_desc VARCHAR(100),
  apdo_pos NUMERIC,
  apdo_visible VARCHAR(1),
  apdo_letra VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_archivos (
  arch_sec NUMERIC,
  arch_nombre VARCHAR(400),
  plan_sec NUMERIC,
  arch_total_lineas NUMERIC,
  arch_monto_total NUMERIC,
  arch_dom_estado_archivo VARCHAR(30),
  arch_fec_carga TIMESTAMP WITHOUT TIME ZONE,
  arch_usr_ing VARCHAR(50),
  arch_checksum VARCHAR(100),
  peri_cod INTEGER,
  PRIMARY KEY (arch_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_arch_errores (
  arch_sec NUMERIC,
  arer_cod_error NUMERIC,
  arer_gls_error VARCHAR(500),
  arer_nro_linea NUMERIC,
  arer_linea VARCHAR(4000),
  arer_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  arer_tipo_error INTEGER
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_articulo_fini (
  arfi_dom_articulo_salud VARCHAR(30),
  arfi_monto BIGINT,
  fini_sec NUMERIC(23, 0),
  PRIMARY KEY (arfi_dom_articulo_salud, fini_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_asign_familiar (
  peri_cod INTEGER,
  asgfm_tramo VARCHAR(1),
  asgfm_mnt_asig NUMERIC(12, 2),
  asgfm_rta_desde NUMERIC(12, 2),
  asgfm_rta_hasta NUMERIC(12, 2),
  asgfm_usr_ing VARCHAR(50),
  asgfm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  asgfm_usr_mod VARCHAR(50),
  asgfm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (peri_cod, asgfm_tramo)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_asig_familiar (
  asfa_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  asfa_dom_tramo VARCHAR(30),
  asfa_dom_tipo_carga VARCHAR(30),
  asfa_monto_carga BIGINT,
  asfa_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  asfa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  asfa_monto_retro BIGINT,
  PRIMARY KEY (asfa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_asistencia_comite (
  asco_sec NUMERIC(23, 0),
  reco_sec NUMERIC(23, 0),
  asco_dom_asistencia VARCHAR(30),
  asco_observacion VARCHAR(200),
  asco_user_ing BIGINT,
  asco_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  asco_user_mod BIGINT,
  asco_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  asco_trab_sec NUMERIC(23, 0),
  PRIMARY KEY (asco_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_asis_capacitacion (
  asca_sec NUMERIC(23, 0),
  catr_sec NUMERIC(23, 0),
  asca_fech TIMESTAMP WITHOUT TIME ZONE,
  asca_dom_asis_capac VARCHAR(30),
  asca_justific VARCHAR(2),
  asca_observacion VARCHAR(100),
  asca_hora_llegada VARCHAR(10),
  asca_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  asca_user_ing BIGINT,
  asca_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  asca_user_mod BIGINT
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_atributo (
  plan_sec NUMERIC(23, 0),
  atri_nombre VARCHAR(200),
  atri_pos INTEGER,
  atri_desc VARCHAR(200),
  PRIMARY KEY (plan_sec, atri_nombre)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_auth_excep (
  auex_dom_tipo_excep VARCHAR(30),
  auex_pers_sec NUMERIC(23, 0),
  auex_rut BIGINT,
  auex_dom_estado VARCHAR(30),
  PRIMARY KEY (auex_dom_tipo_excep, auex_pers_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_baserenta_mv (
  peri_cod INTEGER,
  empmc_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  pers_rut BIGINT,
  pers_div VARCHAR(1),
  pers_nombre VARCHAR(500),
  pers_apell_pat VARCHAR(50),
  pers_apell_mat VARCHAR(50),
  vari_cod VARCHAR(30),
  var_cmds NUMERIC,
  detr_monto NUMERIC,
  detr_orden INTEGER,
  haber_descuento VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_beneficio (
  bene_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  bene_nomb VARCHAR(100),
  bene_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  bene_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  bene_dom_estado VARCHAR(50),
  bene_frecuencia VARCHAR(1),
  bene_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  bene_usr_ing VARCHAR(50),
  bene_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  bene_usr_mod VARCHAR(50),
  bene_tipo_valor VARCHAR(30),
  bene_valor NUMERIC(12, 2),
  vari_cod VARCHAR(20),
  PRIMARY KEY (bene_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_benef_cm (
  becm_sec NUMERIC,
  sind_sec NUMERIC,
  becm_num_doc NUMERIC,
  becm_num_orden VARCHAR(40),
  becm_fecha_recepcion TIMESTAMP WITHOUT TIME ZONE,
  becm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  becm_user_ing VARCHAR(30),
  becm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  becm_user_mod VARCHAR(30),
  PRIMARY KEY (becm_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_benef_cm_detalle (
  bcde_sec NUMERIC,
  becm_sec NUMERIC,
  trab_sec NUMERIC,
  esta_sec NUMERIC,
  bcde_dom_cate_fallecido VARCHAR(30),
  bcde_dom_parentesco_fallecido VARCHAR(30),
  bcde_nombre VARCHAR(200),
  bcde_monto NUMERIC,
  becm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  becm_user_ing VARCHAR(30),
  becm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  becm_user_mod VARCHAR(30),
  PRIMARY KEY (bcde_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_benef_med (
  beme_sec NUMERIC,
  beme_num_doc NUMERIC,
  beme_os_sge NUMERIC,
  beme_fec_recepcion TIMESTAMP WITHOUT TIME ZONE,
  sind_sec NUMERIC,
  beme_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  beme_user_ing VARCHAR(30),
  beme_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  beme_user_mod VARCHAR(30),
  PRIMARY KEY (beme_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_benef_med_detalle (
  bmde_sec NUMERIC,
  beme_sec NUMERIC,
  trab_sec NUMERIC,
  esta_sec NUMERIC,
  bmde_monto NUMERIC,
  becm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  becm_user_ing VARCHAR(30),
  becm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  becm_user_mod VARCHAR(30),
  PRIMARY KEY (bmde_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_benef_trabajador (
  betr_sec NUMERIC(23, 0),
  bene_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  betr_fech_entr TIMESTAMP WITHOUT TIME ZONE,
  betr_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  peri_cod INTEGER,
  betr_monto NUMERIC(10, 2),
  betr_unidad VARCHAR(30),
  betr_sec_nov NUMERIC(23, 0),
  PRIMARY KEY (betr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_bienestar (
  bien_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  bien_nom VARCHAR(50),
  bien_monto BIGINT,
  bien_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  bien_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  bien_dom_estado VARCHAR(30),
  bien_dom_tipo_actividad VARCHAR(30),
  bien_dom_sector VARCHAR(30),
  PRIMARY KEY (bien_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_bienes_trab (
  bitr_sec NUMERIC(23, 0),
  bitr_fech_entr TIMESTAMP WITHOUT TIME ZONE,
  bien_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  PRIMARY KEY (bitr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_bienios_poranio (
  bipa_sec NUMERIC(23, 0),
  bipa_perian INTEGER,
  bipa_bienio INTEGER,
  bipa_prc_scd NUMERIC(5, 2),
  bipa_prc_ccd NUMERIC(5, 2),
  PRIMARY KEY (bipa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_capacitacion (
  capa_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  capa_otec VARCHAR(30),
  capa_nom VARCHAR(100),
  capa_cant_hrs NUMERIC,
  capa_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  capa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  capa_franq VARCHAR(2),
  capa_sence VARCHAR(10),
  capa_cupos NUMERIC,
  capa_dom_tipo_moneda VARCHAR(30),
  capa_valor NUMERIC(6, 0),
  capa_nom_rela VARCHAR(300),
  capa_tel_rela VARCHAR(20),
  capa_email_rela VARCHAR(100),
  capa_dire VARCHAR(500),
  capa_sind VARCHAR(15),
  capa_dom_sector VARCHAR(30),
  capa_dom_cargo VARCHAR(30),
  capa_puntaje INTEGER,
  capa_fact_nivel NUMERIC(6, 0),
  capa_dom_nivel_capacitacion VARCHAR(30),
  capa_dom_estado_cap VARCHAR(30),
  capa_dom_origen_capacitacion VARCHAR(30),
  capa_observacion VARCHAR(300),
  capa_dom_modulo VARCHAR(30),
  capa_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  capa_user_mov NUMERIC,
  ceco_sec NUMERIC(30, 0),
  esta_sec NUMERIC(30, 0),
  coti_sec_aprob NUMERIC,
  capa_origen_txs VARCHAR(30),
  PRIMARY KEY (capa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_capacitacion_mov (
  camo_sec NUMERIC(23, 0),
  capa_sec NUMERIC(23, 0),
  camo_dom_estado_cap VARCHAR(30),
  camo_puntaje INTEGER,
  camo_nom_rela VARCHAR(300),
  camo_tel_rela VARCHAR(20),
  camo_email_rela VARCHAR(100),
  camo_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  camo_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  camo_cupos NUMERIC,
  camo_dire VARCHAR(500),
  camo_observacion VARCHAR(300),
  camo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  camo_user_mov NUMERIC,
  camo_operacion VARCHAR(1),
  PRIMARY KEY (camo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_capac_trab (
  catr_sec NUMERIC(23, 0),
  capa_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  catr_nota NUMERIC(4, 2),
  catr_fact_nota NUMERIC(3, 2),
  catr_dom_estado_capa_trab VARCHAR(30),
  catr_origen_txs VARCHAR(30),
  catr_noti_mail_pendiente VARCHAR(1),
  PRIMARY KEY (catr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carga (
  carg_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  pers_sec_carg NUMERIC(23, 0),
  carg_dom_tipo_carga VARCHAR(30),
  carg_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  carg_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  carg_dom_tramo VARCHAR(30),
  carg_borrar VARCHAR(1),
  arch_sec NUMERIC,
  carg_dom_parentesco VARCHAR(30),
  PRIMARY KEY (carg_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carga_horaria (
  caho_sec NUMERIC,
  caho_nom_archivo VARCHAR(100),
  caho_fec_reg TIMESTAMP WITHOUT TIME ZONE,
  esta_sec NUMERIC,
  esta_sec_new NUMERIC,
  pers_sec NUMERIC,
  trab_sec NUMERIC,
  caho_dom_tipo_contrato VARCHAR(30),
  caho_dom_cargo VARCHAR(30),
  caho_dom_cargo_new VARCHAR(30),
  caho_tipo_dh VARCHAR(6),
  caho_existe_cont VARCHAR(1),
  cont_sec NUMERIC,
  caho_dom_estado_carga_horaria VARCHAR(30),
  caho_nombre_unidad VARCHAR(300),
  caho_rut_empleado NUMERIC,
  caho_dv VARCHAR(300),
  caho_paterno VARCHAR(300),
  caho_materno VARCHAR(300),
  caho_nombre VARCHAR(300),
  caho_tipo_contrato VARCHAR(300),
  caho_descripcion VARCHAR(300),
  caho_primer_contrato TIMESTAMP WITHOUT TIME ZONE,
  caho_inicio_funciones TIMESTAMP WITHOUT TIME ZONE,
  caho_inicio_new_cargo TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_funciones TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_new_cargo TIMESTAMP WITHOUT TIME ZONE,
  caho_horas_contrato NUMERIC,
  caho_horas_contrato_new NUMERIC,
  caho_detalle VARCHAR(300),
  caho_horas_extension NUMERIC,
  caho_detalle_extension VARCHAR(300),
  caho_inicio_extension TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_extension TIMESTAMP WITHOUT TIME ZONE,
  caho_horas_pie NUMERIC,
  caho_inicio_pie TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_pie TIMESTAMP WITHOUT TIME ZONE,
  caho_horas_sep NUMERIC,
  caho_inicio_sep TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_sep TIMESTAMP WITHOUT TIME ZONE,
  caho_horas_gremiales NUMERIC,
  caho_inicio_gremiales TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_gremiales TIMESTAMP WITHOUT TIME ZONE,
  caho_horas_sippe NUMERIC,
  caho_inicio_sippe TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_sippe TIMESTAMP WITHOUT TIME ZONE,
  caho_horas_extraescolar NUMERIC,
  caho_inicio_extraescolar TIMESTAMP WITHOUT TIME ZONE,
  caho_termino_extraescolar TIMESTAMP WITHOUT TIME ZONE,
  caho_total_horas NUMERIC,
  caho_observ VARCHAR(300),
  caho_pers_jefe NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carga_horaria_fechas (
  rut NUMERIC,
  fecha_desde_ini TIMESTAMP WITHOUT TIME ZONE,
  esta_sec_ini NUMERIC,
  unidad_ini VARCHAR(30),
  horas_ini NUMERIC,
  esta_sec_asig NUMERIC,
  unidad_asig VARCHAR(30),
  cargo_asig VARCHAR(30),
  gls_cargo_asig VARCHAR(100),
  horas_asig NUMERIC,
  fecha_desde_asig TIMESTAMP WITHOUT TIME ZONE,
  fecha_hasta_asig TIMESTAMP WITHOUT TIME ZONE,
  archivo VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carga_horaria_jefes (
  codigo VARCHAR(10),
  nombre VARCHAR(100),
  rut NUMERIC,
  codigo_uni VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carga_res (
  carg_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  pers_sec_carg NUMERIC(23, 0),
  carg_dom_tipo_carga VARCHAR(30),
  carg_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  carg_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  carg_tramo VARCHAR(30),
  carg_dom_parentesco VARCHAR(30),
  arch_sec NUMERIC,
  arch_sec_borra NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_cargo_sector (
  case_dom_cargo VARCHAR(30),
  case_dom_sector VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carrera_funcionaria (
  cafu_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  pecf_sec NUMERIC,
  cafu_fecha_ptje TIMESTAMP WITHOUT TIME ZONE,
  cafu_ptje_capa NUMERIC,
  cafu_saldo_categoria NUMERIC,
  cafu_saldo_capacitacion NUMERIC,
  cafu_bienios NUMERIC,
  cafu_ptje_bienios NUMERIC,
  cafu_ptje_acum NUMERIC,
  cafu_dom_categoria VARCHAR(30),
  cafu_dom_nivel VARCHAR(30),
  cafu_tipo_reg VARCHAR(3),
  PRIMARY KEY (cafu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carrera_func_hist (
  chis_rut BIGINT,
  chis_dv VARCHAR(1),
  chis_nombres VARCHAR(500),
  chis_paterno VARCHAR(100),
  chis_materno VARCHAR(100),
  chis_cod_unidad INTEGER,
  chis_establecimiento VARCHAR(100),
  chis_cod_cat VARCHAR(1),
  chis_categoria VARCHAR(100),
  chisa_cod_planta INTEGER,
  chis_planta_glosa VARCHAR(100),
  chis_puntaje NUMERIC,
  chis_nivel INTEGER,
  chis_activo VARCHAR(2),
  chis_bienio_ago95 NUMERIC,
  chis_bienios NUMERIC,
  chis_fecha_ingres TIMESTAMP WITHOUT TIME ZONE,
  chis_prox_bienio TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carrera_fun_bkp_20220923 (
  cafu_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  pecf_sec NUMERIC,
  cafu_fecha_ptje TIMESTAMP WITHOUT TIME ZONE,
  cafu_ptje_capa NUMERIC,
  cafu_saldo_categoria NUMERIC,
  cafu_saldo_capacitacion NUMERIC,
  cafu_bienios NUMERIC,
  cafu_ptje_bienios NUMERIC,
  cafu_ptje_acum NUMERIC,
  cafu_dom_categoria VARCHAR(30),
  cafu_dom_nivel VARCHAR(30),
  cafu_tipo_reg VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_carta_termino (
  cont_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  eval_sec NUMERIC(23, 0),
  eval_promedio NUMERIC(126, 0),
  cate_rut VARCHAR(42),
  cate_nombre VARCHAR(500),
  cate_dom_estado_carta VARCHAR(1),
  cate_fecha_fin_cont TIMESTAMP WITHOUT TIME ZONE,
  cate_fecha_eval TIMESTAMP WITHOUT TIME ZONE,
  cate_nombre_eval VARCHAR(300),
  cate_mail_jefe VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_catalogo_variables (
  vari_cod VARCHAR(20),
  vari_nombre VARCHAR(50),
  vari_desc_larg VARCHAR(150),
  vari_imprime VARCHAR(2),
  vari_copy_mes VARCHAR(2),
  vari_habe_desc VARCHAR(1),
  vari_dom_tipo_vari VARCHAR(15),
  vari_dom_tipo_valor VARCHAR(30),
  vari_dom_orig_valor VARCHAR(30),
  vari_cta_cont1 VARCHAR(30),
  vari_cta_cont2 VARCHAR(30),
  vari_es_imponible VARCHAR(2),
  vari_es_tributable VARCHAR(2),
  vari_nivel BIGINT,
  vari_suma_concepto VARCHAR(2),
  vari_ingr_trab VARCHAR(2),
  vari_visible VARCHAR(2),
  vari_editable VARCHAR(2),
  vari_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  vari_usr_ing VARCHAR(50),
  vari_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  vari_usr_mod VARCHAR(30),
  PRIMARY KEY (vari_cod)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_centro_costo (
  ceco_sec NUMERIC(23, 0),
  ceco_desc VARCHAR(200),
  ceco_cod VARCHAR(30),
  empr_sec NUMERIC(23, 0),
  ceco_dom_estado VARCHAR(30),
  grcc_sec NUMERIC(23, 0),
  PRIMARY KEY (ceco_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_certificado_renta (
  cert_rta_sec NUMERIC(23, 0),
  peri_anual INTEGER,
  mes VARCHAR(15),
  trab_sec BIGINT,
  pers_sec NUMERIC(23, 0),
  pers_rut VARCHAR(12),
  renta_bruta BIGINT,
  coti_previsional BIGINT,
  renta_imponible BIGINT,
  impto_unico BIGINT,
  may_reten_solic BIGINT,
  renta_tot_excenta BIGINT,
  renta_nogravada BIGINT,
  rebaja_zona_extr BIGINT,
  fact_actualiza NUMERIC(5, 3),
  renta_bruta_act BIGINT,
  coti_previsional_act BIGINT,
  renta_imponible_act BIGINT,
  impto_unico_act BIGINT,
  may_reten_solic_act BIGINT,
  renta_tot_excenta_act BIGINT,
  renta_nogravada_act BIGINT,
  rebaja_zona_extr_act BIGINT,
  folio_certif BIGINT,
  PRIMARY KEY (cert_rta_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_certif_rta_1887 (
  cert_f1887_sec NUMERIC(23, 0),
  periodo INTEGER,
  trab_sec BIGINT,
  pers_sec NUMERIC(23, 0),
  pers_rut VARCHAR(12),
  renta_bruta BIGINT,
  coti_previsional BIGINT,
  renta_imponible BIGINT,
  impto_unico BIGINT,
  may_reten_solic BIGINT,
  renta_tot_excenta BIGINT,
  renta_nogravada BIGINT,
  rebaja_zona_extr BIGINT,
  renta_bruta_act BIGINT,
  coti_previsional_act BIGINT,
  renta_imponible_act BIGINT,
  impto_unico_act BIGINT,
  may_reten_solic_act BIGINT,
  renta_tot_excenta_act BIGINT,
  renta_nogravada_act BIGINT,
  rebaja_zona_extr_act BIGINT,
  ene VARCHAR(1),
  feb VARCHAR(1),
  mar VARCHAR(1),
  abr VARCHAR(1),
  may VARCHAR(1),
  jun VARCHAR(1),
  jul VARCHAR(1),
  ago VARCHAR(1),
  sep VARCHAR(1),
  oct VARCHAR(1),
  nov VARCHAR(1),
  dic VARCHAR(1),
  folio_certif BIGINT,
  PRIMARY KEY (cert_f1887_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_cert_anti_arch (
  pers_sec NUMERIC,
  codigo NUMERIC,
  nombre_unidad VARCHAR(400),
  rut_empleado NUMERIC,
  dv VARCHAR(1),
  paterno VARCHAR(400),
  materno VARCHAR(400),
  nombre VARCHAR(400),
  categoria VARCHAR(1),
  descripcion VARCHAR(400),
  detalle VARCHAR(400),
  grado NUMERIC,
  inicio TIMESTAMP WITHOUT TIME ZONE,
  termino TIMESTAMP WITHOUT TIME ZONE,
  antiguedad TIMESTAMP WITHOUT TIME ZONE,
  inicio_05 TIMESTAMP WITHOUT TIME ZONE,
  termino_05 TIMESTAMP WITHOUT TIME ZONE,
  inicio_06 TIMESTAMP WITHOUT TIME ZONE,
  termino_06 TIMESTAMP WITHOUT TIME ZONE,
  inicio_07 TIMESTAMP WITHOUT TIME ZONE,
  termino_07 TIMESTAMP WITHOUT TIME ZONE,
  inicio_08 TIMESTAMP WITHOUT TIME ZONE,
  termino_08 TIMESTAMP WITHOUT TIME ZONE,
  inicio_09 TIMESTAMP WITHOUT TIME ZONE,
  termino_09 TIMESTAMP WITHOUT TIME ZONE,
  inicio_10 TIMESTAMP WITHOUT TIME ZONE,
  termino_10 TIMESTAMP WITHOUT TIME ZONE,
  inicio_11 TIMESTAMP WITHOUT TIME ZONE,
  termino_11 TIMESTAMP WITHOUT TIME ZONE,
  inicio_12 TIMESTAMP WITHOUT TIME ZONE,
  termino_12 TIMESTAMP WITHOUT TIME ZONE,
  inicio_13 TIMESTAMP WITHOUT TIME ZONE,
  termino_13 TIMESTAMP WITHOUT TIME ZONE,
  inicio_14 TIMESTAMP WITHOUT TIME ZONE,
  termino_14 TIMESTAMP WITHOUT TIME ZONE,
  inicio_15 TIMESTAMP WITHOUT TIME ZONE,
  termino_15 TIMESTAMP WITHOUT TIME ZONE,
  inicio_16 TIMESTAMP WITHOUT TIME ZONE,
  termino_16 TIMESTAMP WITHOUT TIME ZONE,
  inicio_17 TIMESTAMP WITHOUT TIME ZONE,
  termino_17 TIMESTAMP WITHOUT TIME ZONE,
  inicio_18 TIMESTAMP WITHOUT TIME ZONE,
  termino_18 TIMESTAMP WITHOUT TIME ZONE,
  inicio_19 TIMESTAMP WITHOUT TIME ZONE,
  termino_19 TIMESTAMP WITHOUT TIME ZONE,
  inicio_20 TIMESTAMP WITHOUT TIME ZONE,
  termino_20 TIMESTAMP WITHOUT TIME ZONE,
  inicio_21 TIMESTAMP WITHOUT TIME ZONE,
  termino_21 TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_comite_paritario (
  copa_sec NUMERIC(23, 0),
  copa_fech_inicio TIMESTAMP WITHOUT TIME ZONE,
  copa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  empr_sec NUMERIC(23, 0),
  copa_nombre VARCHAR(200),
  esta_sec NUMERIC(23, 0),
  PRIMARY KEY (copa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_comunas (
  comu_sec NUMERIC,
  comu_nombre VARCHAR(100),
  prov_sec NUMERIC,
  PRIMARY KEY (comu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_concepto_reporte (
  core_sec NUMERIC(23, 0),
  sere_sec NUMERIC(23, 0),
  core_codigo VARCHAR(30),
  core_descripcion VARCHAR(100),
  core_dom_estado VARCHAR(30),
  core_orden INTEGER,
  PRIMARY KEY (core_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_contrato (
  cont_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  cont_dom_funcion VARCHAR(30),
  cont_dom_tipo_contrato VARCHAR(30),
  cont_dom_tipo_ley VARCHAR(30),
  cont_fech_escr TIMESTAMP WITHOUT TIME ZONE,
  cont_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  cont_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  cont_jorn_lab NUMERIC,
  cont_dom_estado_contrato VARCHAR(30),
  cont_dom_cargo VARCHAR(30),
  cont_ingreso BIGINT,
  cont_sec_ant NUMERIC(23, 0),
  cont_observacion VARCHAR(300),
  cont_user_mov BIGINT,
  cont_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  cont_dom_sector VARCHAR(30),
  cont_nom_documento VARCHAR(250),
  cont_dom_estado VARCHAR(30),
  cont_pers_sec_jefe NUMERIC(23, 0),
  reec_sec NUMERIC,
  cont_horario VARCHAR(1000),
  cont_reubicacion VARCHAR(4000),
  trab_sec_rmplz NUMERIC(23, 0),
  cont_sec_rmplz NUMERIC(23, 0),
  cont_fecha_ult_reajuste TIMESTAMP WITHOUT TIME ZONE,
  cont_porc_ult_reajuste NUMERIC(7, 4),
  cont_ingreso_ant BIGINT,
  cont_reajuste_peri_cod INTEGER,
  cont_texto_libre VARCHAR(4000),
  odca_sec NUMERIC,
  repr_sec NUMERIC,
  cont_chk VARCHAR(300),
  arch_sec NUMERIC,
  cont_ane_definicion VARCHAR(100),
  cont_id_cont_sec_ori NUMERIC,
  cont_extencion_aut_dis VARCHAR(1),
  PRIMARY KEY (cont_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_contratos_ley (
  cole_sec NUMERIC,
  cole_dom_sector VARCHAR(30),
  cole_dom_ley VARCHAR(30),
  dodi_sec NUMERIC,
  cole_dom_estado VARCHAR(30),
  cole_sum_hrs VARCHAR(2),
  cole_renta_aut VARCHAR(2),
  PRIMARY KEY (cole_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_contratos_sectores (
  cose_sec NUMERIC(23, 0),
  cose_dom_sector VARCHAR(30),
  cose_dom_doc_contrato VARCHAR(30),
  cose_dom_estado VARCHAR(30),
  cose_plantilla VARCHAR(100),
  PRIMARY KEY (cose_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_contrato_mov (
  como_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  como_dom_funcion VARCHAR(30),
  como_dom_tipo_contrato VARCHAR(30),
  como_tipo_ley VARCHAR(30),
  como_fech_escr TIMESTAMP WITHOUT TIME ZONE,
  como_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  como_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  como_jorn_lab NUMERIC,
  como_dom_estado_contrato VARCHAR(30),
  como_dom_cargo VARCHAR(30),
  como_ingreso BIGINT,
  como_sec_ant NUMERIC(23, 0),
  como_observacion VARCHAR(300),
  como_tipo_mov VARCHAR(1),
  como_user_mov BIGINT,
  como_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  como_fecha_ult_reajuste TIMESTAMP WITHOUT TIME ZONE,
  como_porc_ult_reajuste NUMERIC(7, 4),
  como_ingreso_reajus BIGINT,
  como_reajuste_peri_cod INTEGER
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_contrato_noti (
  cono_sec NUMERIC,
  cont_sec NUMERIC,
  trab_sec NUMERIC,
  cono_dom_contratro_noti VARCHAR(30),
  cono_dom_accion_cont_noti VARCHAR(30),
  cono_fec_contrato_noti TIMESTAMP WITHOUT TIME ZONE,
  cono_fec_accion_cont_noti TIMESTAMP WITHOUT TIME ZONE,
  cono_email_noti VARCHAR(100),
  PRIMARY KEY (cono_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_contvig_peremun (
  cont_origen VARCHAR(50),
  cont_procesado VARCHAR(1),
  peri_cod INTEGER,
  cont_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  cont_dom_funcion VARCHAR(30),
  cont_dom_tipo_contrato VARCHAR(30),
  cont_dom_tipo_ley VARCHAR(30),
  cont_fech_escr TIMESTAMP WITHOUT TIME ZONE,
  cont_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  cont_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  cont_jorn_lab NUMERIC,
  cont_dom_estado_contrato VARCHAR(30),
  cont_dom_cargo VARCHAR(30),
  cont_ingreso BIGINT,
  cont_sec_ant NUMERIC(23, 0),
  cont_observacion VARCHAR(300),
  cont_user_mov BIGINT,
  cont_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  cont_dom_sector VARCHAR(30),
  cont_nom_documento VARCHAR(250),
  cont_dom_estado VARCHAR(30),
  cont_pers_sec_jefe NUMERIC(23, 0),
  cont_horario VARCHAR(1000),
  cont_reubicacion VARCHAR(4000),
  trab_sec_rmplz NUMERIC(23, 0),
  cont_sec_rmplz NUMERIC(23, 0),
  reec_sec NUMERIC,
  cont_fecha_ult_reajuste TIMESTAMP WITHOUT TIME ZONE,
  cont_porc_ult_reajuste NUMERIC(7, 4),
  cont_ingreso_ant BIGINT,
  cont_reajuste_peri_cod INTEGER,
  cont_texto_libre VARCHAR(4000),
  arch_sec NUMERIC,
  cont_chk VARCHAR(300),
  odca_sec NUMERIC,
  repr_sec NUMERIC(23, 0),
  cont_ane_definicion VARCHAR(100),
  trab_bienios INTEGER,
  trab_con_carr_doc VARCHAR(2),
  trab_sind VARCHAR(2),
  trab_conv VARCHAR(2),
  pers_dom_situacion VARCHAR(30),
  cont_esta_calc INTEGER,
  cont_desc_calc VARCHAR(3200),
  trab_dom_nivel VARCHAR(30),
  trab_dom_nivel_educa VARCHAR(30),
  trab_dom_categoria VARCHAR(30),
  PRIMARY KEY (peri_cod, trab_sec, cont_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_correo_saliente (
  cosa_serv_smtp VARCHAR(30),
  cosa_mail VARCHAR(100),
  cosa_pass VARCHAR(1000),
  cosa_puerto VARCHAR(4),
  cosa_puerto_salida VARCHAR(6),
  cosa_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_cotizacion (
  coti_sec NUMERIC(23, 0),
  capa_sec NUMERIC(23, 0),
  coti_empresa VARCHAR(200),
  coti_monto NUMERIC(12, 2),
  coti_relator VARCHAR(200),
  coti_select VARCHAR(1),
  coti_dom_tipo_moneda VARCHAR(30),
  PRIMARY KEY (coti_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_ctactbl_grcc (
  ctgr_sec NUMERIC(23, 0),
  grcc_sec NUMERIC(23, 0),
  ctsu_sec NUMERIC(23, 0),
  PRIMARY KEY (ctgr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_ctactbl_supereduc (
  ctsu_sec NUMERIC(23, 0),
  peri_anual INTEGER,
  ctsu_codigo VARCHAR(20),
  ctsu_descripcion VARCHAR(100),
  ctsu_dom_estado VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_cuota_sind (
  sind_sec NUMERIC(23, 0),
  cusi_monto NUMERIC(10, 4),
  cusi_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  cusi_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  cusi_dom_tipo_valor VARCHAR(30),
  cusi_dom_tipo_moneda VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_cursos_postulante (
  cupo_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  cupo_nombre VARCHAR(100),
  cupo_cipa VARCHAR(200),
  cupo_tipo VARCHAR(50),
  cupo_origen_txs VARCHAR(30),
  cupo_nacional VARCHAR(1),
  pais_sec NUMERIC,
  regi_sec NUMERIC,
  prov_sec NUMERIC,
  comu_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_def_criterio (
  decr_sec NUMERIC(23, 0),
  deev_cod BIGINT,
  decr_criterio VARCHAR(500),
  decr_order INTEGER,
  PRIMARY KEY (decr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_def_domains (
  dedo_domains VARCHAR(50),
  dedo_concepto_agrupa VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_def_eval (
  deev_cod BIGINT,
  deev_titulo VARCHAR(500),
  deev_order INTEGER,
  PRIMARY KEY (deev_cod)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_def_pregunta (
  depr_sec NUMERIC(23, 0),
  dese_sec NUMERIC(23, 0),
  depr_pregunta VARCHAR(1000),
  depr_order INTEGER,
  PRIMARY KEY (depr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_def_seccion (
  dese_sec NUMERIC(23, 0),
  decr_sec NUMERIC(23, 0),
  dese_seccion VARCHAR(500),
  dese_order INTEGER,
  PRIMARY KEY (dese_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_denuncia (
  denu_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  denu_dom_causal_denuncia VARCHAR(30),
  denu_fech_denu TIMESTAMP WITHOUT TIME ZONE,
  denu_domi_tipo_resol_denuncia VARCHAR(30),
  denu_fech_resol TIMESTAMP WITHOUT TIME ZONE,
  denu_observacion VARCHAR(500),
  denu_dom_estado_denuncia VARCHAR(30),
  denu_user_mov BIGINT,
  denu_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  denu_identificador VARCHAR(100),
  denu_fech_vcto TIMESTAMP WITHOUT TIME ZONE,
  denu_email VARCHAR(100),
  denu_tipo VARCHAR(1),
  PRIMARY KEY (denu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_detalle_accidente (
  deacc_sec NUMERIC(23, 0),
  acci_sec NUMERIC(23, 0),
  deacc_dias_perd NUMERIC,
  deacc_desc VARCHAR(300),
  deacc_fecha_ingr TIMESTAMP WITHOUT TIME ZONE,
  deacc_user_ing VARCHAR(30),
  deacc_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  deacc_user_mod VARCHAR(30),
  PRIMARY KEY (deacc_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_detalle_devo (
  dede_sec NUMERIC(23, 0),
  devo_sec NUMERIC(23, 0),
  dede_peri_cod INTEGER,
  dede_num_cuota INTEGER,
  dede_monto_cuota BIGINT,
  dede_dom_estado_pago VARCHAR(30),
  rmnov_sec NUMERIC(23, 0),
  PRIMARY KEY (dede_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_detalle_trab (
  detr_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  detr_monto NUMERIC(14, 4),
  vari_cod VARCHAR(20),
  empmc_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  detr_orden INTEGER,
  reec_sec NUMERIC(23, 0),
  prm_proc_sec NUMERIC(23, 0),
  esta_sec NUMERIC(23, 0),
  detr_cenco BIGINT,
  PRIMARY KEY (detr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_deta_proc_remun (
  prm_proc_sec NUMERIC,
  prre_dom_est_proc VARCHAR(15),
  prre_fecha_proc TIMESTAMP WITHOUT TIME ZONE,
  prre_hora_proc TIMESTAMP WITHOUT TIME ZONE,
  prre_mensaje VARCHAR(2000),
  prre_sec NUMERIC(23, 0),
  PRIMARY KEY (prre_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_det_carrera_func_hist (
  dchis_rut BIGINT,
  dchis_fecha TIMESTAMP WITHOUT TIME ZONE,
  dchis_experiencia NUMERIC,
  dchis_capacitacion NUMERIC,
  dchis_merito NUMERIC,
  dchis_acumulado NUMERIC,
  dchis_nivel NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_det_resum_trab (
  retr_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  trab_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  secto_cod VARCHAR(30),
  tipo_ley VARCHAR(30),
  esta_sec NUMERIC(23, 0),
  ceco_sec NUMERIC(23, 0),
  retr_sueldo_base NUMERIC(14, 2),
  retr_tot_haberes NUMERIC(14, 2),
  retr_tot_hab_impo NUMERIC(14, 2),
  retr_tot_habnoimp NUMERIC(14, 2),
  retr_tot_tributable NUMERIC(14, 2),
  retr_mto_prevision NUMERIC(14, 2),
  retr_tot_dsctolgl NUMERIC(14, 2),
  retr_mto_salud NUMERIC(14, 2),
  retr_dias_trab INTEGER,
  retr_nom_salud VARCHAR(30),
  retr_tot_liquido NUMERIC(14, 2),
  retr_tot_descuentos NUMERIC(14, 2),
  retr_seg_cesantia NUMERIC(14, 2),
  retr_tot_sector NUMERIC(30, 0),
  retr_tot_tley NUMERIC(30, 0),
  retr_tot_esta NUMERIC(30, 0),
  retr_tot_periodo NUMERIC(30, 0),
  retr_gratificacion NUMERIC(30, 0),
  retr_movilizacion NUMERIC(30, 0),
  retr_colacion NUMERIC(30, 0),
  empmc_sec NUMERIC(30, 0),
  PRIMARY KEY (retr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_devolucion (
  devo_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  devo_peri_deuda INTEGER,
  devo_dom_concepto_dev VARCHAR(30),
  devo_tipo_hd VARCHAR(1),
  devo_folio VARCHAR(10),
  devo_monto BIGINT,
  devo_saldo NUMERIC,
  devo_cant_cuotas INTEGER,
  devo_tasa NUMERIC(5, 3),
  devo_dom_estado_dev VARCHAR(30),
  devo_peri_inicial INTEGER,
  devo_sec_reneg NUMERIC(23, 0),
  devo_user_mod BIGINT,
  devo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  devo_comentario VARCHAR(3200),
  PRIMARY KEY (devo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_direccion (
  dire_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  dire_calle VARCHAR(400),
  dire_numero VARCHAR(6),
  dire_depto VARCHAR(4),
  dire_ref VARCHAR(100),
  dire_comuna VARCHAR(200),
  dire_ciudad VARCHAR(200),
  dire_pais VARCHAR(50),
  dire_latitud VARCHAR(200),
  dire_longitud VARCHAR(200),
  dire_estado VARCHAR(30),
  dire_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dire_user_ing VARCHAR(30),
  dire_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dire_user_mod VARCHAR(30),
  dire_dom_origen_dir VARCHAR(30),
  regi_sec NUMERIC,
  prov_sec NUMERIC,
  comu_sec NUMERIC,
  pais_sec NUMERIC,
  dire_nacional VARCHAR(1),
  PRIMARY KEY (dire_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_direccion_emp (
  diem_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  diem_calle VARCHAR(30),
  diem_numero VARCHAR(6),
  diem_depto VARCHAR(4),
  diem_ref VARCHAR(100),
  diem_comuna VARCHAR(50),
  diem_ciudad VARCHAR(50),
  diem_pais VARCHAR(50),
  diem_latitud VARCHAR(200),
  diem_longitud VARCHAR(200),
  diem_dom_estado_empresa VARCHAR(30),
  diem_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  diem_user_ing VARCHAR(30),
  diem_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  diem_user_mod VARCHAR(30),
  PRIMARY KEY (diem_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_direc_persona (
  dipe_sec NUMERIC,
  cont_sec NUMERIC,
  dire_sec NUMERIC,
  PRIMARY KEY (dipe_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_distribucion_horaria (
  diho_sec NUMERIC(23, 0),
  diho_cant_hrs NUMERIC,
  cont_sec NUMERIC(23, 0),
  diho_desde TIMESTAMP WITHOUT TIME ZONE,
  diho_hasta TIMESTAMP WITHOUT TIME ZONE,
  diho_observ VARCHAR(100),
  diho_funcion VARCHAR(400),
  reec_sec NUMERIC(23, 0),
  diho_dom_tipo_extension VARCHAR(30),
  arch_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_documentos (
  docu_sec NUMERIC(23, 0),
  docu_documento BYTEA,
  docu_key NUMERIC(23, 0),
  docu_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  docu_user_ing BIGINT,
  docu_nombre VARCHAR(100),
  docu_trab_sec NUMERIC(23, 0),
  docu_size NUMERIC(23, 0),
  docu_tipo_documento VARCHAR(50),
  docu_pers_sec NUMERIC(23, 0),
  docu_origen_txs VARCHAR(30),
  PRIMARY KEY (docu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_docu_dinamico (
  dodi_sec NUMERIC(23, 0),
  dodi_nombre VARCHAR(100),
  dodi_formato BYTEA,
  dodi_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dodi_user_ing BIGINT,
  dodi_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  dodi_user_mod BIGINT,
  dodi_dom_sector VARCHAR(30),
  PRIMARY KEY (dodi_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_accidente (
  doac_sec NUMERIC(23, 0),
  acci_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  doac_nombre VARCHAR(100),
  doac_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doac_user_ing BIGINT,
  PRIMARY KEY (doac_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_anexos (
  doax_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  doax_nombre VARCHAR(100),
  doax_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doax_user_ing BIGINT,
  PRIMARY KEY (doax_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_anticipo (
  doan_sec NUMERIC(23, 0),
  anti_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  doan_nombre VARCHAR(100),
  doan_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doan_user_ing BIGINT,
  PRIMARY KEY (doan_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_capacitacion (
  docp_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  catr_sec NUMERIC(23, 0),
  docp_nombre VARCHAR(100),
  docp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  docp_user_ing BIGINT,
  docp_tipo_doc VARCHAR(50),
  docp_size NUMERIC(23, 0),
  docp_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  docp_user_mod NUMERIC(23, 0),
  PRIMARY KEY (docp_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_carga (
  doca_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  carg_sec NUMERIC(23, 0),
  doca_nombre VARCHAR(100),
  doca_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doca_user_ing BIGINT,
  PRIMARY KEY (doca_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_comite (
  doco_sec NUMERIC(23, 0),
  reco_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  doco_nombre VARCHAR(100),
  doco_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doco_user_ing BIGINT,
  PRIMARY KEY (doco_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_contrato (
  docu_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  doco_nombre VARCHAR(100),
  docu_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  docu_user_ing BIGINT,
  doco_size NUMERIC(23, 0),
  docu_tipo_doc VARCHAR(50),
  PRIMARY KEY (cont_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_cotizacion (
  doct_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  coti_sec NUMERIC(23, 0),
  doct_nombre VARCHAR(100),
  doct_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doct_user_ing BIGINT
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_denuncia (
  dode_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  denu_sec NUMERIC(23, 0),
  dode_nombre VARCHAR(100),
  dode_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dode_user_ing BIGINT,
  PRIMARY KEY (dode_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_epp (
  doep_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  eptr_sec NUMERIC(23, 0),
  doep_nombre VARCHAR(100),
  doep_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doep_user_ing VARCHAR(30),
  PRIMARY KEY (doep_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_finiquito (
  dofi_sec NUMERIC(23, 0),
  fini_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  dofi_nombre VARCHAR(100),
  dofi_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dofi_user_ing BIGINT,
  PRIMARY KEY (dofi_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_licencia (
  doli_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  lime_sec NUMERIC(23, 0),
  doli_nombre VARCHAR(100),
  doli_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  doli_user_ing BIGINT,
  PRIMARY KEY (doli_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_permiso (
  dope_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  perm_sec NUMERIC(23, 0),
  dope_nombre VARCHAR(100),
  dope_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dope_user_ing BIGINT,
  PRIMARY KEY (dope_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_doc_persona (
  dope_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  dope_nombre VARCHAR(100),
  dope_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  dope_user_ing BIGINT
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_empresa (
  empr_sec NUMERIC(23, 0),
  empr_run BIGINT,
  empr_div VARCHAR(1),
  empr_razon_social VARCHAR(300),
  empr_nom_fantasia VARCHAR(200),
  empr_giro VARCHAR(100),
  empr_direccion VARCHAR(100),
  PRIMARY KEY (empr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_empresa_grpvariable (
  empgrp_sec NUMERIC(23, 0),
  empmc_sec NUMERIC(23, 0),
  grp_sec NUMERIC(23, 0),
  PRIMARY KEY (empgrp_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_empresa_modcalc (
  empr_sec NUMERIC(23, 0),
  mdc_cod VARCHAR(20),
  emc_dom_estado VARCHAR(30),
  emc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  emc_usr_ing VARCHAR(50),
  emc_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  emc_usr_mod VARCHAR(50),
  empmc_sec NUMERIC(23, 0),
  peri_cod NUMERIC(23, 0),
  PRIMARY KEY (empmc_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_empr_caja (
  emca_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  emca_peri_ini TIMESTAMP WITHOUT TIME ZONE,
  emca_peri_fin TIMESTAMP WITHOUT TIME ZONE,
  emca_dom_cod_caja VARCHAR(30),
  emca_dom_estado VARCHAR(30),
  PRIMARY KEY (emca_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_empr_mutual (
  emmu_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  emmu_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  emmu_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  emmu_dom_cod_mutual VARCHAR(20),
  emmu_tasa_base NUMERIC(5, 3),
  emmu_dom_estado VARCHAR(30),
  emmu_tasa_adicional NUMERIC(5, 3),
  emmu_tasa_extra NUMERIC(5, 3),
  emmu_tasa_sanna NUMERIC(5, 3),
  emmu_peri_anual INTEGER,
  PRIMARY KEY (emmu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_epp (
  epp_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  epp_desc VARCHAR(200),
  epp_dom_estado_epp VARCHAR(30),
  epp_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  epp_user_ing VARCHAR(30),
  epp_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  epp_user_mod VARCHAR(30),
  PRIMARY KEY (epp_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_epp_trabajador (
  eptr_sec NUMERIC(23, 0),
  epp_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  eptr_fech_asig TIMESTAMP WITHOUT TIME ZONE,
  eptr_fech_cambio TIMESTAMP WITHOUT TIME ZONE,
  eptr_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  eptr_user_ing BIGINT,
  eptr_dom_estado_asig VARCHAR(30),
  eptr_observacion VARCHAR(300),
  PRIMARY KEY (eptr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_escala_eval (
  deev_cod BIGINT,
  esva_val_min NUMERIC(3, 1),
  esva_val_max NUMERIC(3, 1),
  esva_dom_proce VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_esc_bonoresponsab (
  ebre_sec NUMERIC(23, 0),
  ebre_factor NUMERIC(5, 3),
  ebre_dom_cargo VARCHAR(30),
  ebre_usr_ing VARCHAR(30),
  ebre_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  ebre_usr_mod VARCHAR(30),
  ebre_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  ebre_dom_tipo_sector VARCHAR(30),
  ebre_desde BIGINT,
  ebre_hasta BIGINT,
  PRIMARY KEY (ebre_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_esc_fondoretiro (
  efre_tramo INTEGER,
  efre_renta_desde NUMERIC(14, 2),
  efre_renta_hasta NUMERIC(14, 2),
  efre_porc_dscto NUMERIC(5, 2),
  PRIMARY KEY (efre_tramo)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_esc_sldbs_asiseduc (
  esae_perian INTEGER,
  esae_peri_cod INTEGER,
  esae_cant_anios INTEGER,
  esae_factor NUMERIC(7, 4),
  esae_usr_ingr VARCHAR(30),
  esae_fec_ingr TIMESTAMP WITHOUT TIME ZONE,
  esae_usr_mod VARCHAR(30),
  esae_fec_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_esc_sldbs_sector (
  esse_sec NUMERIC(23, 0),
  esse_perian INTEGER,
  esse_dom_sector VARCHAR(30),
  esse_nivel INTEGER,
  esse_categoria VARCHAR(2),
  esse_dom_grado_educ VARCHAR(30),
  esse_sueldobase NUMERIC(12, 2),
  esse_atnprimaria NUMERIC(12, 2),
  esse_complzona NUMERIC(12, 2),
  esse_pericod_desde INTEGER,
  esse_pericod_hasta INTEGER,
  PRIMARY KEY (esse_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_establecimiento (
  esta_sec NUMERIC(23, 0),
  esta_cod VARCHAR(8),
  esta_desc VARCHAR(200),
  empr_sec NUMERIC(23, 0),
  esta_mail VARCHAR(100),
  esta_direc VARCHAR(500),
  esta_dom_estado VARCHAR(30),
  esta_rbd BIGINT,
  esta_dom_grado_educ VARCHAR(30),
  esta_cenco VARCHAR(10),
  esta_cant_alumnos INTEGER,
  esta_dom_tipo_sector VARCHAR(30),
  esta_vtf VARCHAR(1),
  PRIMARY KEY (esta_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_estados (
  esta_sec NUMERIC,
  esta_dom VARCHAR(50),
  esta_dom_key VARCHAR(30),
  esta_tab_key NUMERIC,
  esta_observaciones VARCHAR(400),
  esta_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  esta_user_mov NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_estados_lcs (
  esta_sec NUMERIC,
  esta_dom VARCHAR(50),
  esta_dom_key VARCHAR(30),
  esta_tab_key NUMERIC,
  esta_observaciones VARCHAR(400),
  esta_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  esta_user_mov NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_estado_licencia (
  esli_sec NUMERIC(23, 0),
  lime_sec NUMERIC(23, 0),
  esli_dom_estado_licencia VARCHAR(30),
  esli_observacion VARCHAR(300),
  esli_con_sub VARCHAR(2),
  esli_user_ing VARCHAR(30),
  esli_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  esli_user_mod VARCHAR(30),
  esli_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  esli_dom_tipo_resolucion VARCHAR(30),
  esli_dom_causal_rechazo VARCHAR(30),
  esli_obs_causal_rechazo VARCHAR(300),
  esli_dias_autorizados NUMERIC,
  esli_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  esli_user_mov BIGINT,
  esli_operacion VARCHAR(1),
  PRIMARY KEY (esli_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_evaluacion (
  eval_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  eval_fech_eval TIMESTAMP WITHOUT TIME ZONE,
  eval_promedio NUMERIC(126, 0),
  eval_dom_proce VARCHAR(30),
  eval_pers_sec_eval NUMERIC,
  eval_dom_estado_eval VARCHAR(30),
  cont_sec NUMERIC,
  eval_obs VARCHAR(1000),
  eval_pers_rut_eval NUMERIC,
  PRIMARY KEY (eval_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_eval_capacitacion (
  evca_sec NUMERIC,
  evca_year NUMERIC,
  capa_sec NUMERIC,
  trab_sec NUMERIC,
  evca_dom_categoria VARCHAR(30),
  evca_dom_nivel VARCHAR(30),
  eva_nota NUMERIC(10, 2),
  PRIMARY KEY (evca_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_eval_detall (
  evde_sec NUMERIC(23, 0),
  eval_sec NUMERIC(23, 0),
  evde_dom_fact VARCHAR(30),
  evde_dom_nivel VARCHAR(30),
  PRIMARY KEY (evde_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_exregimen_tasas (
  erta_codigo VARCHAR(30),
  erta_codigo_excaja INTEGER,
  erta_codigo_regimen INTEGER,
  erta_tasa NUMERIC(7, 4)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_factor_act (
  periodo INTEGER,
  mes INTEGER,
  factor NUMERIC(5, 3),
  PRIMARY KEY (mes, periodo)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_feriados (
  feri_sec NUMERIC(23, 0),
  feri_fecha TIMESTAMP WITHOUT TIME ZONE,
  feri_desc VARCHAR(500),
  feri_anho INTEGER,
  PRIMARY KEY (feri_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_ficha_postulacion (
  fipo_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  fipo_fech_ficha TIMESTAMP WITHOUT TIME ZONE,
  fipo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  fipo_user_ing VARCHAR(30),
  fipo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  fipo_user_mod VARCHAR(30),
  PRIMARY KEY (fipo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_fina_det (
  fide_sec NUMERIC(23, 0),
  fide_dom_tipo_financiamiento VARCHAR(30),
  detr_sec NUMERIC(23, 0),
  fide_porc NUMERIC(126, 0),
  PRIMARY KEY (fide_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_finiquito (
  fini_sec NUMERIC(23, 0),
  fini_domi_tipo_finiquito VARCHAR(30),
  fini_fech_doc TIMESTAMP WITHOUT TIME ZONE,
  fini_mont_indm BIGINT,
  fini_mont_pago BIGINT,
  fini_antiguedad NUMERIC(126, 0),
  fini_causal VARCHAR(500),
  cont_sec NUMERIC(23, 0),
  fini_enc_fun_rut BIGINT,
  fini_enc_fun_dv VARCHAR(1),
  fini_enc_fun_nombre VARCHAR(200),
  fini_valor_uf NUMERIC(10, 2),
  fini_monto_descuento BIGINT,
  fini_con_mes_aviso VARCHAR(1),
  fini_estado VARCHAR(5),
  fini_tipo_financiamiento VARCHAR(1),
  fini_fech_termino TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (fini_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_finiquito_det (
  fini_sec NUMERIC(23, 0),
  fnqtdt_sec NUMERIC(23, 0),
  vari_cod VARCHAR(20),
  fnqtdt_valor BIGINT,
  fnqtdet_usr_ing VARCHAR(50),
  fnqtdet_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fnqtdet_cantidad INTEGER,
  fnqtdet_descrip VARCHAR(255),
  PRIMARY KEY (fnqtdt_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_firma_doc (
  fido_sec NUMERIC,
  fido_nom_doc VARCHAR(100),
  pers_sec NUMERIC,
  fido_year NUMERIC,
  fido_dom_estado VARCHAR(30),
  PRIMARY KEY (fido_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_firma_externo_doc (
  fied_id_doc VARCHAR(30),
  fied_rut NUMERIC,
  fied_dv VARCHAR(1),
  fied_fec_creacion TIMESTAMP WITHOUT TIME ZONE,
  fied_img64 TEXT,
  PRIMARY KEY (fied_id_doc)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_firma_persona (
  pers_sec NUMERIC,
  fipe_imagen TEXT,
  fipe_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fipe_usuario_mod NUMERIC,
  fipe_img64 TEXT
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_flujo_estados (
  fles_dominio VARCHAR(30),
  fles_estado_origen VARCHAR(30),
  fles_estado_destino VARCHAR(30),
  fles_es_cierre VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_formula (
  frm_sec NUMERIC(23, 0),
  frm_cod VARCHAR(50),
  frm_nombre VARCHAR(100),
  frm_descrip VARCHAR(2000),
  frm_cod_esta VARCHAR(30),
  frm_version BIGINT,
  frm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fmr_usr_ing VARCHAR(50),
  frm_usr_mod VARCHAR(50),
  fmr_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fmr_vari_dest NUMERIC(23, 0),
  empmc_sec NUMERIC(23, 0),
  PRIMARY KEY (frm_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_grupo_ccosto (
  grcc_sec NUMERIC(23, 0),
  grcc_codigo VARCHAR(20),
  grcc_descripcion VARCHAR(50),
  grcc_dom_estado VARCHAR(30),
  PRIMARY KEY (grcc_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_grupo_variable (
  grp_sec NUMERIC(23, 0),
  grp_nombre VARCHAR(50),
  grp_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  grp_usr_ing VARCHAR(30),
  PRIMARY KEY (grp_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_grup_fami (
  grfa_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  pers_sec_fami NUMERIC(23, 0),
  grfa_resp VARCHAR(1),
  grfa_dom_parentesco VARCHAR(30),
  PRIMARY KEY (grfa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_historial (
  hist_sec NUMERIC(23, 0),
  hist_cod_modulo NUMERIC(23, 0),
  hist_nombre VARCHAR(50),
  hist_estado VARCHAR(100),
  hist_observacion VARCHAR(500),
  hist_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  hist_user_mod VARCHAR(30),
  PRIMARY KEY (hist_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_idioma (
  idio_sec NUMERIC(23, 0),
  idio_dom_idioma VARCHAR(30),
  recl_sec NUMERIC(23, 0),
  PRIMARY KEY (idio_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_img_default (
  imde_tipo VARCHAR(40),
  imde_imagen BYTEA
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_impuesto_unico (
  peri_cod INTEGER,
  imun_tramo INTEGER,
  imun_tipo_periodo VARCHAR(20),
  imun_desde NUMERIC(12, 2),
  imun_hasta NUMERIC(12, 2),
  imun_fact NUMERIC(10, 4),
  imun_rebaja NUMERIC(10, 4),
  imun_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  imun_usr_ing VARCHAR(50),
  imun_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  imun_usr_mod VARCHAR(50),
  PRIMARY KEY (imun_tramo, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_indicadores (
  indi_sec NUMERIC(23, 0),
  indi_periodo INTEGER,
  indi_dom_tipo_moneda VARCHAR(30),
  indi_valor NUMERIC(12, 2),
  indi_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  indi_usr_ing VARCHAR(50),
  indi_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  indi_usr_mod VARCHAR(50),
  PRIMARY KEY (indi_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_info_academica (
  inac_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  inac_institucion VARCHAR(500),
  inac_titulo VARCHAR(200),
  inac_fech_titu TIMESTAMP WITHOUT TIME ZONE,
  inac_ciudad VARCHAR(100),
  inac_pais VARCHAR(100),
  inac_origen_txs VARCHAR(30),
  inac_nacional VARCHAR(1),
  pais_sec NUMERIC,
  regi_sec NUMERIC,
  prov_sec NUMERIC,
  comu_sec NUMERIC,
  PRIMARY KEY (inac_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_institucion (
  inst_sec NUMERIC(23, 0),
  detr_sec NUMERIC(23, 0),
  inst_dom_tipo_institucion VARCHAR(30),
  inst_dom_tipo_moneda VARCHAR(30),
  inst_cod_super VARCHAR(10),
  inst_valor VARCHAR(100),
  inst_monto BIGINT,
  PRIMARY KEY (inst_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_institucion_previsional (
  instprv_sec NUMERIC(23, 0),
  instprv_cod VARCHAR(50),
  instprv_dom_key VARCHAR(20),
  instprv_dom_tipo_instit VARCHAR(50),
  instprv_cod_esta_dom VARCHAR(20),
  instprv_usr_ing VARCHAR(50),
  instprv_fec_ingr TIMESTAMP WITHOUT TIME ZONE,
  instprv_usr_mod VARCHAR(50),
  instprv_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  instprv_tipo_inst VARCHAR(30),
  PRIMARY KEY (instprv_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_inst_prev_param (
  instprm_peri_cod INTEGER,
  instprv_sec NUMERIC(23, 0),
  instprv_cod VARCHAR(50),
  instprm_tasa_afp NUMERIC(10, 4),
  instprm_tasa_sis NUMERIC(10, 4),
  instprm_tasa_indp NUMERIC(10, 4),
  instprm_tasa_salud NUMERIC(10, 4),
  PRIMARY KEY (instprm_peri_cod, instprv_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_integrantes_comite (
  inco_sec NUMERIC(23, 0),
  inco_dom_cargo_comite VARCHAR(30),
  inco_fech_inicio TIMESTAMP WITHOUT TIME ZONE,
  inco_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  copa_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  PRIMARY KEY (inco_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_jorn_semanal (
  jose_dom_tipo_ley VARCHAR(30),
  jose_hh_ini INTEGER,
  jose_hh_ext INTEGER
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_ley_causal (
  leca_ley_key VARCHAR(30),
  leca_cau_key VARCHAR(30),
  leca_cau_desc VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_ley_contractual (
  leco_sec NUMERIC(23, 0),
  leco_dom_sector VARCHAR(30),
  leco_dom_tipo_ley VARCHAR(30),
  leco_dom_tipo_contrato VARCHAR(30),
  leco_dom_estado_regla VARCHAR(30),
  leco_user_ing BIGINT,
  leco_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  leco_user_mod BIGINT,
  leco_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (leco_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_ley_jornada (
  lejo_sec NUMERIC,
  lejo_dom_tipo_ley VARCHAR(30),
  lejo_dom_tipo_contrato VARCHAR(30),
  lejo_dom_cargo VARCHAR(30),
  lejo_jornada NUMERIC,
  PRIMARY KEY (lejo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_librem_supereduc (
  lisu_sec NUMERIC(23, 0),
  core_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  lisu_rbd INTEGER,
  trab_sec NUMERIC(23, 0),
  liqui_sec NUMERIC(23, 0),
  liqui_monto NUMERIC(23, 0),
  PRIMARY KEY (lisu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_libro_remuneraciones (
  lrmn_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  trab_sec NUMERIC(23, 0),
  pers_rut VARCHAR(12),
  pers_nombre VARCHAR(50),
  pers_apell_pat VARCHAR(50),
  ceco_cod VARCHAR(30),
  sueldo_base NUMERIC(14, 2),
  gratificacion NUMERIC(14, 2),
  bono_extra NUMERIC(14, 2),
  bono_premio NUMERIC(14, 2),
  horas_extra NUMERIC(14, 2),
  total_afecto NUMERIC(14, 2),
  colacion NUMERIC(14, 2),
  movilizacion NUMERIC(14, 2),
  viatico NUMERIC(14, 2),
  asign_familiar NUMERIC(14, 2),
  total_haberes NUMERIC(14, 2),
  prevision NUMERIC(14, 2),
  sis NUMERIC(14, 2),
  cotiza_voluntaria NUMERIC(14, 2),
  apv NUMERIC(14, 2),
  salud_obligatoria NUMERIC(14, 2),
  salud_adicional NUMERIC(14, 2),
  impto_unico NUMERIC(14, 2),
  anticipo NUMERIC(14, 2),
  aguinaldo NUMERIC(14, 2),
  pago_prestamo NUMERIC(14, 2),
  seg_cesant_trab NUMERIC(14, 2),
  seg_cesant_empr NUMERIC(14, 2),
  seg_salud NUMERIC(14, 2),
  total_descto NUMERIC(14, 2),
  total_liquido NUMERIC(14, 2),
  PRIMARY KEY (lrmn_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_lice_medica (
  lime_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  rein_sec NUMERIC(23, 0),
  lime_numero VARCHAR(20),
  lime_fech_emis TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_recp TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_nac_hj TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_acc TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_conp TIMESTAMP WITHOUT TIME ZONE,
  lime_rut_hj BIGINT,
  lime_dv_hj VARCHAR(1),
  lime_nom_hj VARCHAR(50),
  lime_ape_pat_hj VARCHAR(50),
  lime_ape_mat_hj VARCHAR(50),
  lime_rec_lab VARCHAR(2),
  lime_ini_tr_inv VARCHAR(2),
  lime_just VARCHAR(100),
  lime_dias NUMERIC,
  lime_rut_prof BIGINT,
  lime_dv_prof VARCHAR(1),
  lime_nom_prof VARCHAR(200),
  lime_regi_prof VARCHAR(20),
  lime_cont_otra VARCHAR(2),
  lime_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  lime_user_ing VARCHAR(30),
  lime_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  lime_user_mod VARCHAR(30),
  lime_dom_tipo_licencia VARCHAR(30),
  lime_dom_tipo_reposo VARCHAR(30),
  lime_dom_tipo_reposo_parcial VARCHAR(30),
  lime_dom_lugar_reposo VARCHAR(30),
  lime_dom_salud VARCHAR(30),
  lime_dom_tipo_profesional VARCHAR(30),
  lime_dom_tipo_resolucion VARCHAR(30),
  lime_dom_causal_rec_lic VARCHAR(30),
  lime_obs_causal_rechazo VARCHAR(300),
  lime_fech_ini_ampl TIMESTAMP WITHOUT TIME ZONE,
  lime_fech_fin_ampl TIMESTAMP WITHOUT TIME ZONE,
  lime_dias_autorizados NUMERIC,
  lime_dom_estado_licencia VARCHAR(30),
  lime_observacion VARCHAR(1000),
  lime_con_sub VARCHAR(2),
  lime_notificado VARCHAR(1),
  lime_estado_lic_mail VARCHAR(30),
  lime_dom_modo_licencia VARCHAR(30),
  cont_sec NUMERIC,
  arch_sec NUMERIC,
  trbprv_sec NUMERIC,
  PRIMARY KEY (lime_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_lice_noti (
  lino_sec NUMERIC(23, 0),
  lime_sec NUMERIC(23, 0),
  lino_fech_envio TIMESTAMP WITHOUT TIME ZONE,
  lino_email VARCHAR(100),
  lino_user VARCHAR(10),
  PRIMARY KEY (lino_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_lice_pago (
  lipa_sec NUMERIC(23, 0),
  lime_sec NUMERIC(23, 0),
  lipa_rut BIGINT,
  lipa_num_doc VARCHAR(50),
  lipa_dom_tipo_doc VARCHAR(30),
  lipa_fech_pago TIMESTAMP WITHOUT TIME ZONE,
  lipa_dias_pag INTEGER,
  lipa_monto NUMERIC(23, 0),
  lipa_cuota INTEGER,
  lipa_dom_concepto VARCHAR(30),
  lipa_dom_banco VARCHAR(30),
  arch_sec NUMERIC,
  PRIMARY KEY (lipa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_lice_pago_rech (
  arch_sec NUMERIC,
  lipr_sec NUMERIC(23, 0),
  lipr_nro_linea NUMERIC,
  lipr_nro_licencia NUMERIC(23, 0),
  lipr_rut VARCHAR(20),
  lipr_num_doc VARCHAR(50),
  lipr_dom_tipo_doc VARCHAR(30),
  lipr_fech_pago TIMESTAMP WITHOUT TIME ZONE,
  lipr_dias_pag INTEGER,
  lipr_monto NUMERIC(23, 0),
  lipr_cuota INTEGER,
  lipr_dom_concepto VARCHAR(30),
  lipr_dom_banco VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_liquidacion_trab (
  liqui_sec NUMERIC(23, 0),
  empmc_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  trab_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  reec_sec NUMERIC(23, 0),
  vari_cod VARCHAR(30),
  liqui_monto NUMERIC(14, 4),
  liqui_orden INTEGER,
  esta_sec NUMERIC(23, 0),
  esta_cenco BIGINT,
  proc_sec NUMERIC(23, 0),
  PRIMARY KEY (liqui_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_liqui_resum_trab (
  lqrt_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  trab_sec NUMERIC(23, 0),
  lqrt_sueldo_base NUMERIC(14, 2),
  lqrt_tot_haberes NUMERIC(14, 2),
  lqrt_tot_hab_impo NUMERIC(14, 2),
  lqrt_tot_habnoimp NUMERIC(14, 2),
  lqrt_tot_tributable NUMERIC(14, 2),
  lqrt_mto_prevision NUMERIC(14, 2),
  lqrt_tot_dsctolgl NUMERIC(14, 2),
  lqrt_mto_salud NUMERIC(14, 2),
  lqrt_dias_trab INTEGER,
  lqrt_nom_salud VARCHAR(30),
  lqrt_tot_liquido NUMERIC(14, 2),
  lqrt_tot_descuentos NUMERIC(14, 2),
  lqrt_seg_cesantia NUMERIC(14, 2),
  lqrt_gratificacion BIGINT,
  lqrt_movilizacion BIGINT,
  lqrt_colacion BIGINT,
  cont_sec NUMERIC(23, 0),
  secto_cod VARCHAR(30),
  tipo_ley VARCHAR(30),
  lqrt_tot_sector NUMERIC(30, 0),
  lqrt_tot_tley NUMERIC(30, 0),
  lqrt_tot_esta NUMERIC(30, 0),
  lqrt_tot_periodo NUMERIC(30, 0),
  ceco_sec NUMERIC(23, 0),
  PRIMARY KEY (lqrt_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_lista_mail (
  noap_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  PRIMARY KEY (noap_sec, trab_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_log_app (
  loap_sec NUMERIC,
  loap_user_logico VARCHAR(50),
  loap_app_nombre VARCHAR(200),
  lose_sec_estimado NUMERIC,
  loap_fec_ingreso TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_log_bienios (
  lobi_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  lobi_bienios NUMERIC,
  lobi_bienios_fin NUMERIC,
  lobi_fech_cum_bie TIMESTAMP WITHOUT TIME ZONE,
  lobi_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  lobi_obs VARCHAR(150),
  PRIMARY KEY (lobi_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_log_session (
  lose_sec NUMERIC,
  lose_user_real VARCHAR(50),
  lose_user_logico VARCHAR(50),
  lose_fec_login TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_mail_log (
  malo_tipo VARCHAR(200),
  malo_mail_send NUMERIC,
  malo_ult_mail TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_mail_to_send (
  mats_sec NUMERIC,
  mats_nombre_from VARCHAR(400),
  mats_from VARCHAR(400),
  mats_to VARCHAR(4000),
  mats_subject VARCHAR(4000),
  mats_msg TEXT,
  mats_fec_mail TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (mats_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_mapvari_reporte (
  mare_sec NUMERIC(23, 0),
  core_sec NUMERIC(30, 0),
  peri_anual INTEGER,
  vari_cod VARCHAR(30),
  mare_dom_estado VARCHAR(30),
  PRIMARY KEY (mare_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_matriz_permisos (
  mape_sec NUMERIC,
  mape_dom_tipo_sector VARCHAR(30),
  mape_dom_tipo_ley VARCHAR(30),
  mape_dom_tipo_contrato VARCHAR(30),
  mape_tiene_derecho VARCHAR(1),
  mape_dom_tiempo_pregunta VARCHAR(30),
  mape_num_horas NUMERIC,
  mape_min_dias NUMERIC,
  mape_max_dias NUMERIC,
  mape_num_meses NUMERIC,
  mape_dom_tipo_permiso VARCHAR(30),
  PRIMARY KEY (mape_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_maxmin_impo (
  peri_cod INTEGER,
  mxmi_dom_trmo VARCHAR(30),
  mxmi_tipo VARCHAR(3),
  mxmi_valor_tramo NUMERIC(12, 2),
  mxmi_usr_ing VARCHAR(50),
  mxmi_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mxmi_usr_mod VARCHAR(50),
  mxmi_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  mxmi_dom_tipo_mon VARCHAR(30),
  PRIMARY KEY (peri_cod, mxmi_dom_trmo)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_metadatos (
  meta_sec NUMERIC(23, 0),
  tido_sec NUMERIC(23, 0),
  meta_nombre VARCHAR(100),
  meta_desc VARCHAR(200),
  meta_sql VARCHAR(1000),
  meta_tipo VARCHAR(1),
  PRIMARY KEY (meta_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_modalidad_calculo (
  mdc_cod VARCHAR(20),
  mdc_remu_ley VARCHAR(50),
  mdc_descripcion VARCHAR(100),
  mdc_dom_estado VARCHAR(30),
  mdc_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mdc_usr_ing VARCHAR(50),
  mdc_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  mdc_usr_mod VARCHAR(50),
  PRIMARY KEY (mdc_cod)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_modcalc_grpvar (
  grp_sec NUMERIC(23, 0),
  mdc_cod VARCHAR(20),
  mcgv_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  mcgv_usr_ing VARCHAR(50),
  PRIMARY KEY (grp_sec, mdc_cod)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_nivel_categ (
  ncat_sec NUMERIC(23, 0),
  ncat_dom_categoria VARCHAR(30),
  ncat_desde INTEGER,
  ncat_hasta INTEGER,
  ncat_dom_nivel VARCHAR(30),
  PRIMARY KEY (ncat_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_nivel_factor (
  nifa_dom_nivel_capacitacion VARCHAR(30),
  nifa_factor NUMERIC(3, 2),
  PRIMARY KEY (nifa_dom_nivel_capacitacion)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_notas (
  nota_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  nota_obs VARCHAR(500),
  nota_fech TIMESTAMP WITHOUT TIME ZONE,
  nota_user BIGINT,
  PRIMARY KEY (nota_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_nota_fact (
  nofa_sec NUMERIC(23, 0),
  nofa_desde INTEGER,
  nofa_hasta INTEGER,
  nofa_fact NUMERIC(3, 2),
  PRIMARY KEY (nofa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_noti_app (
  noap_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  noap_modulo VARCHAR(100),
  noap_desc VARCHAR(500),
  PRIMARY KEY (noap_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_odi (
  odi_sec NUMERIC(23, 0),
  docu_sec NUMERIC(23, 0),
  odi_nombre VARCHAR(200),
  odi_dom_estado VARCHAR(30),
  odi_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  odi_user_ing BIGINT,
  PRIMARY KEY (odi_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_odi_cargo (
  odca_sec NUMERIC,
  odca_dom_cargo VARCHAR(30),
  odi_sec NUMERIC,
  odca_dom_estado VARCHAR(30),
  odca_fec_estado TIMESTAMP WITHOUT TIME ZONE,
  odca_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  odca_user_ing VARCHAR(30),
  odca_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  odca_user_mod VARCHAR(30),
  PRIMARY KEY (odca_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_organismo_adm (
  orad_sec NUMERIC(23, 0),
  orad_nombre VARCHAR(300),
  orad_dom_estado NUMERIC(23, 0),
  orad_user_ing BIGINT,
  orad_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  orad_user_mod NUMERIC,
  orad_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (orad_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_paises (
  pais_sec INTEGER,
  pais_nombre VARCHAR(200),
  PRIMARY KEY (pais_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_parametros (
  para_codigo VARCHAR(50),
  para_desc VARCHAR(100),
  para_valor VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_periodo (
  peri_cod INTEGER,
  peri_desc VARCHAR(50),
  empr_sec NUMERIC(23, 0),
  peri_dom_estado_periodo VARCHAR(30),
  peri_anual INTEGER,
  PRIMARY KEY (peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_periodos_vacaciones (
  peva_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  peva_peri_ini INTEGER,
  peva_peri_fin INTEGER,
  peva_dias_asig NUMERIC,
  peva_dom_tipo_permiso VARCHAR(30),
  peva_dom_estado_permiso VARCHAR(30),
  peva_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  peva_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  peva_fech_auto TIMESTAMP WITHOUT TIME ZONE,
  peva_user_auto VARCHAR(30),
  peva_fech_sol TIMESTAMP WITHOUT TIME ZONE,
  peva_observacion_mov VARCHAR(300),
  peva_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  peva_user_mov BIGINT,
  peva_excep VARCHAR(1),
  cont_sec NUMERIC(23, 0),
  peva_dom_estado VARCHAR(30),
  peva_rut_jefe BIGINT,
  peva_origen_txs VARCHAR(30),
  PRIMARY KEY (peva_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_periodo_carr_func (
  pecf_sec NUMERIC,
  pecf_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  pecf_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  pecf_dom_estado VARCHAR(30),
  PRIMARY KEY (pecf_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_peris_vacaciones_det (
  pvdt_sec NUMERIC(23, 0),
  peva_sec NUMERIC(23, 0),
  pvdt_dias INTEGER,
  pvdt_peri_anio INTEGER,
  PRIMARY KEY (pvdt_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_peri_vaca_mov (
  pvmo_sec NUMERIC(23, 0),
  peva_sec NUMERIC(23, 0),
  pvmo_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  pvmo_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  pvmo_dias_asig NUMERIC,
  pvmo_dom_tipo_permiso VARCHAR(30),
  pvmo_dom_estado_permiso VARCHAR(30),
  pvmo_observacion_mov VARCHAR(300),
  pvmo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  pvmo_user_mov BIGINT,
  pvmo_tipo_mov VARCHAR(1),
  pvmo_excep VARCHAR(1),
  PRIMARY KEY (pvmo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_permiso (
  perm_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  perm_fech_sol TIMESTAMP WITHOUT TIME ZONE,
  perm_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  perm_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  perm_dom_tipo_permiso VARCHAR(30),
  perm_dias NUMERIC,
  perm_dom_estado_permiso VARCHAR(30),
  perm_pers_sec_auto NUMERIC(23, 0),
  perm_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  perm_observacion VARCHAR(300),
  perm_user_mov VARCHAR(30),
  perm_excep VARCHAR(1),
  cont_sec NUMERIC(23, 0),
  perm_rut_jefe BIGINT,
  perm_origen_txs VARCHAR(30),
  PRIMARY KEY (perm_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_permiso_covid (
  peco_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  peco_dom_tipo_permiso VARCHAR(30),
  peco_dias_otorga INTEGER,
  peco_dias_usados NUMERIC(3, 1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_permiso_mov (
  pemo_sec NUMERIC(23, 0),
  perm_sec NUMERIC(23, 0),
  pemo_dias NUMERIC,
  pemo_dom_estado_permiso VARCHAR(30),
  pemo_pers_sec_auto NUMERIC(23, 0),
  pemo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  pemo_observacion VARCHAR(300),
  pemo_user_mov VARCHAR(30),
  perm_dom_tipo_permiso VARCHAR(30),
  trab_sec NUMERIC(23, 0),
  perm_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  perm_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  pemo_tipo_mov VARCHAR(1),
  pemo_fech_sol TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (pemo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_persona (
  pers_sec NUMERIC(23, 0),
  pers_rut BIGINT,
  pers_div VARCHAR(1),
  pers_nombre VARCHAR(500),
  pers_apell_pat VARCHAR(50),
  pers_apell_mat VARCHAR(50),
  pers_fech_nac TIMESTAMP WITHOUT TIME ZONE,
  pers_nacionalidad VARCHAR(50),
  pers_dom_sexo VARCHAR(1),
  pers_email VARCHAR(100),
  pers_dom_estado_civil VARCHAR(10),
  pers_lug_nac VARCHAR(200),
  pers_cant_hijo NUMERIC,
  pers_dom_situacion VARCHAR(30),
  pers_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  pers_user_ing VARCHAR(30),
  pers_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  pers_user_mod VARCHAR(30),
  pers_dom_banco VARCHAR(30),
  pers_dom_tipo_cuenta VARCHAR(30),
  pers_dom_lice_cond VARCHAR(30),
  pers_nom_contc VARCHAR(300),
  pers_tel_cont VARCHAR(20),
  pers_dom_sistema_pago VARCHAR(30),
  pers_dom_profesion_actividad VARCHAR(30),
  pers_num_cuenta VARCHAR(100),
  pers_tipo_persona VARCHAR(1),
  pers_chk VARCHAR(300),
  arch_sec NUMERIC,
  pers_dom_parentesco_emergencia VARCHAR(30),
  pers_dom_vigencia VARCHAR(30),
  pers_rut_antiguo NUMERIC,
  pers_dv_antiguo VARCHAR(1),
  pers_fech_act_rut TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (pers_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_plantilla (
  plan_sec NUMERIC(23, 0),
  tipo_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  plan_nombre VARCHAR(200),
  PRIMARY KEY (plan_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_postnatal_avi (
  poav_sec NUMERIC,
  lime_sec NUMERIC,
  pers_sec NUMERIC,
  poav_fec_nac_hj TIMESTAMP WITHOUT TIME ZONE,
  poav_fecha_ini_post TIMESTAMP WITHOUT TIME ZONE,
  poav_fecha_ter_post TIMESTAMP WITHOUT TIME ZONE,
  poav_dom_estado_post VARCHAR(30),
  poav_rut_trab VARCHAR(20),
  poav_nombre_trab VARCHAR(400),
  PRIMARY KEY (poav_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_postulacion (
  post_sec NUMERIC(23, 0),
  recl_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  post_fech TIMESTAMP WITHOUT TIME ZONE,
  post_obs VARCHAR(200),
  post_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  post_user_ing VARCHAR(30),
  post_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  post_user_mod VARCHAR(30),
  post_dom_estado_postulacion VARCHAR(30),
  post_origen_txs VARCHAR(30),
  PRIMARY KEY (post_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_postulacion_mov (
  pomo_sec NUMERIC(23, 0),
  pomo_dom_estado_postulacion VARCHAR(30),
  pomo_observacion VARCHAR(200),
  pomo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  pomo_user_mov NUMERIC(23, 0),
  post_sec NUMERIC(23, 0),
  PRIMARY KEY (pomo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_pos_cursos (
  pocu_sec NUMERIC,
  pous_rut NUMERIC,
  pocu_nombre VARCHAR(200),
  pocu_tipo VARCHAR(200),
  pocu_nacional VARCHAR(1),
  pais_sec NUMERIC,
  regi_sec NUMERIC,
  prov_sec NUMERIC,
  comu_sec NUMERIC,
  pocu_fecha_ingreso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (pocu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_pos_documentos (
  podo_sec NUMERIC,
  pous_rut NUMERIC,
  podo_documento BYTEA,
  podo_nombre_arch VARCHAR(200),
  podo_size NUMERIC,
  podo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (podo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_pos_estudio (
  poes_sec NUMERIC,
  pous_rut NUMERIC,
  poes_institucion VARCHAR(300),
  poes_titulo VARCHAR(300),
  poes_fec_titulo TIMESTAMP WITHOUT TIME ZONE,
  poes_nacional VARCHAR(1),
  pais_sec NUMERIC,
  regi_sec NUMERIC,
  prov_sec NUMERIC,
  comu_sec NUMERIC,
  poes_fec_ingreso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (poes_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_pos_referencia (
  pore_sec NUMERIC,
  pous_rut NUMERIC,
  pore_nombre VARCHAR(200),
  pore_cargo VARCHAR(200),
  pore_fono VARCHAR(20),
  pore_correo VARCHAR(100),
  pore_fecha_ingreso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (pore_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_pos_solicitar (
  poso_sec NUMERIC,
  pous_rut NUMERIC,
  recl_sec NUMERIC,
  poso_fec_solicitud TIMESTAMP WITHOUT TIME ZONE,
  poso_obs_cmds VARCHAR(2000),
  poso_dom_estado_postulacion VARCHAR(30),
  PRIMARY KEY (poso_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_pos_trayectoria (
  potr_sec NUMERIC,
  pous_rut NUMERIC,
  potr_dom_cargo VARCHAR(30),
  potr_dom_funcion VARCHAR(30),
  potr_dom_sector VARCHAR(30),
  potr_tiempo NUMERIC,
  potr_fec_inicio TIMESTAMP WITHOUT TIME ZONE,
  potr_fec_termino TIMESTAMP WITHOUT TIME ZONE,
  potr_fec_ingreso TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (potr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_pos_usuario (
  pous_rut NUMERIC,
  pous_dv VARCHAR(1),
  pous_nombre VARCHAR(50),
  pous_ape_paterno VARCHAR(50),
  pous_ape_materno VARCHAR(50),
  pous_dom_sexo VARCHAR(30),
  pais_sec NUMERIC,
  regi_sec NUMERIC,
  prov_sec NUMERIC,
  comu_sec NUMERIC,
  pous_direccion VARCHAR(400),
  pous_correo VARCHAR(100),
  pous_key_acceso VARCHAR(20),
  pous_fecha_creacion TIMESTAMP WITHOUT TIME ZONE,
  pous_telefono VARCHAR(20),
  pous_estado VARCHAR(10),
  pous_obs VARCHAR(2000),
  PRIMARY KEY (pous_rut)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_prevision_trab (
  trbprv_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  trbprv_dom_tipo_instprev VARCHAR(30),
  trbprv_dom_tipo_moneda VARCHAR(30),
  trbprv_monto_pactado NUMERIC(10, 4),
  trbprv_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  trbprv_usr_ing VARCHAR(50),
  trbprv_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  trbprv_usr_mod VARCHAR(50),
  trbprv_dom_estado VARCHAR(30),
  rein_sec NUMERIC(30, 0),
  trbprv_fec_suscrip TIMESTAMP WITHOUT TIME ZONE,
  trbprv_fecfin_suscrip TIMESTAMP WITHOUT TIME ZONE,
  arch_sec NUMERIC,
  trbprv_dom_tipoctzsalud VARCHAR(30),
  PRIMARY KEY (trbprv_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_procesos_remun (
  prm_proc_sec NUMERIC(23, 0),
  prm_dom_proceso VARCHAR(30),
  prm_dom_est_proc_rmn VARCHAR(30),
  prm_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  prm_user_ing VARCHAR(50),
  prm_fech_proc TIMESTAMP WITHOUT TIME ZONE,
  prm_fech_ini_eje TIMESTAMP WITHOUT TIME ZONE,
  prm_fech_fin_eje TIMESTAMP WITHOUT TIME ZONE,
  p_empmc_sec NUMERIC,
  p_secto_cod VARCHAR(30),
  p_esta_sec NUMERIC,
  p_trab_sec NUMERIC,
  p_cont_sec NUMERIC,
  cod_err NUMERIC,
  des_err VARCHAR(4000),
  p_peri_cod INTEGER,
  p_factor_reajuste NUMERIC(7, 4),
  p_sindicato VARCHAR(2),
  p_sind_codigo VARCHAR(60),
  PRIMARY KEY (prm_proc_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_proceso_previred (
  pprev_peri_cod INTEGER,
  pprev_rut BIGINT,
  pprev_dv VARCHAR(1),
  pprev_apell_pat VARCHAR(30),
  pprev_apell_mat VARCHAR(30),
  pprev_nombres VARCHAR(30),
  pprev_sexo VARCHAR(1),
  pprev_nacionalidad INTEGER,
  pprev_tipo_pag INTEGER,
  pprev_periodo_desde INTEGER,
  pprev_perido_hasta INTEGER,
  pprev_reg_previsional VARCHAR(3),
  pprev_tipo_trabajador INTEGER,
  pprev_dias_trabajados INTEGER,
  pprev_tipo_linea VARCHAR(2),
  pprev_cod_mov_personal INTEGER,
  pprev_fecha_desde VARCHAR(10),
  pprev_fecha_hasta VARCHAR(10),
  pprev_tramo_asig_fam VARCHAR(1),
  pprev_num_cargas_simples INTEGER,
  pprev_num_cargas_matenales INTEGER,
  pprev_num_cargas_invalidas INTEGER,
  pprev_asig_fam INTEGER,
  pprev_asig_fam_retro INTEGER,
  pprev_reintegro_cargas_fam INTEGER,
  pprev_sub_trab_joven VARCHAR(1),
  pprev_codigo_afp INTEGER,
  pprev_monto_imp_afp INTEGER,
  pprev_monto_cotiza_afp INTEGER,
  pprev_monto_seg_inv_sis INTEGER,
  pprev_monto_ahorro_vol_afp INTEGER,
  pprev_monto_renta_imp_sustit INTEGER,
  pprev_tasa_pactada_sustit NUMERIC(5, 2),
  pprev_aporte_indem_sustit INTEGER,
  pprev_nro_periodos_sustit INTEGER,
  pprev_periodo_desde_sustit VARCHAR(10),
  pprev_periodo_hasta_sustit VARCHAR(10),
  pprev_monto_puesto_trab_pesado VARCHAR(40),
  pprev_porc_cotiza_trab_pesado NUMERIC(5, 2),
  pprev_monto_trab_pesado INTEGER,
  pprev_codigo_inst_apvi INTEGER,
  pprev_numero_contrato_apvi VARCHAR(20),
  pprev_forma_pago_apvi INTEGER,
  pprev_monto_apvi INTEGER,
  pprev_monto_conven INTEGER,
  pprev_codigo_inst_apvc INTEGER,
  pprev_numero_contrato_apvc VARCHAR(6),
  pprev_forma_pago_apvc INTEGER,
  pprev_monto_trab_apvc INTEGER,
  pprev_monto_empl_apvc INTEGER,
  pprev_rut_afil_voluntario BIGINT,
  pprev_dv_afil_voluntario VARCHAR(1),
  pprev_apell_paterno_vol VARCHAR(30),
  pprev_apell_materno_vol VARCHAR(30),
  pprev_nombres_vol VARCHAR(30),
  pprev_codi_mov_personal INTEGER,
  pprev_fecha_desde_vol VARCHAR(10),
  pprev_fecha_hasta_vol VARCHAR(10),
  pprev_codigo_afp_vol INTEGER,
  pprev_monto_cap_voluntaria INTEGER,
  pprev_monto_ahorro_voluntario INTEGER,
  pprev_numero_per_cotizacion INTEGER,
  pprev_codigo_excaja_regimen INTEGER,
  pptav_tasa_cotiza_prev NUMERIC(10, 3),
  pprev_monto_imp_ips INTEGER,
  pprev_monto_cotiza_ips INTEGER,
  pprev_monto_imp_deshaucio INTEGER,
  pprev_codigo_regimen_desahucio INTEGER,
  pptav_monto_taza_cot_prev NUMERIC(10, 3),
  pprev_cotiza_desahucio INTEGER,
  pprev_cotiza_fonasa INTEGER,
  pprev_cotiza_acc_trab INTEGER,
  pprev_monto_perm INTEGER,
  pprev_monto_dscto_cargas_isl INTEGER,
  pprev_monto_bon_gobierno INTEGER,
  pprev_codigo_inst_salud INTEGER,
  pprev_numero_fun VARCHAR(16),
  pprev_monto_imp_isapre INTEGER,
  pprev_moneda_plan_isapre INTEGER,
  pprev_cotiza_pactada NUMERIC(10, 3),
  pprev_cotiza_obligatoria INTEGER,
  pprev_cotiza_adicicional INTEGER,
  pprev_monto_ges INTEGER,
  pprev_codigo_ccaf INTEGER,
  pprev_monto_imp_ccaf INTEGER,
  pprev_monto_credito_ccaf INTEGER,
  pprev_monto_dsctos_dental_ccaf INTEGER,
  ppdev_monto_dsctos_leasing INTEGER,
  pprev_monto_dsctos_vida_ccaf INTEGER,
  pprev_monto_otros_dsctos_ccaf INTEGER,
  pprev_monto_noafil_isapre INTEGER,
  pprev_dscto_cargas_fam_ccaf INTEGER,
  pprev_otros_dscto_ccaf1 INTEGER,
  pprev_otros_dscto_ccaf2 INTEGER,
  pprev_bonos_gob_ccaf INTEGER,
  pprev_codigo_sucursal VARCHAR(20),
  pprev_codigo_mutualidad INTEGER,
  pprev_monto_imp_mutual INTEGER,
  ppcov_cotiza_acc_mutual INTEGER,
  pprev_codigo_su_pago_mutual INTEGER,
  pprev_monto_imp_seg_cesantia INTEGER,
  ppapv_monto_aporte_trab_cesant INTEGER,
  ppapv_monto_aporte_emp_cesant INTEGER,
  pprev_rut_pagadora_servicio BIGINT,
  pprev_dv_pagadora_subsidio VARCHAR(1),
  ppcev_centro_costo VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_proc_remun_param (
  param_sec NUMERIC(23, 0),
  prm_proc_sec NUMERIC(23, 0),
  param_cod VARCHAR(30),
  param_valor VARCHAR(30),
  PRIMARY KEY (param_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_provincias (
  prov_sec NUMERIC,
  prov_nombre VARCHAR(101),
  regi_sec NUMERIC,
  PRIMARY KEY (prov_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_puntaje_anual (
  puan_dom_categoria VARCHAR(30),
  puan_puntaje NUMERIC(10, 2),
  PRIMARY KEY (puan_dom_categoria)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_puntaje_ini_cf (
  pers_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  ptje_ini NUMERIC,
  flag_proc INTEGER
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_puntaje_ini_cf_bkp (
  pers_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  ptje_ini NUMERIC,
  flag_proc INTEGER
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_punt_capa (
  puca_sec NUMERIC(23, 0),
  puca_desde INTEGER,
  puca_hasta INTEGER,
  puca_puntaje INTEGER,
  PRIMARY KEY (puca_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_reclutamiento (
  recl_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  recl_dom_sector VARCHAR(30),
  recl_dom_cargo VARCHAR(30),
  recl_descripcion VARCHAR(500),
  recl_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  recl_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  recl_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  recl_user_ing VARCHAR(30),
  recl_ref VARCHAR(300),
  recl_fech_ini_post TIMESTAMP WITHOUT TIME ZONE,
  recl_fech_fin_post TIMESTAMP WITHOUT TIME ZONE,
  recl_dom_estado_reclu VARCHAR(30),
  recl_observacion VARCHAR(200),
  recl_dom_lice_conducir VARCHAR(30),
  recl_vac NUMERIC,
  recl_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  recl_user_mov BIGINT,
  recl_vac_act INTEGER,
  PRIMARY KEY (recl_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_reclutamiento_mov (
  remo_sec NUMERIC(23, 0),
  remo_vac NUMERIC(23, 0),
  remo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  remo_user_mov VARCHAR(30),
  remo_observacion VARCHAR(200),
  remo_dom_lice_conducir VARCHAR(30),
  recl_sec NUMERIC(23, 0),
  remo_operacion VARCHAR(1),
  remo_dom_estado_reclu VARCHAR(30),
  PRIMARY KEY (remo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_referencias (
  refe_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  refe_nombre VARCHAR(200),
  refe_cargo VARCHAR(100),
  refe_fono VARCHAR(10),
  refe_email VARCHAR(50),
  refe_origen_txs VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_region (
  regi_sec NUMERIC,
  regi_nombre VARCHAR(100),
  regi_abreviatura VARCHAR(20),
  regi_capital VARCHAR(100),
  PRIMARY KEY (regi_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_rela_estacc (
  reec_sec NUMERIC,
  esta_sec NUMERIC(23, 0),
  ceco_sec NUMERIC(23, 0),
  reec_dom_estado VARCHAR(30),
  PRIMARY KEY (reec_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_rela_institucion (
  rein_sec NUMERIC(23, 0),
  rein_dom_inst VARCHAR(30),
  rein_dom_key VARCHAR(30),
  rein_cod_super VARCHAR(30),
  rein_dom_estado VARCHAR(30),
  rein_fech_estado_ing TIMESTAMP WITHOUT TIME ZONE,
  rein_fech_estado_mod TIMESTAMP WITHOUT TIME ZONE,
  rein_user_ing BIGINT,
  rein_user_mod BIGINT,
  PRIMARY KEY (rein_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_remun_novedad (
  rmnov_sec NUMERIC(23, 0),
  peri_cod INTEGER,
  trab_sec NUMERIC(23, 0),
  cont_sec NUMERIC(30, 0),
  vari_cod VARCHAR(20),
  dom_tipo_valor VARCHAR(30),
  dom_tipo_moneda VARCHAR(30),
  rmnov_valor NUMERIC(12, 2),
  rmnov_frecuencia VARCHAR(1),
  rmnov_tipo_registro VARCHAR(1),
  rmnov_fec_ingr TIMESTAMP WITHOUT TIME ZONE,
  rmnov_usr_ingr VARCHAR(50),
  rmnov_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  rmnov_usr_mod VARCHAR(50),
  rmnov_fec_desde TIMESTAMP WITHOUT TIME ZONE,
  rmnov_fec_hasta TIMESTAMP WITHOUT TIME ZONE,
  rmnov_cuota_desde INTEGER,
  rmnov_cuota_hasta INTEGER,
  ceco_cod VARCHAR(30),
  arch_sec NUMERIC(23, 0),
  PRIMARY KEY (rmnov_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_remun_resu_periodo (
  peri_cod INTEGER,
  repe_sector VARCHAR(30),
  repe_vari_habe_desc VARCHAR(1),
  repe_vari_cod VARCHAR(30),
  repe_vari_nombre VARCHAR(50),
  repe_tot_monto BIGINT,
  repe_cant_func BIGINT,
  repe_peri_cod_ant INTEGER,
  repe_tot_monto_ant BIGINT,
  repe_cant_func_ant BIGINT
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_reporte (
  repo_sec NUMERIC(23, 0),
  repo_peri_anual INTEGER,
  repo_peri_cod INTEGER,
  repo_nombre_reporte VARCHAR(30),
  repo_dom_estado VARCHAR(30),
  repo_usr_ing VARCHAR(30),
  repo_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  repo_usr_mod VARCHAR(30),
  repo_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  repo_grp_sec NUMERIC(23, 0),
  repo_dom_reporte VARCHAR(30),
  PRIMARY KEY (repo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_reporte_basepersonal (
  reba_peri_cod INTEGER,
  reba_numero_linea BIGINT,
  reba_documento TEXT
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_reporte_previred (
  peri_cod INTEGER,
  repr_numero_linea BIGINT,
  repr_rut BIGINT,
  repr_registro VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_reporte_supereduc (
  resu_sec NUMERIC(23, 0),
  resu_peri_anual INTEGER,
  resu_esta_sec NUMERIC(23, 0),
  resu_esta_rbd BIGINT,
  resu_esta_desc VARCHAR(200),
  resu_documento TEXT
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_representante (
  repr_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  repr_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  repr_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  repr_dom_estado VARCHAR(30),
  repr_dom_fun_repre VARCHAR(30),
  PRIMARY KEY (repr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_resp_eval (
  reev_sec NUMERIC(23, 0),
  eval_sec NUMERIC(23, 0),
  depr_sec NUMERIC(23, 0),
  reev_nivel NUMERIC,
  PRIMARY KEY (reev_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_reunion_comite (
  reco_sec NUMERIC(23, 0),
  copa_sec NUMERIC(23, 0),
  reco_nombre VARCHAR(300),
  reco_dom_estado VARCHAR(30),
  reco_fecha TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (reco_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_roles (
  role_id VARCHAR(50),
  role_desc VARCHAR(100),
  role_usuario_ins VARCHAR(20),
  role_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (role_id)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_roles_aplicacion (
  role_id VARCHAR(50),
  apli_id VARCHAR(60),
  peap_usuario_ins VARCHAR(20),
  peap_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  peap_guardar VARCHAR(1),
  peap_editar VARCHAR(1),
  peap_eliminar VARCHAR(1),
  peap_ver VARCHAR(1),
  peap_movimiento VARCHAR(1),
  peap_imprimir VARCHAR(1),
  peap_exportar VARCHAR(1),
  peap_cargar VARCHAR(1),
  PRIMARY KEY (role_id, apli_id)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_roles_usuarios (
  usua_rut BIGINT,
  role_id INTEGER,
  reus_usuario_ins VARCHAR(20),
  reus_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  reus_usuario_upd VARCHAR(20),
  reus_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usua_rut, role_id)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sacutrab_mov (
  stmo_sec NUMERIC(23, 0),
  satr_sec NUMERIC(23, 0),
  stmo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  stmo_user_mov BIGINT,
  stmo_pers_sec_hijo NUMERIC(23, 0),
  stmo_dom_jornada_sala_cuna VARCHAR(30),
  stmo_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  stmo_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  stmo_fech_reingreso TIMESTAMP WITHOUT TIME ZONE,
  stmo_observacion VARCHAR(500),
  stmo_dom_estado VARCHAR(30),
  stmo_operacion VARCHAR(1),
  PRIMARY KEY (stmo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sacu_pagos (
  sapa_sec NUMERIC,
  sapa_ticket NUMERIC,
  satr_sec NUMERIC,
  sapa_year NUMERIC,
  sapa_mes NUMERIC,
  sapa_monto NUMERIC,
  PRIMARY KEY (sapa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sacu_trab (
  satr_sec NUMERIC(23, 0),
  sacu_sec NUMERIC(23, 0),
  pers_sec_hijo NUMERIC(23, 0),
  satr_dom_jornada_sala_cuna VARCHAR(30),
  trab_sec NUMERIC(23, 0),
  satr_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  satr_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  satr_fech_reingreso TIMESTAMP WITHOUT TIME ZONE,
  satr_observacion VARCHAR(500),
  satr_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  satr_user_ing BIGINT,
  satr_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  satr_user_mod BIGINT,
  satr_dom_estado VARCHAR(30),
  satr_notificacion VARCHAR(1),
  satr_noti_termino VARCHAR(1),
  PRIMARY KEY (satr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sala_cuna (
  sacu_sec NUMERIC(23, 0),
  sacu_nomb_fant VARCHAR(300),
  sacu_rut BIGINT,
  sacu_div VARCHAR(1),
  sacu_razon_soc VARCHAR(300),
  sacu_telefono VARCHAR(20),
  sacu_dire VARCHAR(500),
  sacu_email VARCHAR(100),
  sacu_dom_estado VARCHAR(30),
  sacu_observacion VARCHAR(500),
  sacu_dom_situa_ministerial VARCHAR(30),
  sacu_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  sacu_user_ing BIGINT,
  sacu_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  sacu_user_mod BIGINT,
  PRIMARY KEY (sacu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sala_cuna_mov (
  samo_sec NUMERIC(23, 0),
  sacu_sec NUMERIC(23, 0),
  samo_telefono VARCHAR(20),
  samo_dire VARCHAR(500),
  samo_email VARCHAR(100),
  samo_dom_estado VARCHAR(30),
  samo_observacion VARCHAR(500),
  samo_dom_situa_ministerial VARCHAR(30),
  samo_fech_mov TIMESTAMP WITHOUT TIME ZONE,
  samo_user_mov BIGINT,
  samo_operacion VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_saldo_ini_cf (
  pers_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  saldo_ptje NUMERIC,
  flag_proc INTEGER
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sc_trab (
  satr_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  satr_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  satr_user_ing VARCHAR(30),
  satr_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  satr_user_mod BIGINT,
  PRIMARY KEY (satr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sc_trab_mov (
  stmo_sec NUMERIC(23, 0),
  satr_sec NUMERIC(23, 0),
  sacu_sec NUMERIC(23, 0),
  pers_sec_hijo NUMERIC(23, 0),
  stmo_dom_jornada_sala_cuna VARCHAR(30),
  stmo_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  stmo_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  stmo_fech_reingreso TIMESTAMP WITHOUT TIME ZONE,
  stmo_observacion VARCHAR(500),
  stmo_notificacion VARCHAR(1),
  stmo_noti_termino VARCHAR(1),
  stmo_dom_estado VARCHAR(30),
  stmo_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  stmo_user_ing VARCHAR(30),
  stmo_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  stmo_user_mod BIGINT,
  PRIMARY KEY (stmo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_seccion_reporte (
  sere_sec NUMERIC(23, 0),
  peri_anual INTEGER,
  sere_codigo VARCHAR(20),
  sere_descripcion VARCHAR(50),
  sere_orden INTEGER,
  sere_dom_estado VARCHAR(30),
  sere_tipo_seccion VARCHAR(30),
  repo_sec NUMERIC(23, 0),
  PRIMARY KEY (sere_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_seguro_cesantia (
  peri_cod INTEGER,
  segcs_dom_tpo_cntrt VARCHAR(30),
  segcs_fac_trab NUMERIC(12, 2),
  segcs_fac_empl NUMERIC(12, 2),
  segcs_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  segcs_usr_ing VARCHAR(50),
  segcs_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  segcs_usr_mod VARCHAR(50),
  PRIMARY KEY (peri_cod, segcs_dom_tpo_cntrt)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sindicato (
  sind_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  sind_nombre VARCHAR(500),
  sind_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  sind_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  sind_dom_estado VARCHAR(30),
  sind_codigo VARCHAR(30),
  sind_dom_tipo_asociacion VARCHAR(30),
  sind_fech_negoc TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (sind_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sindicato_cm (
  sicm_sec NUMERIC,
  sind_sec NUMERIC,
  sicm_dom_cate_fallecido VARCHAR(30),
  sicm_monto NUMERIC,
  sicm_fecha_inicio TIMESTAMP WITHOUT TIME ZONE,
  sicm_fecha_fin TIMESTAMP WITHOUT TIME ZONE,
  sicm_dom_estado VARCHAR(30),
  sicm_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  sicm_user_ing VARCHAR(30),
  sicm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  sicm_user_mod VARCHAR(30),
  PRIMARY KEY (sicm_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_sind_trab (
  sitr_sec NUMERIC,
  sind_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  sitr_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  sitr_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  sitr_conv_colect VARCHAR(2),
  sitr_con_fuero VARCHAR(2),
  sitr_dom_fun_sindical VARCHAR(30),
  sitr_fech_ini_fun TIMESTAMP WITHOUT TIME ZONE,
  sitr_fech_fin_fun TIMESTAMP WITHOUT TIME ZONE,
  sitr_dom_estado VARCHAR(30),
  sitr_monto NUMERIC(14, 3),
  sitr_dom_tipo_moneda VARCHAR(30),
  PRIMARY KEY (sitr_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tasas_excajas (
  teca_codigo VARCHAR(30),
  teca_con_mutual VARCHAR(2),
  teca_con_ccaf VARCHAR(2),
  teca_trab_fonasa VARCHAR(2),
  teca_trab_isapre VARCHAR(2),
  teca_tasa NUMERIC(4, 2)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_telefono (
  tele_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  tele_domi_tipo_telefono VARCHAR(10),
  tele_numero VARCHAR(20),
  tele_estado VARCHAR(10),
  tele_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  tele_user_ing VARCHAR(30),
  tele_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  tele_user_mod VARCHAR(30),
  tele_dom_origen_tel VARCHAR(30),
  PRIMARY KEY (tele_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_telefono_empresa (
  teem_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  teem_dom_tipo_telefono VARCHAR(30),
  teem_numero VARCHAR(20),
  teem_dom_estado_telefono VARCHAR(30),
  teem_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  teem_user_ing VARCHAR(30),
  teem_fech_mod TIMESTAMP WITHOUT TIME ZONE,
  teem_user_mod BIGINT,
  PRIMARY KEY (teem_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_text_mail (
  tema_tipo VARCHAR(50),
  tema_subject VARCHAR(500),
  tema_cuerpo TEXT,
  PRIMARY KEY (tema_tipo)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tipo (
  tipo_sec NUMERIC(23, 0),
  tipo_nombre VARCHAR(200),
  tipo_tabla_bd VARCHAR(200),
  tipo_reg VARCHAR(100),
  PRIMARY KEY (tipo_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tipo_atributo (
  tipo_sec NUMERIC(23, 0),
  tiat_nombre VARCHAR(200),
  tiat_pos INTEGER,
  tiat_desc VARCHAR(200),
  PRIMARY KEY (tipo_sec, tiat_nombre)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tipo_documento (
  tido_sec NUMERIC(23, 0),
  tido_nombre VARCHAR(100),
  tido_desc VARCHAR(200),
  tido_dom_estado VARCHAR(30),
  PRIMARY KEY (tido_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_titularidad_doc (
  tido_rut NUMERIC,
  tido_dv VARCHAR(1),
  tido_horas_base NUMERIC,
  tido_horas_15 NUMERIC,
  tido_desgloce_15 VARCHAR(300),
  tido_horas_16 NUMERIC,
  tido_desgloce_16 VARCHAR(300),
  tido_horas_17 NUMERIC,
  tido_desgloce_17 VARCHAR(300),
  tido_horas_18 NUMERIC,
  tido_desgloce_18 VARCHAR(300),
  tido_horas_19 NUMERIC,
  tido_desgloce_19 VARCHAR(300),
  tido_conclucion VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_asig_familiar (
  arch_sec NUMERIC,
  tasfa_sec NUMERIC(23, 0),
  tasfa_nro_linea NUMERIC,
  tasfa_rut_beneficiario NUMERIC,
  tasfa_dv_beneficiario VARCHAR(1),
  tasfa_peri_cod INTEGER,
  tasfa_dom_tramo VARCHAR(30),
  tasfa_dom_tipo_carga VARCHAR(30),
  tasfa_monto_carga BIGINT,
  tasfa_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  tasfa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  tasfa_monto_retro BIGINT,
  tasfa_linea VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_carga_fam (
  arch_sec NUMERIC,
  tcfa_sec NUMERIC,
  tcfa_nro_linea NUMERIC,
  tcfa_rut_afiliado NUMERIC,
  tcfa_dv_afiliado VARCHAR(1),
  tcfa_rut_carga NUMERIC,
  tcfa_dv_carga VARCHAR(1),
  tcfa_nombre_carga VARCHAR(200),
  tcfa_sexo_carga VARCHAR(1),
  tcfa_parenteso VARCHAR(30),
  tcfa_tipo_carga VARCHAR(30),
  tcfa_fec_inicio TIMESTAMP WITHOUT TIME ZONE,
  tcfa_fec_termino TIMESTAMP WITHOUT TIME ZONE,
  tcfa_fec_nacimiento TIMESTAMP WITHOUT TIME ZONE,
  tcfa_tramo VARCHAR(30),
  tcfa_linea VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_documento (
  peri_anual INTEGER,
  num_registro BIGINT,
  doc_formato TEXT,
  nombre_completo VARCHAR(250),
  rut VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_haber_descuento (
  thd_arch_sec NUMERIC(23, 0),
  thd_sec NUMERIC(23, 0),
  thd_nro_linea BIGINT,
  thd_peri_cod INTEGER,
  thd_rut BIGINT,
  thd_vari_cod VARCHAR(20),
  thd_monto BIGINT,
  thd_linea VARCHAR(4000),
  thd_empmc_sec NUMERIC(23, 0),
  thd_fec_desde TIMESTAMP WITHOUT TIME ZONE,
  thd_fec_hasta TIMESTAMP WITHOUT TIME ZONE,
  thd_cuota_desde INTEGER,
  thd_cuota_hasta INTEGER,
  thd_ceco_cod VARCHAR(30),
  PRIMARY KEY (thd_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_lice_estado (
  tlie_arch_sec NUMERIC,
  tlie_sec NUMERIC,
  tlie_nro_linea NUMERIC,
  tlie_nro_licencia VARCHAR(20),
  tlie_rut NUMERIC,
  tlie_estado VARCHAR(30),
  tlie_observacion VARCHAR(300),
  tlie_linea VARCHAR(4000),
  tlie_trab_sec NUMERIC,
  tlie_lime_sec NUMERIC,
  tlie_reg_error VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_lice_pago (
  tlpa_arch_sec NUMERIC,
  tlpa_sec NUMERIC(23, 0),
  tlpa_nro_linea NUMERIC,
  tlpa_nro_licencia NUMERIC(23, 0),
  tlpa_rut VARCHAR(20),
  tlpa_num_doc VARCHAR(50),
  tlpa_tipo_doc VARCHAR(30),
  tlpa_fech_pago TIMESTAMP WITHOUT TIME ZONE,
  tlpa_dias_pag INTEGER,
  tlpa_monto NUMERIC(23, 0),
  tlpa_cuota INTEGER,
  tlpa_dom_concepto VARCHAR(30),
  tlpa_dom_banco VARCHAR(30),
  tlpa_linea VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_salud_afp (
  tsa_arch_sec NUMERIC(23, 0),
  tsa_sec NUMERIC(23, 0),
  tsa_nro_linea BIGINT,
  tsa_peri_cod INTEGER,
  tsa_rut BIGINT,
  tsa_folio_fun VARCHAR(30),
  tsa_dom_tipo_inst VARCHAR(30),
  tsa_nom_inst VARCHAR(30),
  tsa_cod_inst VARCHAR(30),
  tsa_monto NUMERIC(10, 3),
  tsa_dom_moneda VARCHAR(30),
  tsa_linea VARCHAR(4000),
  tsa_tipo_cotizacion VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_tmp_vari_bapers (
  vaba_peri_cod INTEGER,
  vaba_vari_cod VARCHAR(30),
  vaba_tipo_hab_desc VARCHAR(1),
  vaba_num_linea NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_trabajador (
  trab_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  trab_fech_ing TIMESTAMP WITHOUT TIME ZONE,
  trab_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  trab_sind VARCHAR(2),
  trab_conv VARCHAR(2),
  trab_dom_profesion_actividad VARCHAR(30),
  trab_dias_prog BIGINT,
  trab_dom_nivel VARCHAR(30),
  trab_dom_categoria VARCHAR(30),
  trab_bienios INTEGER,
  trab_bienios_fin INTEGER,
  trab_experencia_ini NUMERIC,
  trab_email_corp VARCHAR(100),
  trab_dom_nivel_educa VARCHAR(30),
  trab_dom_sector VARCHAR(30),
  trab_con_idoneidad VARCHAR(2),
  trab_fech_cum_bie TIMESTAMP WITHOUT TIME ZONE,
  trab_con_carr_doc VARCHAR(2),
  trab_seguro_cesantia VARCHAR(2),
  trab_chk VARCHAR(300),
  arch_sec NUMERIC,
  PRIMARY KEY (trab_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_trabajador_lice (
  trli_sec NUMERIC,
  trli_rut VARCHAR(20),
  trli_dom_tipo_prefisional VARCHAR(30),
  trli_nombre VARCHAR(200),
  trli_reg_colegio_pro VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_trayect_post (
  trpo_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  trpo_dom_cargo VARCHAR(30),
  trpo_dom_funcion VARCHAR(30),
  trpo_dom_sector VARCHAR(30),
  trpo_tiempo NUMERIC,
  trpo_desde TIMESTAMP WITHOUT TIME ZONE,
  trpo_hasta TIMESTAMP WITHOUT TIME ZONE,
  trpo_origen_txs VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_users_admin (
  usad_rut BIGINT,
  PRIMARY KEY (usad_rut)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_usuarios (
  usua_rut BIGINT,
  usua_nombre VARCHAR(50),
  usua_email VARCHAR(50),
  usua_telefono VARCHAR(15),
  usua_celular VARCHAR(15),
  usua_usuario_ins VARCHAR(20),
  usua_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usua_usuario_upd VARCHAR(20),
  usua_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usua_rut)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_vacaciones_acum (
  vacm_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  vacm_periodo INTEGER,
  vacm_dias NUMERIC(7, 3),
  vacm_dom_estado VARCHAR(20),
  cont_sector VARCHAR(30),
  vacm_fec_ingr TIMESTAMP WITHOUT TIME ZONE,
  vacm_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (vacm_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_vaca_trab_peri (
  vatp_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  vatp_peri_ini INTEGER,
  vatp_peri_fin INTEGER,
  vatp_dias_peri_vac NUMERIC(6, 2),
  vatp_dias_solic_vac NUMERIC(6, 2),
  vatp_dias_dispo_vac NUMERIC(6, 2),
  vatp_dias_excep_vac NUMERIC(6, 2),
  vatp_dias_planilla_vac NUMERIC(6, 2),
  vatp_dias_progresivo NUMERIC(6, 2),
  vatp_dias_solic_prog NUMERIC(6, 2),
  vatp_dias_dispo_prog NUMERIC(6, 2),
  vatp_estado VARCHAR(30),
  vatp_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  vatp_user_ing VARCHAR(30),
  vatp_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  vatp_user_mod VARCHAR(30),
  PRIMARY KEY (vatp_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_vaca_trab_peri_bkp (
  vatp_sec NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  vatp_peri_ini INTEGER,
  vatp_peri_fin INTEGER,
  vatp_dias_peri_vac NUMERIC(6, 2),
  vatp_dias_solic_vac NUMERIC(6, 2),
  vatp_dias_dispo_vac NUMERIC(6, 2),
  vatp_dias_excep_vac NUMERIC(6, 2),
  vatp_dias_planilla_vac NUMERIC(6, 2),
  vatp_dias_progresivo NUMERIC(6, 2),
  vatp_dias_solic_prog NUMERIC(6, 2),
  vatp_dias_dispo_prog NUMERIC(6, 2),
  vatp_estado VARCHAR(30),
  vatp_fecha_ing TIMESTAMP WITHOUT TIME ZONE,
  vatp_user_ing VARCHAR(30),
  vatp_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  vatp_user_mod VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_vaca_trab_peri_tmp (
  rut_trab NUMERIC(23, 0),
  trab_sec NUMERIC(23, 0),
  cont_sec NUMERIC(23, 0),
  tmp_peri_ini INTEGER,
  tmp_peri_fin INTEGER,
  tmp_dias_vacaciones NUMERIC(5, 2),
  tmp_dias_progresivo INTEGER,
  tmp_origen_carga VARCHAR(30),
  tmp_tab_excel INTEGER,
  tmp_estado VARCHAR(60),
  PRIMARY KEY (rut_trab, tmp_peri_ini, tmp_peri_fin)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_valores_sala_cuna (
  vasa_sec NUMERIC(23, 0),
  vasa_fech_ini TIMESTAMP WITHOUT TIME ZONE,
  vasa_fech_fin TIMESTAMP WITHOUT TIME ZONE,
  vasa_monto BIGINT,
  vasa_dom_jornada_sala_cuna VARCHAR(30),
  sacu_sec NUMERIC(23, 0),
  PRIMARY KEY (vasa_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_valorhora_docente (
  evah_sec NUMERIC(23, 0),
  peri_anual INTEGER,
  trab_sec NUMERIC(23, 0),
  evah_rut BIGINT,
  evah_zonaexthora NUMERIC(14, 2),
  evah_exthoraria NUMERIC(14, 2),
  evah_otrasextensiones NUMERIC(14, 2),
  evah_pericod_desde INTEGER,
  evah_pericod_hasta INTEGER,
  PRIMARY KEY (evah_sec, evah_rut)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_variables (
  vari_sec NUMERIC(23, 0),
  vari_cod VARCHAR(20),
  vari_nombre VARCHAR(50),
  vari_desc_larg VARCHAR(150),
  vari_imprime VARCHAR(2),
  vari_copy_mes VARCHAR(2),
  vari_habe_desc VARCHAR(1),
  vari_dom_tipo_vari VARCHAR(15),
  vari_dom_tipo_valor VARCHAR(30),
  vari_dom_orig_valor VARCHAR(30),
  vari_cta_cont1 VARCHAR(30),
  vari_cta_cont2 VARCHAR(30),
  vari_es_imponible VARCHAR(2),
  vari_es_tributable VARCHAR(2),
  vari_nivel BIGINT,
  vari_suma_concepto VARCHAR(2),
  vari_ingr_trab VARCHAR(2),
  vari_visible VARCHAR(2),
  vari_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  vari_usr_ing VARCHAR(50),
  vari_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  vari_usr_mod VARCHAR(30),
  PRIMARY KEY (vari_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_variables_agrupadas (
  grp_sec NUMERIC(23, 0),
  vari_sec NUMERIC(23, 0),
  grp_var_fecing TIMESTAMP WITHOUT TIME ZONE,
  vari_cod VARCHAR(20),
  vargrp_sec NUMERIC(23, 0),
  PRIMARY KEY (vargrp_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_variables_enuso (
  varusu_sec NUMERIC(23, 0),
  empmc_sec NUMERIC(23, 0),
  vari_cod VARCHAR(20),
  vari_nombre VARCHAR(50),
  vari_desc_larg VARCHAR(150),
  vari_imprime VARCHAR(2),
  vari_copy_mes VARCHAR(2),
  vari_habe_desc VARCHAR(1),
  vari_dom_tipo_vari VARCHAR(15),
  vari_dom_tipo_valor VARCHAR(30),
  vari_dom_orig_valor VARCHAR(30),
  vari_cta_cont1 VARCHAR(30),
  vari_cta_cont2 VARCHAR(30),
  vari_es_imponible VARCHAR(2),
  vari_es_tributable VARCHAR(2),
  vari_nivel BIGINT,
  vari_suma_concepto VARCHAR(2),
  vari_ingr_trab VARCHAR(2),
  vari_visible VARCHAR(2),
  vari_editable VARCHAR(2),
  vari_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  vari_usr_ing VARCHAR(50),
  vari_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  vari_usr_mod VARCHAR(30),
  vari_orden_liq INTEGER,
  vari_valor NUMERIC(15, 5),
  PRIMARY KEY (varusu_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_variables_sistema (
  empmc_sec NUMERIC(23, 0),
  peri_cod NUMERIC,
  varusu_sec NUMERIC(23, 0),
  vari_cod VARCHAR(20),
  vari_valor NUMERIC(14, 5),
  PRIMARY KEY (empmc_sec, peri_cod, vari_cod)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_variable_reque (
  vare_sec NUMERIC(23, 0),
  empr_sec NUMERIC(23, 0),
  vare_orden NUMERIC,
  vargrp_sec NUMERIC(23, 0),
  empr_grp_sec VARCHAR(23),
  PRIMARY KEY (vare_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_varis_formula (
  fmr_vari_sec NUMERIC(23, 0),
  varusu_sec NUMERIC(23, 0),
  frm_sec NUMERIC(23, 0),
  fec_ing TIMESTAMP WITHOUT TIME ZONE,
  usr_ing VARCHAR(20),
  vari_sec_dest NUMERIC(23, 0),
  valor_temp NUMERIC(20, 2),
  PRIMARY KEY (fmr_vari_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.rhu_varuso_grupo (
  vargrp_sec NUMERIC(23, 0),
  varusu_sec NUMERIC(23, 0),
  empgrp_sec NUMERIC(23, 0),
  varfrp_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  vargrp_usr_ing VARCHAR(50),
  vargrp_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  vargrp_usr_mod VARCHAR(30),
  PRIMARY KEY (vargrp_sec)
);

CREATE TABLE IF NOT EXISTS adm_rhu.sqln_explain_plan (
  statement_id VARCHAR(30),
  "timestamp" TIMESTAMP WITHOUT TIME ZONE,
  remarks VARCHAR(80),
  operation VARCHAR(30),
  options VARCHAR(30),
  object_node VARCHAR(128),
  object_owner VARCHAR(30),
  object_name VARCHAR(30),
  object_instance NUMERIC,
  object_type VARCHAR(30),
  optimizer VARCHAR(255),
  search_columns NUMERIC,
  id NUMERIC,
  parent_id NUMERIC,
  position NUMERIC,
  cost NUMERIC,
  cardinality NUMERIC,
  bytes NUMERIC,
  other_tag VARCHAR(255),
  partition_start VARCHAR(255),
  partition_stop VARCHAR(255),
  partition_id NUMERIC,
  other TEXT,
  distribution VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_rhu.x_doce (
  rut_empleado NUMERIC,
  dv VARCHAR(300),
  paterno VARCHAR(300),
  materno VARCHAR(300),
  nombre VARCHAR(300),
  descripcion VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_rhu.x_rut (
  rut NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_anotaciones_alu_1 (
  anal_cod NUMERIC,
  ecal_cod NUMERIC,
  anal_obal_padeduca NUMERIC,
  anal_grcu_padeduca NUMERIC,
  anal_observacion VARCHAR(4000),
  anal_tipo_obs VARCHAR(20),
  anal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  anal_estado VARCHAR(30),
  anal_fecha_obs TIMESTAMP WITHOUT TIME ZONE,
  anal_hora_obs VARCHAR(10),
  anal_tipo_func VARCHAR(2),
  pers_cod NUMERIC,
  anal_tipo_reporta VARCHAR(10),
  anal_tipo_negativa VARCHAR(5),
  anal_momento_incidente VARCHAR(5),
  anal_lugar_incidente VARCHAR(10),
  peri_cod NUMERIC,
  PRIMARY KEY (anal_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_anotaciones_alu_2 (
  anal_cod NUMERIC,
  ecal_cod NUMERIC,
  anal_obal_padeduca NUMERIC,
  anal_grcu_padeduca NUMERIC,
  anal_observacion VARCHAR(4000),
  anal_tipo_obs VARCHAR(20),
  anal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  anal_estado VARCHAR(30),
  anal_fecha_obs TIMESTAMP WITHOUT TIME ZONE,
  anal_hora_obs VARCHAR(10),
  anal_tipo_func VARCHAR(2),
  pers_cod NUMERIC,
  anal_tipo_reporta VARCHAR(10),
  anal_tipo_negativa VARCHAR(5),
  anal_momento_incidente VARCHAR(5),
  anal_lugar_incidente VARCHAR(10),
  peri_cod NUMERIC,
  PRIMARY KEY (anal_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_anotaciones_alu_3 (
  anal_cod NUMERIC,
  ecal_cod NUMERIC,
  anal_obal_padeduca NUMERIC,
  anal_grcu_padeduca NUMERIC,
  anal_observacion VARCHAR(4000),
  anal_tipo_obs VARCHAR(20),
  anal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  anal_estado VARCHAR(30),
  anal_fecha_obs TIMESTAMP WITHOUT TIME ZONE,
  anal_hora_obs VARCHAR(10),
  anal_tipo_func VARCHAR(2),
  pers_cod NUMERIC,
  anal_tipo_reporta VARCHAR(10),
  anal_tipo_negativa VARCHAR(5),
  anal_momento_incidente VARCHAR(5),
  anal_lugar_incidente VARCHAR(10),
  peri_cod NUMERIC,
  PRIMARY KEY (anal_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_apps (
  apps_nombre VARCHAR(300),
  app_modulo VARCHAR(500),
  apps_es_pagado VARCHAR(1),
  PRIMARY KEY (apps_nombre)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_det_1 (
  aecd_cod NUMERIC,
  eecu_cod NUMERIC,
  aecd_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  pers_cod NUMERIC,
  aecd_nro_lista INTEGER,
  dtas_dm_cod NUMERIC,
  dmas_dm_cod NUMERIC,
  aecd_cuac_padeduca NUMERIC,
  aecd_usuario_ins VARCHAR(50),
  aecd_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  aecd_usuario_mod VARCHAR(50),
  aecd_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (aecd_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_det_2 (
  aecd_cod NUMERIC,
  eecu_cod NUMERIC,
  aecd_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  pers_cod NUMERIC,
  aecd_nro_lista INTEGER,
  dtas_dm_cod NUMERIC,
  dmas_dm_cod NUMERIC,
  aecd_cuac_padeduca NUMERIC,
  aecd_usuario_ins VARCHAR(50),
  aecd_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  aecd_usuario_mod VARCHAR(50),
  aecd_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (aecd_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_det_3 (
  aecd_cod NUMERIC,
  eecu_cod NUMERIC,
  aecd_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  pers_cod NUMERIC,
  aecd_nro_lista INTEGER,
  dtas_dm_cod NUMERIC,
  dmas_dm_cod NUMERIC,
  aecd_cuac_padeduca NUMERIC,
  aecd_usuario_ins VARCHAR(50),
  aecd_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  aecd_usuario_mod VARCHAR(50),
  aecd_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (aecd_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_gen_1 (
  aecg_cod NUMERIC,
  eecu_cod NUMERIC,
  aecg_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  dtas_dm_cod NUMERIC,
  aecg_total_asistencia NUMERIC,
  aecg_cuac_padeduca NUMERIC,
  aecg_usuario_ins VARCHAR(50),
  aecg_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  aecg_usuario_mod VARCHAR(50),
  aecg_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (aecg_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_gen_2 (
  aecg_cod NUMERIC,
  eecu_cod NUMERIC,
  aecg_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  dtas_dm_cod NUMERIC,
  aecg_total_asistencia NUMERIC,
  aecg_cuac_padeduca NUMERIC,
  aecg_usuario_ins VARCHAR(50),
  aecg_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  aecg_usuario_mod VARCHAR(50),
  aecg_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (aecg_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_gen_3 (
  aecg_cod NUMERIC,
  eecu_cod NUMERIC,
  aecg_fecha_asistencia TIMESTAMP WITHOUT TIME ZONE,
  dtas_dm_cod NUMERIC,
  aecg_total_asistencia NUMERIC,
  aecg_cuac_padeduca NUMERIC,
  aecg_usuario_ins VARCHAR(50),
  aecg_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  aecg_usuario_mod VARCHAR(50),
  aecg_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (aecg_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_resu_1 (
  sost_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  porcentaje_asist NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (sost_cod, eecu_cod, pers_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_resu_2 (
  sost_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  porcentaje_asist NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (sost_cod, eecu_cod, pers_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_asist_ee_curso_resu_3 (
  sost_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  porcentaje_asist NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (sost_cod, eecu_cod, pers_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_db_asist_01 (
  sost_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  eeso_nombre VARCHAR(200),
  dbas_cant_alumnos NUMERIC,
  dbas_total_alumnos NUMERIC,
  dbas_total NUMERIC,
  usua_usuarios NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_db_asist_02 (
  sost_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  eeso_nombre VARCHAR(200),
  cant_alum NUMERIC,
  asis_neta NUMERIC,
  asis_null NUMERIC,
  asis_dias_festivos NUMERIC,
  dias_consulta NUMERIC,
  asist_posible_estabs NUMERIC,
  usua_usuarios BIGINT
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_db_desemp_01 (
  sost_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  eeso_nombre VARCHAR(200),
  insuficiente NUMERIC,
  cantidad_insuficientes NUMERIC,
  adecuado NUMERIC,
  cantidad_adecuado NUMERIC,
  destacado NUMERIC,
  cantidad_destacado NUMERIC,
  sin_notas NUMERIC,
  cantidad_sin_notas NUMERIC,
  total NUMERIC,
  usua_usuarios BIGINT
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_db_desemp_02 (
  sost_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  eeso_nombre VARCHAR(200),
  tipo VARCHAR(14),
  escala NUMERIC,
  usua_usuarios BIGINT
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_db_notas_01 (
  sost_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  dbno_establecimiento VARCHAR(200),
  dbno_promedio_anual NUMERIC,
  usua_usuarios NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_db_riesgo_01 (
  sost_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  eeso_nombre VARCHAR(200),
  dbri_total NUMERIC,
  usua_usuarios NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_dm_estado_proc (
  depr_dm_cod NUMERIC,
  depr_nombre VARCHAR(50),
  PRIMARY KEY (depr_dm_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_dm_modo_asistencia (
  dmas_dm_cod NUMERIC,
  dmas_nombre VARCHAR(50),
  PRIMARY KEY (dmas_dm_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_dm_tipo_asistencia (
  dtas_dm_cod NUMERIC,
  dtas_nombre VARCHAR(50),
  dtas_dm_padeduca VARCHAR(50),
  PRIMARY KEY (dtas_dm_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_dm_tpo_personas (
  dtpe_dm_cod NUMERIC,
  dtpe_nombre VARCHAR(50),
  PRIMARY KEY (dtpe_dm_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_dominios (
  domi_nombre VARCHAR(50),
  domi_cod VARCHAR(20),
  domi_desc VARCHAR(1000),
  PRIMARY KEY (domi_nombre, domi_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_eeee_dashboard (
  eeda_rbd VARCHAR(20),
  eeda_dv VARCHAR(1),
  eeda_url VARCHAR(4000),
  PRIMARY KEY (eeda_rbd)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_eeee_sostenedor_1 (
  eeso_cod NUMERIC,
  sost_cod NUMERIC,
  eeso_rbd VARCHAR(20),
  eeso_dv VARCHAR(1),
  eeso_nombre VARCHAR(200),
  eeso_region VARCHAR(50),
  eeso_comuna VARCHAR(20),
  eeso_tipo_periodo VARCHAR(20),
  eeso_esed_padeduca NUMERIC,
  eeso_usuario_ins VARCHAR(50),
  eeso_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  eeso_usuario_mod VARCHAR(50),
  eeso_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eeso_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_eeee_sostenedor_2 (
  eeso_cod NUMERIC,
  sost_cod NUMERIC,
  eeso_rbd VARCHAR(20),
  eeso_dv VARCHAR(1),
  eeso_nombre VARCHAR(200),
  eeso_region VARCHAR(50),
  eeso_comuna VARCHAR(20),
  eeso_tipo_periodo VARCHAR(20),
  eeso_esed_padeduca NUMERIC,
  eeso_usuario_ins VARCHAR(50),
  eeso_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  eeso_usuario_mod VARCHAR(50),
  eeso_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eeso_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_eeee_sostenedor_3 (
  eeso_cod NUMERIC,
  sost_cod NUMERIC,
  eeso_rbd VARCHAR(20),
  eeso_dv VARCHAR(1),
  eeso_nombre VARCHAR(200),
  eeso_region VARCHAR(50),
  eeso_comuna VARCHAR(20),
  eeso_tipo_periodo VARCHAR(20),
  eeso_esed_padeduca NUMERIC,
  eeso_usuario_ins VARCHAR(50),
  eeso_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  eeso_usuario_mod VARCHAR(50),
  eeso_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eeso_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_asignaturas_1 (
  eeas_cod VARCHAR(20),
  eeas_descripcion VARCHAR(200),
  eeas_tipo VARCHAR(5),
  peri_cod NUMERIC,
  PRIMARY KEY (eeas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_asignaturas_2 (
  eeas_cod VARCHAR(20),
  eeas_descripcion VARCHAR(200),
  eeas_tipo VARCHAR(5),
  peri_cod NUMERIC,
  PRIMARY KEY (eeas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_asignaturas_3 (
  eeas_cod VARCHAR(20),
  eeas_descripcion VARCHAR(200),
  eeas_tipo VARCHAR(5),
  peri_cod NUMERIC,
  PRIMARY KEY (eeas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_avg_final_asig_1 (
  eafa_cod NUMERIC,
  ecas_cod NUMERIC,
  pers_cod NUMERIC,
  eafa_cuas_padeduca NUMERIC,
  eafa_fial_padeduca NUMERIC,
  eafa_nro_lista NUMERIC,
  eafa_promedio_final VARCHAR(10),
  eafa_promedio_final_n NUMERIC,
  eafa_alcu_padeduca NUMERIC,
  eafa_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (eafa_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_avg_final_asig_2 (
  eafa_cod NUMERIC,
  ecas_cod NUMERIC,
  pers_cod NUMERIC,
  eafa_cuas_padeduca NUMERIC,
  eafa_fial_padeduca NUMERIC,
  eafa_nro_lista NUMERIC,
  eafa_promedio_final VARCHAR(10),
  eafa_promedio_final_n NUMERIC,
  eafa_alcu_padeduca NUMERIC,
  eafa_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (eafa_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_avg_final_asig_3 (
  eafa_cod NUMERIC,
  ecas_cod NUMERIC,
  pers_cod NUMERIC,
  eafa_cuas_padeduca NUMERIC,
  eafa_fial_padeduca NUMERIC,
  eafa_nro_lista NUMERIC,
  eafa_promedio_final VARCHAR(10),
  eafa_promedio_final_n NUMERIC,
  eafa_alcu_padeduca NUMERIC,
  eafa_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (eafa_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_avg_gral_alum_1 (
  eaga_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  eaga_grcu_padeduca NUMERIC,
  eaga_fial_padeduca NUMERIC,
  eaga_nro_lista NUMERIC,
  eaga_prom_1_st NUMERIC,
  eaga_prom_2_st NUMERIC,
  eaga_prom_3_tr NUMERIC,
  eaga_prom_gral NUMERIC,
  eaga_alcu_padeduca NUMERIC,
  eaga_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (eaga_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_avg_gral_alum_2 (
  eaga_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  eaga_grcu_padeduca NUMERIC,
  eaga_fial_padeduca NUMERIC,
  eaga_nro_lista NUMERIC,
  eaga_prom_1_st NUMERIC,
  eaga_prom_2_st NUMERIC,
  eaga_prom_3_tr NUMERIC,
  eaga_prom_gral NUMERIC,
  eaga_alcu_padeduca NUMERIC,
  eaga_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (eaga_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_avg_gral_alum_3 (
  eaga_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  eaga_grcu_padeduca NUMERIC,
  eaga_fial_padeduca NUMERIC,
  eaga_nro_lista NUMERIC,
  eaga_prom_1_st NUMERIC,
  eaga_prom_2_st NUMERIC,
  eaga_prom_3_tr NUMERIC,
  eaga_prom_gral NUMERIC,
  eaga_alcu_padeduca NUMERIC,
  eaga_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (eaga_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_cursos_1 (
  eecu_cod NUMERIC,
  eete_cod NUMERIC,
  eecu_grado NUMERIC,
  eecu_nombre VARCHAR(50),
  eecu_letra VARCHAR(2),
  eecu_grcu_padeduca NUMERIC,
  eecu_usuario_ins VARCHAR(50),
  eecu_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  eecu_usuario_mod VARCHAR(50),
  eecu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eecu_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_cursos_2 (
  eecu_cod NUMERIC,
  eete_cod NUMERIC,
  eecu_grado NUMERIC,
  eecu_nombre VARCHAR(50),
  eecu_letra VARCHAR(2),
  eecu_grcu_padeduca NUMERIC,
  eecu_usuario_ins VARCHAR(50),
  eecu_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  eecu_usuario_mod VARCHAR(50),
  eecu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eecu_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_cursos_3 (
  eecu_cod NUMERIC,
  eete_cod NUMERIC,
  eecu_grado NUMERIC,
  eecu_nombre VARCHAR(50),
  eecu_letra VARCHAR(2),
  eecu_grcu_padeduca NUMERIC,
  eecu_usuario_ins VARCHAR(50),
  eecu_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  eecu_usuario_mod VARCHAR(50),
  eecu_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eecu_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_curso_alumnos_1 (
  ecal_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  ecal_fec_ingreso TIMESTAMP WITHOUT TIME ZONE,
  ecal_fial_padeduca NUMERIC,
  ecal_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  ecal_estado VARCHAR(20),
  ecal_usuario_ins VARCHAR(50),
  ecal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  ecal_usuario_mod VARCHAR(50),
  ecal_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (ecal_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_curso_alumnos_2 (
  ecal_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  ecal_fec_ingreso TIMESTAMP WITHOUT TIME ZONE,
  ecal_fial_padeduca NUMERIC,
  ecal_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  ecal_estado VARCHAR(20),
  ecal_usuario_ins VARCHAR(50),
  ecal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  ecal_usuario_mod VARCHAR(50),
  ecal_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (ecal_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_curso_alumnos_3 (
  ecal_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  ecal_fec_ingreso TIMESTAMP WITHOUT TIME ZONE,
  ecal_fial_padeduca NUMERIC,
  ecal_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  ecal_estado VARCHAR(20),
  ecal_usuario_ins VARCHAR(50),
  ecal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  ecal_usuario_mod VARCHAR(50),
  ecal_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (ecal_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_curso_asignaturas_1 (
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  eeas_cod VARCHAR(20),
  ecas_cuas_padeduca NUMERIC,
  ecas_grcu_padeduca NUMERIC,
  ecas_asig_padeduca VARCHAR(20),
  ecas_tipo_peri VARCHAR(10),
  ecas_tipo_calif VARCHAR(10),
  ecas_aplica_prom VARCHAR(5),
  ecas_aplica_informe VARCHAR(5),
  ecas_orden_info INTEGER,
  ecas_horas_asig NUMERIC(5, 2),
  ecas_calculo_prom VARCHAR(2),
  ecas_tipo_ponderacion VARCHAR(2),
  peri_cod NUMERIC,
  PRIMARY KEY (ecas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_curso_asignaturas_2 (
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  eeas_cod VARCHAR(20),
  ecas_cuas_padeduca NUMERIC,
  ecas_grcu_padeduca NUMERIC,
  ecas_asig_padeduca VARCHAR(20),
  ecas_tipo_peri VARCHAR(10),
  ecas_tipo_calif VARCHAR(10),
  ecas_aplica_prom VARCHAR(5),
  ecas_aplica_informe VARCHAR(5),
  ecas_orden_info INTEGER,
  ecas_horas_asig NUMERIC(5, 2),
  ecas_calculo_prom VARCHAR(2),
  ecas_tipo_ponderacion VARCHAR(2),
  peri_cod NUMERIC,
  PRIMARY KEY (ecas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_curso_asignaturas_3 (
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  eeas_cod VARCHAR(20),
  ecas_cuas_padeduca NUMERIC,
  ecas_grcu_padeduca NUMERIC,
  ecas_asig_padeduca VARCHAR(20),
  ecas_tipo_peri VARCHAR(10),
  ecas_tipo_calif VARCHAR(10),
  ecas_aplica_prom VARCHAR(5),
  ecas_aplica_informe VARCHAR(5),
  ecas_orden_info INTEGER,
  ecas_horas_asig NUMERIC(5, 2),
  ecas_calculo_prom VARCHAR(2),
  ecas_tipo_ponderacion VARCHAR(2),
  peri_cod NUMERIC,
  PRIMARY KEY (ecas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_nota_asig_curso_1 (
  enac_cod NUMERIC,
  ecas_cod NUMERIC,
  pers_cod NUMERIC,
  enac_cuas_padeduca NUMERIC(23, 0),
  enac_fial_padeduca NUMERIC(23, 0),
  enac_tipo_peri VARCHAR(10),
  enac_nota_1 VARCHAR(2),
  enac_nota_2 VARCHAR(2),
  enac_nota_3 VARCHAR(2),
  enac_nota_4 VARCHAR(2),
  enac_nota_5 VARCHAR(2),
  enac_nota_6 VARCHAR(2),
  enac_nota_7 VARCHAR(2),
  enac_nota_8 VARCHAR(2),
  enac_nota_9 VARCHAR(2),
  enac_nota_10 VARCHAR(2),
  enac_nota_11 VARCHAR(2),
  enac_nota_12 VARCHAR(2),
  enac_nota_13 VARCHAR(2),
  enac_nota_14 VARCHAR(2),
  enac_nota_15 VARCHAR(2),
  enac_nota_16 VARCHAR(2),
  enac_nota_17 VARCHAR(2),
  enac_nota_18 VARCHAR(2),
  enac_nota_19 VARCHAR(2),
  enac_nota_20 VARCHAR(2),
  enac_nota_examen VARCHAR(2),
  enac_prom_parc VARCHAR(10),
  enac_prom_sist VARCHAR(10),
  enac_prom_final VARCHAR(10),
  enac_nro_lista INTEGER,
  enac_eximido VARCHAR(1),
  enac_alcu_padeduca NUMERIC,
  enac_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (enac_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_nota_asig_curso_2 (
  enac_cod NUMERIC,
  ecas_cod NUMERIC,
  pers_cod NUMERIC,
  enac_cuas_padeduca NUMERIC(23, 0),
  enac_fial_padeduca NUMERIC(23, 0),
  enac_tipo_peri VARCHAR(10),
  enac_nota_1 VARCHAR(2),
  enac_nota_2 VARCHAR(2),
  enac_nota_3 VARCHAR(2),
  enac_nota_4 VARCHAR(2),
  enac_nota_5 VARCHAR(2),
  enac_nota_6 VARCHAR(2),
  enac_nota_7 VARCHAR(2),
  enac_nota_8 VARCHAR(2),
  enac_nota_9 VARCHAR(2),
  enac_nota_10 VARCHAR(2),
  enac_nota_11 VARCHAR(2),
  enac_nota_12 VARCHAR(2),
  enac_nota_13 VARCHAR(2),
  enac_nota_14 VARCHAR(2),
  enac_nota_15 VARCHAR(2),
  enac_nota_16 VARCHAR(2),
  enac_nota_17 VARCHAR(2),
  enac_nota_18 VARCHAR(2),
  enac_nota_19 VARCHAR(2),
  enac_nota_20 VARCHAR(2),
  enac_nota_examen VARCHAR(2),
  enac_prom_parc VARCHAR(10),
  enac_prom_sist VARCHAR(10),
  enac_prom_final VARCHAR(10),
  enac_nro_lista INTEGER,
  enac_eximido VARCHAR(1),
  enac_alcu_padeduca NUMERIC,
  enac_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (enac_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_nota_asig_curso_3 (
  enac_cod NUMERIC,
  ecas_cod NUMERIC,
  pers_cod NUMERIC,
  enac_cuas_padeduca NUMERIC(23, 0),
  enac_fial_padeduca NUMERIC(23, 0),
  enac_tipo_peri VARCHAR(10),
  enac_nota_1 VARCHAR(2),
  enac_nota_2 VARCHAR(2),
  enac_nota_3 VARCHAR(2),
  enac_nota_4 VARCHAR(2),
  enac_nota_5 VARCHAR(2),
  enac_nota_6 VARCHAR(2),
  enac_nota_7 VARCHAR(2),
  enac_nota_8 VARCHAR(2),
  enac_nota_9 VARCHAR(2),
  enac_nota_10 VARCHAR(2),
  enac_nota_11 VARCHAR(2),
  enac_nota_12 VARCHAR(2),
  enac_nota_13 VARCHAR(2),
  enac_nota_14 VARCHAR(2),
  enac_nota_15 VARCHAR(2),
  enac_nota_16 VARCHAR(2),
  enac_nota_17 VARCHAR(2),
  enac_nota_18 VARCHAR(2),
  enac_nota_19 VARCHAR(2),
  enac_nota_20 VARCHAR(2),
  enac_nota_examen VARCHAR(2),
  enac_prom_parc VARCHAR(10),
  enac_prom_sist VARCHAR(10),
  enac_prom_final VARCHAR(10),
  enac_nro_lista INTEGER,
  enac_eximido VARCHAR(1),
  enac_alcu_padeduca NUMERIC,
  enac_estado VARCHAR(20),
  peri_cod NUMERIC,
  PRIMARY KEY (enac_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_pdf (
  eepd_tipo VARCHAR(100),
  rbd VARCHAR(100),
  esed_sec NUMERIC,
  eepd_correo VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_proceso_pdf (
  esed_sec NUMERIC,
  eppd_anio NUMERIC,
  eppd_nro_semana NUMERIC,
  PRIMARY KEY (esed_sec, eppd_anio, eppd_nro_semana)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_tipo_ensenanzas_1 (
  eete_cod NUMERIC,
  peee_cod NUMERIC,
  tien_cod NUMERIC,
  eete_tipo_peri VARCHAR(10),
  eete_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  eete_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eete_cod, peee_cod, tien_cod, eete_tipo_peri)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_tipo_ensenanzas_2 (
  eete_cod NUMERIC,
  peee_cod NUMERIC,
  tien_cod NUMERIC,
  eete_tipo_peri VARCHAR(10),
  eete_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  eete_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eete_cod, peee_cod, tien_cod, eete_tipo_peri)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_ee_tipo_ensenanzas_3 (
  eete_cod NUMERIC,
  peee_cod NUMERIC,
  tien_cod NUMERIC,
  eete_tipo_peri VARCHAR(10),
  eete_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  eete_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (eete_cod, peee_cod, tien_cod, eete_tipo_peri)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_firma_asist_1 (
  fias_cod NUMERIC,
  ecas_cod NUMERIC,
  fias_nro_bloque NUMERIC,
  fias_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  fias_estado_token VARCHAR(20),
  fias_tipo NUMERIC,
  fias_cuas_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (fias_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_firma_asist_2 (
  fias_cod NUMERIC,
  ecas_cod NUMERIC,
  fias_nro_bloque NUMERIC,
  fias_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  fias_estado_token VARCHAR(20),
  fias_tipo NUMERIC,
  fias_cuas_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (fias_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_firma_asist_3 (
  fias_cod NUMERIC,
  ecas_cod NUMERIC,
  fias_nro_bloque NUMERIC,
  fias_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  fias_estado_token VARCHAR(20),
  fias_tipo NUMERIC,
  fias_cuas_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (fias_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_firma_leccionario_1 (
  file_cod NUMERIC,
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  file_fecha TIMESTAMP WITHOUT TIME ZONE,
  file_estado VARCHAR(20),
  file_tipo NUMERIC,
  file_leas_padeduca NUMERIC,
  file_lepa_padeduca NUMERIC,
  file_cuas_padeduca NUMERIC,
  file_grcu_pdeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (file_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_firma_leccionario_2 (
  file_cod NUMERIC,
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  file_fecha TIMESTAMP WITHOUT TIME ZONE,
  file_estado VARCHAR(20),
  file_tipo NUMERIC,
  file_leas_padeduca NUMERIC,
  file_lepa_padeduca NUMERIC,
  file_cuas_padeduca NUMERIC,
  file_grcu_pdeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (file_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_firma_leccionario_3 (
  file_cod NUMERIC,
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  file_fecha TIMESTAMP WITHOUT TIME ZONE,
  file_estado VARCHAR(20),
  file_tipo NUMERIC,
  file_leas_padeduca NUMERIC,
  file_lepa_padeduca NUMERIC,
  file_cuas_padeduca NUMERIC,
  file_grcu_pdeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (file_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_leccionario_1 (
  lecc_cod NUMERIC,
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  lecc_fecha TIMESTAMP WITHOUT TIME ZONE,
  lecc_horas NUMERIC,
  lecc_tipo NUMERIC,
  lecc_leas_padeduca NUMERIC,
  lecc_lepa_padeduca NUMERIC,
  lecc_cuas_padeduca NUMERIC,
  leec_grcu_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (lecc_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_leccionario_2 (
  lecc_cod NUMERIC,
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  lecc_fecha TIMESTAMP WITHOUT TIME ZONE,
  lecc_horas NUMERIC,
  lecc_tipo NUMERIC,
  lecc_leas_padeduca NUMERIC,
  lecc_lepa_padeduca NUMERIC,
  lecc_cuas_padeduca NUMERIC,
  leec_grcu_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (lecc_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_leccionario_3 (
  lecc_cod NUMERIC,
  ecas_cod NUMERIC,
  eecu_cod NUMERIC,
  lecc_fecha TIMESTAMP WITHOUT TIME ZONE,
  lecc_horas NUMERIC,
  lecc_tipo NUMERIC,
  lecc_leas_padeduca NUMERIC,
  lecc_lepa_padeduca NUMERIC,
  lecc_cuas_padeduca NUMERIC,
  leec_grcu_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (lecc_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_01 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_02 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_03 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_04 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_05 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_06 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_07 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_08 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_09 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_10 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_11 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_logger_12 (
  logg_sec NUMERIC,
  logg_tipo VARCHAR(30),
  logg_fecha TIMESTAMP WITHOUT TIME ZONE,
  logg_client_id VARCHAR(200),
  logg_msg VARCHAR(4000),
  logg_param VARCHAR(4000),
  logg_cod_error NUMERIC,
  logg_t1 TIMESTAMP WITHOUT TIME ZONE,
  logg_t2 TIMESTAMP WITHOUT TIME ZONE,
  log_diff NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_log_menu (
  id NUMERIC,
  inserted_date TIMESTAMP WITHOUT TIME ZONE,
  username VARCHAR(90),
  application VARCHAR(255),
  creator VARCHAR(30),
  ip_user VARCHAR(255),
  action VARCHAR(30),
  description TEXT,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_mantencion (
  mant_cod NUMERIC,
  mant_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  mant_fec_ter TIMESTAMP WITHOUT TIME ZONE,
  mant_estado VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_parametros (
  para_cod VARCHAR(50),
  para_desc VARCHAR(200),
  para_valor VARCHAR(200),
  para_dominio VARCHAR(200),
  PRIMARY KEY (para_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_periodos (
  peri_cod NUMERIC,
  peri_anio NUMERIC,
  peri_desc VARCHAR(50),
  peri_en_uso VARCHAR(1),
  peri_usuario_ins VARCHAR(50),
  peri_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  peri_usuario_mod VARCHAR(50),
  peri_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_periodos_eeee_1 (
  peee_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  peee_peri_padeduca NUMERIC,
  peee_usuario_ins VARCHAR(50),
  peee_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  peee_usuario_mod VARCHAR(50),
  peee_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (peee_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_periodos_eeee_2 (
  peee_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  peee_peri_padeduca NUMERIC,
  peee_usuario_ins VARCHAR(50),
  peee_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  peee_usuario_mod VARCHAR(50),
  peee_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (peee_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_periodos_eeee_3 (
  peee_cod NUMERIC,
  peri_cod NUMERIC,
  eeso_cod NUMERIC,
  peee_peri_padeduca NUMERIC,
  peee_usuario_ins VARCHAR(50),
  peee_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  peee_usuario_mod VARCHAR(50),
  peee_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (peee_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_personas (
  pers_cod NUMERIC,
  pers_rut NUMERIC,
  pers_rut_dv VARCHAR(1),
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(50),
  pers_ape_mat VARCHAR(50),
  dtpe_dm_cod NUMERIC,
  pers_pers_padeduca NUMERIC,
  pers_usuario_ins VARCHAR(50),
  pers_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  pers_usuario_mod VARCHAR(50),
  pers_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (pers_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_proc_cargas (
  prca_sec_proc NUMERIC,
  prca_fec_proc TIMESTAMP WITHOUT TIME ZONE,
  prca_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  prca_fec_ter TIMESTAMP WITHOUT TIME ZONE,
  prca_tiempo_total NUMERIC,
  prca_tabla_uso NUMERIC,
  depr_dm_cod NUMERIC,
  PRIMARY KEY (prca_sec_proc)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_proc_carga_sostenedor (
  prca_sec_proc NUMERIC,
  sost_cod NUMERIC,
  prcs_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  prcs_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  prcs_tiempo_total NUMERIC,
  depr_dm_cod NUMERIC,
  PRIMARY KEY (prca_sec_proc, sost_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_proc_tab_procedadas (
  prca_sec_proc NUMERIC,
  sost_cod NUMERIC,
  prtp_orden NUMERIC,
  prtp_tabla VARCHAR(50),
  prtp_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  prtp_fec_fin TIMESTAMP WITHOUT TIME ZONE,
  prtp_tiempo_total NUMERIC,
  prtp_nro_filas NUMERIC,
  PRIMARY KEY (prca_sec_proc, sost_cod, prtp_tabla)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_proc_tab_to_view (
  prtv_tabla VARCHAR(100),
  prtv_code TEXT,
  PRIMARY KEY (prtv_tabla)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_profesores_ee_1 (
  pree_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  pree_peri_padeduca NUMERIC,
  pree_usuario_ins VARCHAR(50),
  pree_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  pree_usuario_mod VARCHAR(50),
  pree_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (pree_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_profesores_ee_2 (
  pree_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  pree_peri_padeduca NUMERIC,
  pree_usuario_ins VARCHAR(50),
  pree_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  pree_usuario_mod VARCHAR(50),
  pree_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (pree_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_profesores_ee_3 (
  pree_cod NUMERIC,
  eecu_cod NUMERIC,
  pers_cod NUMERIC,
  pree_peri_padeduca NUMERIC,
  pree_usuario_ins VARCHAR(50),
  pree_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  pree_usuario_mod VARCHAR(50),
  pree_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  peri_cod NUMERIC,
  PRIMARY KEY (pree_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_profesor_asignatura_1 (
  pras_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  pras_tipo_periodo VARCHAR(20),
  pras_prof_padeduca NUMERIC,
  pras_pers_padeduca VARCHAR(20),
  pras_cuas_padeduca NUMERIC,
  pras_grcu_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (pras_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_profesor_asignatura_2 (
  pras_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  pras_tipo_periodo VARCHAR(20),
  pras_prof_padeduca NUMERIC,
  pras_pers_padeduca VARCHAR(20),
  pras_cuas_padeduca NUMERIC,
  pras_grcu_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (pras_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_profesor_asignatura_3 (
  pras_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  pras_tipo_periodo VARCHAR(20),
  pras_prof_padeduca NUMERIC,
  pras_pers_padeduca VARCHAR(20),
  pras_cuas_padeduca NUMERIC,
  pras_grcu_padeduca NUMERIC,
  peri_cod NUMERIC,
  PRIMARY KEY (pras_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_resumen_asistencia_1 (
  reas_cod NUMERIC,
  peee_cod NUMERIC,
  eecu_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  reas_tipo_asistencia VARCHAR(10),
  reas_nro_bloque NUMERIC,
  reas_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  reas_cod_estado VARCHAR(15),
  reas_desc_estado VARCHAR(240),
  reas_nom_firma VARCHAR(4000),
  peri_cod NUMERIC,
  PRIMARY KEY (reas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_resumen_asistencia_2 (
  reas_cod NUMERIC,
  peee_cod NUMERIC,
  eecu_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  reas_tipo_asistencia VARCHAR(10),
  reas_nro_bloque NUMERIC,
  reas_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  reas_cod_estado VARCHAR(15),
  reas_desc_estado VARCHAR(240),
  reas_nom_firma VARCHAR(4000),
  peri_cod NUMERIC,
  PRIMARY KEY (reas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_resumen_asistencia_3 (
  reas_cod NUMERIC,
  peee_cod NUMERIC,
  eecu_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  reas_tipo_asistencia VARCHAR(10),
  reas_nro_bloque NUMERIC,
  reas_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  reas_cod_estado VARCHAR(15),
  reas_desc_estado VARCHAR(240),
  reas_nom_firma VARCHAR(4000),
  peri_cod NUMERIC,
  PRIMARY KEY (reas_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_resumen_leccionario_1 (
  rele_cod NUMERIC,
  peee_cod NUMERIC,
  eecu_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  tipo_leccionario VARCHAR(14),
  fec_leccionario TIMESTAMP WITHOUT TIME ZONE,
  cod_estado VARCHAR(15),
  desc_estado VARCHAR(240),
  firma_lecc VARCHAR(4000),
  peri_cod NUMERIC,
  PRIMARY KEY (rele_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_resumen_leccionario_2 (
  rele_cod NUMERIC,
  peee_cod NUMERIC,
  eecu_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  tipo_leccionario VARCHAR(14),
  fec_leccionario TIMESTAMP WITHOUT TIME ZONE,
  cod_estado VARCHAR(15),
  desc_estado VARCHAR(240),
  firma_lecc VARCHAR(4000),
  peri_cod NUMERIC,
  PRIMARY KEY (rele_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_resumen_leccionario_3 (
  rele_cod NUMERIC,
  peee_cod NUMERIC,
  eecu_cod NUMERIC,
  ecas_cod NUMERIC,
  eeas_cod VARCHAR(20),
  pers_cod NUMERIC,
  tipo_leccionario VARCHAR(14),
  fec_leccionario TIMESTAMP WITHOUT TIME ZONE,
  cod_estado VARCHAR(15),
  desc_estado VARCHAR(240),
  firma_lecc VARCHAR(4000),
  peri_cod NUMERIC,
  PRIMARY KEY (rele_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_rtp_graph (
  eecu_cod NUMERIC,
  curso VARCHAR(300),
  porcentaje_asistencia NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_sostenedores (
  sost_cod NUMERIC,
  sost_rut VARCHAR(20),
  sost_nombre VARCHAR(200),
  sost_esad_padeduca VARCHAR(30),
  sost_usuario_ins VARCHAR(50),
  sost_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  sost_usuario_mod VARCHAR(50),
  sost_fecha_mod TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (sost_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_texto_correos (
  teco_nombre VARCHAR(100),
  teco_titulo VARCHAR(1000),
  teco_cuerpo TEXT,
  PRIMARY KEY (teco_nombre)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_tipo_ensenanzas_1 (
  tien_cod NUMERIC,
  tien_nombre VARCHAR(300),
  peri_cod NUMERIC,
  PRIMARY KEY (tien_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_tipo_ensenanzas_2 (
  tien_cod NUMERIC,
  tien_nombre VARCHAR(300),
  peri_cod NUMERIC,
  PRIMARY KEY (tien_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_tipo_ensenanzas_3 (
  tien_cod NUMERIC,
  tien_nombre VARCHAR(300),
  peri_cod NUMERIC,
  PRIMARY KEY (tien_cod, peri_cod)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_unicos_tien (
  eete_cod NUMERIC,
  peee_cod NUMERIC,
  tien_cod NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_anotaciones (
  obal_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  obal_observacion VARCHAR(4000),
  obal_tipo_obs VARCHAR(20),
  obal_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  obal_estado VARCHAR(30),
  obal_fecha_obs TIMESTAMP WITHOUT TIME ZONE,
  obal_hora_obs VARCHAR(10),
  caso_sec NUMERIC(23, 0),
  obal_tipo_func VARCHAR(2),
  prof_sec NUMERIC(23, 0),
  coes_sec NUMERIC(23, 0),
  maal_sec NUMERIC(23, 0),
  obal_tipo_reporta VARCHAR(10),
  obal_tipo_negativa VARCHAR(5),
  obal_momento_incidente VARCHAR(5),
  obal_lugar_incidente VARCHAR(10),
  obal_pers_sec_reporta NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_anotaciones_pers (
  tipo_func VARCHAR(2),
  sec_tipo_func NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  pers_rut BIGINT,
  pers_dv VARCHAR(1),
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(60),
  pers_ape_mat VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_asignaturas (
  asig_cod VARCHAR(20),
  asig_descripcion VARCHAR(200),
  asig_tipo VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_asistencias (
  grcu_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  asbl_nro_lista BIGINT,
  asbl_fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  asistencia VARCHAR(30),
  cuas_sec NUMERIC(23, 0),
  tipo_asistencia VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_curso_asignaturas (
  cuas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  asig_cod VARCHAR(20),
  cuas_tipo_peri VARCHAR(10),
  cuas_tipo_calif VARCHAR(10),
  cuas_aplica_prom VARCHAR(5),
  cuas_aplica_informe VARCHAR(5),
  cuas_orden_info INTEGER,
  cuas_horas_asig NUMERIC(5, 2),
  cuas_calculo_prom VARCHAR(2),
  cuas_tipo_ponderacion VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_eeee_sostenedor (
  esad_cod VARCHAR(30),
  rbd VARCHAR(30),
  rbd_dv NUMERIC,
  esed_descripcion VARCHAR(200),
  esde_tipo_periodo VARCHAR(20),
  esed_sec NUMERIC(23, 0)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_ee_avg_final_asig (
  cuas_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  prfa_nro_lista INTEGER,
  prfa_prom_final VARCHAR(10),
  alcu_sec NUMERIC(23, 0),
  prfa_estado VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_ee_avg_gral_alum (
  grcu_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  prga_nro_lista INTEGER,
  prga_prom_1_st VARCHAR(10),
  prga_prom_2_st VARCHAR(10),
  prga_prom_3_tr VARCHAR(10),
  prga_prom_gral VARCHAR(10),
  alcu_sec NUMERIC(23, 0),
  prga_estado VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_ee_cursos (
  grcu_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  grte_cod VARCHAR(10),
  grcu_letra_curso VARCHAR(2),
  grte_descrip VARCHAR(100),
  peri_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_ee_curso_alumnos (
  grcu_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  rut NUMERIC,
  dv VARCHAR(1),
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(60),
  pers_ape_mat VARCHAR(60),
  alcu_fec_incorp TIMESTAMP WITHOUT TIME ZONE,
  fial_sec NUMERIC,
  alcu_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  alcu_estado VARCHAR(20),
  alcu_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_ee_tipo_ensenanzas (
  peri_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  pete_tipo_peri VARCHAR(10),
  pete_fec_ini TIMESTAMP WITHOUT TIME ZONE,
  pete_fec_fin TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_firmas (
  cuas_sec NUMERIC(23, 0),
  nro_bloque NUMERIC,
  fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  rut_usuario VARCHAR(15),
  fecha_zh VARCHAR(100),
  estado_token VARCHAR(10),
  tipo_firma NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_firma_leccionario (
  leas_sec NUMERIC(23, 0),
  lepa_sec NUMERIC(23, 0),
  cuas_sec NUMERIC,
  grcu_sec NUMERIC,
  fecha TIMESTAMP WITHOUT TIME ZONE,
  estado VARCHAR(10),
  tipo NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_leccionario (
  leas_sec NUMERIC,
  lepa_sec NUMERIC,
  cuas_sec NUMERIC,
  grcu_sec NUMERIC,
  leas_fecha TIMESTAMP WITHOUT TIME ZONE,
  leas_horas INTEGER,
  tipo NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_nota_asig_curso (
  cuas_sec NUMERIC(23, 0),
  fial_sec NUMERIC(23, 0),
  nacu_tipo_peri VARCHAR(10),
  nacu_nota_1 VARCHAR(2),
  nacu_nota_2 VARCHAR(2),
  nacu_nota_3 VARCHAR(2),
  nacu_nota_4 VARCHAR(2),
  nacu_nota_5 VARCHAR(2),
  nacu_nota_6 VARCHAR(2),
  nacu_nota_7 VARCHAR(2),
  nacu_nota_8 VARCHAR(2),
  nacu_nota_9 VARCHAR(2),
  nacu_nota_10 VARCHAR(2),
  nacu_nota_11 VARCHAR(2),
  nacu_nota_12 VARCHAR(2),
  nacu_nota_13 VARCHAR(2),
  nacu_nota_14 VARCHAR(2),
  nacu_nota_15 VARCHAR(2),
  nacu_nota_16 VARCHAR(2),
  nacu_nota_17 VARCHAR(2),
  nacu_nota_18 VARCHAR(2),
  nacu_nota_19 VARCHAR(2),
  nacu_nota_20 VARCHAR(2),
  nacu_nota_examen VARCHAR(2),
  nacu_prom_parc VARCHAR(10),
  nacu_prom_sist VARCHAR(10),
  nacu_prom_final VARCHAR(10),
  nacu_nro_lista INTEGER,
  nacu_eximido VARCHAR(1),
  alcu_sec NUMERIC(23, 0),
  nacu_estado VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_periodos_eeee (
  peri_sec NUMERIC,
  peri_anio NUMERIC,
  esed_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_profesores_ee (
  grcu_sec NUMERIC,
  pers_sec NUMERIC,
  rut NUMERIC,
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(60),
  pers_ape_mat VARCHAR(60),
  dv VARCHAR(1),
  peri_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_profesor_asignatura (
  prof_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  pers_rut NUMERIC,
  pers_dv VARCHAR(1),
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(60),
  pers_ape_mat VARCHAR(60),
  cuas_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  asig_cod VARCHAR(20),
  cuas_tipo_peri VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_resumen_asistencia (
  tipo_asistencia VARCHAR(10),
  reab_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  tien_descripcion VARCHAR(200),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  grcu_letra_curso VARCHAR(2),
  cuas_sec NUMERIC(23, 0),
  asig_cod VARCHAR(20),
  asig_descripcion VARCHAR(4000),
  nro_bloque NUMERIC,
  fec_asistencia TIMESTAMP WITHOUT TIME ZONE,
  cod_estado VARCHAR(15),
  desc_estado VARCHAR(240),
  prof_sec NUMERIC(23, 0),
  rut_prof VARCHAR(4000),
  nom_prof VARCHAR(4000),
  nom_firma VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_resumen_leccionario (
  tipo_leccionario VARCHAR(14),
  reel_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  peri_sec NUMERIC(23, 0),
  grcu_sec NUMERIC(23, 0),
  tien_cod VARCHAR(10),
  tien_descripcion VARCHAR(200),
  grte_cod VARCHAR(10),
  grte_descrip VARCHAR(100),
  grcu_letra_curso VARCHAR(2),
  reel_nro_cont NUMERIC(23, 0),
  cuas_sec NUMERIC,
  asig_cod VARCHAR(20),
  asig_descripcion VARCHAR(200),
  fec_leccionario TIMESTAMP WITHOUT TIME ZONE,
  cod_estado VARCHAR(15),
  desc_estado VARCHAR(240),
  firma_lecc VARCHAR(4000),
  nom_prof VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_tipo_ensenanzas (
  tien_cod NUMERIC,
  tien_nombre VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_portaldir.pdir_wrk_usuarios_sost (
  pers_rut BIGINT,
  pers_dv VARCHAR(1),
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(60),
  pers_ape_mat VARCHAR(60),
  pers_sec NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_portaldir.xx_pad (
  grcu_sec NUMERIC(23, 0),
  pers_sec NUMERIC(23, 0),
  esed_sec NUMERIC(23, 0),
  pers_rut BIGINT,
  pers_dv VARCHAR(1),
  pers_nombres VARCHAR(100),
  pers_ape_pat VARCHAR(60),
  pers_ape_mat VARCHAR(60),
  alcu_fec_incorp TIMESTAMP WITHOUT TIME ZONE,
  fial_sec NUMERIC(23, 0),
  alcu_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  alcu_estado VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS admeta.aq__eta_envio_encu_tb_h (
  msgid BYTEA,
  subscriber_ NUMERIC,
  name VARCHAR(512),
  address_ NUMERIC,
  dequeue_time TIMESTAMP WITHOUT TIME ZONE,
  transaction_id VARCHAR(30),
  dequeue_user VARCHAR(128),
  propagated_msgid BYTEA,
  retry_count NUMERIC,
  hint VARCHAR(10),
  spare BYTEA,
  PRIMARY KEY (msgid, subscriber_, name, address_)
);

CREATE TABLE IF NOT EXISTS admeta.bkp_usuarios_mail (
  usua_rut BIGINT,
  usua_email VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS admeta.eta_aplicaciones (
  apli_id VARCHAR(60),
  apli_desc VARCHAR(60),
  apli_label VARCHAR(60),
  apli_pos_aplic INTEGER,
  apli_usuario_ins VARCHAR(20),
  apli_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  apli_padre VARCHAR(60),
  apli_pos_padre INTEGER,
  apli_link VARCHAR(50),
  apli_ayuda VARCHAR(100),
  apli_target VARCHAR(50),
  apli_icono VARCHAR(400),
  PRIMARY KEY (apli_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_app_domains (
  apdo_domain VARCHAR(50),
  apdo_key VARCHAR(30),
  apdo_valor VARCHAR(100),
  apdo_desc VARCHAR(100),
  PRIMARY KEY (apdo_domain, apdo_key)
);

CREATE TABLE IF NOT EXISTS admeta.eta_condiciones (
  encu_id INTEGER,
  preg_id INTEGER,
  cond_id INTEGER,
  cond_operador_rel VARCHAR(3),
  cond_tepr_id INTEGER,
  cond_operador VARCHAR(10),
  cond_valor_cte VARCHAR(50),
  PRIMARY KEY (encu_id, cond_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_controles (
  cont_id VARCHAR(30),
  cont_nombre VARCHAR(250),
  cont_es_lista VARCHAR(1),
  cont_max_caracteres VARCHAR(1),
  cont_usa_decimal VARCHAR(1),
  cont_rango_min VARCHAR(1),
  cont_rango_max VARCHAR(1),
  cont_rango_estricto VARCHAR(1),
  cont_texto_estricto VARCHAR(1),
  cont_max_elementos VARCHAR(1),
  cont_usa_ponderacion VARCHAR(1),
  PRIMARY KEY (cont_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_dashboard_usuario (
  usua_rut NUMERIC,
  tien_id NUMERIC,
  daus_orden NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_digitador_encuestas (
  usua_rut BIGINT,
  encu_id INTEGER,
  dien_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  dien_usuario_ins VARCHAR(20),
  PRIMARY KEY (usua_rut, encu_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_encuestas (
  encu_id INTEGER,
  encu_tmpl_ref INTEGER,
  tien_id INTEGER,
  encu_titulo VARCHAR(150),
  encu_subtitulo VARCHAR(200),
  encu_descripcion VARCHAR(400),
  encu_label1 VARCHAR(40),
  encu_label2 VARCHAR(40),
  encu_label3 VARCHAR(40),
  encu_ayuda VARCHAR(1000),
  encu_ponderacion NUMERIC(5, 2),
  encu_estado VARCHAR(1),
  encu_usuario_ins VARCHAR(20),
  encu_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  encu_usuario_upd VARCHAR(20),
  encu_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  encu_fec_envio TIMESTAMP WITHOUT TIME ZONE,
  encu_puntaje NUMERIC,
  encu_tipo_termino VARCHAR(1),
  encu_fec_termino TIMESTAMP WITHOUT TIME ZONE,
  encu_tipo_eval VARCHAR(1),
  encu_tipo VARCHAR(1),
  PRIMARY KEY (encu_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_encuesta_mot_rechazos (
  encu_id INTEGER,
  more_id INTEGER,
  enmr_usuario_ins VARCHAR(20),
  enmr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (encu_id, more_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_envio_encu_tb (
  q_name VARCHAR(128),
  msgid BYTEA,
  corrid VARCHAR(128),
  priority NUMERIC,
  state NUMERIC,
  delay TIMESTAMP WITHOUT TIME ZONE,
  expiration NUMERIC,
  time_manager_info TIMESTAMP WITHOUT TIME ZONE,
  local_order_no NUMERIC,
  chain_no NUMERIC,
  cscn NUMERIC,
  dscn NUMERIC,
  enq_time TIMESTAMP WITHOUT TIME ZONE,
  enq_uid VARCHAR(128),
  enq_tid VARCHAR(30),
  deq_time TIMESTAMP WITHOUT TIME ZONE,
  deq_uid VARCHAR(128),
  deq_tid VARCHAR(30),
  retry_count NUMERIC,
  exception_qschema VARCHAR(128),
  exception_queue VARCHAR(128),
  step_no NUMERIC,
  recipient_key NUMERIC,
  dequeue_msgid BYTEA,
  sender_name VARCHAR(128),
  sender_address VARCHAR(1024),
  sender_protocol NUMERIC,
  user_data TEXT,
  user_prop TEXT,
  PRIMARY KEY (msgid)
);

CREATE TABLE IF NOT EXISTS admeta.eta_estados_encuesta (
  esen_id INTEGER,
  esen_tipo_id VARCHAR(3),
  esen_desc_usuario VARCHAR(50),
  esen_desc_interno VARCHAR(300),
  esen_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  esen_usuario_ins VARCHAR(20),
  PRIMARY KEY (esen_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_esta_detalle (
  esde_encu_id NUMERIC,
  esde_rut_usuario NUMERIC,
  esde_tipo_objeto NUMERIC,
  esde_fec_envio TIMESTAMP WITHOUT TIME ZONE,
  esde_cnt_tipo_obj NUMERIC,
  esde_cnt_tipo_obj_cat NUMERIC,
  esde_cnt_tipo_obj_pen NUMERIC,
  esde_cnt_90_100 NUMERIC,
  esde_cnt_61_89 NUMERIC,
  esde_cnt_0_60 NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_esta_resumen (
  esre_id NUMERIC,
  esre_encu_id NUMERIC,
  esre_encu_titulo VARCHAR(400),
  esre_encu_fec_envio TIMESTAMP WITHOUT TIME ZONE,
  esre_rut_usuario NUMERIC,
  esre_cnt_encu NUMERIC,
  esre_cnt_encu_contestadas NUMERIC,
  esre_cnt_encu_pendientes NUMERIC,
  esre_cnt_encu_invalidadas NUMERIC,
  esre_cnt_encu_90_100 NUMERIC,
  esre_cnt_encu_61_89 NUMERIC,
  esre_cnt_encu_0_60 NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_eval_encuestas (
  even_id INTEGER,
  encu_id INTEGER,
  even_descripcion VARCHAR(4000),
  even_fecha_creacion TIMESTAMP WITHOUT TIME ZONE,
  even_r1_ini INTEGER,
  even_r1_fin NUMERIC,
  even_r2_ini NUMERIC,
  even_r2_fin NUMERIC,
  even_r3_ini NUMERIC,
  even_r3_fin NUMERIC,
  even_titulo VARCHAR(300),
  even_puntaje NUMERIC,
  even_estado VARCHAR(1),
  PRIMARY KEY (even_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_eval_grupos (
  even_id NUMERIC,
  encu_id NUMERIC,
  grup_id NUMERIC,
  evgr_puntaje NUMERIC,
  evgr_orden NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_eval_item_respuestas (
  even_id INTEGER,
  encu_id INTEGER,
  secc_id INTEGER,
  preg_id NUMERIC,
  cont_id VARCHAR(30),
  evir_valor VARCHAR(50),
  evir_peso NUMERIC,
  PRIMARY KEY (even_id, encu_id, secc_id, preg_id, cont_id, evir_valor)
);

CREATE TABLE IF NOT EXISTS admeta.eta_eval_preguntas (
  even_id INTEGER,
  encu_id INTEGER,
  secc_id INTEGER,
  preg_id INTEGER,
  evpr_puntaje NUMERIC,
  evpr_orden NUMERIC,
  PRIMARY KEY (even_id, encu_id, secc_id, preg_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_eval_rangos (
  usua_rut NUMERIC,
  even_id NUMERIC,
  encu_id NUMERIC,
  usen_id NUMERIC,
  r1 NUMERIC,
  r2 NUMERIC,
  r3 NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_eval_resultado (
  usua_rut NUMERIC,
  even_id NUMERIC,
  encu_id NUMERIC,
  tien_id NUMERIC,
  tiob_descripcion VARCHAR(30),
  total_encuesta NUMERIC,
  total_contestado NUMERIC,
  total_pendiente NUMERIC,
  total_rechazados NUMERIC,
  total_invalidos NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_eval_secciones (
  even_id INTEGER,
  encu_id INTEGER,
  secc_id INTEGER,
  evse_puntaje NUMERIC,
  grup_id NUMERIC,
  evse_orden NUMERIC,
  PRIMARY KEY (even_id, encu_id, secc_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_grupos (
  grup_id INTEGER,
  encu_id INTEGER,
  grup_titulo VARCHAR(150),
  grup_ponderacion NUMERIC,
  grup_usuario_ins VARCHAR(20),
  grup_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  grup_usuario_upd VARCHAR(20),
  grup_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  grup_orden INTEGER,
  PRIMARY KEY (grup_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_historia_estado (
  hies_id INTEGER,
  usen_id INTEGER,
  esen_id INTEGER,
  hies_usuario_ins VARCHAR(20),
  hies_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (hies_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_imagenes (
  imag_id INTEGER,
  imag_foto TEXT,
  PRIMARY KEY (imag_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_img_respuesta (
  resp_id INTEGER,
  imag_id INTEGER,
  imag_file VARCHAR(200),
  imag_mimetype VARCHAR(200),
  imag_size NUMERIC,
  imag_height NUMERIC,
  imag_width NUMERIC,
  imag_usuario_ins VARCHAR(20),
  imag_fec_ins TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS admeta.eta_lista_anonima (
  lian_id NUMERIC,
  lian_nombre VARCHAR(200),
  encu_id NUMERIC,
  obje_id NUMERIC,
  lian_fec_creacion TIMESTAMP WITHOUT TIME ZONE,
  lian_estado VARCHAR(1),
  PRIMARY KEY (lian_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_lista_elementos (
  preg_id INTEGER,
  encu_id INTEGER,
  liel_id VARCHAR(20),
  liel_texto VARCHAR(40),
  liel_posicion INTEGER,
  liel_estado VARCHAR(1),
  liel_usuario_ins VARCHAR(20),
  liel_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  liel_usuario_upd VARCHAR(20),
  liel_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (encu_id, preg_id, liel_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_log_app_d (
  load_id NUMERIC,
  load_dump TEXT
);

CREATE TABLE IF NOT EXISTS admeta.eta_log_app_h (
  loah_id NUMERIC,
  loah_ip VARCHAR(100),
  loah_usuario VARCHAR(100),
  loah_fec_app VARCHAR(50),
  loah_recurso VARCHAR(4000),
  loah_status_code VARCHAR(100),
  loah_return_size NUMERIC,
  loah_fec_sys TIMESTAMP WITHOUT TIME ZONE,
  loah_error_code NUMERIC,
  load_id NUMERIC,
  loah_id_padre NUMERIC,
  loah_level_error VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS admeta.eta_motivo_rechazos (
  more_id INTEGER,
  more_descripcion VARCHAR(50),
  more_usuario_ins VARCHAR(20),
  more_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  more_usuario_upd VARCHAR(20),
  more_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  more_estado VARCHAR(1),
  PRIMARY KEY (more_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_objetos (
  obje_id INTEGER,
  obje_nombre VARCHAR(50),
  tiob_id INTEGER,
  obje_logo TEXT,
  obje_descripcion VARCHAR(1000),
  obje_usuario_ins VARCHAR(20),
  obje_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  obje_usuario_upd VARCHAR(20),
  obje_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  obje_estado VARCHAR(1),
  PRIMARY KEY (obje_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_parametros (
  para_codigo VARCHAR(50),
  para_desc VARCHAR(100),
  para_valor VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS admeta.eta_perfiles (
  perf_id VARCHAR(50),
  perf_desc VARCHAR(100),
  perf_usuario_ins VARCHAR(20),
  perf_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (perf_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_perfiles_aplicacion (
  perf_id VARCHAR(50),
  apli_id VARCHAR(60),
  peap_usuario_ins VARCHAR(20),
  peap_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (perf_id, apli_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_perfiles_usuarios (
  usua_rut BIGINT,
  tipe_id INTEGER,
  peus_usuario_ins VARCHAR(20),
  peus_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  peus_usuario_upd VARCHAR(20),
  peus_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usua_rut, tipe_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_preguntas (
  preg_id INTEGER,
  preg_enunciado VARCHAR(250),
  cont_id VARCHAR(30),
  preg_opcional VARCHAR(1),
  preg_tiene_condicion VARCHAR(1),
  preg_tipo_condicion VARCHAR(3),
  preg_ponderacion NUMERIC,
  preg_es_lista VARCHAR(1),
  preg_max_caracteres INTEGER,
  preg_usa_decimal VARCHAR(1),
  preg_rango_min NUMERIC,
  preg_rango_max NUMERIC,
  preg_rango_estricto VARCHAR(1),
  preg_texto_estricto VARCHAR(150),
  preg_max_elementos INTEGER,
  preg_estado VARCHAR(1),
  preg_usuario_ins VARCHAR(20),
  preg_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  preg_usuario_upd VARCHAR(20),
  preg_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  preg_orden INTEGER,
  tipr_id INTEGER,
  encu_id INTEGER,
  preg_es_total VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS admeta.eta_response_json (
  usen_id INTEGER,
  rejs_json TEXT
);

CREATE TABLE IF NOT EXISTS admeta.eta_respuestas (
  resp_id INTEGER,
  usen_id INTEGER,
  encu_id INTEGER,
  secc_id INTEGER,
  preg_id INTEGER,
  resp_r_text VARCHAR(4000),
  resp_r_number NUMERIC,
  resp_r_date TIMESTAMP WITHOUT TIME ZONE,
  resp_fec_respuesta TIMESTAMP WITHOUT TIME ZONE,
  resp_usuario_ins VARCHAR(20),
  resp_fec_ins TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS admeta.eta_respuestas_nor (
  resp_id INTEGER,
  usen_id INTEGER,
  encu_id INTEGER,
  secc_id INTEGER,
  preg_id INTEGER,
  reno_item INTEGER,
  reno_valor INTEGER,
  reno_fec_respuesta TIMESTAMP WITHOUT TIME ZONE,
  reno_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  reno_usuario_ins VARCHAR(20),
  PRIMARY KEY (resp_id, usen_id, encu_id, secc_id, preg_id, reno_item)
);

CREATE TABLE IF NOT EXISTS admeta.eta_respuesta_resumen (
  usen_id INTEGER,
  rere_total_respuestas NUMERIC,
  rere_total_enviadas NUMERIC,
  rere_respuestas_null VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS admeta.eta_roles (
  role_id VARCHAR(50),
  role_desc VARCHAR(100),
  role_usuario_ins VARCHAR(20),
  role_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (role_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_roles_aplicacion (
  role_id VARCHAR(50),
  apli_id VARCHAR(60),
  peap_usuario_ins VARCHAR(20),
  peap_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (role_id, apli_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_roles_usuarios (
  usua_rut BIGINT,
  role_id INTEGER,
  reus_usuario_ins VARCHAR(20),
  reus_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  reus_usuario_upd VARCHAR(20),
  reus_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usua_rut, role_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_run_proc (
  rupr_id NUMERIC,
  rupr_nombre VARCHAR(200),
  rupr_cod_err NUMERIC,
  rupr_des_err VARCHAR(4000),
  rupr_rtn_number NUMERIC,
  rupr_rtn_varchar VARCHAR(4000),
  rupr_rtn_date TIMESTAMP WITHOUT TIME ZONE,
  rupr_fec_exec TIMESTAMP WITHOUT TIME ZONE,
  rupr_user VARCHAR(50),
  PRIMARY KEY (rupr_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_secciones (
  secc_id INTEGER,
  encu_id INTEGER,
  secc_titulo VARCHAR(150),
  secc_descripcion VARCHAR(400),
  secc_ponderacion NUMERIC,
  secc_ayuda VARCHAR(1000),
  secc_estado VARCHAR(1),
  secc_usuario_ins VARCHAR(20),
  secc_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  secc_usuario_upd VARCHAR(20),
  secc_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  secc_orden INTEGER,
  secc_es_porcentaje VARCHAR(1),
  grup_id INTEGER,
  PRIMARY KEY (secc_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_seccion_preguntas (
  secc_id INTEGER,
  preg_id INTEGER,
  sepr_usuario_ins VARCHAR(20),
  sepr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  sepr_puntaje NUMERIC,
  sepr_orden NUMERIC,
  PRIMARY KEY (preg_id, secc_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_stat_preguntas (
  usua_rut BIGINT,
  encu_id INTEGER,
  even_id INTEGER,
  usen_id INTEGER,
  secc_id INTEGER,
  preg_id INTEGER,
  stpr_ru VARCHAR(4000),
  stpr_pe NUMERIC,
  stpr_po NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_stat_secciones (
  usua_rut BIGINT,
  encu_id INTEGER,
  even_id INTEGER,
  usen_id INTEGER,
  secc_id INTEGER,
  stse_pe NUMERIC,
  stse_po NUMERIC,
  stse_pr NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_tags_modelo (
  tamo_id INTEGER,
  tamo_md5 VARCHAR(1000),
  tamo_tag_real VARCHAR(100),
  PRIMARY KEY (tamo_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tag_teen (
  teen_id INTEGER,
  tamo_id INTEGER,
  tate_usuario_ins VARCHAR(20),
  tate_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (teen_id, tamo_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tag_tepr (
  tepr_id INTEGER,
  tamo_id INTEGER,
  tatp_usuario_ins VARCHAR(20),
  tatp_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (tepr_id, tamo_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tipo_encuesta (
  tien_id INTEGER,
  tien_descripcion VARCHAR(50),
  tien_usuario_ins VARCHAR(20),
  tien_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tien_usuario_upd VARCHAR(20),
  tien_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  tien_estado VARCHAR(1),
  PRIMARY KEY (tien_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tipo_objeto (
  tiob_id INTEGER,
  tiob_descripcion VARCHAR(50),
  tiob_usuario_ins VARCHAR(20),
  tiob_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tiob_usuario_upd VARCHAR(20),
  tiob_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  tiob_estado VARCHAR(1),
  PRIMARY KEY (tiob_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tipo_perfiles (
  tipe_id INTEGER,
  tipe_nombre VARCHAR(50),
  tipe_usuario_ins VARCHAR(20),
  tipe_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  tipe_usuario_upd VARCHAR(20),
  tipe_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (tipe_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tipo_preguntas (
  tipr_id INTEGER,
  tipr_nombre VARCHAR(100),
  tipr_estado VARCHAR(1),
  tipr_usuario_ins VARCHAR(20),
  tipr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tipr_usuario_upd VARCHAR(20),
  tipr_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (tipr_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_condiciones (
  tcon_id INTEGER,
  tepr_id INTEGER,
  tcon_operador_rel VARCHAR(3),
  tcon_tepr_id INTEGER,
  tcon_operador VARCHAR(10),
  tcon_valor_cte VARCHAR(50),
  PRIMARY KEY (tcon_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_encuestas_org (
  teen_id INTEGER,
  tien_id INTEGER,
  teen_titulo VARCHAR(150),
  teen_subtitulo VARCHAR(200),
  teen_descripcion VARCHAR(400),
  teen_label1 VARCHAR(40),
  teen_label2 VARCHAR(40),
  teen_label3 VARCHAR(40),
  teen_ayuda VARCHAR(1000),
  teen_estado VARCHAR(1),
  teen_usuario_ins VARCHAR(20),
  teen_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  teen_usuario_upd VARCHAR(20),
  teen_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  teen_puntaje NUMERIC,
  teen_tipo_eval VARCHAR(1),
  teen_puntaje_real NUMERIC,
  PRIMARY KEY (teen_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_encu_mot_rec (
  teen_id INTEGER,
  more_id INTEGER,
  tmtr_usuario_ins VARCHAR(20),
  tmtr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (teen_id, more_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_grupos (
  tegr_id INTEGER,
  teen_id INTEGER,
  tegr_titulo VARCHAR(150),
  tegr_ponderacion NUMERIC,
  tegr_usuario_ins VARCHAR(20),
  tegr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tegr_usuario_upd VARCHAR(20),
  tegr_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  tegr_orden INTEGER,
  PRIMARY KEY (tegr_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_lst_elementos (
  tepr_id INTEGER,
  tlel_id VARCHAR(20),
  tlel_texto VARCHAR(40),
  tlel_posicion INTEGER,
  tlel_estado VARCHAR(1),
  tlel_usuario_ins VARCHAR(20),
  tlel_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tlel_usuario_upd VARCHAR(20),
  tlel_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (tepr_id, tlel_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_preguntas (
  tepr_id INTEGER,
  tepr_enunciado VARCHAR(250),
  cont_id VARCHAR(30),
  tepr_opcional VARCHAR(1),
  tepr_tiene_condicion VARCHAR(1),
  tepr_tipo_condicion VARCHAR(3),
  tepr_ponderacion NUMERIC,
  tepr_es_lista VARCHAR(1),
  tepr_max_caracteres INTEGER,
  tepr_usa_decimal VARCHAR(1),
  tepr_rango_min NUMERIC,
  tepr_rango_max NUMERIC,
  tepr_rango_estricto VARCHAR(1),
  tepr_texto_estricto VARCHAR(150),
  tepr_max_elementos INTEGER,
  tepr_estado VARCHAR(1),
  tepr_usuario_ins VARCHAR(20),
  tepr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tepr_usuario_upd VARCHAR(20),
  tepr_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  tepr_orden INTEGER,
  tipr_id INTEGER,
  tepr_es_total VARCHAR(1),
  PRIMARY KEY (tepr_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_preguntas_8am (
  tepr_id INTEGER,
  tepr_enunciado VARCHAR(250),
  cont_id VARCHAR(30),
  tepr_opcional VARCHAR(1),
  tepr_tiene_condicion VARCHAR(1),
  tepr_tipo_condicion VARCHAR(3),
  tepr_ponderacion NUMERIC(5, 2),
  tepr_es_lista VARCHAR(1),
  tepr_max_caracteres INTEGER,
  tepr_usa_decimal VARCHAR(1),
  tepr_rango_min NUMERIC,
  tepr_rango_max NUMERIC,
  tepr_rango_estricto VARCHAR(1),
  tepr_texto_estricto VARCHAR(150),
  tepr_max_elementos INTEGER,
  tepr_estado VARCHAR(1),
  tepr_usuario_ins VARCHAR(20),
  tepr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tepr_usuario_upd VARCHAR(20),
  tepr_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  tepr_orden INTEGER,
  tipr_id INTEGER,
  tepr_es_total VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_secciones (
  tese_id INTEGER,
  teen_id INTEGER,
  tese_titulo VARCHAR(150),
  tese_descripcion VARCHAR(400),
  tese_ponderacion NUMERIC,
  tese_ayuda VARCHAR(1000),
  tese_estado VARCHAR(1),
  tese_usuario_ins VARCHAR(20),
  tese_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tese_usuario_upd VARCHAR(20),
  tese_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  tese_orden INTEGER,
  tese_es_porcentaje VARCHAR(1),
  tegr_id INTEGER,
  PRIMARY KEY (tese_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_secciones_8am (
  tese_id INTEGER,
  teen_id INTEGER,
  tese_titulo VARCHAR(150),
  tese_descripcion VARCHAR(400),
  tese_ponderacion NUMERIC,
  tese_ayuda VARCHAR(1000),
  tese_estado VARCHAR(1),
  tese_usuario_ins VARCHAR(20),
  tese_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tese_usuario_upd VARCHAR(20),
  tese_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  tese_orden INTEGER,
  tese_es_porcentaje VARCHAR(1),
  tegr_id INTEGER
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_seccion_preguntas (
  tese_id INTEGER,
  tepr_id INTEGER,
  tspr_usuario_ins VARCHAR(20),
  tspr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tspr_puntaje NUMERIC,
  tspr_orden NUMERIC,
  PRIMARY KEY (tepr_id, tese_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_tmpl_seccion_preguntas_8am (
  tese_id INTEGER,
  tepr_id INTEGER,
  tspr_usuario_ins VARCHAR(20),
  tspr_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  tspr_puntaje NUMERIC,
  tspr_orden NUMERIC
);

CREATE TABLE IF NOT EXISTS admeta.eta_users_admin (
  usad_rut BIGINT,
  PRIMARY KEY (usad_rut)
);

CREATE TABLE IF NOT EXISTS admeta.eta_user_anonimos (
  lian_id NUMERIC,
  usan_id NUMERIC,
  usan_correo VARCHAR(200),
  usan_telefono VARCHAR(30),
  usan_token VARCHAR(2000),
  PRIMARY KEY (usan_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_usuarios (
  usua_rut BIGINT,
  usua_nombre VARCHAR(50),
  usua_email VARCHAR(50),
  usua_telefono VARCHAR(15),
  usua_celular VARCHAR(15),
  usua_usuario_ins VARCHAR(20),
  usua_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usua_usuario_upd VARCHAR(20),
  usua_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usua_rut)
);

CREATE TABLE IF NOT EXISTS admeta.eta_usuarios_encuentas (
  usen_id INTEGER,
  encu_id INTEGER,
  obje_id INTEGER,
  usua_rut BIGINT,
  esen_id INTEGER,
  usen_estado_movil INTEGER,
  usen_estado_mail INTEGER,
  usen_dias_duracion INTEGER,
  usua_rut_respuesta BIGINT,
  usen_usuario_ins VARCHAR(20),
  usen_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  usen_usuario_upd VARCHAR(20),
  usen_fec_upd TIMESTAMP WITHOUT TIME ZONE,
  more_id INTEGER,
  usen_asignacion VARCHAR(1),
  usen_fec_termino TIMESTAMP WITHOUT TIME ZONE,
  usen_tipo VARCHAR(1),
  PRIMARY KEY (usen_id)
);

CREATE TABLE IF NOT EXISTS admeta.eta_usuarios_perfiles (
  usua_rut BIGINT,
  perf_id VARCHAR(50),
  uspe_usuario_ins VARCHAR(20),
  uspe_fec_ins TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (usua_rut, perf_id)
);

CREATE TABLE IF NOT EXISTS admeta.lcs_educa (
  rut NUMERIC,
  nombre VARCHAR(200),
  ape1 VARCHAR(200),
  ape2 VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS admeta.lcs_rut_mail (
  pers_rut NUMERIC,
  trab_email_corp VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS admeta.lcs_rut_mail_2 (
  pers_rut NUMERIC,
  trab_email_corp VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS admeta.x_educa (
  rut_empleado NUMERIC,
  dv VARCHAR(300),
  paterno VARCHAR(300),
  materno VARCHAR(300),
  nombre VARCHAR(300),
  descripcion VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_asignaturas_tmp (
  asig_asignatura VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_asignaturas_tmp_order (
  asig_asignatura VARCHAR(200),
  orden NUMERIC
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_asig_orden_tmp (
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  asig_asignatura VARCHAR(200),
  orden NUMERIC,
  PRIMARY KEY (cod_rbd, desc_grado, asig_asignatura)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_asistencia_alum_tmp (
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  periodo VARCHAR(20),
  fial_rut BIGINT,
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  asal_porc_asis NUMERIC(5, 2),
  asal_usr_ins VARCHAR(10),
  asal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  asal_usr_upd VARCHAR(10),
  asal_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  fial_estado_alum VARCHAR(30),
  PRIMARY KEY (fial_anno, cod_rbd, desc_grado, fial_letra_curso, periodo, fial_rut)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_directores_estab_tmp (
  cod_rbd VARCHAR(10),
  dies_director VARCHAR(200),
  dies_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  dies_usr_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_estab_educa_tmp (
  esed_codigo VARCHAR(30),
  esed_descripcion VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_ficha_alumno_tmp (
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  cod_tipo_educa VARCHAR(10),
  cod_grado VARCHAR(10),
  desc_grado VARCHAR(100),
  fial_letra_curso VARCHAR(5),
  fial_rut BIGINT,
  fial_dv VARCHAR(1),
  fial_genero VARCHAR(5),
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  fial_direc VARCHAR(200),
  fial_cod_region VARCHAR(20),
  fial_comuna_res VARCHAR(100),
  fial_cod_comuna_res VARCHAR(20),
  fial_telefono VARCHAR(30),
  fial_celular VARCHAR(30),
  fial_email VARCHAR(100),
  fial_fec_nac TIMESTAMP WITHOUT TIME ZONE,
  fial_cod_etnia VARCHAR(10),
  fial_fec_ing_curso TIMESTAMP WITHOUT TIME ZONE,
  fial_fec_retiro TIMESTAMP WITHOUT TIME ZONE,
  fial_promedio_final NUMERIC(5, 2),
  fial_porc_asistenca NUMERIC(5, 2),
  fial_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  fial_user_ing VARCHAR(30),
  fial_fec_mod TIMESTAMP WITHOUT TIME ZONE,
  fial_user_mod VARCHAR(30),
  fial_estado_alum VARCHAR(30),
  PRIMARY KEY (fial_anno, cod_rbd, cod_grado, fial_letra_curso, fial_rut)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_notas_alumnos_log_tmp (
  accion VARCHAR(6),
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  periodo VARCHAR(20),
  fial_rut BIGINT,
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  asig_asignatura VARCHAR(200),
  noal_nota_1 VARCHAR(2),
  noal_nota_2 VARCHAR(2),
  noal_nota_3 VARCHAR(2),
  noal_nota_4 VARCHAR(2),
  noal_nota_5 VARCHAR(2),
  noal_nota_6 VARCHAR(2),
  noal_nota_7 VARCHAR(2),
  noal_nota_8 VARCHAR(2),
  noal_nota_9 VARCHAR(2),
  noal_nota_10 VARCHAR(2),
  noal_nota_11 VARCHAR(2),
  noal_nota_12 VARCHAR(2),
  noal_nota_13 VARCHAR(2),
  noal_nota_14 VARCHAR(2),
  noal_nota_15 VARCHAR(2),
  noal_promedio_parcial VARCHAR(2),
  noal_nota_examen VARCHAR(2),
  noal_promedio_final VARCHAR(2),
  noal_usr_ins VARCHAR(10),
  noal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  noal_usr_upd VARCHAR(10),
  noal_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  noal_prom_par_sis VARCHAR(2),
  fial_estado_alum VARCHAR(30),
  logs_usr_mod VARCHAR(10),
  logs_fecha_mod TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_notas_alumnos_tmp (
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  periodo VARCHAR(20),
  fial_rut BIGINT,
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  asig_asignatura VARCHAR(200),
  noal_nota_1 VARCHAR(2),
  noal_nota_2 VARCHAR(2),
  noal_nota_3 VARCHAR(2),
  noal_nota_4 VARCHAR(2),
  noal_nota_5 VARCHAR(2),
  noal_nota_6 VARCHAR(2),
  noal_nota_7 VARCHAR(2),
  noal_nota_8 VARCHAR(2),
  noal_nota_9 VARCHAR(2),
  noal_nota_10 VARCHAR(2),
  noal_nota_11 VARCHAR(2),
  noal_nota_12 VARCHAR(2),
  noal_nota_13 VARCHAR(2),
  noal_nota_14 VARCHAR(2),
  noal_nota_15 VARCHAR(2),
  noal_promedio_parcial VARCHAR(2),
  noal_nota_examen VARCHAR(2),
  noal_promedio_final VARCHAR(2),
  noal_usr_ins VARCHAR(10),
  noal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  noal_usr_upd VARCHAR(10),
  noal_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  noal_prom_par_sis VARCHAR(2),
  fial_estado_alum VARCHAR(30),
  PRIMARY KEY (fial_anno, cod_rbd, desc_grado, fial_letra_curso, periodo, fial_rut, asig_asignatura)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_notas_alumnos_tmp_bkp (
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  periodo VARCHAR(20),
  fial_rut BIGINT,
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  asig_asignatura VARCHAR(200),
  noal_nota_1 VARCHAR(2),
  noal_nota_2 VARCHAR(2),
  noal_nota_3 VARCHAR(2),
  noal_nota_4 VARCHAR(2),
  noal_nota_5 VARCHAR(2),
  noal_nota_6 VARCHAR(2),
  noal_nota_7 VARCHAR(2),
  noal_nota_8 VARCHAR(2),
  noal_nota_9 VARCHAR(2),
  noal_nota_10 VARCHAR(2),
  noal_nota_11 VARCHAR(2),
  noal_nota_12 VARCHAR(2),
  noal_nota_13 VARCHAR(2),
  noal_nota_14 VARCHAR(2),
  noal_nota_15 VARCHAR(2),
  noal_promedio_parcial VARCHAR(2),
  noal_nota_examen VARCHAR(2),
  noal_promedio_final VARCHAR(2),
  noal_usr_ins VARCHAR(10),
  noal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  noal_usr_upd VARCHAR(10),
  noal_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  noal_prom_par_sis VARCHAR(2),
  fial_estado_alum VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_notas_alumnos_tmp_bkp_2 (
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  periodo VARCHAR(20),
  fial_rut BIGINT,
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  asig_asignatura VARCHAR(200),
  noal_nota_1 VARCHAR(2),
  noal_nota_2 VARCHAR(2),
  noal_nota_3 VARCHAR(2),
  noal_nota_4 VARCHAR(2),
  noal_nota_5 VARCHAR(2),
  noal_nota_6 VARCHAR(2),
  noal_nota_7 VARCHAR(2),
  noal_nota_8 VARCHAR(2),
  noal_nota_9 VARCHAR(2),
  noal_nota_10 VARCHAR(2),
  noal_nota_11 VARCHAR(2),
  noal_nota_12 VARCHAR(2),
  noal_nota_13 VARCHAR(2),
  noal_nota_14 VARCHAR(2),
  noal_nota_15 VARCHAR(2),
  noal_promedio_parcial VARCHAR(2),
  noal_nota_examen VARCHAR(2),
  noal_promedio_final VARCHAR(2),
  noal_usr_ins VARCHAR(10),
  noal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  noal_usr_upd VARCHAR(10),
  noal_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  noal_prom_par_sis VARCHAR(2),
  fial_estado_alum VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_notas_alumnos_tmp_bkp_3 (
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  periodo VARCHAR(20),
  fial_rut BIGINT,
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  asig_asignatura VARCHAR(200),
  noal_nota_1 VARCHAR(2),
  noal_nota_2 VARCHAR(2),
  noal_nota_3 VARCHAR(2),
  noal_nota_4 VARCHAR(2),
  noal_nota_5 VARCHAR(2),
  noal_nota_6 VARCHAR(2),
  noal_nota_7 VARCHAR(2),
  noal_nota_8 VARCHAR(2),
  noal_nota_9 VARCHAR(2),
  noal_nota_10 VARCHAR(2),
  noal_nota_11 VARCHAR(2),
  noal_nota_12 VARCHAR(2),
  noal_nota_13 VARCHAR(2),
  noal_nota_14 VARCHAR(2),
  noal_nota_15 VARCHAR(2),
  noal_promedio_parcial VARCHAR(2),
  noal_nota_examen VARCHAR(2),
  noal_promedio_final VARCHAR(2),
  noal_usr_ins VARCHAR(10),
  noal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  noal_usr_upd VARCHAR(10),
  noal_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  noal_prom_par_sis VARCHAR(2),
  fial_estado_alum VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_notas_alumnos_tmp_bkp_4 (
  fial_anno INTEGER,
  cod_rbd VARCHAR(10),
  desc_grado VARCHAR(200),
  fial_letra_curso VARCHAR(5),
  periodo VARCHAR(20),
  fial_rut BIGINT,
  fial_nombres VARCHAR(100),
  fial_ape_pat VARCHAR(60),
  fial_ape_mat VARCHAR(60),
  asig_asignatura VARCHAR(200),
  noal_nota_1 VARCHAR(2),
  noal_nota_2 VARCHAR(2),
  noal_nota_3 VARCHAR(2),
  noal_nota_4 VARCHAR(2),
  noal_nota_5 VARCHAR(2),
  noal_nota_6 VARCHAR(2),
  noal_nota_7 VARCHAR(2),
  noal_nota_8 VARCHAR(2),
  noal_nota_9 VARCHAR(2),
  noal_nota_10 VARCHAR(2),
  noal_nota_11 VARCHAR(2),
  noal_nota_12 VARCHAR(2),
  noal_nota_13 VARCHAR(2),
  noal_nota_14 VARCHAR(2),
  noal_nota_15 VARCHAR(2),
  noal_promedio_parcial VARCHAR(2),
  noal_nota_examen VARCHAR(2),
  noal_promedio_final VARCHAR(2),
  noal_usr_ins VARCHAR(10),
  noal_fecha_ins TIMESTAMP WITHOUT TIME ZONE,
  noal_usr_upd VARCHAR(10),
  noal_fecha_upd TIMESTAMP WITHOUT TIME ZONE,
  noal_prom_par_sis VARCHAR(2),
  fial_estado_alum VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_profesores_jefes_tmp (
  cod_rbd VARCHAR(10),
  prje_rut BIGINT,
  prje_dv VARCHAR(1),
  prje_profesor VARCHAR(200),
  desc_grado VARCHAR(100),
  fial_letra_curso VARCHAR(5),
  prje_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prje_usr_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_profesores_jefes_tmp_bkp (
  cod_rbd VARCHAR(10),
  prje_rut BIGINT,
  prje_dv VARCHAR(1),
  prje_profesor VARCHAR(200),
  desc_grado VARCHAR(100),
  fial_letra_curso VARCHAR(5),
  prje_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  prje_usr_ing VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS adm_notas.edc_usuarios_tmp (
  usua_usuarios VARCHAR(10),
  usua_clave VARCHAR(256),
  usua_bloqueo VARCHAR(1),
  usua_fec_ing TIMESTAMP WITHOUT TIME ZONE,
  cod_rbd VARCHAR(10),
  PRIMARY KEY (usua_usuarios)
);

CREATE TABLE IF NOT EXISTS adm_notas.sqln_explain_plan (
  statement_id VARCHAR(30),
  "timestamp" TIMESTAMP WITHOUT TIME ZONE,
  remarks VARCHAR(80),
  operation VARCHAR(30),
  options VARCHAR(30),
  object_node VARCHAR(128),
  object_owner VARCHAR(30),
  object_name VARCHAR(30),
  object_instance NUMERIC,
  object_type VARCHAR(30),
  optimizer VARCHAR(255),
  search_columns NUMERIC,
  id NUMERIC,
  parent_id NUMERIC,
  position NUMERIC,
  cost NUMERIC,
  cardinality NUMERIC,
  bytes NUMERIC,
  other_tag VARCHAR(255),
  partition_start VARCHAR(255),
  partition_stop VARCHAR(255),
  partition_id NUMERIC,
  other TEXT,
  distribution VARCHAR(30)
);


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
    