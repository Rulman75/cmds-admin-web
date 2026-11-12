import React, { useState, useEffect, useCallback } from 'react';
import { useSearchParams } from 'react-router-dom';
import axios from 'axios';
import { exportToExcel, exportToPDF, formatCLP, formatRut } from '../utils/exportUtils';

interface CatalogMeta {
  id: string;
  label: string;
  table: string;
  desc: string;
  columns: { key: string; label: string; format?: 'clp' | 'rut' | 'badge' }[];
}

const CATALOGS: CatalogMeta[] = [
  {
    id: 'unidades',
    label: 'Unidades / Establecimientos',
    table: 'ADM_OBS.ADM_UNIDAD',
    desc: 'Establecimientos de Salud (CESFAM), Liceos, Escuelas y Direcciones de Administración Central.',
    columns: [
      { key: 'UNID_SEC', label: 'ID' },
      { key: 'UNID_CODIGO', label: 'Código' },
      { key: 'UNID_DESC', label: 'Nombre Unidad / Establecimiento' },
      { key: 'SECTOR_DESC', label: 'Sector', format: 'badge' },
      { key: 'TOTAL_CONVENIOS', label: 'Convenios Asoc.' }
    ]
  },
  {
    id: 'cecos',
    label: 'Centros de Costo',
    table: 'ADM_OBS.BHO_CENTRO_COSTO',
    desc: 'Catálogo de Centros de Costo contables (Softland CW) asociados a Salud, Educación y Administración.',
    columns: [
      { key: 'CECO_SEC', label: 'ID' },
      { key: 'CECO_COD', label: 'Código CeCo' },
      { key: 'CECO_DESC', label: 'Descripción Centro de Costo' },
      { key: 'SECTOR_DESC', label: 'Sector', format: 'badge' },
      { key: 'CECO_DOM_ESTADO', label: 'Estado' }
    ]
  },
  {
    id: 'convenios',
    label: 'Convenios APS / SEP',
    table: 'ADM_OBS.ADM_CONVENIO',
    desc: 'Programas Ministeriales de Salud (PRAPS) y Convenios con imputación contable y centro de costo.',
    columns: [
      { key: 'CONV_SEC', label: 'ID' },
      { key: 'CONV_CODIGO', label: 'Cód. Convenio' },
      { key: 'CONV_DESC', label: 'Nombre del Convenio / Programa' },
      { key: 'CONV_CUENTA_SALUD', label: 'Cuenta Contable' },
      { key: 'CONV_CECO_COD', label: 'CeCo Asociado' },
      { key: 'CONV_IND_TRANSVERSAL', label: 'Transversal' }
    ]
  },
  {
    id: 'actividades',
    label: 'Actividades y Tarifas',
    table: 'ADM_OBS.ADM_ACTIVIDAD',
    desc: 'Actividades clínicas, docentes y administrativas con valor hora referencial y área de cuenta.',
    columns: [
      { key: 'ACTI_SEC', label: 'ID' },
      { key: 'ACTI_CODIGO', label: 'Código' },
      { key: 'ACTI_DESC', label: 'Descripción de Actividad' },
      { key: 'ACTI_AREA_CUENTA', label: 'Área Cuenta' },
      { key: 'ACTI_MONTO_HORA', label: 'Valor Hora Ref.', format: 'clp' },
      { key: 'ACTI_ESTADO', label: 'Estado', format: 'badge' }
    ]
  },
  {
    id: 'periodos',
    label: 'Períodos Contables BHO',
    table: 'ADM_OBS.BHO_PERIODOS',
    desc: 'Control de apertura y cierre mensual de recepción de Boletas de Honorarios y Evidencias por Sector.',
    columns: [
      { key: 'PERI_SEC', label: 'ID Período' },
      { key: 'PERI_NOMBRE', label: 'Período (AAAAMM)' },
      { key: 'SECTOR_DESC', label: 'Sector' },
      { key: 'PERI_ESTADO', label: 'Estado', format: 'badge' },
      { key: 'FECHA_ING', label: 'Fecha Apertura' },
      { key: 'FECHA_EVIDENCIA', label: 'Tope Evidencia' },
      { key: 'TOTAL_BOLETAS', label: 'N° Boletas' }
    ]
  },
  {
    id: 'departamentos',
    label: 'Departamentos y Jefaturas',
    table: 'ADM_OBS.HR_DEPARTAMENTO',
    desc: 'Estructura orgánica de Direcciones y Departamentos CMDS con RUT de Director/Jefe firmante y subrogante.',
    columns: [
      { key: 'DEPA_SEC', label: 'ID' },
      { key: 'DEPA_NOMBRE', label: 'Departamento / Dirección' },
      { key: 'DEPA_RUT_RESP', label: 'RUT Jefatura' },
      { key: 'DEPA_NOMBRE_RESP', label: 'Nombre Responsable' },
      { key: 'DEPA_CORREO_RESP', label: 'Correo' },
      { key: 'DEPA_NOMBRE_SUBR', label: 'Subrogante' },
      { key: 'DEPA_ESTADO', label: 'Estado', format: 'badge' }
    ]
  },
  {
    id: 'usuarios',
    label: 'Usuarios y Permisos SSO',
    table: 'ADM_AUTH.AUT_USUARIOS + ADM_OBS.OBS_USUARIOS_AUTH_V',
    desc: 'Usuarios corporativos habilitados en el ecosistema CMDS y cantidad de opciones de menú asignadas.',
    columns: [
      { key: 'RUT_USUARIO', label: 'RUT Usuario' },
      { key: 'NOMBRE_USUARIO', label: 'Nombre Completo' },
      { key: 'CORREO', label: 'Correo Institucional' },
      { key: 'TIPO', label: 'Rol (A/U)' },
      { key: 'ESTADO', label: 'Estado', format: 'badge' },
      { key: 'PERMISOS_MENU', label: 'Ítems Menú' }
    ]
  },
  {
    id: 'menus',
    label: 'Árbol de Menús RBAC',
    table: 'ADM_OBS.OBS_MENU + OBS_MENU_DETALLE',
    desc: 'Estructura jerárquica de módulos y aplicaciones que controla el acceso por perfil en CMDS ADMIN.',
    columns: [
      { key: 'MENU_ID', label: 'ID Menú' },
      { key: 'PADRE_DESC', label: 'Módulo Padre' },
      { key: 'MENU_DESC', label: 'Opción de Menú' },
      { key: 'MEDE_LABEL', label: 'Etiqueta UI' },
      { key: 'MEDE_LINK', label: 'Controlador / App' }
    ]
  },
  {
    id: 'sectores',
    label: 'Sectores Institucionales',
    table: 'ADM_OBS.ADM_SECTOR',
    desc: 'Macro-sectores presupuestarios de la Corporación Municipal de Desarrollo Social.',
    columns: [
      { key: 'SECT_SEC', label: 'Código Sector' },
      { key: 'SECT_DESC', label: 'Nombre Sector' },
      { key: 'TOTAL_UNIDADES', label: 'Unidades Asociadas' },
      { key: 'TOTAL_CECOS', label: 'Centros de Costo' }
    ]
  },
  {
    id: 'formaciones',
    label: 'Formaciones Profesionales',
    table: 'ADM_OBS.ADM_FORMACION',
    desc: 'Catálogo de profesiones, especialidades médicas, docentes y técnicas.',
    columns: [
      { key: 'FORM_SEC', label: 'ID' },
      { key: 'FORM_CODIGO', label: 'Código' },
      { key: 'FORM_DESC', label: 'Formación / Profesión' }
    ]
  },
  {
    id: 'dominios',
    label: 'Dominios (OBS_REF_CODES)',
    table: 'ADM_OBS.OBS_REF_CODES',
    desc: 'Tabla maestra de códigos de referencia (Bancos, Estados de Boleta, Estados de Evidencia, Tipos de Contrato).',
    columns: [
      { key: 'REF_DOM', label: 'Dominio' },
      { key: 'REF_LOW_VAL', label: 'Código / Valor' },
      { key: 'REF_MNG', label: 'Significado / Glosa' },
      { key: 'REF_MOD', label: 'Módulo' }
    ]
  },
  {
    id: 'parametros',
    label: 'Parámetros Globales',
    table: 'ADM_OBS.OBS_PARAMETROS',
    desc: 'Parámetros de negocio transversales (% Retención SII, topes y banderas operativas).',
    columns: [
      { key: 'PARA_CODIGO', label: 'Código Parámetro' },
      { key: 'PARA_DESC', label: 'Descripción' },
      { key: 'PARA_VALOR', label: 'Valor Vigente' }
    ]
  }
];

