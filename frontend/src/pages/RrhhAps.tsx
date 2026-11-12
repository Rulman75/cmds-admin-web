import React, { useState, useEffect, useCallback } from 'react';

interface RegistroAps {
  REGI_SEC: number;
  FECHA_REGISTRO: string;
  ESTA_COD: string;
  ESTABLECIMIENTO: string;
  ESMI_COD: string;
  ESTAMENTO: string;
  CATEGORIA: string;
  CONT_COD: string;
  CONTRATO: string;
  TOTAL_FUNC: number;
  OPERATIVOS: number;
  FERIADO_LEGAL: number;
  LICENCIA_MEDICA: number;
  PERMISO_ADMIN: number;
  CAPACITACION: number;
  ESQUEMA_VAC: number;
  TELETRABAJO: number;
  JORNADA_PARCIAL: number;
  ESTADO: string;
}

export default function RrhhAps() {
  const [activeTab, setActiveTab] = useState<'dotacion' | 'resumen' | 'rem' | 'catalogos'>('dotacion');
  const [registros, setRegistros] = useState<RegistroAps[]>([]);
  const [resumenEstab, setResumenEstab] = useState<any[]>([]);
  const [remData, setRemData] = useState<{
    carpetas: any[];
    subcarpetas: any[];
    archivos: any[];
  }>({ carpetas: [], subcarpetas: [], archivos: [] });
  const [catalogos, setCatalogos] = useState<{
    establecimientos: any[];
    estamentos: any[];
    contratos: any[];
  }>({ establecimientos: [], estamentos: [], contratos: [] });
  const [loading, setLoading] = useState(true);
  const [feedback, setFeedback] = useState<{ type: 'ok' | 'err'; msg: string } | null>(null);

  const [filtroEstab, setFiltroEstab] = useState('');
  const [filtroEstamento, setFiltroEstamento] = useState('');
  const [filtroContrato, setFiltroContrato] = useState('');
  const [search, setSearch] = useState('');

  // Modal Nuevo Registro APS
  const [showNewRegModal, setShowNewRegModal] = useState(false);
  const [regForm, setRegForm] = useState({
    estaCod: 'CES-01',
    esmiCod: 'EST-B1',
    contCod: 'CONT-PL',
    fechaRegistro: new Date().toISOString().slice(0, 10),
    operativos: 22,
    feriadoLegal: 2,
    licenciaMedica: 1,
    permisoAdmin: 1,
    capacitacion: 0,
    teletrabajo: 0
  });

  // Modal Subir Archivo REM
  const [showRemModal, setShowRemModal] = useState(false);
  const [remForm, setRemForm] = useState({
    archNombre: 'REM_A_CESFAM_NORTE_202611.xlsx',
    planSec: 1,
    totalLineas: 1480
  });

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtroEstab) params.set('establecimiento', filtroEstab);
      if (filtroEstamento) params.set('estamento', filtroEstamento);
      if (filtroContrato) params.set('contrato', filtroContrato);
      if (search) params.set('search', search);

      const res = await fetch(`/api/rrhh-aps?${params.toString()}`);
      const json = await res.json();
      if (json.status === 'ok') {
        setRegistros(json.data || []);
        setResumenEstab(json.resumenEstablecimientos || []);
        setRemData(json.rem || { carpetas: [], subcarpetas: [], archivos: [] });
        setCatalogos(json.catalogos || { establecimientos: [], estamentos: [], contratos: [] });
      }
    } catch (err) {
      console.error('Error cargando RRHH APS:', err);
    } finally {
      setLoading(false);
    }
  }, [filtroEstab, filtroEstamento, filtroContrato, search]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleCreateReg = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/rrhh-aps/registros', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(regForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewRegModal(false);
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleCreateRem = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/rrhh-aps/rem-archivo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(remForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowRemModal(false);
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const totalDotacion = registros.reduce((acc, r) => acc + Number(r.TOTAL_FUNC || 0), 0);
  const totalOperativos = registros.reduce((acc, r) => acc + Number(r.OPERATIVOS || 0), 0);
  const totalLicencias = registros.reduce((acc, r) => acc + Number(r.LICENCIA_MEDICA || 0), 0);
  const totalFeriados = registros.reduce(
    (acc, r) => acc + Number(r.FERIADO_LEGAL || 0) + Number(r.PERMISO_ADMIN || 0),
    0
  );

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#016098] text-white">
              FASE 3 · MÓDULO 9 · ADM_OBS.REGISTRO & REM
            </span>
            <span className="text-xs text-slate-500 font-medium">
              Salud Primaria APS (Ley 19.378) · PostgreSQL 18
            </span>
          </div>
          <h1 className="text-xl font-bold text-slate-800 mt-1">
            RRHH Atención Primaria de Salud (APS) y Repositorio Estadístico REM
          </h1>
          <p className="text-xs text-slate-500">
            Control diario de dotación operativa, ausentismo (licencias, feriados, permisos) por CESFAM/Estamento y gestión de archivos REM MINSAL.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <button
            onClick={() => setShowNewRegModal(true)}
            className="px-3.5 py-2 rounded-lg bg-[#016098] hover:bg-[#014b76] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Registrar Dotación CESFAM
          </button>
          <button
            onClick={() => setShowRemModal(true)}
            className="px-3.5 py-2 rounded-lg bg-[#39BABD] hover:bg-[#2da3a6] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Subir Archivo REM
          </button>
        </div>
      </div>

      {feedback && (
        <div
          className={`p-3.5 rounded-xl border text-xs font-semibold flex items-center justify-between ${
            feedback.type === 'ok'
              ? 'bg-emerald-50 border-emerald-200 text-emerald-800'
              : 'bg-rose-50 border-rose-200 text-rose-800'
          }`}
        >
          <span>{feedback.msg}</span>
          <button onClick={() => setFeedback(null)} className="text-xs underline ml-4 cursor-pointer">
            Cerrar
          </button>
        </div>
      )}

      {/* KPIs */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#016098]">
          <p className="text-xs text-slate-500 font-semibold uppercase">Dotación Total Informada</p>
          <p className="text-2xl font-extrabold text-slate-800 mt-1">{totalDotacion}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Funcionarios en {catalogos.establecimientos.length} establecimientos APS</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Operativos Presenciales</p>
          <p className="text-2xl font-extrabold text-emerald-600 mt-1">
            {totalOperativos}{' '}
            <span className="text-xs font-bold text-slate-400">
              ({totalDotacion > 0 ? Math.round((totalOperativos / totalDotacion) * 100) : 0}%)
            </span>
          </p>
          <p className="text-[11px] text-slate-400 mt-0.5">En funciones clínicas / administrativas</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-rose-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Con Licencia Médica (LM)</p>
          <p className="text-2xl font-extrabold text-rose-600 mt-1">{totalLicencias}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Ausentismo médico vigente</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-amber-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Feriados y Permisos (FL + DP)</p>
          <p className="text-2xl font-extrabold text-amber-600 mt-1">{totalFeriados}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Feriado legal y días administrativos</p>
        </div>
      </div>

      {/* Pestañas */}
      <div className="flex flex-wrap gap-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('dotacion')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'dotacion'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Registros Diarios APS ({registros.length})
        </button>
        <button
          onClick={() => setActiveTab('resumen')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'resumen'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Consolidado por CESFAM ({resumenEstab.length})
        </button>
        <button
          onClick={() => setActiveTab('rem')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'rem'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Repositorio REM MINSAL ({remData.archivos.length})
        </button>
        <button
          onClick={() => setActiveTab('catalogos')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'catalogos'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Estamentos ({catalogos.estamentos.length}) y Contratos ({catalogos.contratos.length})
        </button>
      </div>

      {activeTab === 'dotacion' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200 grid grid-cols-1 md:grid-cols-4 gap-3">
            <select
              value={filtroEstab}
              onChange={(e) => setFiltroEstab(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los CESFAM / Establecimientos</option>
              {catalogos.establecimientos.map((e: any) => (
                <option key={e.ESTA_COD} value={e.ESTA_COD}>
                  {e.ESTA_NOMB}
                </option>
              ))}
            </select>
            <select
              value={filtroEstamento}
              onChange={(e) => setFiltroEstamento(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Estamentos Ley 19.378</option>
              {catalogos.estamentos.map((es: any) => (
                <option key={es.ESMI_COD} value={es.ESMI_COD}>
                  {es.ESMI_CATE} — {es.ESMI_NOMB}
                </option>
              ))}
            </select>
            <select
              value={filtroContrato}
              onChange={(e) => setFiltroContrato(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Tipos de Contrato</option>
              {catalogos.contratos.map((c: any) => (
                <option key={c.CONT_COD} value={c.CONT_COD}>
                  {c.CONT_NOMB}
                </option>
              ))}
            </select>
            <button
              onClick={() => {
                setFiltroEstab('');
                setFiltroEstamento('');
                setFiltroContrato('');
                setSearch('');
              }}
              className="px-3 py-2 rounded-lg border border-slate-300 bg-white hover:bg-slate-100 text-xs font-semibold text-slate-600 cursor-pointer"
            >
              Limpiar Filtros
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">ID / Fecha</th>
                  <th className="py-3 px-4">Establecimiento APS</th>
                  <th className="py-3 px-4">Estamento / Categoría</th>
                  <th className="py-3 px-3">Calidad Jurídica</th>
                  <th className="py-3 px-3 text-center">Dotación Total</th>
                  <th className="py-3 px-3 text-center text-emerald-700">Operativos</th>
                  <th className="py-3 px-3 text-center text-amber-700">Feriado (FL)</th>
                  <th className="py-3 px-3 text-center text-rose-700">Licencia (LM)</th>
                  <th className="py-3 px-3 text-center">Permiso (DP)</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={9} className="py-8 text-center text-slate-400">
                      Cargando registros de RRHH APS desde PostgreSQL...
                    </td>
                  </tr>
                ) : (
                  registros.map((r) => (
                    <tr key={r.REGI_SEC} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-4">
                        <div className="font-bold text-[#016098]">#{r.REGI_SEC}</div>
                        <div className="text-[11px] text-slate-400">{r.FECHA_REGISTRO}</div>
                      </td>
                      <td className="py-3 px-4 font-bold text-slate-800">{r.ESTABLECIMIENTO}</td>
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-800">{r.ESTAMENTO}</div>
                        <div className="text-[10px] font-bold text-[#016098]">{r.CATEGORIA}</div>
                      </td>
                      <td className="py-3 px-3 text-slate-600">{r.CONTRATO}</td>
                      <td className="py-3 px-3 text-center font-extrabold text-slate-800 text-sm">
                        {r.TOTAL_FUNC}
                      </td>
                      <td className="py-3 px-3 text-center font-bold text-emerald-600">{r.OPERATIVOS}</td>
                      <td className="py-3 px-3 text-center font-semibold text-amber-600">{r.FERIADO_LEGAL}</td>
                      <td className="py-3 px-3 text-center font-semibold text-rose-600">{r.LICENCIA_MEDICA}</td>
                      <td className="py-3 px-3 text-center text-slate-600">{r.PERMISO_ADMIN}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'resumen' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200">
            <h3 className="text-sm font-bold text-slate-800">
              Reporte Consolidado de Dotación y Ausentismo por Establecimiento APS
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">Código</th>
                  <th className="py-3 px-4">Establecimiento CESFAM</th>
                  <th className="py-3 px-4 text-center">Dotación Total</th>
                  <th className="py-3 px-4 text-center">Operativos</th>
                  <th className="py-3 px-4 text-center">Feriado Legal</th>
                  <th className="py-3 px-4 text-center">Licencia Médica</th>
                  <th className="py-3 px-4 text-center">Permisos Adm.</th>
                  <th className="py-3 px-4 text-center">% Operatividad</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {resumenEstab.map((re: any) => {
                  const pct =
                    Number(re.DOTACION_TOTAL) > 0
                      ? Math.round((Number(re.OPERATIVOS) / Number(re.DOTACION_TOTAL)) * 100)
                      : 0;
                  return (
                    <tr key={re.ESTA_COD} className="hover:bg-slate-50">
                      <td className="py-3 px-4 font-mono font-bold text-[#016098]">{re.ESTA_COD}</td>
                      <td className="py-3 px-4 font-bold text-slate-800">{re.ESTABLECIMIENTO}</td>
                      <td className="py-3 px-4 text-center font-extrabold">{re.DOTACION_TOTAL}</td>
                      <td className="py-3 px-4 text-center font-bold text-emerald-600">{re.OPERATIVOS}</td>
                      <td className="py-3 px-4 text-center text-amber-600 font-semibold">{re.FERIADO_LEGAL}</td>
                      <td className="py-3 px-4 text-center text-rose-600 font-semibold">{re.LICENCIA_MEDICA}</td>
                      <td className="py-3 px-4 text-center">{re.PERMISO_ADMIN}</td>
                      <td className="py-3 px-4 text-center">
                        <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-800">
                          {pct}%
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'rem' && (
        <div className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-3">
            {remData.carpetas.map((c: any) => (
              <div key={c.CARE_SEC} className="bg-white rounded-xl p-4 shadow-sm border border-slate-200">
                <div className="flex items-center justify-between">
                  <span className="font-mono text-xs font-bold text-[#016098]">Período #{c.CARE_SEC}</span>
                  <span
                    className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                      c.CARE_ESTADO === 'ABIERTO'
                        ? 'bg-emerald-100 text-emerald-800'
                        : 'bg-slate-100 text-slate-600'
                    }`}
                  >
                    {c.CARE_ESTADO}
                  </span>
                </div>
                <p className="text-xs font-bold text-slate-800 mt-2">{c.CARE_NOMBRE}</p>
              </div>
            ))}
          </div>

          <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="p-4 bg-slate-50 border-b border-slate-200">
              <h3 className="text-sm font-bold text-slate-800">
                Archivos Estadísticos REM Cargados por Establecimiento (OBS_ARCHIVOS)
              </h3>
            </div>
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">ID</th>
                  <th className="py-3 px-4">Archivo REM</th>
                  <th className="py-3 px-4">Serie MINSAL</th>
                  <th className="py-3 px-3 text-right">Registros</th>
                  <th className="py-3 px-4">Checksum</th>
                  <th className="py-3 px-4">Fecha Carga</th>
                  <th className="py-3 px-4 text-center">Estado</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {remData.archivos.map((a: any) => (
                  <tr key={a.ARCH_SEC} className="hover:bg-slate-50">
                    <td className="py-2.5 px-4 font-mono">#{a.ARCH_SEC}</td>
                    <td className="py-2.5 px-4 font-bold text-[#016098]">{a.ARCH_NOMBRE}</td>
                    <td className="py-2.5 px-4 font-semibold text-slate-700">{a.SERIE_REM}</td>
                    <td className="py-2.5 px-3 text-right font-bold">{a.ARCH_TOTAL_LINEAS}</td>
                    <td className="py-2.5 px-4 font-mono text-[11px] text-slate-500">{a.ARCH_CHECKSUM}</td>
                    <td className="py-2.5 px-4 text-slate-600">{a.FECHA_CARGA}</td>
                    <td className="py-2.5 px-4 text-center">
                      <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                        {a.ARCH_DOM_ESTADO_ARCHIVO}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'catalogos' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="p-4 bg-slate-50 border-b border-slate-200">
              <h3 className="text-sm font-bold text-slate-800">Estamentos Salud Primaria (ESTAMIENTO)</h3>
            </div>
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-2.5 px-4">Código</th>
                  <th className="py-2.5 px-4">Categoría Ley 19.378</th>
                  <th className="py-2.5 px-4">Estamento</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {catalogos.estamentos.map((e: any) => (
                  <tr key={e.ESMI_COD}>
                    <td className="py-2.5 px-4 font-mono font-bold text-[#016098]">{e.ESMI_COD}</td>
                    <td className="py-2.5 px-4 font-bold text-slate-600">{e.ESMI_CATE}</td>
                    <td className="py-2.5 px-4 font-semibold text-slate-800">{e.ESMI_NOMB}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="p-4 bg-slate-50 border-b border-slate-200">
              <h3 className="text-sm font-bold text-slate-800">Modalidades de Contrato APS (CONTRATO)</h3>
            </div>
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-2.5 px-4">Código</th>
                  <th className="py-2.5 px-4">Descripción Contrato</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {catalogos.contratos.map((c: any) => (
                  <tr key={c.CONT_COD}>
                    <td className="py-2.5 px-4 font-mono font-bold text-[#016098]">{c.CONT_COD}</td>
                    <td className="py-2.5 px-4 font-semibold text-slate-800">{c.CONT_NOMB}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Modal Nuevo Registro Dotación APS */}
      {showNewRegModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Registrar Dotación y Ausentismo Diario APS</h3>
              <button onClick={() => setShowNewRegModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateReg} className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Establecimiento CESFAM</label>
                  <select
                    value={regForm.estaCod}
                    onChange={(e) => setRegForm({ ...regForm, estaCod: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.establecimientos.map((e: any) => (
                      <option key={e.ESTA_COD} value={e.ESTA_COD}>
                        {e.ESTA_NOMB}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Fecha de Corte</label>
                  <input
                    type="date"
                    value={regForm.fechaRegistro}
                    onChange={(e) => setRegForm({ ...regForm, fechaRegistro: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Estamento</label>
                  <select
                    value={regForm.esmiCod}
                    onChange={(e) => setRegForm({ ...regForm, esmiCod: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.estamentos.map((es: any) => (
                      <option key={es.ESMI_COD} value={es.ESMI_COD}>
                        {es.ESMI_NOMB}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Calidad Contractual</label>
                  <select
                    value={regForm.contCod}
                    onChange={(e) => setRegForm({ ...regForm, contCod: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.contratos.map((c: any) => (
                      <option key={c.CONT_COD} value={c.CONT_COD}>
                        {c.CONT_NOMB}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 bg-slate-50 p-3 rounded-lg border border-slate-200">
                <div>
                  <label className="block font-bold text-emerald-700 mb-1">Operativos</label>
                  <input
                    type="number"
                    min={0}
                    value={regForm.operativos}
                    onChange={(e) => setRegForm({ ...regForm, operativos: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  />
                </div>
                <div>
                  <label className="block font-bold text-amber-700 mb-1">Feriado Legal</label>
                  <input
                    type="number"
                    min={0}
                    value={regForm.feriadoLegal}
                    onChange={(e) => setRegForm({ ...regForm, feriadoLegal: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  />
                </div>
                <div>
                  <label className="block font-bold text-rose-700 mb-1">Licencia Médica</label>
                  <input
                    type="number"
                    min={0}
                    value={regForm.licenciaMedica}
                    onChange={(e) => setRegForm({ ...regForm, licenciaMedica: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Permiso Adm.</label>
                  <input
                    type="number"
                    min={0}
                    value={regForm.permisoAdmin}
                    onChange={(e) => setRegForm({ ...regForm, permisoAdmin: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  />
                </div>
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowNewRegModal(false)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#016098] text-white font-bold cursor-pointer"
                >
                  Guardar en PostgreSQL
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal Subir REM */}
      {showRemModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-md w-full overflow-hidden">
            <div className="p-4 bg-[#39BABD] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Registrar Carga de Archivo Estadístico REM</h3>
              <button onClick={() => setShowRemModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateRem} className="p-5 space-y-4 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Nombre Archivo REM *</label>
                <input
                  type="text"
                  required
                  value={remForm.archNombre}
                  onChange={(e) => setRemForm({ ...remForm, archNombre: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Serie REM MINSAL</label>
                <select
                  value={remForm.planSec}
                  onChange={(e) => setRemForm({ ...remForm, planSec: Number(e.target.value) })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                >
                  {remData.subcarpetas.map((s: any) => (
                    <option key={s.SURE_SEC} value={s.SURE_SEC}>
                      {s.SURE_NOMBRE}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Cantidad de Registros / Líneas</label>
                <input
                  type="number"
                  value={remForm.totalLineas}
                  onChange={(e) => setRemForm({ ...remForm, totalLineas: Number(e.target.value) })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowRemModal(false)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#39BABD] text-white font-bold cursor-pointer"
                >
                  Registrar Archivo REM
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
