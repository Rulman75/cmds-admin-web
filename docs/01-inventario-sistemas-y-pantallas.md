# 01. Inventario de Sistemas, Módulos y Pantallas — Portal CMDS ADMIN (`cmds_adm_prod`)

- **URL Productiva:** `https://cmds.pad.cl:3443/cmds_adm_prod/`
- **Tecnología Actual:** Scriptcase (PHP) sobre Oracle AI Database 26ai (`186.67.6.133:9521 / cmdseducaprod`)
- **Esquemas Oracle Utilizados por este Portal:**
  - `ADM_OBS` (238 tablas, 13 vistas — esquema principal de negocio y menú dinámico `OBS_MENU` / `OBS_MENU_DETALLE`)
  - `ADM_AUTH` (21 tablas, 2 vistas — autenticación centralizada OAuth2/usuarios `AUT_USUARIOS`, `AUT_SISTEMAS`)
  - `ADM_CMDS` (9 tablas — parámetros `CDS_PARAMETROS` y tokens OAuth)
  - `PADLOG` (14 tablas, 2 vistas — auditoría técnica centralizada `PADLOG_LOGGER2_01..06` con colas Oracle AQ)
- **Total Aplicaciones Únicas Inspeccionadas:** **134 aplicaciones Scriptcase** (`46 grids`, `34 forms`, `21 controls`, `18 dashboards`, `7 blanks`, `8 sub-aplicaciones/otros`).

---

## Arquitectura de Navegación del Portal en Scriptcase

El portal `CMDS ADMIN` utiliza un esquema de **menú dinámico gobernado por base de datos**:
1. El login (`login`) valida las credenciales contra `ADM_AUTH` / `ADM_OBS.OBS_USUARIOS_AUTH_V` y consulta la vista `ADM_OBS.OBS_MENU_USUARIOS_V` (alimentada por `OBS_MENU`, `OBS_MENU_DETALLE` y `OBS_USER_MENU`).
2. Muchos ítems del menú apuntan a **Dashboards contenedores** (`blank_dashboard_*` o `dashboard_*`), los cuales incrustan mediante `<iframe>` dos aplicaciones simultáneas:
   - Arriba: una aplicación tipo **Control** (`control_*` o `*_ctrl`) que actúa como barra de filtros o acciones masivas.
   - Abajo: una aplicación tipo **Grilla** (`*_grid` o `grid_*`) que lista los registros y enlaza al **Formulario** (`*_form` o `form_*`) o a ventanas modales (`*_blank`).

---

## Catálogo Detallado de los 10 Módulos Priorizados

