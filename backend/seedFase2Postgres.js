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

async function seedFase2() {
  const client = await pool.connect();
  try {
    console.log('[1/6] Ajustando columnas de observaciones/descripciones en adm_obs a TEXT...');
    const textCols = [
      ['opa_orden_servicio', 'orde_descripcion'],
      ['opa_orden_servicio_mov', 'osmo_descripcion'],
      ['opa_orse_derivados', 'osde_observaciones'],
      ['hr_iniciativa', 'inic_observaciones'],
      ['hr_iniciativa', 'inic_obs_log'],
      ['hr_iniciativa', 'inic_obs_rev'],
      ['hr_hoja_ruta', 'horu_observacion'],
      ['hr_hoja_ruta_log', 'horu_observacion']
    ];
    for (const [tbl, col] of textCols) {
      await client.query(`
        ALTER TABLE adm_obs.${tbl}
        ALTER COLUMN ${col} TYPE TEXT USING ${col}::text
      `).catch(() => {});
    }

    // =========================================================================
    // 1. OFICINA DE PARTES (OPA_*)
    // =========================================================================
    console.log('[2/6] Poblando Módulo 1 Fase 2: Oficina de Partes (adm_obs.opa_*)...');
    const tiposDoc = [
      [1, 'FACT', 'FACTURA ELECTRONICA', 'ACTIVO'],
      [2, 'OFIC', 'OFICIO ORDINARIO', 'ACTIVO'],
      [3, 'MEMO', 'MEMORANDUM INTERNO', 'ACTIVO'],
      [4, 'RESO', 'RESOLUCION EXENTA', 'ACTIVO'],
      [5, 'CART', 'CARTA CERTIFICADA', 'ACTIVO'],
      [6, 'DECR', 'DECRETO ALCALDICIO', 'ACTIVO'],
      [7, 'BOGA', 'BOLETA DE GARANTIA', 'ACTIVO'],
      [8, 'INFO', 'INFORME TECNICO', 'ACTIVO']
    ];
    for (const [sec, cod, desc, est] of tiposDoc) {
      await replaceRow(
        client,
        'opa_tipo_documentos',
        'tido_sec',
        sec,
        `INSERT INTO adm_obs.opa_tipo_documentos (tido_sec, tido_tipo_docu, tido_desc_docu, tido_ult_estado, tido_user_ing, tido_fecha_ing)
         VALUES ($1, $2, $3, $4, '10633447', NOW())`,
        [sec, cod, desc, est]
      );
    }

    const remitentes = [
      [101, '61607100', '7', 'SEREMI DE SALUD REGION DE ANTOFAGASTA', 'EXTERNO', '552655000', 'DR. ALBERTO GODOY', 'ofpartes.antofagasta@redsalud.gob.cl'],
      [102, '60910000', '1', 'SUPERINTENDENCIA DE EDUCACION ANTOFAGASTA', 'EXTERNO', '552451200', 'DIRECCION REGIONAL SIE', 'antofagasta@supereduc.cl'],
      [103, '96579800', '5', 'AGUAS ANTOFAGASTA S.A.', 'PROVEEDOR', '600700600', 'EJECUTIVO GRANDES CLIENTES', 'grandesclientes@aguasantofagasta.cl'],
      [104, '76145890', '2', 'CONSTRUCTORA E INGENIERIA LOA SPA', 'PROVEEDOR', '552891400', 'CARLOS URRUTIA ROJAS', 'contacto@constructoraloa.cl'],
      [105, '61608000', 'K', 'CENTRAL DE ABASTECIMIENTO CENABAST', 'EXTERNO', '224135000', 'SUBDIRECCION OPERACIONES', 'operaciones@cenabast.cl'],
      [106, '69020100', '2', 'ILUSTRE MUNICIPALIDAD DE ANTOFAGASTA', 'EXTERNO', '552887000', 'SECRETARIA MUNICIPAL', 'oficinadepartes@imantof.cl'],
      [107, '76892310', '9', 'SERVICIOS INTEGRALES Y MANTENCION NORTE LTDA.', 'PROVEEDOR', '552773100', 'PATRICIO CONTRERAS', 'pcontreras@mantencionnorte.cl'],
      [108, '70901200', '4', 'DIRECCION DE SALUD APS - CMDS ANTOFAGASTA', 'INTERNO', '552531100', 'DIRECCION SALUD APS', 'salud@cmds.cl'],
      [109, '70901200', '4', 'DIRECCION DE EDUCACION - CMDS ANTOFAGASTA', 'INTERNO', '552531200', 'DIRECCION EDUCACION', 'educacion@cmds.cl'],
      [110, '77320410', 'K', 'TECNOLOGIA Y REDES DIGITALES ATACAMA SPA', 'PROVEEDOR', '552904400', 'MARCELA PIZARRO', 'ventas@redesatacama.cl']
    ];
    for (const [sec, rut, dv, razon, tipo, tel, cont, mail] of remitentes) {
      await replaceRow(
        client,
        'opa_remitentes',
        'remi_sec',
        sec,
        `INSERT INTO adm_obs.opa_remitentes (remi_sec, remi_rut, remi_dv, remi_razon_social, remi_tipo, remi_tel, remi_contacto, remi_mail, remi_user_ing, remi_fecha_ing)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, '10633447', NOW())`,
        [sec, rut, dv, razon, tipo, tel, cont, mail]
      );
    }

    const destinatarios = [
      [201, 'SECRETARIA GENERAL EJECUTIVA', 'DIRECCION EJECUTIVA', 'direccion@cmds.cl', '10633447', 'K', 1, 'ACTIVO'],
      [202, 'DIRECCION DE ADMINISTRACION Y FINANZAS (DAF)', 'FINANZAS', 'daf@cmds.cl', '12890341', '5', 2, 'ACTIVO'],
      [203, 'DIRECCION DE SALUD APS', 'SALUD', 'salud@cmds.cl', '11450982', '3', 3, 'ACTIVO'],
      [204, 'DIRECCION DE EDUCACION', 'EDUCACION', 'educacion@cmds.cl', '13567123', '8', 4, 'ACTIVO'],
      [205, 'DIRECCION DE ASESORIA JURIDICA', 'JURIDICA', 'juridica@cmds.cl', '14223890', '1', 5, 'ACTIVO'],
      [206, 'DEPARTAMENTO DE ABASTECIMIENTO Y LICITACIONES', 'ABASTECIMIENTO', 'abastecimiento@cmds.cl', '15678234', '9', 6, 'ACTIVO'],
      [207, 'DEPARTAMENTO DE OBRAS Y MANTENCION', 'OBRAS', 'obras@cmds.cl', '16334901', '2', 7, 'ACTIVO'],
      [208, 'DEPARTAMENTO DE RECURSOS HUMANOS', 'RRHH', 'rrhh@cmds.cl', '13998112', '4', 8, 'ACTIVO']
    ];
    for (const [sec, nom, area, mail, rut, dv, depa, est] of destinatarios) {
      await replaceRow(
        client,
        'opa_destinatarios',
        'dest_sec',
        sec,
        `INSERT INTO adm_obs.opa_destinatarios (dest_sec, dest_nombre, dest_area, dest_mail, dest_rut, dest_dv, depa_sec, dest_estado, dest_user_ing, dest_fecha_ing)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, '10633447', NOW())`,
        [sec, nom, area, mail, rut, dv, depa, est]
      );
    }

    const documentos = [
      [5001, 2026001, 'OF-1420/2026', '2026-10-28', 'REMITE RESOLUCION SANITARIA CONVENIO PRAPS ODONTOLOGICO CESFAM NORTE Y CORVALLIS', 'OFIC', 'RECEPCIONADO', 101, 'Prioridad revisión convenio APS 2026', 'EXTERNO', 'N', 203, 0, 0, 0, 'N', ''],
      [5002, 2026002, 'FE-88412', '2026-10-30', 'ESTADO DE PAGO N°3 REPARACION CUBIERTAS Y SERVICIOS HIGIENICOS LICEO BICENTENARIO ANDRES SABELLA', 'FACT', 'EN DISTRIBUCION', 104, 'Adjunta acta recepción provisoria ITO Obras', 'PROVEEDOR', 'N', 202, 18500000, 3515000, 22015000, 'S', '1111614-101-SE26'],
      [5003, 2026003, 'ORD-982/2026', '2026-11-02', 'FISCALIZACION USO RECURSOS SUBVENCION ESCOLAR PREFERENCIAL (SEP) ESTABLECIMIENTOS CMDS', 'OFIC', 'DERIVADO', 102, 'Plazo respuesta 10 días hábiles', 'EXTERNO', 'N', 204, 0, 0, 0, 'N', ''],
      [5004, 2026004, 'FE-310944', '2026-11-04', 'SUMINISTRO AGUA POTABLE Y ALCANTARILLADO RED ESTABLECIMIENTOS EDUCACIONALES OCTUBRE 2026', 'FACT', 'RECEPCIONADO', 103, 'Consumos consolidados 48 establecimientos', 'PROVEEDOR', 'N', 202, 12400000, 2356000, 14756000, 'S', '1111614-104-CM26'],
      [5005, 2026005, 'RES-3310/2026', '2026-11-05', 'APRUEBA TRANSFERENCIA DE FONDOS CONVENIO APOYO A LA GESTION LOCAL EN SALUD MUNICIPAL', 'RESO', 'RECEPCIONADO', 101, 'Transferencia cuota Noviembre 2026', 'EXTERNO', 'N', 203, 45000000, 0, 45000000, 'N', ''],
      [5006, 2026006, 'FE-9921', '2026-11-06', 'ADQUISICION EQUIPAMIENTO COMPUTACIONAL Y REDES PARA LABORATORIOS SEP ESCUELA D-68', 'FACT', 'INGRESADO', 110, 'Con guía de despacho firmada por Director', 'PROVEEDOR', 'N', 206, 9800000, 1862000, 11662000, 'S', '1111614-102-CM26'],
      [5007, 2026007, 'MEMO-415/2026', '2026-11-08', 'SOLICITA PRORROGA CONTRATO MANTENCION CLIMATIZACION Y GRUPOS ELECTROGENOS CESFAM', 'MEMO', 'EN DISTRIBUCION', 108, 'Urgente para continuidad operacional SAPU/SAR', 'INTERNO', 'N', 205, 0, 0, 0, 'N', ''],
      [5008, 2026008, 'DECR-2890/2026', '2026-11-09', 'APRUEBA MODIFICACION PRESUPUESTARIA APORTE MUNICIPAL EDUCACION Y SALUD Q4 2026', 'DECR', 'INGRESADO', 106, 'Remitido por Secretaría Municipal IMA', 'EXTERNO', 'N', 201, 120000000, 0, 120000000, 'N', '']
    ];
    for (const [docSec, orden, nro, fecha, mat, tipo, est, remi, obs, remiTipo, priv, destSec, neto, iva, total, indOc, oc] of documentos) {
      await replaceRow(
        client,
        'opa_documentos',
        'docu_sec',
        docSec,
        `INSERT INTO adm_obs.opa_documentos (
          docu_sec, docu_orden, docu_nro, docu_fecha, docu_materia, docu_tipo_docu,
          docu_ult_estado, docu_remi_sec, docu_obs, docu_user_ing, docu_fecha_ing,
          docu_remi_tipo, docu_privado
        ) VALUES ($1, $2, $3, $4::timestamp, $5, $6, $7, $8, $9, '10633447', NOW(), $10, $11)`,
        [docSec, orden, nro, fecha, mat, tipo, est, remi, obs, remiTipo, priv]
      );

      await client.query('DELETE FROM adm_obs.opa_valorados WHERE docu_sec = $1', [docSec]);
      if (total > 0) {
        await client.query(
          `INSERT INTO adm_obs.opa_valorados (docu_sec, remi_sec, valo_neto, valo_iva, valo_total, valo_ind_oc, valo_oc, valo_user_ing, valo_fecha_ing)
           VALUES ($1, $2, $3, $4, $5, $6, $7, '10633447', NOW())`,
          [docSec, remi, neto, iva, total, indOc, oc]
        );
      }

      const flujSec = docSec + 1000;
      await replaceRow(
        client,
        'opa_flujo',
        'fluj_sec',
        flujSec,
        `INSERT INTO adm_obs.opa_flujo (fluj_sec, docu_sec, fluj_estado, fluj_fecha_rpta, dest_sec, remi_sec, fluj_observaciones, fluj_user_ing, fluj_fecha_ing)
         VALUES ($1, $2, $3, ($4::timestamp + INTERVAL '5 days'), $5, $6, $7, '10633447', NOW())`,
        [flujSec, docSec, est, fecha, destSec, remi, obs]
      );

      await replaceRow(
        client,
        'opa_mov_documentos',
        'modo_sec',
        docSec + 2000,
        `INSERT INTO adm_obs.opa_mov_documentos (modo_sec, fluj_sec, docu_sec, modo_estado, modo_obs, dest_sec, remi_sec, modo_tipo_flujo, modo_user_ing, modo_fecha_ing)
         VALUES ($1, $2, $3, $4, $5, $6, $7, 'DERIVACION', '10633447', NOW())`,
        [docSec + 2000, flujSec, docSec, est, `Derivado a destinatario #${destSec} (${obs})`, destSec, remi]
      );
    }

    // =========================================================================
    // 2. ORDEN DE SERVICIO - ODS (OPA_ORDEN_SERVICIO*)
    // =========================================================================
    console.log('[3/6] Poblando Módulo 2 Fase 2: Orden de Servicio - ODS (adm_obs.opa_orden_servicio*)...');
    await client.query('DELETE FROM adm_obs.opa_dm_tipo_orden_servicio WHERE tios_sec IN (1, 2)');
    await client.query(`
      INSERT INTO adm_obs.opa_dm_tipo_orden_servicio (tios_sec, tios_nombre, tios_principal)
      VALUES
        (1, 'ORDEN DE SERVICIO EJECUTIVA', 'S'),
        (2, 'ORDEN DE SERVICIO OPERATIVA / INTERNA', 'N')
    `);

    const materiasOds = [
      [1, 'INSTRUCCION DIRECCION EJECUTIVA', 'ACTIVO'],
      [2, 'AUDITORIA Y TRANSPARENCIA / CONTRALORIA', 'ACTIVO'],
      [3, 'GESTION CONVENIOS SALUD APS', 'ACTIVO'],
      [4, 'INFRAESTRUCTURA Y MANTENCION ESTABLECIMIENTOS', 'ACTIVO'],
      [5, 'GESTION DOTACION Y REEMPLAZOS', 'ACTIVO'],
      [6, 'ADQUISICIONES Y CONTRATOS LICITADOS', 'ACTIVO']
    ];
    for (const [sec, nom, est] of materiasOds) {
      await replaceRow(
        client,
        'opa_materia',
        'mate_sec',
        sec,
        `INSERT INTO adm_obs.opa_materia (mate_sec, mate_nombre, mate_estado, mate_fech_ing, mate_user_ing)
         VALUES ($1, $2, $3, NOW(), '10633447')`,
        [sec, nom, est]
      );
    }

    const ordenesServicio = [
      [7001, 5001, 'ODS-2026-081', 101, 'EN GESTION', 'OFICINA DE PARTES', '2026-10-29', 'Ejecutar habilitación inmediata de box dental CESFAM Norte y remitir informe de cumplimiento a SEREMI.', 'N', 'ALTA', 1, 1, 3, 203, '2026-11-14'],
      [7002, 5002, 'ODS-2026-082', 104, 'DERIVADA', 'OFICINA DE PARTES', '2026-10-31', 'Revisar antecedentes técnicos de Estado de Pago N°3 Liceo Andrés Sabella y emitir VB para pago en DAF.', 'N', 'URGENTE', 1, 1, 4, 207, '2026-11-12'],
      [7003, 5003, 'ODS-2026-083', 102, 'EN GESTION', 'OFICINA DE PARTES', '2026-11-03', 'Consolidar rendición de gastos SEP 2026 solicitada por Superintendencia de Educación antes del vencimiento.', 'S', 'URGENTE', 1, 1, 2, 204, '2026-11-13'],
      [7004, null, 'ODS-2026-084', 108, 'RESPONDIDA', 'DIRECCION SALUD', '2026-11-04', 'Coordinar plan de contingencia de turnos SAPU/SAR para fin de semana largo y validar disponibilidad de móviles.', 'N', 'ALTA', 0, 2, 3, 203, '2026-11-10'],
      [7005, 5006, 'ODS-2026-085', 110, 'INGRESADA', 'ABASTECIMIENTO', '2026-11-07', 'Verificar recepción conforme de equipamiento computacional Escuela D-68 e inventariar activos fijos.', 'N', 'NORMAL', 1, 2, 6, 206, '2026-11-18'],
      [7006, 5008, 'ODS-2026-086', 106, 'FINALIZADA', 'DIRECCION EJECUTIVA', '2026-11-09', 'Incorporar suplemento presupuestario municipal Q4 en clasificador contable Softland Salud y Educación.', 'N', 'ALTA', 1, 1, 1, 202, '2026-11-11']
    ];
    for (const [orseSec, docSec, docNum, remiSec, est, orig, fEnv, desc, rsva, prio, indOfpa, tiosSec, mateSec, destSec, fRpta] of ordenesServicio) {
      await replaceRow(
        client,
        'opa_orden_servicio',
        'orse_sec',
        orseSec,
        `INSERT INTO adm_obs.opa_orden_servicio (
          orse_sec, orse_doc_sec, docu_numero, remi_sec, orse_estado, orse_origen,
          orse_fecha_envio, orse_fech_ing, orse_user_ing, orde_descripcion,
          orse_ind_rsva, orse_prioridad, orse_ind_ofpa, tios_sec
        ) VALUES ($1, $2, $3, $4, $5, $6, $7::timestamp, $7::timestamp, '10633447', $8, $9, $10, $11, $12)`,
        [orseSec, docSec, docNum, remiSec, est, orig, fEnv, desc, rsva, prio, indOfpa, tiosSec]
      );

      await client.query('DELETE FROM adm_obs.opa_orse_materia WHERE orse_sec = $1', [orseSec]);
      await client.query(
        `INSERT INTO adm_obs.opa_orse_materia (orse_sec, mate_sec, osma_fech_ing, osma_user_ing)
         VALUES ($1, $2, NOW(), '10633447')`,
        [orseSec, mateSec]
      );

      const osmoSec = orseSec + 1000;
      await replaceRow(
        client,
        'opa_orden_servicio_mov',
        'osmo_sec',
        osmoSec,
        `INSERT INTO adm_obs.opa_orden_servicio_mov (
          osmo_sec, orse_sec, remi_sec, dest_sec, osmo_estado, osmo_fecha_rpta,
          osmo_fech_ing, osmo_user_ing, osmo_descripcion, osmo_tipo_deriv
        ) VALUES ($1, $2, $3, $4, $5, $6::timestamp, NOW(), '10633447', $7, 'PRINCIPAL')`,
        [osmoSec, orseSec, remiSec, destSec, est, fRpta, desc]
      );
    }

    // =========================================================================
    // 3. MANTENIMIENTO DE OBRAS - OTR (OTR_*)
    // =========================================================================
    console.log('[4/6] Poblando Módulo 3 Fase 2: Mantenimiento de Obras (adm_obs.otr_*)...');
    await client.query('DELETE FROM adm_obs.otr_dom_estados_ot WHERE doeo_id IN (1, 2, 3, 4)');
    await client.query(`
      INSERT INTO adm_obs.otr_dom_estados_ot (doeo_id, doeo_estado) VALUES
        (1, 'EMITIDA / EN REVISION'),
        (2, 'EN EJECUCION'),
        (3, 'RECEPCIONADA CONFORME'),
        (4, 'LIQUIDADA A PAGO')
    `);
    await client.query('DELETE FROM adm_obs.otr_dom_tipo_ot WHERE doto_id IN (1, 2)');
    await client.query(`
      INSERT INTO adm_obs.otr_dom_tipo_ot (doto_id, doto_desc) VALUES
        (1, 'MANTENCION CORRECTIVA / EMERGENCIA'),
        (2, 'MANTENCION PREVENTIVA PROGRAMADA')
    `);
    await client.query('DELETE FROM adm_obs.otr_dom_ubicaciones WHERE doub_id IN (1, 2, 3)');
    await client.query(`
      INSERT INTO adm_obs.otr_dom_ubicaciones (doub_id, doub_lugar) VALUES
        (1, 'SECTOR NORTE ANTOFAGASTA'),
        (2, 'SECTOR CENTRO ANTOFAGASTA'),
        (3, 'SECTOR SUR ANTOFAGASTA')
    `);

    const contratistas = [
      [76145890, '2', 'CONSTRUCTORA E INGENIERIA LOA SPA'],
      [76892310, '9', 'SERVICIOS INTEGRALES Y MANTENCION NORTE LTDA.'],
      [77510220, 'K', 'INGENIERIA SANITARIA Y ELECTRICA ANTOFAGASTA SPA']
    ];
    for (const [rut, dv, razon] of contratistas) {
      await replaceRow(
        client,
        'otr_contratistas',
        'cont_rut',
        rut,
        `INSERT INTO adm_obs.otr_contratistas (cont_rut, cont_dv, cont_razon_social, cont_fec_ins, cont_user_ins)
         VALUES ($1, $2, $3, NOW(), '10633447')`,
        [rut, dv, razon]
      );
    }

    const zonas = [
      [1, 1, 1, 76145890, 1, 120000000, 22800000, 142800000, 2026],
      [2, 1, 2, 76892310, 2, 95000000, 18050000, 113050000, 2026],
      [3, 2, 3, 77510220, 1, 85000000, 16150000, 101150000, 2026],
      [4, 2, 4, 76145890, 3, 78000000, 14820000, 92820000, 2026]
    ];
    for (const [zid, sect, znum, crut, doub, neto, iva, bruto, anio] of zonas) {
      await replaceRow(
        client,
        'otr_zonas',
        'zona_id',
        zid,
        `INSERT INTO adm_obs.otr_zonas (zona_id, sect_sec, zona_num, cont_rut, doub_id, zona_monto_neto, zona_iva, zona_monto_bruto, zona_anio, zona_fec_ins, zona_user_ins)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NOW(), '10633447')`,
        [zid, sect, znum, crut, doub, neto, iva, bruto, anio]
      );
    }

    const itemsServicio = [
      [101, 'OBR-001', 'REPARACION CUBIERTA Y PLANCHAS ZINCALUM', 'Desmontaje y reposición de cubierta acanalada 0.5mm incluye fijaciones', 'M2', 28500],
      [102, 'ELE-004', 'REPOSICION EQUIPO ILUMINACION LED ALTA EFICIENCIA', 'Suministro e instalación panel LED 40W embutido/sobrepuesto certificado SEC', 'UN', 34000],
      [103, 'SAN-002', 'DESOBSTRUCCION Y REPARACION RED ALCANTARILLADO', 'Limpieza mecánica con varillaje e hidrojet en cámaras de inspección y red', 'ML', 22000],
      [104, 'PIN-008', 'PINTURA ESMALTE AL AGUA MUROS INTERIORES/EXTERIORES', 'Preparación de superficie, empaste parcial y 2 manos esmalte al agua lavable', 'M2', 9500],
      [105, 'CAR-011', 'REPARACION Y REFUERZO CIERRE PERIMETRAL METÁLICO', 'Soldadura MIG, reposición perfiles 50x50x3mm y anticorrosivo epóxico', 'ML', 46000],
      [106, 'CLI-003', 'MANTENCION PREVENTIVA EQUIPO CLIMATIZACION SPLIT/ROOFTOP', 'Limpieza serpentines, revisión carga refrigerante y control eléctrico', 'UN', 65000]
    ];
    for (const [id, cod, nom, desc, unid, precio] of itemsServicio) {
      await replaceRow(
        client,
        'otr_item_servicio',
        'itse_id',
        id,
        `INSERT INTO adm_obs.otr_item_servicio (itse_id, itse_codigo, itse_nombre, itse_desc, itse_unidad, itse_fec_ins, itse_user_ins)
         VALUES ($1, $2, $3, $4, $5, NOW(), '10633447')`,
        [id, cod, nom, desc, unid]
      );

      for (const [crut] of contratistas) {
        const iva = Math.round(precio * 0.19);
        await client.query('DELETE FROM adm_obs.otr_items_contratista WHERE cont_rut = $1 AND itse_id = $2', [crut, id]);
        await client.query(
          `INSERT INTO adm_obs.otr_items_contratista (cont_rut, itse_id, itco_precio_neto, itco_iva, itco_precio_bruto, itco_anio, itco_fec_ins, itco_user_ins)
           VALUES ($1, $2, $3, $4, $5, 2026, NOW(), '10633447')`,
          [crut, id, precio, iva, precio + iva]
        );
      }
    }

    const ordenesTrabajo = [
      [901, 1, 4850000, 921500, 5771500, 3, 2026, '2026-10-15', 10633447, 1, '2026-10-16', '2026-10-28', 'Reparación integral techumbre pabellón B y reposición luminarias Liceo Bicentenario Andrés Sabella', 101, 120, 28500],
      [902, 2, 2420000, 459800, 2879800, 2, 2026, '2026-10-25', 10633447, 1, '2026-10-26', '2026-11-12', 'Desobstrucción emergencia red sanitaria y reposición artefactos Escuela D-68 José Papic', 103, 110, 22000],
      [903, 3, 3250000, 617500, 3867500, 3, 2026, '2026-10-29', 10633447, 2, '2026-10-30', '2026-11-08', 'Mantención preventiva climatización Box Clínicos y Farmacia CESFAM Norte', 106, 50, 65000],
      [904, 4, 3800000, 722000, 4522000, 2, 2026, '2026-11-03', 10633447, 2, '2026-11-04', '2026-11-18', 'Pintura general salas de espera y urgencia SAPU CESFAM Corvallis', 104, 400, 9500],
      [905, 1, 2300000, 437000, 2737000, 1, 2026, '2026-11-07', 10633447, 1, '2026-11-09', '2026-11-20', 'Refuerzo cierre perimetral sector cancha Liceo Marta Narea Díaz A-17', 105, 50, 46000]
    ];
    for (const [ortrId, zonaId, neto, iva, bruto, doeoId, anio, fCre, usotRut, dotoId, fIni, fTer, obs, itseId, cant, pUnit] of ordenesTrabajo) {
      await replaceRow(
        client,
        'otr_orden_trabajo',
        'ortr_id',
        ortrId,
        `INSERT INTO adm_obs.otr_orden_trabajo (
          ortr_id, zona_id, ortr_monto_neto, ortr_iva, ortr_monto_bruto, doeo_id,
          ortra_anio, ortra_fec_cre, usot_rut, ortr_fec_ins, ortr_user_ins,
          doto_id, ortr_fec_ini, ortr_fec_ter, ortr_obs
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8::timestamp, $9, NOW(), '10633447', $10, $11::timestamp, $12::timestamp, $13)`,
        [ortrId, zonaId, neto, iva, bruto, doeoId, anio, fCre, usotRut, dotoId, fIni, fTer, obs]
      );

      const detNeto = cant * pUnit;
      const detIva = Math.round(detNeto * 0.19);
      await replaceRow(
        client,
        'otr_orden_trabajo_det',
        'ortd_id',
        ortrId * 10 + 1,
        `INSERT INTO adm_obs.otr_orden_trabajo_det (
          ortd_id, ortr_id, zoun_id, itse_id, ortd_cantidad, ortd_precio_neto,
          ortd_iva, ortd_precio_bruto, ortd_fec_ins, ortd_user_ins
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), '10633447')`,
        [ortrId * 10 + 1, ortrId, zonaId, itseId, cant, detNeto, detIva, detNeto + detIva]
      );
    }

    // =========================================================================
    // 4. HOJA DE RUTA Y DISPONIBILIDAD PRESUPUESTARIA (HR_*)
    // =========================================================================
    console.log('[5/6] Poblando Módulo 4 Fase 2: Hoja de Ruta y Disponibilidad Presupuestaria (adm_obs.hr_*)...');
    const tiposFinan = [
      [1, 'SEP - SUBVENCION ESCOLAR PREFERENCIAL', 'ACTIVO'],
      [2, 'PIE - PROGRAMA INTEGRACION ESCOLAR', 'ACTIVO'],
      [3, 'FAEP - FONDO APOYO EDUCACION PUBLICA', 'ACTIVO'],
      [4, 'SUBVENCION GENERAL EDUCACION', 'ACTIVO'],
      [5, 'APS PER CAPITA SALUD MUNICIPAL', 'ACTIVO'],
      [6, 'CONVENIOS PRAPS SERVICIO DE SALUD', 'ACTIVO'],
      [7, 'FONDOS PROPIOS CORPORACION (ADM CENTRAL)', 'ACTIVO']
    ];
    for (const [sec, nom, est] of tiposFinan) {
      await replaceRow(
        client,
        'hr_tipo_financiamiento',
        'tifi_sec',
        sec,
        `INSERT INTO adm_obs.hr_tipo_financiamiento (tifi_sec, tifi_nombre, tifi_finan_ult_estado)
         VALUES ($1, $2, $3)`,
        [sec, nom, est]
      );
    }

    const hrDeptos = [
      [1, 'UNIDAD REQUIRENTE / ESTABLECIMIENTO', 10633447, '7', 'RAUL HORMAZABAL FIGUEROA', 'rhormazabal@cmds.cl', 'ACTIVO', 1],
      [2, 'COORDINACION TECNICA SEP / PIE EDUCACION', 12450112, '3', 'CAROLINA ROJAS MENU', 'crojas@cmds.cl', 'ACTIVO', 2],
      [3, 'DIRECCION DE SALUD APS - REFERENTE TECNICO', 11450982, '3', 'DR. RODRIGO MEDINA', 'rmedina@cmds.cl', 'ACTIVO', 3],
      [4, 'CONTROL PRESUPUESTARIO Y FINANZAS', 12890341, '5', 'RODRIGO VARGAS CASTRO', 'rvargas@cmds.cl', 'ACTIVO', 4],
      [5, 'DEPARTAMENTO DE ABASTECIMIENTO Y LICITACIONES', 15678234, '9', 'JORGE CORTES CORTES', 'jcortes@cmds.cl', 'ACTIVO', 5],
      [6, 'DIRECCION DE ASESORIA JURIDICA', 14223890, '1', 'PAULINA TORRES SILVA', 'ptorres@cmds.cl', 'ACTIVO', 6],
      [7, 'DIRECCION DE ADMINISTRACION Y FINANZAS (DAF)', 12890341, '5', 'RODRIGO VARGAS CASTRO', 'daf@cmds.cl', 'ACTIVO', 7],
      [8, 'SECRETARIA GENERAL EJECUTIVA', 10633447, '7', 'SECRETARIO GENERAL EJECUTIVO', 'direccion@cmds.cl', 'ACTIVO', 8]
    ];
    for (const [sec, nom, rut, dv, resp, mail, est, ord] of hrDeptos) {
      await replaceRow(
        client,
        'hr_departamento',
        'depa_sec',
        sec,
        `INSERT INTO adm_obs.hr_departamento (depa_sec, depa_nombre, depa_rut_resp, depa_dv_rut_resp, depa_nombre_resp, depa_correo_resp, depa_estado, depa_orden, depa_user_ing, depa_fecha_ing)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, '10633447', NOW())`,
        [sec, nom, rut, dv, resp, mail, est, ord]
      );
    }

    const iniciativas = [
      [3001, 'ADQUISICION PIZARRAS INTERACTIVAS Y NOTEBOOKS PLAN PME-SEP LICEO MARTA NAREA DIAZ', 2, 28500000, '2026-10-18', 'APROBADA DAF', 'Iniciativa priorizada en PME 2026 dimensión Gestión Pedagógica.', 1, 'HR-2026-0301', 'S', 'VB_DAF_3001.pdf', 4, 'APROBADO'],
      [3002, 'COMPRA INSUMOS DENTALES Y RADIOLOGIA DIGITAL CONVENIO ODONTOLOGICO INTEGRAL APS', 3, 19400000, '2026-10-22', 'EN EVALUACION', 'Requerimiento urgente para cumplimiento de metas sanitarias Q4 en 6 CESFAM.', 6, 'HR-2026-0302', 'N', '', 4, 'PENDIENTE REVISION'],
      [3003, 'CONTRATACION SERVICIO MEJORAMIENTO PATIO TECHADO Y MULTICANCHA ESCUELA D-68', 5, 42000000, '2026-10-27', 'CON CDP EMITIDO', 'Cuenta con especificaciones técnicas aprobadas por Depto. de Obras CMDS.', 3, 'HR-2026-0303', 'S', 'CDP_3003.pdf', 5, 'APROBADO'],
      [3004, 'ADQUISICION KIT MATERIAL DIDACTICO Y EVALUACION PSICOPEDAGOGICA PIE 2026 (BATERIAS WISC-V)', 2, 14800000, '2026-11-02', 'EN EVALUACION', 'Para equipos multiprofesionales PIE de 18 escuelas básicas.', 2, 'HR-2026-0304', 'N', '', 2, 'EN REVISION TECNICA'],
      [3005, 'RENOVACION LICENCIAS FORTIGATE Y EQUIPAMIENTO FIREWALL DATACENTER CORPORATIVO CMDS', 6, 16200000, '2026-11-05', 'APROBADA DAF', 'Continuidad operacional red corporativa Salud, Educación y Administración.', 7, 'HR-2026-0305', 'S', 'VB_TI_3005.pdf', 7, 'APROBADO'],
      [3006, 'SUMINISTRO FARMACOS CRONICOS CARDIOVASCULARES COMPLEMENTARIOS FARMACIA COMUNAL', 3, 34900000, '2026-11-08', 'OBSERVADA', 'Se solicita adjuntar cotización referencial CENABAST / Convenio Marco.', 5, 'HR-2026-0306', 'N', '', 4, 'OBSERVADO PPTO']
    ];
    for (const [inicSec, nomProy, depaSec, monto, fIng, est, obs, tifiSec, folio, indVb, docVb, pasoOrden, pasoEst] of iniciativas) {
      await replaceRow(
        client,
        'hr_iniciativa',
        'inic_sec',
        inicSec,
        `INSERT INTO adm_obs.hr_iniciativa (
          inic_sec, inic_nom_proyecto, depa_sec, inic_monto, inic_user_ing,
          inic_fecha_ing, inic_estado, inic_observaciones, inic_tipo_finan,
          inic_folio, inic_ind_vb, inic_nom_doc_vb, inic_nom_usu_doc_vb
        ) VALUES ($1, $2, $3, $4, '10633447', $5::timestamp, $6, $7, $8, $9, $10, $11, 'RAUL HORMAZABAL')`,
        [inicSec, nomProy, depaSec, monto, fIng, est, obs, tifiSec, folio, indVb, docVb]
      );

      await client.query('DELETE FROM adm_obs.hr_hoja_ruta WHERE inic_sec = $1', [inicSec]);
      const etapas = [
        [1, 1, 'APROBADO', 'Ingreso y validación por unidad requirente'],
        [2, depaSec, pasoOrden > 2 ? 'APROBADO' : pasoEst, 'Evaluación pertinencia técnica del programa'],
        [3, 4, pasoOrden > 4 ? 'APROBADO' : (pasoOrden === 4 ? pasoEst : 'PENDIENTE'), 'Verificación imputación y disponibilidad presupuestaria'],
        [4, 7, est.includes('APROBADA') || est.includes('CDP') ? 'APROBADO' : 'PENDIENTE', 'Visación Dirección de Administración y Finanzas (DAF)']
      ];
      for (const [orden, dSec, hEst, hObs] of etapas) {
        await client.query(
          `INSERT INTO adm_obs.hr_hoja_ruta (
            inic_sec, depa_sec, horu_orden, horu_estado, horu_fecha_rpta,
            horu_user_ing, horu_fecha_ing, horu_observacion, horu_inc_doc_vb
          ) VALUES ($1, $2, $3, $4, NOW(), '10633447', NOW(), $5, $6)`,
          [inicSec, dSec, orden, hEst, hObs, hEst === 'APROBADO' ? 'S' : 'N']
        );
      }
    }

    const dispPpto = [
      [4001, 'CDP-2026-0411: PIZARRAS INTERACTIVAS Y NOTEBOOKS PME-SEP LICEO A-17', 2, 1, 28500000, '2026-10-20', 'EMITIDO / APROBADO', 'Imputación Subtítulo 29 Ítem 06 Equipos Informáticos SEP', 'Cuenta 215-29-06-001 SEP', 'Saldo disponible verificado en cuenta corriente SEP Liceo A-17', 'Autorizado por DAF para licitación/CM', '1111614-102-CM26'],
      [4002, 'CDP-2026-0412: INSUMOS DENTALES Y RADIOLOGIA CONVENIO ODONTOLOGICO APS', 3, 6, 19400000, '2026-10-24', 'EN REVISION PPTO', 'Imputación Subtítulo 22 Ítem 04 Materiales de Uso o Consumo Clínico', 'Cuenta 215-22-04-005 Salud', 'En validación de remesa Servicio de Salud Antofagasta', 'Pendiente visación final DAF', ''],
      [4003, 'CDP-2026-0413: MEJORAMIENTO PATIO TECHADO Y MULTICANCHA ESCUELA D-68', 4, 3, 42000000, '2026-10-29', 'EMITIDO / APROBADO', 'Imputación Subtítulo 31 Iniciativas de Inversión FAEP', 'Cuenta 215-31-02-004 Obras Civiles', 'Certificado emitido con cargo a saldo FAEP vigente', 'Aprobado DAF y Control Interno', '1111614-101-SE26'],
      [4004, 'CDP-2026-0414: RENOVACION LICENCIAS FORTIGATE Y FIREWALL DATACENTER CMDS', 7, 7, 16200000, '2026-11-06', 'EMITIDO / APROBADO', 'Imputación Subtítulo 29 Ítem 07 Programas Informáticos', 'Cuenta 215-29-07-001 Informática', 'Disponibilidad presupuestaria validada Administración Central', 'Aprobado sin observaciones', '1111614-105-TD26'],
      [4005, 'CDP-2026-0415: SUMINISTRO FARMACOS CRONICOS FARMACIA COMUNAL', 3, 5, 34900000, '2026-11-09', 'OBSERVADO', 'Imputación Subtítulo 22 Ítem 04 Productos Farmacéuticos', 'Cuenta 215-22-04-001 Farmacia', 'Se requiere desglosar monto afecto a Copago vs Per Cápita', 'Devuelto a unidad requirente para ajuste', '']
    ];
    for (const [dippSec, nom, depaSec, tifiSec, monto, fecha, est, obs, glosa, obsPpto, obsDaf, oc] of dispPpto) {
      await replaceRow(
        client,
        'hr_disponibilidad_ppto',
        'dipp_sec',
        dippSec,
        `INSERT INTO adm_obs.hr_disponibilidad_ppto (
          dipp_sec, dipp_nombre_proyecto, depa_sec, tifi_sec, dipp_monto, dipp_fecha,
          dipp_estado, dipp_observacion, dipp_glosa, dipp_observacion_ppto,
          dipp_fech_ing, dipp_user_ing, dipp_observacion_ppto_daf, dipp_orden_compra
        ) VALUES ($1, $2, $3, $4, $5, $6::timestamp, $7, $8, $9, $10, NOW(), '10633447', $11, $12)`,
        [dippSec, nom, depaSec, tifiSec, monto, fecha, est, obs, glosa, obsPpto, obsDaf, oc]
      );
    }

    // =========================================================================
    // 5. MERCADO PUBLICO (MPU_*)
    // =========================================================================
    console.log('[6/6] Poblando Módulo 5 Fase 2: Mercado Público (adm_obs.mpu_*)...');
    await replaceRow(
      client,
      'mpu_compradores',
      'comp_cod',
      '1111614',
      `INSERT INTO adm_obs.mpu_compradores (comp_cod, comp_nombre)
       VALUES ($1, $2)`,
      ['1111614', 'CORPORACION MUNICIPAL DE DESARROLLO SOCIAL DE ANTOFAGASTA']
    );

    const estadosOc = [
      [4, 'ENVIADA A PROVEEDOR'],
      [5, 'EN PROCESO'],
      [6, 'ACEPTADA'],
      [9, 'CANCELADA'],
      [12, 'RECEPCION CONFORME'],
      [13, 'PENDIENTE DE RECEPCIONAR'],
      [14, 'RECEPCIONADA PARCIALMENTE'],
      [15, 'TERMINADA POR INCUMPLIMIENTO']
    ];
    for (const [cod, desc] of estadosOc) {
      await replaceRow(
        client,
        'mpu_dom_estado_oc',
        'dmeo_cod_estado',
        cod,
        `INSERT INTO adm_obs.mpu_dom_estado_oc (dmeo_cod_estado, dmeo_desc) VALUES ($1, $2)`,
        [cod, desc]
      );
    }

    const tiposOc = [
      ['SE', 'SE', 'SIN EMISION AUTOMATICA (LICITACION / TRATO DIRECTO)'],
      ['CM', 'CM', 'CONVENIO MARCO'],
      ['AG', 'AG', 'COMPRA AGIL (HASTA 30 UTM)'],
      ['L1', 'L1', 'LICITACION PUBLICA MENOR A 100 UTM'],
      ['LE', 'LE', 'LICITACION PUBLICA ENTRE 100 Y 1000 UTM'],
      ['LP', 'LP', 'LICITACION PUBLICA MAYOR A 1000 UTM'],
      ['TD', 'TD', 'TRATO DIRECTO O CONTRATACION EXCEPCIONAL']
    ];
    for (const [t, abr, desc] of tiposOc) {
      await replaceRow(
        client,
        'mpu_dom_tipo_oc',
        'dmto_tipo_oc',
        t,
        `INSERT INTO adm_obs.mpu_dom_tipo_oc (dmto_tipo_oc, dmto_abreviacion, dmto_desc) VALUES ($1, $2, $3)`,
        [t, abr, desc]
      );
    }

    const proveedoresMpu = [
      ['PROV-01', 'CONSTRUCTORA E INGENIERIA LOA SPA', 'OBRAS MENORES Y MANTENCION INFRAESTRUCTURA', '76.145.890-2', 'Av. Pedro Aguirre Cerda 7890', 'Antofagasta', 'Carlos Urrutia', 'contacto@constructoraloa.cl'],
      ['PROV-02', 'TECNOLOGIA Y REDES DIGITALES ATACAMA SPA', 'EQUIPAMIENTO COMPUTACIONAL Y LICENCIAS TI', '77.320.410-K', 'Av. Brasil 1540 Of. 402', 'Antofagasta', 'Marcela Pizarro', 'ventas@redesatacama.cl'],
      ['PROV-03', 'DROGUERIA E INSUMOS MEDICOS DEL NORTE LTDA.', 'INSUMOS CLINICOS, DENTALES Y FARMACIA', '76.442.190-5', 'Manuel Antonio Matta 2310', 'Antofagasta', 'Roberto Olivares', 'licitaciones@medicosnorte.cl'],
      ['PROV-04', 'AGUAS ANTOFAGASTA S.A.', 'SUMINISTRO AGUA POTABLE Y ALCANTARILLADO', '96.579.800-5', 'Av. Pedro Aguirre Cerda 6496', 'Antofagasta', 'Ejecutivo Grandes Clientes', 'grandesclientes@aguasantofagasta.cl'],
      ['PROV-05', 'EDITORIAL Y MATERIAL DIDACTICO EDUCACHILE SPA', 'TEXTOS ESCOLARES Y BATERIAS PSICOPEDAGOGICAS PIE', '76.998.120-3', 'Av. Providencia 2120', 'Santiago', 'Andrea Valdés', 'conveniomarco@educachile.cl'],
      ['PROV-06', 'SERVICIOS INTEGRALES Y MANTENCION NORTE LTDA.', 'CLIMATIZACION, ELECTRICIDAD Y SERVICIOS GENERALES', '76.892.310-9', 'Cobija 342', 'Antofagasta', 'Patricio Contreras', 'pcontreras@mantencionnorte.cl']
    ];
    for (const [pCod, pNom, pAct, rut, dir, com, cont, mail] of proveedoresMpu) {
      await replaceRow(
        client,
        'mpu_proveedores',
        'prov_cod',
        pCod,
        `INSERT INTO adm_obs.mpu_proveedores (prov_cod, prov_nombre, prov_actividad) VALUES ($1, $2, $3)`,
        [pCod, pNom, pAct]
      );

      await client.query('DELETE FROM adm_obs.mpu_sucursales WHERE prov_cod = $1', [pCod]);
      await client.query(
        `INSERT INTO adm_obs.mpu_sucursales (
          prov_cod, sucu_cod_sucursal, sucu_nombre_sucursal, sucu_rut_sucursal,
          sucu_direccion, sucu_comuna, sucu_region, sucu_pais,
          sucu_nombre_contacto, sucu_cargo_contacto, sucu_fono_contacto, sucu_mail_contacto
        ) VALUES ($1, $2, $3, $4, $5, $6, 'Región de Antofagasta', 'Chile', $7, 'Ejecutivo Comercial', '+56 55 2531000', $8)`,
        [pCod, `SUC-${pCod}`, `${pNom} - Casa Matriz`, rut, dir, com, cont, mail]
      );
    }

    const ordenesCompra = [
      [8001, '1111614-101-SE26', 'MEJORAMIENTO CUBIERTAS Y PATIO TECHADO ESTABLECIMIENTOS EDUCACIONALES', 12, '1111614-44-LP26', 'Ejecución obras de mantención correctiva según Licitación Pública 1111614-44-LP26', 'SE', 'CLP', 'ACEPTADA', '2026-10-12', 18500000, 3515000, 22015000, 'FAEP / SUBVENCION GENERAL', 'PROV-01', 2, 'REPARACION CUBIERTA Y ESTRUCTURA METALICA PABELLON', 1, 18500000],
      [8002, '1111614-102-CM26', 'ADQUISICION NOTEBOOKS Y PIZARRAS INTERACTIVAS PME-SEP', 6, '2239-4-LR25', 'Compra por Convenio Marco Computadores y Periféricos ID 2239-4-LR25', 'CM', 'CLP', 'ACEPTADA', '2026-10-21', 23949580, 4550420, 28500000, 'SEP EDUCACION', 'PROV-02', 25, 'NOTEBOOK CORPORATIVO CORE I7 16GB RAM 512GB SSD + PIZARRA', 25, 957983],
      [8003, '1111614-103-LE26', 'SUMINISTRO INSUMOS DENTALES Y RADIOLOGIA DIGITAL CESFAM', 6, '1111614-89-LE26', 'Adquisición insumos odontológicos para 6 CESFAM de la comuna de Antofagasta', 'LE', 'CLP', 'ACEPTADA', '2026-10-26', 16302521, 3097479, 19400000, 'CONVENIO PRAPS SALUD', 'PROV-03', 100, 'KIT RESINAS FOTOCURADO, ANESTESIA Y SENSORES RADIOGRAFICOS', 100, 163025],
      [8004, '1111614-104-CM26', 'CONSUMOS AGUA POTABLE RED ESTABLECIMIENTOS CMDS OCTUBRE 2026', 12, '', 'Pago servicios básicos sanitarios establecimientos Educación y Salud', 'SE', 'CLP', 'RECEPCION CONFORME', '2026-11-01', 12400000, 2356000, 14756000, 'SUBVENCION GENERAL / APS', 'PROV-04', 1, 'SUMINISTRO AGUA POTABLE Y ALCANTARILLADO CONSOLIDADO', 1, 12400000],
      [8005, '1111614-105-TD26', 'RENOVACION SUSCRIPCION FORTIGATE Y SOPORTE FIREWALL DATACENTER', 6, 'RES-3190/2026', 'Renovación licenciamiento seguridad perimetral red CMDS Antofagasta', 'TD', 'CLP', 'ACEPTADA', '2026-11-05', 13613445, 2586555, 16200000, 'FONDOS PROPIOS CMDS', 'PROV-02', 2, 'LICENCIA FORTIGATE UTM BUNDLE 24X7 1 AÑO', 2, 6806722],
      [8006, '1111614-106-AG26', 'COMPRA AGIL BATERIAS PSICOPEDAGOGICAS WISC-V PROGRAMA PIE', 4, '1111614-312-COT26', 'Adquisición vía Compra Ágil para equipos de aula de recursos PIE', 'AG', 'CLP', 'ENVIADA A PROVEEDOR', '2026-11-08', 12436975, 2363025, 14800000, 'PIE EDUCACION', 'PROV-05', 10, 'BATERIA EVALUACION COGNITIVA WISC-V COMPLETA ESPAÑOL', 10, 1243698],
      [8007, '1111614-107-LE26', 'MANTENCION PREVENTIVA CLIMATIZACION Y GRUPOS ELECTROGENOS CESFAM', 13, '1111614-95-LE26', 'Servicio trimestral mantención equipos críticos SAPU/SAR y Farmacia', 'LE', 'CLP', 'ACEPTADA', '2026-11-09', 9200000, 1748000, 10948000, 'APS PER CAPITA SALUD', 'PROV-06', 20, 'MANTENCION PREVENTIVA INTEGRAL EQUIPO CLIMATIZACION Y TABLEROS', 20, 460000]
    ];
    for (const [secId, codOc, nom, codEst, licit, desc, tipoOc, mon, estProv, fCre, neto, iva, total, finan, provCod, totItems, prodNom, cant, pNeto] of ordenesCompra) {
      await replaceRow(
        client,
        'mpu_ordenes_cab',
        'orca_sec_id',
        secId,
        `INSERT INTO adm_obs.mpu_ordenes_cab (
          orca_sec_id, orca_cod_oc, orca_nombre, dmeo_cod_estado, orca_codigo_licitacion,
          orca_desc_oc, orca_codigo_tipo, dmto_tipo_oc, dmtm_tipo_moneda,
          orca_cod_estado_proveedor, orca_estado_proveedor, orca_fec_creacion,
          orca_fec_envio, orca_fec_aceptacion, orca_fec_ultima_mod, orca_tiene_items,
          orca_promedio_calific, orca_eval_proveedor, orca_descuentos, orca_cargos,
          orca_total_neto, orca_iva, orca_impuestos, orca_total_oc,
          orca_financiamiento, orca_pais, dmtd_tipo_despacho, dmfp_forma_pago,
          comp_cod, prov_cod, orca_total_items, orca_version_api, orca_fec_ins, orca_user_ins
        ) VALUES (
          $1, $2, $3, $4, $5, $6, $7, $7, $8, 1, $9, $10::timestamp,
          $10::timestamp, $10::timestamp, NOW(), 'S', 5, 5, 0, 0,
          $11, $12, 0, $13, $14, 'CL', '1', '30 DIAS',
          '1111614', $15, $16, 'v2.1', NOW(), '10633447'
        )`,
        [secId, codOc, nom, codEst, licit, desc, tipoOc, mon, estProv, fCre, neto, iva, total, finan, provCod, totItems]
      );

      await replaceRow(
        client,
        'mpu_ordenes_det',
        'orde_sec_id',
        secId * 10 + 1,
        `INSERT INTO adm_obs.mpu_ordenes_det (
          orde_sec_id, orca_sec_id, ordet_correlativo, ordet_cod_categoria,
          ordet_categoria, ordet_cod_producto, ordet_producto,
          ordet_espec_comprador, ordet_espec_proveedor, ordet_cantidad,
          ordet_unidad, dmtm_tipo_moneda, ordet_precio_neto,
          ordet_total_cargos, ordet_total_descuentos, ordet_total_impuestos, ordet_total
        ) VALUES (
          $1, $2, 1, 43211500, 'EQUIPAMIENTO Y SERVICIOS INSTITUCIONALES', 43211503,
          $3, $4, 'Según bases técnicas y oferta adjudicada en portal Mercado Público',
          $5, 'UNIDAD', 'CLP', $6, 0, 0, $7, $8
        )`,
        [secId * 10 + 1, secId, prodNom, desc, cant, pNeto, iva, total]
      );
    }

    const reprocesos = [
      [1, 1001, '1111614-106-AG26', '2026-11-08 09:15:00', '2026-11-08 09:20:00', 'PROCESADO OK'],
      [2, 1002, '1111614-107-LE26', '2026-11-09 14:30:00', '2026-11-09 14:35:00', 'PROCESADO OK'],
      [3, 1003, '1111614-108-CM26', '2026-11-10 18:10:00', null, 'PENDIENTE REPROCESO API']
    ];
    for (const [id, proc, pauta, fErr, fRet, est] of reprocesos) {
      await replaceRow(
        client,
        'mpu_reprocesos',
        'repr_sec_id',
        id,
        `INSERT INTO adm_obs.mpu_reprocesos (repr_sec_id, repr_sec_proc, repr_pauta, repr_fec_error, repr_fec_retoma, repr_estado)
         VALUES ($1, $2, $3, $4::timestamp, $5::timestamp, $6)`,
        [id, proc, pauta, fErr, fRet, est]
      );
    }

    console.log('✓ Todos los módulos de Fase 2 fueron poblados exitosamente en PostgreSQL 18 (bd_cmds_admin).');
  } finally {
    client.release();
    await pool.end();
  }
}

seedFase2().catch((err) => {
  console.error('Error en seedFase2Postgres:', err);
  process.exit(1);
});
