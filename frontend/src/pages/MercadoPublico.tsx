import React, { useState, useEffect, useCallback } from 'react';

interface OrdenCompraMpu {
  ORCA_SEC_ID: number;
  ORCA_COD_OC: string;
  ORCA_NOMBRE: string;
  DMEO_COD_ESTADO: number;
  ESTADO_OC_DESC: string;
  ORCA_CODIGO_LICITACION: string;
  ORCA_DESC_OC: string;
  DMTO_TIPO_OC: string;
  TIPO_OC_DESC: string;
  DMTM_TIPO_MONEDA: string;
  FECHA_CREACION: string;
  FECHA_ENVIO: string;
  ORCA_TOTAL_NETO: number;
  ORCA_IVA: number;
  ORCA_TOTAL_OC: number;
  ORCA_FINANCIAMIENTO: string;
  PROV_COD: string;
  PROVEEDOR: string;
  GIRO_PROVEEDOR: string;
  RUT_PROVEEDOR: string;
  DIRECCION_PROVEEDOR: string;
  MAIL_PROVEEDOR: string;
  ORCA_TOTAL_ITEMS: number;
  ITEMS: any[];
}

export default function MercadoPublico() {
  const [activeTab, setActiveTab] = useState<'ordenes' | 'reprocesos' | 'proveedores'>('ordenes');
  const [ordenes, setOrdenes] = useState<OrdenCompraMpu[]>([]);
  const [reprocesos, setReprocesos] = useState<any[]>([]);
  const [catalogos, setCatalogos] = useState<{
    estadosOc: any[];
    tiposOc: any[];
    proveedores: any[];
  }>({ estadosOc: [], tiposOc: [], proveedores: [] });
  const [loading, setLoading] = useState(true);
  const [feedback, setFeedback] = useState<{ type: 'ok' | 'err'; msg: string } | null>(null);

  const [filtroEstado, setFiltroEstado] = useState('');
  const [filtroTipo, setFiltroTipo] = useState('');
  const [search, setSearch] = useState('');

  const [selectedOc, setSelectedOc] = useState<OrdenCompraMpu | null>(null);
  const [codOcSync, setCodOcSync] = useState('');

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtroEstado) params.set('estado', filtroEstado);
      if (filtroTipo) params.set('tipo', filtroTipo);
      if (search) params.set('search', search);

      const res = await fetch(`/api/mercado-publico?${params.toString()}`);
      const json = await res.json();
      if (json.status === 'ok') {
        setOrdenes(json.data || []);
        setReprocesos(json.reprocesos || []);
        setCatalogos(json.catalogos || { estadosOc: [], tiposOc: [], proveedores: [] });
      }
    } catch (err) {
      console.error('Error cargando Mercado Público:', err);
    } finally {
      setLoading(false);
    }
  }, [filtroEstado, filtroTipo, search]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleSyncOc = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!codOcSync.trim()) return;
    try {
      const res = await fetch('/api/mercado-publico/reprocesar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ codOc: codOcSync })
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setCodOcSync('');
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleRecepcionarOc = async (oc: OrdenCompraMpu) => {
    try {
      const res = await fetch(`/api/mercado-publico/${oc.ORCA_SEC_ID}/estado`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ dmeoCodEstado: 12, estadoDesc: 'RECEPCION CONFORME' })
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setSelectedOc(null);
        fetchData();
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const totalAdjudicado = ordenes.reduce((acc, o) => acc + Number(o.ORCA_TOTAL_OC || 0), 0);
  const aceptadas = ordenes.filter((o) => [6, 12].includes(Number(o.DMEO_COD_ESTADO))).length;

  const badgeEstadoOc = (cod: number) => {
    if (cod === 12) return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    if (cod === 6) return 'bg-blue-100 text-blue-800 border-blue-200';
    if (cod === 9) return 'bg-rose-100 text-rose-800 border-rose-200';
    return 'bg-amber-100 text-amber-800 border-amber-200';
  };

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#016098] text-white">
              FASE 2 · ADM_OBS.MPU_*
            </span>
            <span className="text-xs text-slate-500 font-medium">
              Comprador ChileCompra #1111614 · PostgreSQL 18
            </span>
          </div>
          <h1 className="text-xl font-bold text-slate-800 mt-1">
            Integración Mercado Público y Órdenes de Compra (OC)
          </h1>
          <p className="text-xs text-slate-500">
            Consulta de cabeceras y líneas de detalle de Órdenes de Compra (MPU_ORDENES_CAB / DET), proveedores adjudicados y sincronización API.
          </p>
        </div>

        <form onSubmit={handleSyncOc} className="flex items-center gap-2">
          <input
            type="text"
            placeholder="Código OC (ej: 1111614-109-CM26)"
            value={codOcSync}
            onChange={(e) => setCodOcSync(e.target.value)}
            className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white w-52"
          />
          <button
            type="submit"
            className="px-3.5 py-2 rounded-lg bg-[#016098] hover:bg-[#014b76] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer whitespace-nowrap"
          >
            Sincronizar / Reprocesar OC
          </button>
        </form>
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
          <p className="text-xs text-slate-500 font-semibold uppercase">Órdenes de Compra</p>
          <p className="text-2xl font-extrabold text-slate-800 mt-1">{ordenes.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.mpu_ordenes_cab</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Aceptadas / Recepción Conforme</p>
          <p className="text-2xl font-extrabold text-emerald-600 mt-1">{aceptadas}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Habilitadas para devengo DAF</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-amber-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Proveedores Adjudicados</p>
          <p className="text-2xl font-extrabold text-amber-600 mt-1">{catalogos.proveedores.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.mpu_proveedores</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#39BABD]">
          <p className="text-xs text-slate-500 font-semibold uppercase">Monto Total Adquisiciones</p>
          <p className="text-2xl font-extrabold text-[#016098] mt-1">
            ${totalAdjudicado.toLocaleString('es-CL')}
          </p>
          <p className="text-[11px] text-slate-400 mt-0.5">Total Bruto OC (IVA incluido)</p>
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
          Listado de Órdenes de Compra ({ordenes.length})
        </button>
        <button
          onClick={() => setActiveTab('reprocesos')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'reprocesos'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Bandeja de Sincronización y Reprocesos API ({reprocesos.length})
        </button>
        <button
          onClick={() => setActiveTab('proveedores')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'proveedores'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Proveedores Registrados ({catalogos.proveedores.length})
        </button>
      </div>

      {activeTab === 'ordenes' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200 grid grid-cols-1 md:grid-cols-4 gap-3">
            <input
              type="text"
              placeholder="Buscar por código OC, nombre, proveedor o licitación..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            />
            <select
              value={filtroTipo}
              onChange={(e) => setFiltroTipo(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todas las Modalidades (SE, CM, LE, AG, TD)</option>
              {catalogos.tiposOc.map((t: any) => (
                <option key={t.DMTO_TIPO_OC} value={t.DMTO_TIPO_OC}>
                  {t.DMTO_TIPO_OC} — {t.DMTO_DESC}
                </option>
              ))}
            </select>
            <select
              value={filtroEstado}
              onChange={(e) => setFiltroEstado(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Estados OC</option>
              {catalogos.estadosOc.map((e: any) => (
                <option key={e.DMEO_COD_ESTADO} value={e.DMEO_COD_ESTADO}>
                  {e.DMEO_DESC}
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
                  <th className="py-3 px-4">Código OC / Licitación</th>
                  <th className="py-3 px-3">Tipo</th>
                  <th className="py-3 px-4">Nombre Adquisición</th>
                  <th className="py-3 px-4">Proveedor Adjudicado</th>
                  <th className="py-3 px-3">Financiamiento</th>
                  <th className="py-3 px-3 text-right">Monto Total OC</th>
                  <th className="py-3 px-3 text-center">Estado</th>
                  <th className="py-3 px-4 text-center">Acción</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={8} className="py-8 text-center text-slate-400">
                      Cargando Órdenes de Compra desde PostgreSQL...
                    </td>
                  </tr>
                ) : (
                  ordenes.map((oc) => (
                    <tr key={oc.ORCA_SEC_ID} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-4">
                        <div className="font-mono font-bold text-[#016098]">{oc.ORCA_COD_OC}</div>
                        <div className="text-[11px] text-slate-400">
                          {oc.ORCA_CODIGO_LICITACION || 'Directa'} · {oc.FECHA_CREACION}
                        </div>
                      </td>
                      <td className="py-3 px-3">
                        <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700 font-bold text-[11px]">
                          {oc.DMTO_TIPO_OC}
                        </span>
                      </td>
                      <td className="py-3 px-4 max-w-xs">
                        <div className="font-semibold text-slate-800">{oc.ORCA_NOMBRE}</div>
                        <div className="text-[11px] text-slate-400 line-clamp-1">{oc.ORCA_DESC_OC}</div>
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-800">{oc.PROVEEDOR}</div>
                        <div className="text-[11px] text-slate-400">RUT: {oc.RUT_PROVEEDOR}</div>
                      </td>
                      <td className="py-3 px-3 text-slate-600 font-medium">{oc.ORCA_FINANCIAMIENTO}</td>
                      <td className="py-3 px-3 text-right whitespace-nowrap">
                        <div className="font-extrabold text-slate-800">
                          ${Number(oc.ORCA_TOTAL_OC).toLocaleString('es-CL')}
                        </div>
                        <div className="text-[10px] text-slate-400">
                          Neto: ${Number(oc.ORCA_TOTAL_NETO).toLocaleString('es-CL')}
                        </div>
                      </td>
                      <td className="py-3 px-3 text-center">
                        <span
                          className={`inline-block px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${badgeEstadoOc(
                            Number(oc.DMEO_COD_ESTADO)
                          )}`}
                        >
                          {oc.ESTADO_OC_DESC}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-center">
                        <button
                          onClick={() => setSelectedOc(oc)}
                          className="px-2.5 py-1 rounded-md bg-[#39BABD] hover:bg-[#2da3a6] text-white text-[11px] font-bold transition-colors cursor-pointer"
                        >
                          Ver Ficha / Ítems
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

      {activeTab === 'reprocesos' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200">
            <h3 className="text-sm font-bold text-slate-800">
              Bitácora de Sincronización y Reprocesamiento API ChileCompra (MPU_REPROCESOS)
            </h3>
          </div>
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                <th className="py-3 px-4">ID Proceso</th>
                <th className="py-3 px-4">Orden de Compra (Pauta)</th>
                <th className="py-3 px-4">Fecha Solicitud</th>
                <th className="py-3 px-4">Fecha Retoma / Sincronización</th>
                <th className="py-3 px-4">Estado</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {reprocesos.map((r: any) => (
                <tr key={r.REPR_SEC_ID} className="hover:bg-slate-50">
                  <td className="py-2.5 px-4 font-mono">#{r.REPR_SEC_PROC}</td>
                  <td className="py-2.5 px-4 font-mono font-bold text-[#016098]">{r.REPR_PAUTA}</td>
                  <td className="py-2.5 px-4 text-slate-600">{r.FECHA_SOLICITUD}</td>
                  <td className="py-2.5 px-4 text-slate-600">{r.FECHA_RETOMA || '—'}</td>
                  <td className="py-2.5 px-4 font-bold text-emerald-700">{r.REPR_ESTADO}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {activeTab === 'proveedores' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200">
            <h3 className="text-sm font-bold text-slate-800">Proveedores Adjudicados (MPU_PROVEEDORES)</h3>
          </div>
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                <th className="py-3 px-4">Código</th>
                <th className="py-3 px-4">Razón Social Proveedor</th>
                <th className="py-3 px-4">Rubro / Actividad</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {catalogos.proveedores.map((p: any) => (
                <tr key={p.PROV_COD} className="hover:bg-slate-50">
                  <td className="py-2.5 px-4 font-mono font-bold text-[#016098]">{p.PROV_COD}</td>
                  <td className="py-2.5 px-4 font-semibold text-slate-800">{p.PROV_NOMBRE}</td>
                  <td className="py-2.5 px-4 text-slate-600">{p.PROV_ACTIVIDAD}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Modal Detalle OC */}
      {selectedOc && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-2xl w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <div>
                <h3 className="text-sm font-bold">
                  Orden de Compra {selectedOc.ORCA_COD_OC} — {selectedOc.ESTADO_OC_DESC}
                </h3>
                <p className="text-[11px] text-blue-100">{selectedOc.ORCA_NOMBRE}</p>
              </div>
              <button onClick={() => setSelectedOc(null)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <div className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 bg-slate-50 p-3.5 rounded-lg border border-slate-200">
                <div>
                  <p className="text-slate-400 uppercase text-[10px] font-bold">Proveedor Adjudicado</p>
                  <p className="font-bold text-slate-800">{selectedOc.PROVEEDOR}</p>
                  <p className="text-slate-500">RUT: {selectedOc.RUT_PROVEEDOR} · {selectedOc.DIRECCION_PROVEEDOR}</p>
                  <p className="text-slate-500">Contacto: {selectedOc.MAIL_PROVEEDOR}</p>
                </div>
                <div>
                  <p className="text-slate-400 uppercase text-[10px] font-bold">Datos Financieros</p>
                  <p className="text-slate-700">Financiamiento: <strong>{selectedOc.ORCA_FINANCIAMIENTO}</strong></p>
                  <p className="text-slate-700">Neto: ${Number(selectedOc.ORCA_TOTAL_NETO).toLocaleString('es-CL')}</p>
                  <p className="text-slate-700">IVA (19%): ${Number(selectedOc.ORCA_IVA).toLocaleString('es-CL')}</p>
                  <p className="font-extrabold text-[#016098] text-sm">
                    Total OC: ${Number(selectedOc.ORCA_TOTAL_OC).toLocaleString('es-CL')}
                  </p>
                </div>
              </div>

              <div>
                <h4 className="font-bold text-slate-700 mb-2">
                  Líneas de Detalle de la Orden de Compra (MPU_ORDENES_DET)
                </h4>
                <table className="w-full text-left border-collapse border border-slate-200 text-xs">
                  <thead>
                    <tr className="bg-slate-100 text-slate-600 text-[11px]">
                      <th className="py-2 px-3">#</th>
                      <th className="py-2 px-3">Producto / Servicio</th>
                      <th className="py-2 px-3 text-right">Cant.</th>
                      <th className="py-2 px-3 text-right">P. Unitario</th>
                      <th className="py-2 px-3 text-right">Total Línea</th>
                    </tr>
                  </thead>
                  <tbody>
                    {(selectedOc.ITEMS || []).map((it: any) => (
                      <tr key={it.ORDE_SEC_ID} className="border-t border-slate-200">
                        <td className="py-2 px-3 font-bold">{it.ORDET_CORRELATIVO}</td>
                        <td className="py-2 px-3">
                          <div className="font-semibold text-slate-800">{it.ORDET_PRODUCTO}</div>
                          <div className="text-[11px] text-slate-500">{it.ORDET_ESPEC_COMPRADOR}</div>
                        </td>
                        <td className="py-2 px-3 text-right font-semibold">{it.ORDET_CANTIDAD}</td>
                        <td className="py-2 px-3 text-right">
                          ${Number(it.ORDET_PRECIO_NETO).toLocaleString('es-CL')}
                        </td>
                        <td className="py-2 px-3 text-right font-bold text-slate-800">
                          ${Number(it.ORDET_TOTAL).toLocaleString('es-CL')}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              <div className="flex justify-end gap-2 pt-2">
                {Number(selectedOc.DMEO_COD_ESTADO) !== 12 && (
                  <button
                    onClick={() => handleRecepcionarOc(selectedOc)}
                    className="px-4 py-2 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white font-bold cursor-pointer"
                  >
                    Marcar Recepción Conforme en PostgreSQL
                  </button>
                )}
                <button
                  onClick={() => setSelectedOc(null)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cerrar
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
