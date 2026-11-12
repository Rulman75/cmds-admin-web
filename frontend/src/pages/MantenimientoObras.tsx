import React, { useState, useEffect, useCallback } from 'react';

interface OrdenTrabajo {
  ORTR_ID: number;
  ZONA_ID: number;
  ZONA_NUM: number;
  SECTOR_DESC: string;
  CONT_RUT: number;
  CONT_DV: string;
  CONTRATISTA: string;
  UBICACION: string;
  ORTR_MONTO_NETO: number;
  ORTR_IVA: number;
  ORTR_MONTO_BRUTO: number;
  DOEO_ID: number;
  ESTADO_DESC: string;
  DOTO_ID: number;
  TIPO_OT_DESC: string;
  ORTRA_ANIO: number;
  FECHA_CREACION: string;
  FECHA_INICIO: string;
  FECHA_TERMINO: string;
  ORTR_OBS: string;
  ITEMS: any[];
}

export default function MantenimientoObras() {
  const [activeTab, setActiveTab] = useState<'ordenes' | 'preciario' | 'zonas'>('ordenes');
  const [ordenes, setOrdenes] = useState<OrdenTrabajo[]>([]);
  const [catalogos, setCatalogos] = useState<{
    estadosOt: any[];
    tiposOt: any[];
    ubicaciones: any[];
    contratistas: any[];
    zonas: any[];
    itemsServicio: any[];
  }>({
    estadosOt: [],
    tiposOt: [],
    ubicaciones: [],
    contratistas: [],
    zonas: [],
    itemsServicio: []
  });
  const [loading, setLoading] = useState(true);
  const [feedback, setFeedback] = useState<{ type: 'ok' | 'err'; msg: string } | null>(null);

  const [filtroEstado, setFiltroEstado] = useState('');
  const [filtroTipo, setFiltroTipo] = useState('');
  const [search, setSearch] = useState('');

  // Modal Nueva OT
  const [showNewModal, setShowNewModal] = useState(false);
  const [newForm, setNewForm] = useState({
    zonaId: 1,
    dotoId: 1,
    itseId: 101,
    cantidad: 25,
    precioUnitario: 28500,
    fechaInicio: '2026-11-11',
    fechaTermino: '2026-11-22',
    observaciones: ''
  });

  // Modal Actualizar Estado OT
  const [selectedOt, setSelectedOt] = useState<OrdenTrabajo | null>(null);
  const [estadoForm, setEstadoForm] = useState({
    doeoId: 3,
    observacion: ''
  });

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtroEstado) params.set('estado', filtroEstado);
      if (filtroTipo) params.set('tipo', filtroTipo);
      if (search) params.set('search', search);

      const res = await fetch(`/api/obras?${params.toString()}`);
      const json = await res.json();
      if (json.status === 'ok') {
        setOrdenes(json.data || []);
        setCatalogos(
          json.catalogos || {
            estadosOt: [],
            tiposOt: [],
            ubicaciones: [],
            contratistas: [],
            zonas: [],
            itemsServicio: []
          }
        );
      }
    } catch (err) {
      console.error('Error cargando Mantenimiento de Obras:', err);
    } finally {
      setLoading(false);
    }
  }, [filtroEstado, filtroTipo, search]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleCreateOt = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/obras', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewModal(false);
        setNewForm({
          zonaId: 1,
          dotoId: 1,
          itseId: 101,
          cantidad: 25,
          precioUnitario: 28500,
          fechaInicio: '2026-11-11',
          fechaTermino: '2026-11-22',
          observaciones: ''
        });
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleUpdateOt = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedOt) return;
    try {
      const res = await fetch(`/api/obras/${selectedOt.ORTR_ID}/estado`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(estadoForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setSelectedOt(null);
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const totalBruto = ordenes.reduce((acc, o) => acc + Number(o.ORTR_MONTO_BRUTO || 0), 0);
  const enEjecucion = ordenes.filter((o) => Number(o.DOEO_ID) === 2).length;
  const recepcionadas = ordenes.filter((o) => Number(o.DOEO_ID) >= 3).length;

  const badgeOt = (id: number) => {
    if (id >= 3) return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    if (id === 2) return 'bg-amber-100 text-amber-800 border-amber-200';
    return 'bg-blue-100 text-blue-800 border-blue-200';
  };

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#016098] text-white">
              FASE 2 · ADM_OBS.OTR_*
            </span>
            <span className="text-xs text-slate-500 font-medium">PostgreSQL 18 (bd_cmds_admin)</span>
          </div>
          <h1 className="text-xl font-bold text-slate-800 mt-1">
            Mantenimiento de Obras y Órdenes de Trabajo (OT)
          </h1>
          <p className="text-xs text-slate-500">
            Control de contratos de mantención de establecimientos Educacionales y CESFAM por Zona, Contratista y Preciario Oficial (ITSE/ITCO).
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <button
            onClick={() => setShowNewModal(true)}
            className="px-4 py-2 rounded-lg bg-[#016098] hover:bg-[#014b76] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Emitir Orden de Trabajo (OT)
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
          <p className="text-xs text-slate-500 font-semibold uppercase">Órdenes de Trabajo Emitidas</p>
          <p className="text-2xl font-extrabold text-slate-800 mt-1">{ordenes.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.otr_orden_trabajo</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-amber-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">En Ejecución en Terreno</p>
          <p className="text-2xl font-extrabold text-amber-600 mt-1">{enEjecucion}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Supervisión ITO Obras CMDS</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Recepcionadas / Liquidadas</p>
          <p className="text-2xl font-extrabold text-emerald-600 mt-1">{recepcionadas}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Con acta de recepción conforme</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#39BABD]">
          <p className="text-xs text-slate-500 font-semibold uppercase">Monto Bruto Comprometido</p>
          <p className="text-2xl font-extrabold text-[#016098] mt-1">
            ${totalBruto.toLocaleString('es-CL')}
          </p>
          <p className="text-[11px] text-slate-400 mt-0.5">Incluye IVA 19% (OTR_MONTO_BRUTO)</p>
        </div>
      </div>

      {/* Pestañas */}
      <div className="flex flex-wrap gap-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('ordenes')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'ordenes'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Órdenes de Trabajo ({ordenes.length})
        </button>
        <button
          onClick={() => setActiveTab('preciario')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'preciario'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Catálogo de Partidas y Preciario ({catalogos.itemsServicio.length})
        </button>
        <button
          onClick={() => setActiveTab('zonas')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'zonas'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Zonas y Contratistas Adjudicados ({catalogos.zonas.length})
        </button>
      </div>

      {activeTab === 'ordenes' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200 grid grid-cols-1 md:grid-cols-4 gap-3">
            <input
              type="text"
              placeholder="Buscar por N° OT, contratista o descripción de obra..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            />
            <select
              value={filtroTipo}
              onChange={(e) => setFiltroTipo(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Tipos de OT</option>
              {catalogos.tiposOt.map((t: any) => (
                <option key={t.DOTO_ID} value={t.DOTO_ID}>
                  {t.DOTO_DESC}
                </option>
              ))}
            </select>
            <select
              value={filtroEstado}
              onChange={(e) => setFiltroEstado(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Estados</option>
              {catalogos.estadosOt.map((e: any) => (
                <option key={e.DOEO_ID} value={e.DOEO_ID}>
                  {e.DOEO_ESTADO}
                </option>
              ))}
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

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">N° OT</th>
                  <th className="py-3 px-4">Zona / Contratista</th>
                  <th className="py-3 px-3">Tipo Mantención</th>
                  <th className="py-3 px-4">Obra / Especificación</th>
                  <th className="py-3 px-3">Plazo Ejecución</th>
                  <th className="py-3 px-3 text-right">Monto Neto / Bruto</th>
                  <th className="py-3 px-3 text-center">Estado</th>
                  <th className="py-3 px-4 text-center">Acción</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={8} className="py-8 text-center text-slate-400">
                      Cargando Órdenes de Trabajo desde PostgreSQL...
                    </td>
                  </tr>
                ) : (
                  ordenes.map((ot) => (
                    <tr key={ot.ORTR_ID} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-4">
                        <div className="font-bold text-[#016098]">OT #{ot.ORTR_ID}</div>
                        <div className="text-[11px] text-slate-400">Año {ot.ORTRA_ANIO}</div>
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-800">{ot.CONTRATISTA}</div>
                        <div className="text-[11px] text-slate-400">
                          Zona {ot.ZONA_NUM} ({ot.UBICACION})
                        </div>
                      </td>
                      <td className="py-3 px-3">
                        <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700 font-semibold text-[11px]">
                          {ot.TIPO_OT_DESC}
                        </span>
                      </td>
                      <td className="py-3 px-4 max-w-sm">
                        <div className="font-medium text-slate-800">{ot.ORTR_OBS}</div>
                        {ot.ITEMS && ot.ITEMS.length > 0 && (
                          <div className="text-[11px] text-[#016098] mt-0.5 font-semibold">
                            Partida: {ot.ITEMS[0].ITSE_CODIGO} — {ot.ITEMS[0].ITSE_NOMBRE} ({ot.ITEMS[0].ORTD_CANTIDAD}{' '}
                            {ot.ITEMS[0].ITSE_UNIDAD})
                          </div>
                        )}
                      </td>
                      <td className="py-3 px-3 whitespace-nowrap text-slate-600">
                        <div>Ini: {ot.FECHA_INICIO}</div>
                        <div>Tér: {ot.FECHA_TERMINO}</div>
                      </td>
                      <td className="py-3 px-3 text-right whitespace-nowrap">
                        <div className="font-bold text-slate-800">
                          ${Number(ot.ORTR_MONTO_BRUTO).toLocaleString('es-CL')}
                        </div>
                        <div className="text-[10px] text-slate-400">
                          Neto: ${Number(ot.ORTR_MONTO_NETO).toLocaleString('es-CL')}
                        </div>
                      </td>
                      <td className="py-3 px-3 text-center">
                        <span
                          className={`inline-block px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${badgeOt(
                            Number(ot.DOEO_ID)
                          )}`}
                        >
                          {ot.ESTADO_DESC}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-center">
                        <button
                          onClick={() => {
                            setSelectedOt(ot);
                            setEstadoForm({
                              doeoId: Number(ot.DOEO_ID) < 3 ? Number(ot.DOEO_ID) + 1 : 4,
                              observacion: ''
                            });
                          }}
                          className="px-2.5 py-1 rounded-md bg-[#39BABD] hover:bg-[#2da3a6] text-white text-[11px] font-bold transition-colors cursor-pointer"
                        >
                          Actualizar Estado
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

      {activeTab === 'preciario' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200">
            <h3 className="text-sm font-bold text-slate-800">
              Catálogo de Ítems y Preciario Oficial (OTR_ITEM_SERVICIO / OTR_ITEMS_CONTRATISTA)
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">Código</th>
                  <th className="py-3 px-4">Partida / Servicio</th>
                  <th className="py-3 px-4">Especificación Técnica</th>
                  <th className="py-3 px-3 text-center">Unidad</th>
                  <th className="py-3 px-4 text-right">Precio Unitario Neto</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {catalogos.itemsServicio.map((it: any) => (
                  <tr key={it.ITSE_ID} className="hover:bg-slate-50">
                    <td className="py-2.5 px-4 font-mono font-bold text-[#016098]">{it.ITSE_CODIGO}</td>
                    <td className="py-2.5 px-4 font-semibold text-slate-800">{it.ITSE_NOMBRE}</td>
                    <td className="py-2.5 px-4 text-slate-600">{it.ITSE_DESC}</td>
                    <td className="py-2.5 px-3 text-center font-bold">{it.ITSE_UNIDAD}</td>
                    <td className="py-2.5 px-4 text-right font-bold text-slate-800">
                      ${Number(it.PRECIO_UNITARIO).toLocaleString('es-CL')}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'zonas' && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {catalogos.zonas.map((z: any) => (
            <div key={z.ZONA_ID} className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 space-y-2">
              <div className="flex items-center justify-between">
                <span className="font-bold text-sm text-[#016098]">
                  Zona #{z.ZONA_NUM} — {z.UBICACION}
                </span>
                <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-blue-100 text-blue-800">
                  Año {z.ZONA_ANIO}
                </span>
              </div>
              <p className="text-xs font-semibold text-slate-800">Contratista: {z.CONTRATISTA}</p>
              <p className="text-xs text-slate-500">RUT Contratista: {z.CONT_RUT}</p>
              <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-xs">
                <span className="text-slate-500">Marco Presupuestario Bruto:</span>
                <span className="font-extrabold text-emerald-700">
                  ${Number(z.ZONA_MONTO_BRUTO).toLocaleString('es-CL')}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Modal Emitir OT */}
      {showNewModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Emitir Nueva Orden de Trabajo (OT)</h3>
              <button onClick={() => setShowNewModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateOt} className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Zona y Contratista Adjudicado</label>
                  <select
                    value={newForm.zonaId}
                    onChange={(e) => setNewForm({ ...newForm, zonaId: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.zonas.map((z: any) => (
                      <option key={z.ZONA_ID} value={z.ZONA_ID}>
                        Zona {z.ZONA_NUM} ({z.UBICACION}) — {z.CONTRATISTA}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Tipo de Orden de Trabajo</label>
                  <select
                    value={newForm.dotoId}
                    onChange={(e) => setNewForm({ ...newForm, dotoId: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.tiposOt.map((t: any) => (
                      <option key={t.DOTO_ID} value={t.DOTO_ID}>
                        {t.DOTO_DESC}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 bg-slate-50 p-3 rounded-lg border border-slate-200">
                <div className="sm:col-span-2">
                  <label className="block font-bold text-slate-700 mb-1">Partida del Preciario (ITSE)</label>
                  <select
                    value={newForm.itseId}
                    onChange={(e) => {
                      const id = Number(e.target.value);
                      const found = catalogos.itemsServicio.find((i: any) => Number(i.ITSE_ID) === id);
                      setNewForm({
                        ...newForm,
                        itseId: id,
                        precioUnitario: found ? Number(found.PRECIO_UNITARIO) : newForm.precioUnitario
                      });
                    }}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  >
                    {catalogos.itemsServicio.map((it: any) => (
                      <option key={it.ITSE_ID} value={it.ITSE_ID}>
                        {it.ITSE_CODIGO} — {it.ITSE_NOMBRE} (${Number(it.PRECIO_UNITARIO).toLocaleString('es-CL')}/{it.ITSE_UNIDAD})
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Cantidad</label>
                  <input
                    type="number"
                    min={1}
                    value={newForm.cantidad}
                    onChange={(e) => setNewForm({ ...newForm, cantidad: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300 bg-white"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Fecha Inicio Obras</label>
                  <input
                    type="date"
                    value={newForm.fechaInicio}
                    onChange={(e) => setNewForm({ ...newForm, fechaInicio: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Fecha Término Estimada</label>
                  <input
                    type="date"
                    value={newForm.fechaTermino}
                    onChange={(e) => setNewForm({ ...newForm, fechaTermino: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">
                  Establecimiento y Descripción de Trabajos *
                </label>
                <textarea
                  rows={3}
                  required
                  placeholder="Indique establecimiento (Liceo/Escuela/CESFAM) y detalle técnico de los trabajos..."
                  value={newForm.observaciones}
                  onChange={(e) => setNewForm({ ...newForm, observaciones: e.target.value })}
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
                  Emitir OT en PostgreSQL
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal Estado OT */}
      {selectedOt && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-md w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Actualizar Estado OT #{selectedOt.ORTR_ID}</h3>
              <button onClick={() => setSelectedOt(null)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleUpdateOt} className="p-5 space-y-4 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Nuevo Estado OT</label>
                <select
                  value={estadoForm.doeoId}
                  onChange={(e) => setEstadoForm({ ...estadoForm, doeoId: Number(e.target.value) })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                >
                  {catalogos.estadosOt.map((est: any) => (
                    <option key={est.DOEO_ID} value={est.DOEO_ID}>
                      {est.DOEO_ESTADO}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Observación ITO / Recepción</label>
                <textarea
                  rows={3}
                  placeholder="Ej: Recepción provisoria conforme sin observaciones..."
                  value={estadoForm.observacion}
                  onChange={(e) => setEstadoForm({ ...estadoForm, observacion: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setSelectedOt(null)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#39BABD] text-white font-bold cursor-pointer"
                >
                  Guardar Estado
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