### 1. Módulo: Boleta de Honorarios (`MENU_ID = 2`)
Gestiona el ciclo completo de emisión, recepción, validación de evidencias (CESFAM/Referentes), aprobación por estado, nóminas de pago (integración formato SERVIPAG) y generación de archivos contables/presupuestarios (Softland, Presupuesto, Transparencia, Consolidado).

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `41` | **Ingreso Boletas** | `blank_dashboard_boletas` | Dashboard | `control_boletas` (Control)<br>`boletas_grid` (Grid)<br>→ `boletas_form`<br>→ `general_boleta_control` | `ADM_OBS.BHO_BOLETAS`<br>(48.529 reg.)<br>`ADM_OBS.BHO_FLUJO_ESTADO`<br>(90.177 reg.) | **Filtros (`control_boletas`):** `sector`, `numero_doc`, `trabajador` (autocomp), `emision`, `periodo`, `unidad`, `estado`, `accion`.<br>**Columnas (`boletas_grid`):** N° Documento, Trabajador, Periodo, Unidad, N° Horas, Bruto, Impuesto (12.25% param.), Líquido a Pagar, Tipo, Emisión. |
| `42` | **Aprobación Boletas** | `estados_ctrl` | Control | Enlaza a flujo de cambio de estado masivo | `ADM_OBS.BHO_BOLETAS`<br>`ADM_OBS.BHO_FLUJO_ESTADO` | **Campos:** `b_sector` (Sector), `b_func_sec` (Funcionario), `b_periodos` (Periodos), `b_unidad` (Unidad), `b_convenio` (Convenio), `con_func`, `con_convenio`. |
| `43` | **Archivo Consolidado** | `archivo_consolidado_ctrl` | Control | Genera exportación consolidada | `ADM_OBS.BHO_REPORTE_CONSOLIDADO`<br>(154 reg.) | **Campos:** `b_sector` (Sector), `b_periodos` (Periodo). |
| `44` | **Archivo Transparencia** | `archivo_transparencia_ctrl` | Control | Genera archivo Ley de Transparencia | `ADM_OBS.BHO_REPORTE_TRANSPARENCIA`<br>(81 reg.) | **Campos:** `b_sector` (Sector), `b_periodos` (Periodo). |
| `45` | **Archivo Presupuesto** | `general_presupuesto_control` | Control | Genera cuadratura presupuestaria | `ADM_OBS.BHO_REPORTE_PRESUPUESTO`<br>(75 reg.) | **Campos:** `b_sector` (Sector), `b_periodos` (Periodo). |
| `46` | **Archivo Softland** | `general_softland_control` | Control | Genera interfaz contable ERP Softland | `ADM_OBS.ADM_REPORTE_SOFTLAND`<br>(218 reg.) | **Campos:** `b_sector` (Sector), `b_periodos` (Periodo), `b_area` (Área de cuenta). |
| `161` | **Nómina Pago** | `blank_dashboard_nomina_pago` | Dashboard | `control_nomina_boletas` (Control)<br>`nomina_boletas_grid` (Grid) | `ADM_OBS.BHO_REPORTE_NOMINA` (602 reg.)<br>`ADM_OBS.OPA_NOMINA_BOLETAS` (2.734 reg.)<br>`ADM_OBS.OPA_GEN_NOMINA` (2.464 reg.) | **Filtros (`control_nomina_boletas`):** `b_sector` (Sector), `b_periodos` (Periodo), `estado`, `accion`. Parámetro `MONTO_MAX_REG_NOM = 1.000.000` (Servipag). |
| `202` | **Periodo** | `blank_dashboard_periodo` | Dashboard | `control_periodos` (Control)<br>`periodos_grid` (Grid)<br>→ `periodos_form` | `ADM_OBS.BHO_PERIODOS` (70 reg.)<br>`ADM_OBS.BHO_PERI_IMPU` (181 reg.) | **Filtros:** `b_sector`, `b_periodos`, `estado`, `accion`.<br>**Columnas (`periodos_grid`):** Periodo, Estado, Fecha Límite Documento, Sector. |
| `243` | **Funcionarios** | `funcionario_grid` | Grid | → `funcionario_form` | `ADM_OBS.BHO_FUNCIONARIOS` (2.469 reg.)<br>`ADM_OBS.BHO_CONV_FUNC` (4.132 reg.)<br>`ADM_OBS.BHO_COTO_FUNC` (2.887 reg.) | **Filtros:** `func_nombres`, `func_rut`, `func_sec_sector`.<br>**Columnas:** Rut, Dígito Verificador, Nombre, Apellido Paterno, Apellido Materno. |
| `1090` | **Ranking de Antigüedad** | `blank_dashboard_funcionario_cmds` | Dashboard | `control_funcionario` (Control)<br>`funcionario_cmds_grid` (Grid)<br>→ `funcionario_cmd_form`<br>→ `grid_contrato_funcionario_antiguedad`<br>→ `blank_exportar_funcionarios` | `ADM_OBS.BHO_FUNCIONARIOS`<br>`ADM_OBS.ADM_CONVENIO` (`CONV_IND_RANKEAR`) | **Filtros:** `nombre`, `rut`, `sector`, `actividad`, `estado`, `motivo`, `condicion_actividad`.<br>**Columnas:** Rut, DV, Nombre, Apellidos, Antigüedad Lineal, Antigüedad Efectiva, Sector, Actividad, Estado. |
| `932` | **Verificadores Referente** | `evidencia_grid` | Grid | → `evidencia_from`<br>→ `estado_evidencia_blank` | `ADM_OBS.BHO_EVIDENCIA` (24.124 reg.)<br>`ADM_OBS.BHO_EVIDENCIA_DOCUMENTO` (62.897 reg.)<br>`ADM_OBS.BHO_EVIDENCIA_LOG` (6.428 reg.) | **Filtros:** `evia_esta_cod`, `evia_convenio`, `evia_ano`, `evia_mes`, `evia_rut_empleado`, `funcionario`, `evia_boleta`, `b_ref_mng`.<br>**Columnas:** N° Boleta, Rut Funcionario, Funcionario, Establecimiento, Convenio, Año, Mes, Estado, Trazabilidad, Verificar. |
| `930` | **Verificadores Cesfam** | `evidencia_cesfam_grid` | Grid | → `evidencia_cesfam_from`<br>→ `estado_evidencia_blank` | `ADM_OBS.BHO_EVIDENCIA`<br>`ADM_OBS.BHO_EVIDENCIA_DOCUMENTO` | Misma estructura de `evidencia_grid`, acotada al perfil de establecimientos CESFAM. |

---