const MantenedorGeneral: React.FC = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const tabParam = searchParams.get('tab') || 'unidades';
  const [activeCat, setActiveCat] = useState<string>(tabParam);
  const [search, setSearch] = useState<string>('');
  const [rows, setRows] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [showAddModal, setShowAddModal] = useState<boolean>(false);
  const [newRecord, setNewRecord] = useState<Record<string, string>>({});

  useEffect(() => {
    const t = searchParams.get('tab');
    if (t && t !== activeCat) {
      setActiveCat(t);
      setSearch('');
    }
  }, [searchParams, activeCat]);

  const currentMeta = CATALOGS.find((c) => c.id === activeCat) || CATALOGS[0];

  const fetchCatalog = useCallback(async () => {
    setLoading(true);
    try {
      const res = await axios.get(`/api/mantenedor/${activeCat}`, {
        params: { search }
      });
      if (res.data.status === 'ok') {
        setRows(res.data.data || []);
      }
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [activeCat, search]);

  useEffect(() => {
    fetchCatalog();
  }, [fetchCatalog]);

  const handleCreateRecord = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await axios.post(`/api/mantenedor/${activeCat}`, newRecord);
      if (res.data.status === 'ok') {
        setShowAddModal(false);
        setNewRecord({});
        fetchCatalog();
      }
    } catch (err: any) {
      alert(err.response?.data?.message || 'Error al guardar registro');
    }
  };

  return (
    <div className="space-y-5">
      {/* Selector de Catálogos Maestros */}
      <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200">
        <div className="flex flex-wrap gap-1.5">
          {CATALOGS.map((cat) => {
            const isActive = cat.id === activeCat;
            return (
              <button
                key={cat.id}
                onClick={() => {
                  setActiveCat(cat.id);
                  setSearchParams({ tab: cat.id });
                  setSearch('');
                }}
                className={`px-3 py-2 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
                  isActive
                    ? 'bg-[#016098] text-white shadow-sm'
                    : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                }`}
              >
                {cat.label}
              </button>
            );
          })}
        </div>
      </div>

      {/* Cabecera de Catálogo Activo y Barra de Herramientas */}
      <div className="bg-white rounded-xl p-5 shadow-sm border border-slate-200 flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-[#016098]/10 text-[#016098] uppercase">
              Fase 0 · Catálogo Maestro
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-mono bg-slate-100 text-slate-700 border border-slate-200">
              {currentMeta.table}
            </span>
          </div>
          <h2 className="text-lg font-bold text-slate-800 mt-1">{currentMeta.label}</h2>
          <p className="text-xs text-slate-500 mt-0.5">{currentMeta.desc}</p>
        </div>

        <div className="flex flex-wrap items-center gap-2 w-full lg:w-auto">
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Filtrar por código, nombre o glosa..."
            className="flex-1 lg:w-64 px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
          />
          <button
            onClick={() => {
              const initial: Record<string, string> = {};
              currentMeta.columns.forEach((c) => {
                initial[c.key] = '';
              });
              setNewRecord(initial);
              setShowAddModal(true);
            }}
            className="px-3.5 py-2 bg-[#39BABD] hover:bg-[#2fa3a6] text-white rounded-lg text-xs font-bold shadow-xs cursor-pointer"
          >
            + Nuevo Registro
          </button>
          <button
            onClick={() => exportToExcel(rows, `Catalogo_${currentMeta.id}`)}
            className="px-3 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
          >
            Excel
          </button>
          <button
            onClick={() =>
              exportToPDF(
                `Catálogo Maestro: ${currentMeta.label}`,
                currentMeta.columns.map((c) => c.label),
                rows.map((r) => currentMeta.columns.map((c) => r[c.key] ?? '')),
                `Catalogo_${currentMeta.id}`
              )
            }
            className="px-3 py-2 bg-slate-700 hover:bg-slate-800 text-white rounded-lg text-xs font-semibold cursor-pointer"
          >
            PDF
          </button>
        </div>
      </div>

      {/* Tabla de Datos del Catálogo */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="px-4 py-2.5 bg-slate-50 border-b border-slate-200 flex justify-between items-center text-xs text-slate-500">
          <span>
            Registros cargados desde Oracle: <strong className="text-slate-800">{rows.length}</strong>
          </span>
          <span className="font-mono text-[11px]">{currentMeta.table}</span>
        </div>

        <div className="overflow-x-auto max-h-[580px]">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-[#016098] text-white text-[11px] uppercase tracking-wider sticky top-0">
                {currentMeta.columns.map((col) => (
                  <th key={col.key} className="py-3 px-4">
                    {col.label}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-200 text-xs">
              {loading ? (
                <tr>
                  <td colSpan={currentMeta.columns.length} className="py-12 text-center text-slate-500">
                    Consultando {currentMeta.table} en Oracle 26ai...
                  </td>
                </tr>
              ) : rows.length === 0 ? (
                <tr>
                  <td colSpan={currentMeta.columns.length} className="py-12 text-center text-slate-400">
                    No se encontraron registros para el criterio indicado.
                  </td>
                </tr>
              ) : (
                rows.map((r, idx) => (
                  <tr key={idx} className="hover:bg-slate-50 transition-colors">
                    {currentMeta.columns.map((col) => {
                      const val = r[col.key];
                      if (col.format === 'clp') {
                        return (
                          <td key={col.key} className="py-2.5 px-4 font-mono font-semibold text-slate-800">
                            {formatCLP(val)}
                          </td>
                        );
                      }
                      if (col.format === 'rut') {
                        return (
                          <td key={col.key} className="py-2.5 px-4 font-mono">
                            {formatRut(val)}
                          </td>
                        );
                      }
                      if (col.format === 'badge') {
                        return (
                          <td key={col.key} className="py-2.5 px-4">
                            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-[#016098]/10 text-[#016098]">
                              {val || '—'}
                            </span>
                          </td>
                        );
                      }
                      return (
                        <td key={col.key} className="py-2.5 px-4 text-slate-700">
                          {val !== null && val !== undefined && val !== '' ? String(val) : '—'}
                        </td>
                      );
                    })}
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal para Agregar Registro al Catálogo (Overlay Seguro) */}
      {showAddModal && (
        <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 max-w-lg w-full overflow-hidden">
            <div className="px-6 py-4 bg-[#016098] text-white flex justify-between items-center">
              <div>
                <span className="text-[10px] uppercase tracking-widest text-[#39BABD] font-bold">
                  Nuevo Registro · {currentMeta.table}
                </span>
                <h3 className="text-base font-bold">Agregar a {currentMeta.label}</h3>
              </div>
              <button
                onClick={() => setShowAddModal(false)}
                className="text-white/80 hover:text-white text-sm font-bold cursor-pointer"
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleCreateRecord} className="p-6 space-y-4">
              {currentMeta.columns.map((col) => (
                <div key={col.key}>
                  <label className="block text-xs font-bold text-slate-700 mb-1">
                    {col.label} <span className="text-slate-400 font-mono">({col.key})</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={newRecord[col.key] || ''}
                    onChange={(e) => setNewRecord({ ...newRecord, [col.key]: e.target.value })}
                    className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
                  />
                </div>
              ))}

              <div className="flex justify-end gap-2 pt-3 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setShowAddModal(false)}
                  className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-xs font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-[#016098] hover:bg-[#014f7d] text-white rounded-lg text-xs font-bold cursor-pointer"
                >
                  Guardar Registro
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default MantenedorGeneral;
