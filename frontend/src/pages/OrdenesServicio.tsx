import React, { useState, useEffect, useCallback } from 'react';

interface OrdenServicio {
  ORSE_SEC: number;
  ORSE_DOC_SEC: number | null;
  DOCU_NUMERO: string;
  REMI_SEC: number;
  REMITENTE: string;
  ORSE_ESTADO: string;
  ORSE_ORIGEN: string;
  FECHA_ENVIO: string;
  FECHA_ING: string;
  DESCRIPCION: string;
  ORSE_IND_RSVA: string;
  ORSE_PRIORIDAD: string;
  TIOS_SEC: number;
  TIPO_ODS: string;
  MATE_SEC: number;
  MATERIA: string;
  DEST_SEC: number;
  DESTINATARIO: string;
  DESTINATARIO_AREA: string;
  FECHA_PLAZO: string;
}

export default function OrdenesServicio() {
  const [activeTab, setActiveTab] = useState<'solicitudes' | 'cronograma'>('solicitudes');
  const [ordenes, setOrdenes] = useState<OrdenServicio[]>([]);
  const [catalogos, setCatalogos] = useState<{
    tiposOds: any[];
    materias: any[];
    destinatarios: any[];
    remitentes: any[];
  }>({ tiposOds: [], materias: [], destinatarios: [], remitentes: [] });
  const [loading, setLoading] = useState(true);
  const [feedback, setFeedback] = useState<{ type: 'ok' | 'err'; msg: string } | null>(null);

  const [filtroEstado, setFiltroEstado] = useState('');
  const [filtroPrioridad, setFiltroPrioridad] = useState('');
  const [search, setSearch] = useState('');

  // Modal Nueva ODS
  const [showNewModal, setShowNewModal] = useState(false);
  const [newForm, setNewForm] = useState({
    docuNumero: '',
    tiosSec: 1,
    mateSec: 1,
    remiSec: 108,
    destSec: 203,
    prioridad: 'ALTA',
    origen: 'DIRECCION EJECUTIVA',
    fechaPlazo: '2026-11-18',
    descripcion: ''
  });

  // Modal Gestión Estado ODS
  const [selectedOds, setSelectedOds] = useState<OrdenServicio | null>(null);
  const [estadoForm, setEstadoForm] = useState({
    nuevoEstado: 'RESPONDIDA',
    destSec: 201,
    observacion: ''
  });

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtroEstado) params.set('estado', filtroEstado);
      if (filtroPrioridad) params.set('prioridad', filtroPrioridad);
      if (search) params.set('search', search);

      const res = await fetch(`/api/ordenes-servicio?${params.toString()}`);
      const json = await res.json();
      if (json.status === 'ok') {
        setOrdenes(json.data || []);
        setCatalogos(json.catalogos || { tiposOds: [], materias: [], destinatarios: [], remitentes: [] });
      }
    } catch (err) {
      console.error('Error cargando Órdenes de Servicio:', err);
    } finally {
      setLoading(false);
    }
  }, [filtroEstado, filtroPrioridad, search]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleCreateOds = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/ordenes-servicio', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewModal(false);
        setNewForm({
          docuNumero: '',
          tiosSec: 1,
          mateSec: 1,
          remiSec: 108,
          destSec: 203,
          prioridad: 'ALTA',
          origen: 'DIRECCION EJECUTIVA',
          fechaPlazo: '2026-11-18',
          descripcion: ''
        });
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleUpdateEstado = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedOds) return;
    try {
      const res = await fetch(`/api/ordenes-servicio/${selectedOds.ORSE_SEC}/estado`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(estadoForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setSelectedOds(null);
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const badgePrioridad = (p: string) => {
    const u = (p || '').toUpperCase();
    if (u === 'URGENTE') return 'bg-rose-100 text-rose-800 border-rose-200';
    if (u === 'ALTA') return 'bg-amber-100 text-amber-800 border-amber-200';
    return 'bg-slate-100 text-slate-700 border-slate-200';
  };

  const badgeEstado = (e: string) => {
    const u = (e || '').toUpperCase();
    if (u.includes('FINALIZ') || u.includes('RESPOND')) return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    if (u.includes('GESTION') || u.includes('DERIV')) return 'bg-blue-100 text-blue-800 border-blue-200';
    return 'bg-amber-100 text-amber-800 border-amber-200';
  };

  const urgentesCount = ordenes.filter((o) => o.ORSE_PRIORIDAD === 'URGENTE' || o.ORSE_PRIORIDAD === 'ALTA').length;
  const enGestionCount = ordenes.filter((o) => ['EN GESTION', 'DERIVADA', 'INGRESADA'].includes(o.ORSE_ESTADO)).length;
  const cerradasCount = ordenes.filter((o) => ['RESPONDIDA', 'FINALIZADA'].includes(o.ORSE_ESTADO)).length;

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#016098] text-white">
              FASE 2 · ADM_OBS.OPA_ORDEN_SERVICIO
            </span>
            <span className="text-xs text-slate-500 font-medium">PostgreSQL 18 (bd_cmds_admin)</span>
          </div>
          <h1 className="text-xl font-bold text-slate-800 mt-1">
            Órdenes de Servicio (ODS) y Cronograma de Plazos
          </h1>
          <p className="text-xs text-slate-500">
            Instrucciones ejecutivas y operativas, asignación de materias, derivación a Direcciones y control de fechas de respuesta.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <button
            onClick={() => setShowNewModal(true)}
            className="px-4 py-2 rounded-lg bg-[#016098] hover:bg-[#014b76] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Emitir Orden de Servicio
          </button>
          <button
            onClick={fetchData}
            className="px-3.5 py-2 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-semibold transition-colors cursor-pointer"
          >
            Actualizar
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
          <p className="text-xs text-slate-500 font-semibold uppercase">Total Órdenes de Servicio</p>
          <p className="text-2xl font-extrabold text-slate-800 mt-1">{ordenes.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.opa_orden_servicio</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-rose-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Prioridad Urgente / Alta</p>
          <p className="text-2xl font-extrabold text-rose-600 mt-1">{urgentesCount}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Seguimiento prioritario Dirección</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-amber-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">En Gestión / Derivadas</p>
          <p className="text-2xl font-extrabold text-amber-600 mt-1">{enGestionCount}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">En bandeja de unidades</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Respondidas / Finalizadas</p>
          <p className="text-2xl font-extrabold text-emerald-600 mt-1">{cerradasCount}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Instrucción cumplida</p>
        </div>
      </div>

      {/* Pestañas */}
      <div className="flex flex-wrap gap-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('solicitudes')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'solicitudes'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Bandeja de Solicitudes ODS ({ordenes.length})
        </button>
        <button
          onClick={() => setActiveTab('cronograma')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'cronograma'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Cronograma y Control de Plazos SLA
        </button>
      </div>

      {activeTab === 'solicitudes' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200 grid grid-cols-1 md:grid-cols-4 gap-3">
            <input
              type="text"
              placeholder="Buscar por N° ODS, instrucción o remitente..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            />
            <select
              value={filtroPrioridad}
              onChange={(e) => setFiltroPrioridad(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todas las Prioridades</option>
              <option value="URGENTE">URGENTE</option>
              <option value="ALTA">ALTA</option>
              <option value="NORMAL">NORMAL</option>
            </select>
            <select
              value={filtroEstado}
              onChange={(e) => setFiltroEstado(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Estados</option>
              <option value="INGRESADA">INGRESADA</option>
              <option value="EN GESTION">EN GESTION</option>
              <option value="DERIVADA">DERIVADA</option>
              <option value="RESPONDIDA">RESPONDIDA</option>
              <option value="FINALIZADA">FINALIZADA</option>
            </select>
            <button
              onClick={() => {
                setFiltroEstado('');
                setFiltroPrioridad('');
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
                  <th className="py-3 px-4">Folio ODS</th>
                  <th className="py-3 px-3">Prioridad</th>
                  <th className="py-3 px-4">Materia / Tipo</th>
                  <th className="py-3 px-4">Instrucción / Descripción</th>
                  <th className="py-3 px-4">Unidad Responsable</th>
                  <th className="py-3 px-3">Plazo Respuesta</th>
                  <th className="py-3 px-3 text-center">Estado</th>
                  <th className="py-3 px-4 text-center">Acción</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={8} className="py-8 text-center text-slate-400">
                      Cargando Órdenes de Servicio desde PostgreSQL...
                    </td>
                  </tr>
                ) : (
                  ordenes.map((o) => (
                    <tr key={o.ORSE_SEC} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-4">
                        <div className="font-bold text-[#016098]">{o.DOCU_NUMERO}</div>
                        <div className="text-[11px] text-slate-400">
                          ID #{o.ORSE_SEC} · {o.FECHA_ENVIO}
                        </div>
                      </td>
                      <td className="py-3 px-3">
                        <span
                          className={`inline-block px-2 py-0.5 rounded-full text-[10px] font-bold border ${badgePrioridad(
                            o.ORSE_PRIORIDAD
                          )}`}
                        >
                          {o.ORSE_PRIORIDAD}
                        </span>
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-800">{o.MATERIA}</div>
                        <div className="text-[11px] text-slate-400">
                          {o.TIPO_ODS} · Origen: {o.ORSE_ORIGEN}
                        </div>
                      </td>
                      <td className="py-3 px-4 max-w-sm">
                        <div className="text-slate-700 font-medium">{o.DESCRIPCION}</div>
                        {o.ORSE_DOC_SEC && (
                          <div className="text-[10px] text-[#016098] font-semibold mt-0.5">
                            Vinculada a Doc Oficina Partes #{o.ORSE_DOC_SEC}
                          </div>
                        )}
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-800">{o.DESTINATARIO}</div>
                        <div className="text-[11px] text-slate-400">{o.REMITENTE}</div>
                      </td>
                      <td className="py-3 px-3 whitespace-nowrap font-semibold text-slate-700">
                        {o.FECHA_PLAZO || '—'}
                      </td>
                      <td className="py-3 px-3 text-center">
                        <span
                          className={`inline-block px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${badgeEstado(
                            o.ORSE_ESTADO
                          )}`}
                        >
                          {o.ORSE_ESTADO}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-center">
                        <button
                          onClick={() => {
                            setSelectedOds(o);
                            setEstadoForm({
                              nuevoEstado: o.ORSE_ESTADO === 'RESPONDIDA' ? 'FINALIZADA' : 'RESPONDIDA',
                              destSec: o.DEST_SEC || 203,
                              observacion: ''
                            });
                          }}
                          className="px-2.5 py-1 rounded-md bg-[#39BABD] hover:bg-[#2da3a6] text-white text-[11px] font-bold transition-colors cursor-pointer"
                        >
                          Gestionar / Responder
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'cronograma' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {ordenes.map((o) => (
            <div key={o.ORSE_SEC} className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 flex flex-col justify-between space-y-3">
              <div>
                <div className="flex items-center justify-between">
                  <span className="font-bold text-sm text-[#016098]">{o.DOCU_NUMERO}</span>
                  <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold border ${badgePrioridad(o.ORSE_PRIORIDAD)}`}>
                    {o.ORSE_PRIORIDAD}
                  </span>
                </div>
                <p className="text-[11px] font-bold text-slate-500 mt-1 uppercase">{o.MATERIA}</p>
                <p className="text-xs text-slate-700 mt-2">{o.DESCRIPCION}</p>
              </div>
              <div className="pt-3 border-t border-slate-100 flex items-center justify-between text-[11px]">
                <div>
                  <div className="text-slate-400">Responsable:</div>
                  <div className="font-bold text-slate-700">{o.DESTINATARIO}</div>
                </div>
                <div className="text-right">
                  <div className="text-slate-400">Fecha Límite Rpta:</div>
                  <div className="font-bold text-rose-600">{o.FECHA_PLAZO || 'Sin plazo'}</div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Modal Emitir ODS */}
      {showNewModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Emitir Nueva Orden de Servicio (ODS)</h3>
              <button onClick={() => setShowNewModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateOds} className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Folio ODS (Opcional)</label>
                  <input
                    type="text"
                    placeholder="Auto: ODS-2026-0XX"
                    value={newForm.docuNumero}
                    onChange={(e) => setNewForm({ ...newForm, docuNumero: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Prioridad</label>
                  <select
                    value={newForm.prioridad}
                    onChange={(e) => setNewForm({ ...newForm, prioridad: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    <option value="URGENTE">URGENTE</option>
                    <option value="ALTA">ALTA</option>
                    <option value="NORMAL">NORMAL</option>
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Plazo de Respuesta</label>
                  <input
                    type="date"
                    value={newForm.fechaPlazo}
                    onChange={(e) => setNewForm({ ...newForm, fechaPlazo: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Tipo de ODS</label>
                  <select
                    value={newForm.tiosSec}
                    onChange={(e) => setNewForm({ ...newForm, tiosSec: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.tiposOds.map((t: any) => (
                      <option key={t.TIOS_SEC} value={t.TIOS_SEC}>
                        {t.TIOS_NOMBRE}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Materia</label>
                  <select
                    value={newForm.mateSec}
                    onChange={(e) => setNewForm({ ...newForm, mateSec: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.materias.map((m: any) => (
                      <option key={m.MATE_SEC} value={m.MATE_SEC}>
                        {m.MATE_NOMBRE}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">Dirección / Unidad Destinataria</label>
                <select
                  value={newForm.destSec}
                  onChange={(e) => setNewForm({ ...newForm, destSec: Number(e.target.value) })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                >
                  {catalogos.destinatarios.map((d: any) => (
                    <option key={d.DEST_SEC} value={d.DEST_SEC}>
                      {d.DEST_NOMBRE}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">Instrucción / Descripción de la ODS *</label>
                <textarea
                  rows={3}
                  required
                  placeholder="Detalle la instrucción ejecutiva u operativa y los entregables requeridos..."
                  value={newForm.descripcion}
                  onChange={(e) => setNewForm({ ...newForm, descripcion: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowNewModal(false)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#016098] text-white font-bold cursor-pointer"
                >
                  Emitir en PostgreSQL
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal Gestionar ODS */}
      {selectedOds && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-md w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Gestionar {selectedOds.DOCU_NUMERO}</h3>
              <button onClick={() => setSelectedOds(null)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleUpdateEstado} className="p-5 space-y-4 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Nuevo Estado</label>
                <select
                  value={estadoForm.nuevoEstado}
                  onChange={(e) => setEstadoForm({ ...estadoForm, nuevoEstado: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                >
                  <option value="EN GESTION">EN GESTION</option>
                  <option value="DERIVADA">DERIVADA</option>
                  <option value="RESPONDIDA">RESPONDIDA</option>
                  <option value="FINALIZADA">FINALIZADA</option>
                </select>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Unidad Asignada</label>
                <select
                  value={estadoForm.destSec}
                  onChange={(e) => setEstadoForm({ ...estadoForm, destSec: Number(e.target.value) })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                >
                  {catalogos.destinatarios.map((d: any) => (
                    <option key={d.DEST_SEC} value={d.DEST_SEC}>
                      {d.DEST_NOMBRE}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Respuesta / Observación de Cumplimiento</label>
                <textarea
                  rows={3}
                  placeholder="Ingrese el detalle de gestión o respuesta..."
                  value={estadoForm.observacion}
                  onChange={(e) => setEstadoForm({ ...estadoForm, observacion: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setSelectedOds(null)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#39BABD] text-white font-bold cursor-pointer"
                >
                  Guardar Gestión
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