### 2. Módulo: Oficina de Partes (`MENU_ID = 3`)
Registra el ingreso de correspondencia/documentos externos e internos, digitalización de adjuntos, derivación a departamentos/destinatarios, recepción conforme y enlace con Órdenes de Servicio.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `47` | **Ingreso Documentos** | `documentos_grid` | Grid | → `documentos_frm` (Form alta/edición)<br>→ `adjuntar_grid` / `adjuntar_form`<br>→ `adjuntar_inte_grid`<br>→ `estado_documentos_blank`<br>→ `blank_documento_v_b` | `ADM_OBS.OPA_DOCUMENTOS` (16.722 reg.)<br>`ADM_OBS.OPA_FLUJO` (16.452 reg.)<br>`ADM_OBS.OPA_MOV_DOCUMENTOS` (1.062 reg.)<br>`ADM_OBS.OPA_VALORADOS` (15.856 reg.)<br>`ADM_OBS.OPA_ADJUNTOS` (16.164 reg.) | **Filtros:** `docu_fecha`, `docu_nro`, `docu_orden`, `docu_tipo_docu`, `docu_user_ing`, `docu_remi_sec`, `fecha_acep_sge`.<br>**Columnas Grilla:** Adjuntar, N° Secuencia, N° Documento, Fecha Doc, Fecha Aceptación SGE, Tipo, Remitente, Destinatario, Materia, Estado, Guía, Enviar, Eliminar.<br>**Campos `documentos_frm`:** `docu_ult_estado`, `docu_fecha`, `docu_tipo_docu`, `docu_nro`, `docu_remi_tipo`, `remitente_in`, `docu_privado`, `neto`, `iva`, `total`. |
| `49` | **Recepción Documentos** | `recepcion_grid` | Grid | → `recencionado_documento_form`<br>→ `form_reenviados_ofpa` | `ADM_OBS.OPA_DOCUMENTOS`<br>`ADM_OBS.OPA_OFPA_DERIVADOS` (135 reg.)<br>`ADM_OBS.OPA_FLUJO` | **Columnas:** Recepcionar, N° Secuencia, N° Documento, Fecha Doc, Tipo, Estado, Remitente, Destinatario, Materia, Reenvío, Guía, Orden de Servicio. |
| `50` | **Destinatarios** | `destinatarios_grid` | Grid | → `detinatarios_form` | `ADM_OBS.HR_DEPARTAMENTO` (45 reg.)<br>`ADM_OBS.OPA_DESTINATARIOS` (222 reg.) | **Filtros:** `depa_nombre`, `depa_nombre_resp`.<br>**Columnas:** Ver, Departamento, Representante, Correo Representante. |
| `51` | **Remitentes** | `remitentes_grid` | Grid | → `remitentes_form` | `ADM_OBS.OPA_REMITENTES` (1.551 reg.) | **Filtros:** `remi_rut`, `remi_dv`, `remi_sec`, `remi_tipo`.<br>**Columnas:** Rut, Dígito Verificador, Razón Social, Tipo, Teléfono, Contacto. |

---

### 3. Módulo: Orden de Servicio (`MENU_ID = 1210`)
Gestiona las solicitudes de órdenes de servicio originadas o vinculadas a Oficina de Partes, sus derivaciones entre unidades, materias, adjuntos y cronograma de seguimiento.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `1211` | **Solicitudes** | `blank_dashboard_propuestas` | Dashboard | `control_servicio` (Control)<br>`grid_orden_servicio` (Grid)<br>→ `form_orden_servicio`<br>→ `estado_orden_blank`<br>→ `blank_reporte_orden_servicio` | `ADM_OBS.OPA_ORDEN_SERVICIO` (20.217 reg.)<br>`ADM_OBS.OPA_ORDEN_SERVICIO_MOV` (46.595 reg.)<br>`ADM_OBS.OPA_ORSE_DERIVADOS` (26.541 reg.)<br>`ADM_OBS.OPA_ORSE_MATERIA` (20.184 reg.)<br>`ADM_OBS.OPA_ADJUNTOS_ORDEN_SERVICIO` (3.927 reg.) | **Filtros (`control_servicio`):** `orden_servicio` (N° O.S), `oficina_partes` (N° Secuencia O.P), `tipo` (Tipo O.S), `remitente`, `destinatarios`, `fecha`, `estado`, `prioridad`, `reservado`, `obs`, `mate_obs` (Materia O.P.).<br>**Columnas (`grid_orden_servicio`):** Ver, N° O.S, N° O.P, Fecha de Registro, Remitente, Destinatarios, Origen, Observación, Materia O.P., Tipo O.S. |
| `1212` | **Cronograma** | `blank_dashboard_cronograma` | Dashboard | `control_cronograma` (Control)<br>`grid_cronograma_orden` (Grid) | `ADM_OBS.OPA_ORDEN_SERVICIO`<br>`ADM_OBS.OPA_ORDEN_SERVICIO_MOV`<br>`ADM_OBS.OPA_ORSE_MOV_LOG` (14.602 reg.) | **Filtros (`control_cronograma`):** `orden_servicio`, `oficina_partes`, `tipo`, `remitente`, `fecha`, `estado`, `prioridad`, `tipo_registro`, `reservado`, `obs`, `mate_obs`. |

---

