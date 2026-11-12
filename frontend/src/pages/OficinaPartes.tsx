import React, { useState, useEffect, useCallback } from 'react';

interface DocumentoOpa {
  DOCU_SEC: number;
  DOCU_ORDEN: number;
  DOCU_NRO: string;
  FECHA_DOC: string;
  DOCU_MATERIA: string;
  DOCU_TIPO_DOCU: string;
  TIPO_DESC: string;
  DOCU_ULT_ESTADO: string;
  DOCU_REMI_SEC: number;
  REMITENTE: string;
  REMITENTE_RUT: string;
  DOCU_OBS: string;
  DOCU_REMI_TIPO: string;
  FECHA_ING: string;
  VALO_NETO: number;
  VALO_IVA: number;
  VALO_TOTAL: number;
  VALO_IND_OC: string;
  VALO_OC: string;
  DEST_SEC: number;
  DESTINATARIO: string;
  DESTINATARIO_AREA: string;
  FECHA_PLAZO: string;
}

export default function OficinaPartes() {
  const [activeTab, setActiveTab] = useState<'bandeja' | 'trazabilidad' | 'catalogos'>('bandeja');
  const [documentos, setDocumentos] = useState<DocumentoOpa[]>([]);
  const [movimientos, setMovimientos] = useState<any[]>([]);
  const [catalogos, setCatalogos] = useState<{
    tiposDocumento: any[];
    remitentes: any[];
    destinatarios: any[];
  }>({ tiposDocumento: [], remitentes: [], destinatarios: [] });
  const [loading, setLoading] = useState(true);
  const [feedback, setFeedback] = useState<{ type: 'ok' | 'err'; msg: string } | null>(null);

  // Filtros
  const [filtroEstado, setFiltroEstado] = useState('');
  const [filtroTipo, setFiltroTipo] = useState('');
  const [search, setSearch] = useState('');

  // Modal Nuevo Documento
  const [showNewModal, setShowNewModal] = useState(false);
  const [newForm, setNewForm] = useState({
    docuNro: '',
    docuFecha: new Date().toISOString().slice(0, 10),
    docuTipoDocu: 'OFIC',
    docuRemiSec: 101,
    destSec: 203,
    docuMateria: '',
    docuObs: '',
    valoNeto: '',
    valoOc: ''
  });

  // Modal Derivar / Estado
  const [selectedDoc, setSelectedDoc] = useState<DocumentoOpa | null>(null);
  const [derivarForm, setDerivarForm] = useState({
    nuevoEstado: 'RECEPCIONADO',
    destSec: 201,
    observacion: ''
  });

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtroEstado) params.set('estado', filtroEstado);
      if (filtroTipo) params.set('tipo', filtroTipo);
      if (search) params.set('search', search);

      const res = await fetch(`/api/oficina-partes?${params.toString()}`);
      const json = await res.json();
      if (json.status === 'ok') {
        setDocumentos(json.data || []);
        setMovimientos(json.movimientos || []);
        setCatalogos(json.catalogos || { tiposDocumento: [], remitentes: [], destinatarios: [] });
      }
    } catch (err) {
      console.error('Error cargando Oficina de Partes:', err);
    } finally {
      setLoading(false);
    }
  }, [filtroEstado, filtroTipo, search]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleCreateDoc = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/oficina-partes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...newForm,
          valoNeto: Number(newForm.valoNeto || 0)
        })
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewModal(false);
        setNewForm({
          docuNro: '',
          docuFecha: new Date().toISOString().slice(0, 10),
          docuTipoDocu: 'OFIC',
          docuRemiSec: 101,
          destSec: 203,
          docuMateria: '',
          docuObs: '',
          valoNeto: '',
          valoOc: ''
        });
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message || 'Error al registrar documento' });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleDerivar = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedDoc) return;
    try {
      const res = await fetch(`/api/oficina-partes/${selectedDoc.DOCU_SEC}/derivar`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(derivarForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setSelectedDoc(null);
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message || 'Error al derivar documento' });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const totalValorado = documentos.reduce((acc, d) => acc + Number(d.VALO_TOTAL || 0), 0);
  const totalRecepcionados = documentos.filter((d) => d.DOCU_ULT_ESTADO === 'RECEPCIONADO').length;
  const totalEnCurso = documentos.filter((d) => d.DOCU_ULT_ESTADO !== 'RECEPCIONADO').length;

  const badgeEstado = (est: string) => {
    const u = (est || '').toUpperCase();
    if (u.includes('RECEPCION')) return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    if (u.includes('DISTRIB') || u.includes('DERIV')) return 'bg-amber-100 text-amber-800 border-amber-200';
    return 'bg-blue-100 text-blue-800 border-blue-200';
  };

  return (
    <div className="space-y-6">
      {/* Encabezado */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#016098] text-white">
              FASE 2 · ADM_OBS.OPA_*
            </span>
            <span className="text-xs text-slate-500 font-medium">
              PostgreSQL 18 (bd_cmds_admin)
            </span>
          </div>
          <h1 className="text-xl font-bold text-slate-800 mt-1">
            Oficina de Partes y Gestión Documental Valorada
          </h1>
          <p className="text-xs text-slate-500">
            Registro de correspondencia oficial, facturas/documentos valorados (OPA_VALORADOS) y flujo de derivación entre Direcciones CMDS.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <button
            onClick={() => setShowNewModal(true)}
            className="px-4 py-2 rounded-lg bg-[#016098] hover:bg-[#014b76] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Ingresar Documento
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
          <p className="text-xs text-slate-500 font-semibold uppercase">Documentos Registrados</p>
          <p className="text-2xl font-extrabold text-slate-800 mt-1">{documentos.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.opa_documentos</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-amber-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">En Distribución / Derivados</p>
          <p className="text-2xl font-extrabold text-amber-600 mt-1">{totalEnCurso}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Pendientes de acuse final</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Recepcionados Conforme</p>
          <p className="text-2xl font-extrabold text-emerald-600 mt-1">{totalRecepcionados}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Flujo completado en destino</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#39BABD]">
          <p className="text-xs text-slate-500 font-semibold uppercase">Total Documentos Valorados</p>
          <p className="text-2xl font-extrabold text-[#016098] mt-1">
            ${totalValorado.toLocaleString('es-CL')}
          </p>
          <p className="text-[11px] text-slate-400 mt-0.5">Facturas, Resoluciones y Decretos</p>
        </div>
      </div>

      {/* Pestañas */}
      <div className="flex flex-wrap gap-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('bandeja')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'bandeja'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Bandeja de Documentos ({documentos.length})
        </button>
        <button
          onClick={() => setActiveTab('trazabilidad')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'trazabilidad'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Bitácora de Derivaciones ({movimientos.length})
        </button>
        <button
          onClick={() => setActiveTab('catalogos')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'catalogos'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Remitentes ({catalogos.remitentes.length}) y Destinatarios ({catalogos.destinatarios.length})
        </button>
      </div>

      {activeTab === 'bandeja' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          {/* Barra de Filtros */}
          <div className="p-4 bg-slate-50 border-b border-slate-200 grid grid-cols-1 md:grid-cols-4 gap-3">
            <input
              type="text"
              placeholder="Buscar por N° doc, folio, materia o remitente..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-none focus:border-[#016098] bg-white"
            />
            <select
              value={filtroTipo}
              onChange={(e) => setFiltroTipo(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Tipos de Documento</option>
              {catalogos.tiposDocumento.map((t: any) => (
                <option key={t.TIDO_SEC} value={t.TIDO_TIPO_DOCU}>
                  {t.TIDO_TIPO_DOCU} — {t.TIDO_DESC_DOCU}
                </option>
              ))}
            </select>
            <select
              value={filtroEstado}
              onChange={(e) => setFiltroEstado(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Estados</option>
              <option value="INGRESADO">INGRESADO</option>
              <option value="EN DISTRIBUCION">EN DISTRIBUCION</option>
              <option value="DERIVADO">DERIVADO</option>
              <option value="RECEPCIONADO">RECEPCIONADO</option>
            </select>
            <button
              onClick={() => {
                setFiltroEstado('');
                setFiltroTipo('');
                setSearch('');
              }}
              className="px-3 py-2 rounded-lg border border-slate-300 bg-white hover:bg-slate-100 text-xs font-semibold text-slate-600 cursor-pointer"
            >
              Limpiar Filtros
            </button>
          </div>

          {/* Tabla de Documentos */}
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">Folio / N° Doc</th>
                  <th className="py-3 px-3">Fecha</th>
                  <th className="py-3 px-3">Tipo</th>
                  <th className="py-3 px-4">Remitente</th>
                  <th className="py-3 px-4">Materia / Glosa</th>
                  <th className="py-3 px-4">Destinatario Actual</th>
                  <th className="py-3 px-3 text-right">Monto Valorado</th>
                  <th className="py-3 px-3 text-center">Estado</th>
                  <th className="py-3 px-4 text-center">Acción</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={9} className="py-8 text-center text-slate-400">
                      Cargando documentos desde PostgreSQL...
                    </td>
                  </tr>
                ) : documentos.length === 0 ? (
                  <tr>
                    <td colSpan={9} className="py-8 text-center text-slate-400">
                      No se encontraron documentos con los filtros seleccionados.
                    </td>
                  </tr>
                ) : (
                  documentos.map((d) => (
                    <tr key={d.DOCU_SEC} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-4">
                        <div className="font-bold text-[#016098]">#{d.DOCU_ORDEN}</div>
                        <div className="text-[11px] font-mono text-slate-600">{d.DOCU_NRO}</div>
                      </td>
                      <td className="py-3 px-3 whitespace-nowrap text-slate-600">{d.FECHA_DOC}</td>
                      <td className="py-3 px-3">
                        <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700 font-semibold text-[11px]">
                          {d.TIPO_DESC}
                        </span>
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-800">{d.REMITENTE}</div>
                        <div className="text-[11px] text-slate-400">
                          RUT: {d.REMITENTE_RUT} · {d.DOCU_REMI_TIPO}
                        </div>
                      </td>
                      <td className="py-3 px-4 max-w-xs">
                        <div className="font-medium text-slate-800 line-clamp-2">{d.DOCU_MATERIA}</div>
                        {d.DOCU_OBS && <div className="text-[11px] text-slate-400 mt-0.5">{d.DOCU_OBS}</div>}
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-700">{d.DESTINATARIO}</div>
                        <div className="text-[11px] text-slate-400">Plazo: {d.FECHA_PLAZO || '—'}</div>
                      </td>
                      <td className="py-3 px-3 text-right whitespace-nowrap">
                        {Number(d.VALO_TOTAL) > 0 ? (
                          <div>
                            <div className="font-bold text-slate-800">
                              ${Number(d.VALO_TOTAL).toLocaleString('es-CL')}
                            </div>
                            {d.VALO_OC && (
                              <div className="text-[10px] font-mono text-[#016098]">OC: {d.VALO_OC}</div>
                            )}
                          </div>
                        ) : (
                          <span className="text-slate-400">No valorado</span>
                        )}
                      </td>
                      <td className="py-3 px-3 text-center">
                        <span
                          className={`inline-block px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${badgeEstado(
                            d.DOCU_ULT_ESTADO
                          )}`}
                        >
                          {d.DOCU_ULT_ESTADO}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-center">
                        <button
                          onClick={() => {
                            setSelectedDoc(d);
                            setDerivarForm({
                              nuevoEstado: d.DOCU_ULT_ESTADO === 'RECEPCIONADO' ? 'DERIVADO' : 'RECEPCIONADO',
                              destSec: d.DEST_SEC || 201,
                              observacion: ''
                            });
                          }}
                          className="px-2.5 py-1 rounded-md bg-[#39BABD] hover:bg-[#2da3a6] text-white text-[11px] font-bold transition-colors cursor-pointer"
                        >
                          Derivar / Recepcionar
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

      {activeTab === 'trazabilidad' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200">
            <h3 className="text-sm font-bold text-slate-800">
              Historial de Movimientos y Derivaciones (adm_obs.opa_mov_documentos)
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">ID Mov</th>
                  <th className="py-3 px-4">ID Doc</th>
                  <th className="py-3 px-4">Tipo Flujo</th>
                  <th className="py-3 px-4">Estado</th>
                  <th className="py-3 px-4">Unidad / Destinatario</th>
                  <th className="py-3 px-4">Observación</th>
                  <th className="py-3 px-4">Fecha / Usuario</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {movimientos.map((m) => (
                  <tr key={m.MODO_SEC} className="hover:bg-slate-50">
                    <td className="py-2.5 px-4 font-mono font-bold text-slate-700">#{m.MODO_SEC}</td>
                    <td className="py-2.5 px-4 font-bold text-[#016098]">Doc #{m.DOCU_SEC}</td>
                    <td className="py-2.5 px-4">{m.MODO_TIPO_FLUJO}</td>
                    <td className="py-2.5 px-4">
                      <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold border ${badgeEstado(m.MODO_ESTADO)}`}>
                        {m.MODO_ESTADO}
                      </span>
                    </td>
                    <td className="py-2.5 px-4 font-semibold text-slate-700">{m.DESTINATARIO}</td>
                    <td className="py-2.5 px-4 text-slate-600">{m.MODO_OBS}</td>
                    <td className="py-2.5 px-4 text-slate-500">
                      {m.FECHA_MOV} · {m.MODO_USER_ING}
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
              <h3 className="text-sm font-bold text-slate-800">Remitentes Registrados (OPA_REMITENTES)</h3>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-xs">
                <thead>
                  <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                    <th className="py-2.5 px-3">RUT</th>
                    <th className="py-2.5 px-3">Razón Social</th>
                    <th className="py-2.5 px-3">Tipo</th>
                    <th className="py-2.5 px-3">Contacto</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {catalogos.remitentes.map((r: any) => (
                    <tr key={r.REMI_SEC} className="hover:bg-slate-50">
                      <td className="py-2.5 px-3 font-mono">
                        {r.REMI_RUT}-{r.REMI_DV}
                      </td>
                      <td className="py-2.5 px-3 font-semibold text-slate-800">{r.REMI_RAZON_SOCIAL}</td>
                      <td className="py-2.5 px-3">{r.REMI_TIPO}</td>
                      <td className="py-2.5 px-3 text-slate-500">{r.REMI_MAIL}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="p-4 bg-slate-50 border-b border-slate-200">
              <h3 className="text-sm font-bold text-slate-800">Destinatarios Oficiales CMDS (OPA_DESTINATARIOS)</h3>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-xs">
                <thead>
                  <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                    <th className="py-2.5 px-3">ID</th>
                    <th className="py-2.5 px-3">Dirección / Jefatura</th>
                    <th className="py-2.5 px-3">Área</th>
                    <th className="py-2.5 px-3">Correo</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {catalogos.destinatarios.map((d: any) => (
                    <tr key={d.DEST_SEC} className="hover:bg-slate-50">
                      <td className="py-2.5 px-3 font-mono">#{d.DEST_SEC}</td>
                      <td className="py-2.5 px-3 font-semibold text-slate-800">{d.DEST_NOMBRE}</td>
                      <td className="py-2.5 px-3">{d.DEST_AREA}</td>
                      <td className="py-2.5 px-3 text-slate-500">{d.DEST_MAIL}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* Modal Nuevo Documento */}
      {showNewModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Ingresar Nuevo Documento en Oficina de Partes</h3>
              <button onClick={() => setShowNewModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateDoc} className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">N° Documento *</label>
                  <input
                    type="text"
                    required
                    placeholder="Ej: OF-1580/2026 o FE-9102"
                    value={newForm.docuNro}
                    onChange={(e) => setNewForm({ ...newForm, docuNro: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Fecha Documento</label>
                  <input
                    type="date"
                    value={newForm.docuFecha}
                    onChange={(e) => setNewForm({ ...newForm, docuFecha: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Tipo Documento</label>
                  <select
                    value={newForm.docuTipoDocu}
                    onChange={(e) => setNewForm({ ...newForm, docuTipoDocu: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.tiposDocumento.map((t: any) => (
                      <option key={t.TIDO_SEC} value={t.TIDO_TIPO_DOCU}>
                        {t.TIDO_DESC_DOCU}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Remitente</label>
                  <select
                    value={newForm.docuRemiSec}
                    onChange={(e) => setNewForm({ ...newForm, docuRemiSec: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.remitentes.map((r: any) => (
                      <option key={r.REMI_SEC} value={r.REMI_SEC}>
                        {r.REMI_RAZON_SOCIAL}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Destinatario Inicial CMDS</label>
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
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">Materia / Asunto *</label>
                <textarea
                  rows={2}
                  required
                  placeholder="Descripción oficial de la materia del documento..."
                  value={newForm.docuMateria}
                  onChange={(e) => setNewForm({ ...newForm, docuMateria: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 bg-slate-50 p-3 rounded-lg border border-slate-200">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">
                    Monto Neto $ (Opcional si es Valorado)
                  </label>
                  <input
                    type="number"
                    placeholder="0"
                    value={newForm.valoNeto}
                    onChange={(e) => setNewForm({ ...newForm, valoNeto: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Orden de Compra Asociada (Opcional)</label>
                  <input
                    type="text"
                    placeholder="Ej: 1111614-102-CM26"
                    value={newForm.valoOc}
                    onChange={(e) => setNewForm({ ...newForm, valoOc: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  />
                </div>
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
                  Guardar en PostgreSQL
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal Derivar / Recepcionar */}
      {selectedDoc && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-md w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">
                Derivar / Actualizar Documento #{selectedDoc.DOCU_ORDEN} ({selectedDoc.DOCU_NRO})
              </h3>
              <button onClick={() => setSelectedDoc(null)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleDerivar} className="p-5 space-y-4 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Nuevo Estado</label>
                <select
                  value={derivarForm.nuevoEstado}
                  onChange={(e) => setDerivarForm({ ...derivarForm, nuevoEstado: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                >
                  <option value="RECEPCIONADO">RECEPCIONADO CONFORME</option>
                  <option value="DERIVADO">DERIVADO A OTRA UNIDAD</option>
                  <option value="EN DISTRIBUCION">EN DISTRIBUCION</option>
                </select>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Unidad Destinataria</label>
                <select
                  value={derivarForm.destSec}
                  onChange={(e) => setDerivarForm({ ...derivarForm, destSec: Number(e.target.value) })}
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
                <label className="block font-bold text-slate-700 mb-1">Observación / Providencia</label>
                <textarea
                  rows={3}
                  placeholder="Indique instrucciones de derivación o acuse de recibo..."
                  value={derivarForm.observacion}
                  onChange={(e) => setDerivarForm({ ...derivarForm, observacion: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setSelectedDoc(null)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#39BABD] text-white font-bold cursor-pointer"
                >
                  Confirmar Cambio
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