### 4. Módulo: Mantenedor General (`MENU_ID = 5`)
Administra las tablas maestras y paramétricas transversales a Boleta de Honorarios, Oficina de Partes, Hoja de Ruta, Orden de Servicio y Mantenimiento de Obras, además de la seguridad y permisos de usuarios.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `55` | **Formación** | `formacion_form` | Form (Multiregistro) | Edición directa en grilla editable | `ADM_OBS.ADM_FORMACION` (79 reg.) | `form_sec`, `form_codigo` (Código Formación *), `form_desc` (Formación *). |
| `56` | **Unidad** | `unidad_form` | Form (Multiregistro) | Enlaza a asignación de CECO y Convenio | `ADM_OBS.ADM_UNIDAD` (123 reg.)<br>`ADM_OBS.ADM_RELA_UNICECO` (154 reg.)<br>`ADM_OBS.ADM_RELA_UNIDCONV` (312 reg.) | `unid_sec`, `unid_codigo` (Código Unidad *), `unid_desc` (Unidad *), `sect_sec` (Sector *), Asignar Centro de Costo, Asignar Convenio. |
| `57` | **Sector/Relación** | `sector_form` | Form (Multiregistro) | Relación Sector ↔ Formación/Actividad | `ADM_OBS.ADM_SECTOR` (5 reg.)<br>`ADM_OBS.ADM_RELA_ACTISEC` (60 reg.)<br>`ADM_OBS.ADM_RELA_FORSEC` (45 reg.) | `sect_sec`, `sect_desc` (Sector *), Formación / Actividad. |
| `58` | **Actividad** | `actividad_form` | Form (Multiregistro) | Edición directa | `ADM_OBS.ADM_ACTIVIDAD` (94 reg.) | `acti_sec`, `acti_codigo` (Código Actividad *), `acti_desc` (Actividad *), `acti_area_cuenta` (Área de Cuenta), `acti_monto_hora` (Monto por HH), `acti_estado`. |
| `59` | **Convenio** | `convenio_form` | Form (Multiregistro) | Edición directa | `ADM_OBS.ADM_CONVENIO` (101 reg.) | `conv_sec`, `conv_codigo` (Código *), `conv_desc` (Convenio *), `conv_cuenta_salud` (Cuenta Salud *), `conv_ceco_cod` (Centro de Costo *), `conv_ind_transversal` (Transversal), `conv_ind_rankear` (Rankeable). |
| `60` | **Centro de Costo** | `centro_costo_form` | Form (Multiregistro) | Edición directa | `ADM_OBS.BHO_CENTRO_COSTO` (165 reg.) | `ceco_sec`, `ceco_cod` (Código *), `ceco_sect_sec` (Sector *), `ceco_desc` (Descripción *), `ceco_dom_estado` (Estado *). |
| `61` | **Usuarios del Sistema** | `usuario_sistema_grid` | Grid | → `usuario_sistema_from` | `ADM_OBS.OBS_USUARIOS_AUTH_V` (Vista sobre `ADM_AUTH.AUT_USUARIOS` + `ADM_OBS.OBS_USUARIOS` + `OBS_USER_MENU`) | **Filtros:** `rut_usuario`, `nombre_usuario`, `correo`, `telefono`.<br>**Columnas:** Rut, Trabajador, Nivel Usuario, Asignar Opciones (`OBS_USER_MENU`: 3.282 permisos asignados). |
| `281` | **Financiamiento** | `tipo_financiamiento_grid` | Grid | → `tipo_financiamiento_form` | `ADM_OBS.HR_TIPO_FINANCIAMIENTO` (78 reg.) | **Campos:** `tifi_nombre` (Financiamiento), `tifi_finan_ult_estado` (Estado). |
| `321` | **Tipo Documento** | `tipo_documento_grid` | Grid | → `tipo_documento_form` | `ADM_OBS.OPA_TIPO_DOCUMENTOS` (56 reg.) | **Campos:** `tido_sigla` (Sigla), `tido_desc_docu` (Descripción), `tido_ult_estado` (Estado). |
| `1170` | **Destinatario Departamento** | `destinatarios_departamento_grid` | Grid (Maestro-Detalle) | Iframes maestro-detalle para funcionarios por depto | `ADM_OBS.HR_DEPARTAMENTO` (45 reg.)<br>`ADM_OBS.OPA_DESTINATARIOS` (222 reg.) | **Columnas:** Departamento, Agregar Funcionarios. |
| `1213` | **Materia** | `grid_materia` | Grid | → `form_materia` | `ADM_OBS.OPA_MATERIA` (6 reg.) | **Campos:** `mate_nombre` (Materia), `mate_estado` (Estado). |
| `1250` | **Tipo Orden de Servicio** | `grid_tipo_orden` | Grid | → `form_tipo_orden` | `ADM_OBS.OPA_DM_TIPO_ORDEN_SERVICIO` (2 reg.) | **Campos:** `tios_sec` (Tipo), Principal. |
| `1251` | **Ítem Presupuestario** | `grid_item_ppto` | Grid | → `form_item_ppto` | `ADM_OBS.OPA_TIPO_DISPONIBILIDAD_PPTO` (47 reg.) | **Campos:** `dpto_id` (Id), Descripción, `dpto_estado` (Estado). |
| `1291` | **Usuarios Sistema Mantención** | `usuario_sistema_mantencion_grid` | Grid | → `form_usuarios_sistema_mantencion`<br>→ `usuario_sitema_mantencion_sector_grid`<br>→ `form_usuarios_sistema_mantencion_sector` | `ADM_OBS.OTR_USUARIOS_OT` (11 reg.)<br>`ADM_OBS.OTR_USUARIOS_SECTOR` (15 reg.) | **Campos:** `usot_rut` (Rut), `nombre_usuario` (Trabajador), Sector. |

---

### 5. Módulo: Mantenimiento de Obras (`MENU_ID = 10`)
Gestiona las Órdenes de Trabajo (OT) de mantención de infraestructura/establecimientos, contratistas/proveedores, zonas adjudicadas, catálogo de ítems de servicio y preciarios anuales por contratista.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `1331` | **Ingreso (OT)** | `blank_dashboard_ot` | Dashboard | `control_busqueda_ot` (Control)<br>`grid_mantenedor_ot` (Grid)<br>→ `form_mantenedor_ot`<br>→ `grid_items_visualizar_ot`<br>→ `blank_reporte_ot_xlsx`<br>→ `blank_reporte_ot_masivo_xlsx` | `ADM_OBS.OTR_ORDEN_TRABAJO` (11 reg.)<br>`ADM_OBS.OTR_ORDEN_TRABAJO_DET` (18 reg.)<br>`ADM_OBS.OTR_ARCHIVOS_OT` (2 reg.)<br>`ADM_OBS.OTR_DOM_ESTADOS_OT` (3 reg.)<br>`ADM_OBS.OTR_DOM_TIPO_OT` (2 reg.) | **Filtros (`control_busqueda_ot`):** `num_ot`, `sector`, `zona`, `unidad`, `ubicacion`, `proveedor`, `estado`, `tipo_ot`, `fecha_emision`, `fecha_termino`.<br>**Columnas (`grid_mantenedor_ot`):** N° OT, Sector, Zona, Unidad / Establecimiento, Ubicación, Fecha, Proveedor, Tipo OT, Estado, Fecha Inicio. |
| `1334` | **Mantenedor → Zona Proveedor** | `blank_dashboard_zona_proveedor` | Dashboard | `grid_zona_proveedor` (Grid)<br>→ `form_zona_proveedor`<br>→ `grid_zona_unidad` | `ADM_OBS.OTR_ZONAS` (7 reg.)<br>`ADM_OBS.OTR_ZONA_UNIDAD` (69 reg.)<br>`ADM_OBS.OTR_DOM_UBICACIONES` (3 reg.) | **Campos:** `sect_sec` (Sector), `zona_id` (Zona), `cont_rut` (Proveedor), `doub_id` (Ubicación), Monto Neto, IVA, Monto Bruto, `zona_anio` (Año), Unidad. |
| `1335` | **Mantenedor → Ítem de Servicios** | `blank_dashboard_item_servicio` | Dashboard | `grid_item_servicio` (Grid)<br>→ `form_item_servicio` | `ADM_OBS.OTR_ITEM_SERVICIO` (637 reg.) | **Campos:** `itse_codigo` (Código), `itse_nombre` (Descripción), `itse_unidad` (Unidad de medida). |
| `1336` | **Mantenedor → Tarifa de Servicios** | `blank_dashboard_tarifa_servicios` | Dashboard | `grid_item_servicio_precio` (Grid)<br>→ `form_item_servicio_precio` | `ADM_OBS.OTR_ITEMS_CONTRATISTA` (1.273 reg.) | **Campos:** `cont_rut` (Proveedor), `itse_nombre` (Ítem), `itse_codigo` (Código), `itco_precio` (Precio Neto), IVA, Precio Bruto, `itse_unidad` (Unidad), `itco_anio` (Año). |
| `1337` | **Mantenedor → Subvención de Sector** | `blank_dashboard_subvencion_sector` | Dashboard | `grid_sub_sector` (Grid)<br>→ `form_sub_sector` | `ADM_OBS.OTR_FINANCIAMIENTO` (4 reg.) | **Campos:** `sect_sec` (Sector), `tifi_sec` (Financiamiento). |
| `1333` | **Mantenedor → Proveedor de Servicios** | `blank_dashboard_proveedor_servicios` | Dashboard | `grid_proveedor_servicios` (Grid)<br>→ `form_proveedor_servicios` | `ADM_OBS.OTR_CONTRATISTAS` (2 reg.) | **Campos:** `cont_rut` (Rut), Dígito Verificador, `cont_razon_social` (Razón Social). |

---

### 6. Módulo: Hoja de Ruta (`MENU_ID = 81`)
Sistema de seguimiento de iniciativas de compra/proyectos, flujo de aprobaciones y vistos buenos (Hoja de Ruta por departamentos), evaluación técnica de terceros, foliación y emisión de **Certificados de Disponibilidad Presupuestaria (CDP)** vinculados a Órdenes de Compra.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `82` | **Departamento** | `departamento_grid` | Grid | → `departamento_form`<br>→ `HR_EVALUADOR_SUPLENTE_FORM` | `ADM_OBS.HR_DEPARTAMENTO` (45 reg.)<br>`ADM_OBS.HR_SECUENCIA_DEPTO` (9 reg.)<br>`ADM_OBS.HR_EVALUADOR_SUPLENTE` (150 reg.) | **Columnas:** Ver, Departamento (`depa_nombre`), Representante (`depa_nombre_resp`), Correo Representante, Configurar Funcionarios. |
| `83` | **Iniciativa** | `iniciativa_grid` | Grid | → `iniciativa_form`<br>→ `estado_iniciativa_blank`<br>→ `documento_hoja_blank`<br>→ `argumento_form` | `ADM_OBS.HR_INICIATIVA` (3.684 reg.)<br>`ADM_OBS.HR_INICIATIVA_LOG` (859 reg.)<br>`ADM_OBS.HR_HOJA_RUTA` (19.376 reg.)<br>`ADM_OBS.HR_HOJA_RUTA_LOG` (14.490 reg.)<br>`ADM_OBS.HR_DOCUMENTOS` (23.092 reg.)<br>`ADM_OBS.HR_ARGUMENTO` (428 reg.) | **Filtros:** `i_inic_nom_proyecto`, `i_depa_sec`, `i_inic_estado`, `i_inic_fecha_ing`, `i_inic_folio`, `i_inic_sec`.<br>**Columnas:** Ver, #, Folio, Proyecto, Fecha de Registro, Departamento, Monto, Estado, Historial Hoja, Documento, Documento V°B°, Foliar, Justificar. |
| `121` | **Evaluación** | `evaluar_hoja_grid` | Grid | Visación de pasos de Hoja de Ruta | `ADM_OBS.HR_HOJA_RUTA`<br>`ADM_OBS.HR_HOJA_RUTA_LOG` | **Filtros:** `horu_estado`, `horu_fecha_rpta`. |
| `855` | **Evaluación Terceros** | `tercero_grid` | Grid | Evaluación por especialista/tercero | `ADM_OBS.HR_REGISTRO_EVALUADOR` (3.550 reg.)<br>`ADM_OBS.HR_DOCUMENTOS_EVALUADOR` (8 reg.) | **Filtros:** `r_reev_estado`, `i_inic_nom_proyecto`. |
| `970` | **Usuario Folio** | `usuario_folio_grid` | Grid | → `usuario_folio_form` | `ADM_OBS.HR_USUARIO_FOLIO` (2 reg.) | **Campos:** `usfo_rut` (Rut), Nombre, `usfo_estado` (Estado). |
| `1010` | **Disponibilidad Presupuestaria** | `grid_dispo_ppto` | Grid | → `imprimir_certificado_disponibilidad_blank` | `ADM_OBS.HR_DISPONIBILIDAD_PPTO` (3.054 reg.)<br>`ADM_OBS.HR_DISPONIBILIDAD_PPTO_LOG` (9.106 reg.)<br>`ADM_OBS.HR_DISPONIBILLIDAD_PPTO_ORDEN_COMP` (45 reg.)<br>`ADM_OBS.HR_DOCUMENTOS_PPTO` (3.032 reg.) | **Filtros:** `dipp_nombre_proyecto`, `depa_sec`, `tifi_sec`, `dipp_fecha`, `dipp_estado`.<br>**Columnas:** N° Certificado, Proyecto, Departamento, Financiamiento, Monto Licitación, Monto Orden de Compra, Fecha de Registro, Estado, Orden de Compra, Certificado, Eliminar. |
| `1050` | **Reportes y Estadística** | `blank_dashboard_reporte_iniciativa` | Dashboard | `control_reporte_iniciativa` (Control)<br>`pagina_vacia` | `ADM_OBS.HR_INICIATIVA`<br>`ADM_OBS.HR_HOJA_RUTA` | **Filtros (`control_reporte_iniciativa`):** `departamentos`, `tipo_repot`. |

---

### 7. Módulo: Evidencia (`MENU_ID = 890`)
Acceso directo al módulo de control y verificación de evidencias documentales asociadas a las Boletas de Honorarios.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `890` | **Evidencia** | `evidencia_grid` | Grid | → `evidencia_from`<br>→ `estado_evidencia_blank` | `ADM_OBS.BHO_EVIDENCIA` (24.124 reg.)<br>`ADM_OBS.BHO_EVIDENCIA_DOCUMENTO` (62.897 reg.)<br>`ADM_OBS.BHO_EVIDENCIA_LOG` (6.428 reg.) | **Filtros:** `evia_esta_cod` (Establecimiento), `evia_convenio` (Convenio), `evia_ano` (Año), `evia_mes` (Mes), `evia_rut_empleado`, `funcionario`, `evia_boleta`, `b_ref_mng` (Estado).<br>**Columnas:** N° Boleta, Rut Funcionario, Funcionario, Establecimiento, Convenio, Año, Mes, Estado, Trazabilidad, Verificar.<br>**Campos Form (`evidencia_from`):** `evia_esta_cod`, `evia_convenio`, `evia_mes`, `evia_estado`, `evia_observacion`, `peri_sec`, `evia_fech_firma_1`. |

---

### 8. Módulo: Mercado Público (`MENU_ID = 1371`)
Consulta, visualización gráfica y reprocesamiento de Órdenes de Compra (OC) obtenidas desde la API de Mercado Público (`COMPRADOR = 1111614`) mediante colas Oracle Advanced Queuing (`MPU_ORDEN_MPU_TB`) y un servicio backend (`http://appl.pad.cl:12000/padmpu/*`).

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `1372` | **Listado de Órdenes** | `dashboard_ordenes_cab` | Dashboard | `control_filtros_ordenes_cab` (Control)<br>`app_listado_mpu_ordenes_grid` (Grid) | `ADM_OBS.MPU_ORDENES_CAB` (5.138 reg.)<br>`ADM_OBS.MPU_ORDENES_DET` (14.599 reg.)<br>`ADM_OBS.MPU_OCS_V` (Vista 47 cols)<br>`ADM_OBS.MPU_PROVEEDORES` (910 reg.)<br>`ADM_OBS.MPU_SUCURSALES` (938 reg.) | **Filtros (`control_filtros_ordenes_cab`):** `orden`, `estado`, `proveedor`, `sucursal`, `moneda`, `fecha_ini`, `fecha_fin`.<br>**Columnas (`app_listado_mpu_ordenes_grid`):** Orden, Proveedor, Sucursal, Descriptor OC, Fecha Envío, Estado, Total, Moneda, Ver. |
| `1373` | **Gráficos de Órdenes** | `blank_dashboard_graficos_ordenes` | Dashboard | `control_filtras_graficos_ordenes` (Control)<br>`blank_graficos_ordenes` (Dashboard)<br>→ `blank_grid_estados_x_moneda`<br>→ `chart_cantidades_x_estado` | `ADM_OBS.MPU_ORDENES_CAB`<br>`ADM_OBS.MPU_DOM_ESTADO_OC`<br>`ADM_OBS.MPU_DOM_TIPO_MONEDA` | **Filtros:** `fec_ini`, `fec_fin`, `proveedor`, `moneda`, `estado` (doble lista selección). |
| `1374` | **Reprocesar Órdenes** | `dashboard_reprocesar_ordenes` | Dashboard | `control_filtros_reprocesar_ordenes` (Control)<br>`app_listado_mpu_ordenes_reprocesar_grid` (Grid) | `ADM_OBS.MPU_REPROCESOS` (496 reg.)<br>`ADM_OBS.MPU_ORDENES_OD` (13 reg.)<br>`ADM_OBS.MPU_REQUEST_ORDEN_MPU_TB` (Cola AQ) | **Filtros:** `orden`, `estado`, `fecha_ini`, `fecha_fin`.<br>**Columnas:** Orden, Proveedor, Descriptor OC, Fecha Envío, Fecha Solicitud, Estado OC, Estado Solicitud. |

---

### 9. Módulo: RRHH APS (`MENU_ID = 804`)
Módulo de Recursos Humanos para Atención Primaria de Salud (APS): catálogos de estamentos, establecimientos, tipos de contrato, carga/consulta de registros de asistencia/dotación APS, reportes consolidados y descarga de base de datos por rango de fechas.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `805` | **Estamento** | `estamiento_grid` | Grid | → `estamiento_form` | `ADM_OBS.ESTAMIENTO` (21 reg.) | **Campos:** `esmi_cod` (Código Estamento), `esmi_nomb` (Estamento), `esmi_cate` (Categoría). |
| `806` | **Establecimiento** | `estableicmiento_grid` | Grid | → `establecimiento_form` | `ADM_OBS.ESTABLECIMIENTO` (15 reg.) | **Campos:** `esta_cod` (Código Establecimiento), `esta_nomb` (Establecimiento). |
| `807` | **Contrato** | `contrato_gird` | Grid | → `contrato_form` | `ADM_OBS.CONTRATO` (2 reg.) | **Campos:** `cont_cod` (Código Contrato), `cont_nomb` (Contrato). |
| `808` | **Registros APS** | `registro_blank` | Blank | Interfaz personalizada de registro APS | `ADM_OBS.REGISTRO` (88.158 reg.) | Gestión de registros de funcionarios APS en `ADM_OBS.REGISTRO`. |
| `809` | **Reporte** | `reporte_aps_control` | Control | Generación de reporte RRHH APS | `ADM_OBS.OBS_REP_RRHH` (47 reg.)<br>`ADM_OBS.OBS_REP_RRHH_DET` (10.290 reg.)<br>`ADM_OBS.OBS_REP_RRHH_RES` (1.100 reg.) | **Campos:** `regi_fecha` (Fecha *), `cont_cod` (Contrato *), `rerr_sec` (RERR_SEC). |
| `810` | **Descarga de BD** | `descarga_bd_control` | Control | Exportación masiva por fechas | `ADM_OBS.REGISTRO` | **Campos:** `desde` (Desde *), `hasta` (Hasta *). |

---

### 10. Módulo: Agenda de Atención (`MENU_ID = 441`)
Administración de módulos de atención presencial por departamento y reportería tabular/gráfica de citas y solicitudes de atención ciudadana.

| ID Menú | Opción de Menú | App Principal (Scriptcase) | Tipo | Sub-Apps / Iframes / Enlaces | Tabla(s) Oracle Principal(es) | Campos / Filtros y Columnas Relevantes |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- |
| `442` | **Departamento** | `departamento_atencion_grid` | Grid | Configuración de módulos de atención | `ADM_OBS.HR_DEPARTAMENTO` (45 reg.)<br>`ADM_OBS.OBS_HORA_SOLICITUD` (9 reg.)<br>`ADM_OBS.OBS_TRAMITES_DPTOS` | **Columnas:** Ver, Departamento (`depa_nombre`), Representante (`depa_nombre_resp`), Módulo de Atención, Estado. |
| `443` | **Reporte** | `reporte_atencion_blank` | Dashboard | `reporte_atencion_1` (Grid)<br>`reporte_atencion_1_form` (Form)<br>`reporte_atencion_2` (Chart)<br>`reporte_atencion_3` (Chart) | `ADM_OBS.OBS_DATOS_SOLICITUD` (49 reg.)<br>`ADM_OBS.OBS_HORA_SOLICITUD` (9 reg.)<br>`ADM_OBS.HR_DEPARTAMENTO` | **Columnas (`reporte_atencion_1`):** EDITAR, Departamento, RUT, DV, Pasaporte, Nombre, Apellido Paterno, Apellido Materno, Fecha de Atención, Hora. |

---

## Otros Módulos Presentes en el Portal y en `OBS_MENU_DETALLE`

Además de los 10 módulos priorizados, existen en el mismo portal (y registrados en `ADM_OBS.OBS_MENU_DETALLE`):
1. **Servicios Básicos (`MENU_ID = 4`):** `pagos_grid`, `servicios_grid`, `clientes_grid` → Tablas `ADM_OBS.SBA_CLIENTES` (411 reg.), `SBA_SERVICIOS` (21 reg.), `SBA_CLIE_SERV` (483 reg.), `SBA_CONSUMOS` (13.060 reg.), `SBA_FLUJO_ESTADO` (13.060 reg.).
2. **Certificados COVID (`MENU_ID = 361`):** `certificado_grid`, `reporte_blank` → Tabla `ADM_OBS.OBS_CERTIFICADO` (25.777 reg.). *(Módulo histórico).*
3. **Seguimiento / Trazabilidad COVID (`MENU_ID = 481`):** 12 pantallas (`cargar_traza_blank`, `investigador_grid`, etc.) → Tablas `ADM_OBS.OBS_TRAZABILIDAD*` (~35.000 reg.). *(Módulo histórico).*
4. **Estadística Salud (`MENU_ID = 811`):** `estadistica_blank`, `reporte_essa_blank`, `descarga_blank`, `periodo_epidem_grid` → Tablas `ADM_OBS.ADM_ALIMENTACION_COMPL`, `ADM_ATENCION_URGENCIA`, `ADM_PERIODO_EPIDEM`, `ADM_SEMANA_EPIDEM`.
5. **Certificado Elecciones (`MENU_ID = 816`):** `certificado_eleccion_grid` → Tabla `ADM_OBS.OBS_CERTIFICADO_ELECCION` (3 reg.).
6. **Opciones de Menú REM (`MENU_ID = 1130..1136` en `OBS_MENU_DETALLE`):** `blank_dashboard_up_doc`, `blank_dashboard_dw_doc`, `blank_dashboard_car_peri`, `blank_dashboard_sub_peri`, `blank_dashboard_user_dest` → Tablas `ADM_OBS.OBS_CARPETAS_REM`, `OBS_SUBCARPETAS_REM`, `OBS_REM_LOG` (visibles para usuarios del perfil `REM` a través de la vista `OBS_MENU_USU_REM_V`).
