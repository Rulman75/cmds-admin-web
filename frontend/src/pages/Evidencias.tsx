import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import { exportToExcel, exportToPDF, formatRut } from '../utils/exportUtils';

const ESTADOS_EVIDENCIA = [
  { code: '', label: 'Todos los Estados' },
  { code: '0', label: '0 - INGRESADO (Pendiente Firma 1)' },
  { code: '1', label: '1 - RECHAZADA POR DIRECTOR' },
  { code: '2', label: '2 - APROBADA POR DIRECTOR (Pendiente Firma 2)' },
  { code: '3', label: '3 - RECHAZADA POR REFERENTE TÉCNICO' },
  { code: '4', label: '4 - APROBADA POR REFERENTE TÉCNICO' },
  { code: '5', label: '5 - BOLETA GENERADA' },
  { code: '6', label: '6 - CONSOLIDADA' }
];

const Evidencias: React.FC = () => {
  const [anio, setAnio] = useState('2026');
  const [mes, setMes] = useState('');
  const [estado, setEstado] = useState('');
  const [convenio, setConvenio] = useState('');
  const [search, setSearch] = useState('');
  const [conveniosList, setConveniosList] = useState<any[]>([]);
  const [rows, setRows] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  // Modal de detalle + Firma
  const [selectedEvia, setSelectedEvia] = useState<any | null>(null);
  const [detalle, setDetalle] = useState<{ documentos: any[]; logs: any[] }>({
    documentos: [],
    logs: []
  });
  const [loadingDetalle, setLoadingDetalle] = useState(false);
  const [observacionFirma, setObservacionFirma] = useState('');
  const [actionMsg, setActionMsg] = useState('');

  useEffect(() => {
    axios
      .get('/api/boletas/filtros')
      .then((res) => {
        if (res.data.status === 'ok') {
          setConveniosList(res.data.data?.convenios || []);
        }
      })
      .catch(console.error);
  }, []);

  const fetchEvidencias = useCallback(async () => {
    setLoading(true);
    try {
      const res = await axios.get('/api/evidencias', {
        params: { anio, mes, estado, convenio, search, limit: 150 }
      });
      if (res.data.status === 'ok') {
        setRows(res.data.data || []);
      }
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [anio, mes, estado, convenio, search]);

  useEffect(() => {
    fetchEvidencias();
  }, [fetchEvidencias]);

  const openDetalle = async (row: any) => {
    setSelectedEvia(row);
    setObservacionFirma(row.EVIA_OBSERVACION || '');
    setActionMsg('');
    setLoadingDetalle(true);
    try {
      const res = await axios.get(`/api/evidencias/${row.EVIA_SEC}/detalle`);
      if (res.data.status === 'ok') {
        setDetalle(res.data.data);
      }
    } catch (err) {
      console.error(err);
    } finally {
      setLoadingDetalle(false);
    }
  };

  const handleVisar = async (nuevoEstado: string, nivelFirma: number) => {
    if (!selectedEvia) return;
    try {
      const userStr = localStorage.getItem('cmds_user');
      const user = userStr ? JSON.parse(userStr) : { rut: '10633447' };
      const res = await axios.put(`/api/evidencias/${selectedEvia.EVIA_SEC}/visar`, {
        nuevoEstado,
        observacion: observacionFirma,
        usuario: user.rut,
        nivelFirma
      });
      if (res.data.status === 'ok') {
        setActionMsg(res.data.message);
        await fetchEvidencias();
        await openDetalle({
          ...selectedEvia,
          EVIA_ESTADO: nuevoEstado,
          EVIA_OBSERVACION: observacionFirma
        });
      }
    } catch (err: any) {
      alert(err.response?.data?.message || 'Error al visar evidencia');
    }
  };

  const getEstadoBadge = (est: string, desc: string) => {
    const code = String(est);
    if (['4', '5', '6'].includes(code)) {
      return (
        <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-800">
          {desc}
        </span>
      );
    }
    if (code === '2') {
      return (
        <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-sky-100 text-sky-800">
          {desc}
        </span>
      );
    }
    if (['1', '3'].includes(code)) {
      return (
        <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-rose-100 text-rose-800">
          {desc}
        </span>
      );
    }
    return (
      <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-amber-100 text-amber-800">
        {desc}
      </span>
    );
  };

  const countIngresadas = rows.filter((r) => String(r.EVIA_ESTADO) === '0').length;
  const countFirma1 = rows.filter((r) => String(r.EVIA_ESTADO) === '2').length;
  const countAprobadas = rows.filter((r) => ['4', '5', '6'].includes(String(r.EVIA_ESTADO))).length;
  const countRechazadas = rows.filter((r) => ['1', '3'].includes(String(r.EVIA_ESTADO))).length;

  return (
    <div className="space-y-5">
      {/* Tarjetas Resumen de Flujo de Firma */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-amber-500">
          <div className="text-[11px] font-bold text-slate-500 uppercase">0 · Pendientes Firma 1 (Director)</div>
          <div className="text-2xl font-extrabold text-amber-600 mt-1">{countIngresadas}</div>
          <div className="text-[11px] text-slate-400 mt-0.5">En bandeja de Director CESFAM</div>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#016098]">
          <div className="text-[11px] font-bold text-slate-500 uppercase">2 · Aprobadas Director (Pend. Firma 2)</div>
          <div className="text-2xl font-extrabold text-[#016098] mt-1">{countFirma1}</div>
          <div className="text-[11px] text-slate-400 mt-0.5">En bandeja de Referente Técnico</div>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <div className="text-[11px] font-bold text-slate-500 uppercase">4/5/6 · Visadas / Consolidadas</div>
          <div className="text-2xl font-extrabold text-emerald-600 mt-1">{countAprobadas}</div>
          <div className="text-[11px] text-slate-400 mt-0.5">Habilitadas para pago de Boleta</div>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#EB567F]">
          <div className="text-[11px] font-bold text-slate-500 uppercase">1/3 · Observadas / Rechazadas</div>
          <div className="text-2xl font-extrabold text-[#EB567F] mt-1">{countRechazadas}</div>
          <div className="text-[11px] text-slate-400 mt-0.5">Con reparo en documentación</div>
        </div>
      </div>

      {/* Filtros de Búsqueda */}
      <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-6 gap-3 items-end">
          <div>
            <label className="block text-[11px] font-bold text-slate-600 uppercase mb-1">Año</label>
            <select
              value={anio}
              onChange={(e) => setAnio(e.target.value)}
              className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
            >
              <option value="">Todos</option>
              <option value="2026">2026</option>
              <option value="2025">2025</option>
              <option value="2024">2024</option>
              <option value="2023">2023</option>
            </select>
          </div>

          <div>
            <label className="block text-[11px] font-bold text-slate-600 uppercase mb-1">Mes</label>
            <select
              value={mes}
              onChange={(e) => setMes(e.target.value)}
              className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
            >
              <option value="">Todos los Meses</option>
              {['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'].map((m) => (
                <option key={m} value={m}>
                  Mes {m}
                </option>
              ))}
            </select>
          </div>

          <div className="lg:col-span-2">
            <label className="block text-[11px] font-bold text-slate-600 uppercase mb-1">
              Estado de Visación (DM_ESTADO_EVI)
            </label>
            <select
              value={estado}
              onChange={(e) => setEstado(e.target.value)}
              className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
            >
              {ESTADOS_EVIDENCIA.map((st) => (
                <option key={st.code} value={st.code}>
                  {st.label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-[11px] font-bold text-slate-600 uppercase mb-1">Convenio APS</label>
            <select
              value={convenio}
              onChange={(e) => setConvenio(e.target.value)}
              className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
            >
              <option value="">Todos</option>
              {conveniosList.map((c: any) => (
                <option key={c.CONV_SEC} value={c.CONV_CODIGO}>
                  {c.CONV_CODIGO} - {c.CONV_DESC}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-[11px] font-bold text-slate-600 uppercase mb-1">
              RUT / Prestador / N° Boleta
            </label>
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Ej: 15844 o N° Boleta..."
              className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
            />
          </div>
        </div>

        <div className="flex flex-wrap justify-between items-center mt-3 pt-3 border-t border-slate-100 gap-2">
          <div className="text-xs text-slate-500">
            Consultando <code className="font-mono text-[#016098]">ADM_OBS.BHO_EVIDENCIA</code> ·{' '}
            <strong>{rows.length}</strong> registros listados
          </div>
          <div className="flex gap-2">
            <button
              onClick={() => exportToExcel(rows, `Evidencias_Honorarios_${anio || 'Hist'}`)}
              className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
            >
              Exportar Excel
            </button>
            <button
              onClick={() =>
                exportToPDF(
                  'Control de Evidencias y Respaldo de Boletas APS',
                  ['Folio', 'Año/Mes', 'RUT', 'Prestador', 'N° Boleta', 'Convenio', 'Estado', 'Docs'],
                  rows.map((r) => [
                    r.EVIA_SEC,
                    `${r.EVIA_ANO}-${r.EVIA_MES}`,
                    formatRut(r.EVIA_RUT_EMPLEADO, r.FUNC_DV),
                    r.FUNCIONARIO || 'S/I',
                    r.EVIA_BOLETA,
                    r.CONVENIO_DESC,
                    r.ESTADO_DESC,
                    r.CANT_DOCS
                  ]),
                  `Evidencias_${anio}`
                )
              }
              className="px-3 py-1.5 bg-slate-700 hover:bg-slate-800 text-white rounded-lg text-xs font-semibold cursor-pointer"
            >
              Imprimir PDF
            </button>
          </div>
        </div>
      </div>

      {/* Tabla de Evidencias */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-[#016098] text-white text-[11px] uppercase tracking-wider">
                <th className="py-3 px-3">Folio</th>
                <th className="py-3 px-3">Año / Mes</th>
                <th className="py-3 px-3">Prestador / RUT</th>
                <th className="py-3 px-3">Establecimiento / Convenio</th>
                <th className="py-3 px-3">N° Boleta</th>
                <th className="py-3 px-3 text-center">Adjuntos</th>
                <th className="py-3 px-3">Firma 1 (Director)</th>
                <th className="py-3 px-3">Firma 2 (Ref. Técnico)</th>
                <th className="py-3 px-3">Estado</th>
                <th className="py-3 px-3 text-right">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-200 text-xs">
              {loading ? (
                <tr>
                  <td colSpan={10} className="py-12 text-center text-slate-500">
                    Cargando evidencias desde Oracle ADM_OBS.BHO_EVIDENCIA...
                  </td>
                </tr>
              ) : rows.length === 0 ? (
                <tr>
                  <td colSpan={10} className="py-12 text-center text-slate-400">
                    No se encontraron evidencias con los filtros actuales.
                  </td>
                </tr>
              ) : (
                rows.map((r) => (
                  <tr key={r.EVIA_SEC} className="hover:bg-slate-50 transition-colors">
                    <td className="py-2.5 px-3 font-mono font-bold text-[#016098]">#{r.EVIA_SEC}</td>
                    <td className="py-2.5 px-3 font-mono text-slate-700">
                      {r.EVIA_ANO}-{String(r.EVIA_MES).padStart(2, '0')}
                    </td>
                    <td className="py-2.5 px-3">
                      <div className="font-semibold text-slate-800">{r.FUNCIONARIO || 'PRESTADOR APS'}</div>
                      <div className="text-[11px] text-slate-500 font-mono">
                        {formatRut(r.EVIA_RUT_EMPLEADO, r.FUNC_DV)}
                      </div>
                    </td>
                    <td className="py-2.5 px-3">
                      <div className="font-medium text-slate-700">{r.CONVENIO_DESC}</div>
                      <div className="text-[11px] text-slate-400">Estab. Cód: {r.EVIA_ESTA_COD || 'CMDS'}</div>
                    </td>
                    <td className="py-2.5 px-3 font-mono font-bold text-slate-800">
                      N° {r.EVIA_BOLETA || 'S/N'}
                    </td>
                    <td className="py-2.5 px-3 text-center">
                      <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700 font-mono text-[11px]">
                        {r.CANT_DOCS} PDF
                      </span>
                    </td>
                    <td className="py-2.5 px-3 text-[11px]">
                      {r.EVIA_USER_FIRMA_1 ? (
                        <div>
                          <span className="font-semibold text-emerald-700">RUT {r.EVIA_USER_FIRMA_1}</span>
                          <div className="text-slate-400">{r.FECH_FIRMA_1}</div>
                        </div>
                      ) : (
                        <span className="text-slate-400 italic">Sin firma 1</span>
                      )}
                    </td>
                    <td className="py-2.5 px-3 text-[11px]">
                      {r.EVIA_USER_FIRMA_2 ? (
                        <div>
                          <span className="font-semibold text-[#016098]">RUT {r.EVIA_USER_FIRMA_2}</span>
                          <div className="text-slate-400">{r.FECH_FIRMA_2}</div>
                        </div>
                      ) : (
                        <span className="text-slate-400 italic">Sin firma 2</span>
                      )}
                    </td>
                    <td className="py-2.5 px-3">{getEstadoBadge(r.EVIA_ESTADO, r.ESTADO_DESC)}</td>
                    <td className="py-2.5 px-3 text-right">
                      <button
                        onClick={() => openDetalle(r)}
                        className="px-3 py-1 bg-[#016098] hover:bg-[#014f7d] text-white rounded-lg text-[11px] font-semibold transition-colors cursor-pointer"
                      >
                        Revisar / Visar
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal de Revisión Documental y Doble Firma */}
      {selectedEvia && (
        <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="px-6 py-4 bg-[#016098] text-white flex justify-between items-center rounded-t-2xl">
              <div>
                <span className="text-[10px] uppercase tracking-widest text-[#39BABD] font-bold">
                  Expediente de Evidencia Digital · ADM_OBS.BHO_EVIDENCIA
                </span>
                <h3 className="text-base font-bold">
                  Evidencia #{selectedEvia.EVIA_SEC} — Boleta N° {selectedEvia.EVIA_BOLETA} ({selectedEvia.EVIA_ANO}-
                  {String(selectedEvia.EVIA_MES).padStart(2, '0')})
                </h3>
              </div>
              <button
                onClick={() => setSelectedEvia(null)}
                className="text-white/80 hover:text-white text-sm font-bold px-2.5 py-1 rounded cursor-pointer"
              >
                ✕ Cerrar
              </button>
            </div>

            <div className="p-6 space-y-5">
              {actionMsg && (
                <div className="p-3 rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-semibold">
                  ✓ {actionMsg}
                </div>
              )}

              {/* Datos Principales */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-3 bg-slate-50 p-4 rounded-xl border border-slate-200 text-xs">
                <div>
                  <span className="text-slate-400 block text-[10px] uppercase font-bold">Prestador</span>
                  <strong className="text-slate-800">{selectedEvia.FUNCIONARIO || 'PRESTADOR APS'}</strong>
                  <div className="text-slate-500 font-mono">
                    RUT: {formatRut(selectedEvia.EVIA_RUT_EMPLEADO, selectedEvia.FUNC_DV)}
                  </div>
                </div>
                <div>
                  <span className="text-slate-400 block text-[10px] uppercase font-bold">Convenio / Establecimiento</span>
                  <strong className="text-slate-800">{selectedEvia.CONVENIO_DESC}</strong>
                  <div className="text-slate-500">Establecimiento: {selectedEvia.EVIA_ESTA_COD}</div>
                </div>
                <div>
                  <span className="text-slate-400 block text-[10px] uppercase font-bold">Estado Actual</span>
                  <div className="mt-1">{getEstadoBadge(selectedEvia.EVIA_ESTADO, selectedEvia.ESTADO_DESC)}</div>
                </div>
              </div>

              {/* Documentos Adjuntos (BHO_EVIDENCIA_DOCUMENTO) */}
              <div>
                <h4 className="text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                  Archivos de Respaldo Adjuntos (BHO_EVIDENCIA_DOCUMENTO)
                </h4>
                {loadingDetalle ? (
                  <div className="text-xs text-slate-400 py-4">Consultando archivos en Oracle...</div>
                ) : detalle.documentos.length === 0 ? (
                  <div className="text-xs text-slate-400 py-3 bg-slate-50 rounded-lg px-4 border border-slate-200">
                    No se registran archivos adjuntos en BHO_EVIDENCIA_DOCUMENTO para este folio.
                  </div>
                ) : (
                  <div className="border border-slate-200 rounded-xl overflow-hidden">
                    <table className="w-full text-left text-xs">
                      <thead className="bg-slate-100 text-slate-600 text-[11px] uppercase">
                        <tr>
                          <th className="py-2 px-3">ID Doc</th>
                          <th className="py-2 px-3">Nombre Archivo Original</th>
                          <th className="py-2 px-3">Ruta / Hash</th>
                          <th className="py-2 px-3">Tamaño</th>
                          <th className="py-2 px-3">Fecha Carga</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-slate-200">
                        {detalle.documentos.map((d: any) => (
                          <tr key={d.EVDO_SEC}>
                            <td className="py-2 px-3 font-mono">#{d.EVDO_SEC}</td>
                            <td className="py-2 px-3 font-semibold text-[#016098]">
                              {d.EVIA_ARCHIVO_REAL || d.EVIA_ARCHIVO}
                            </td>
                            <td className="py-2 px-3 font-mono text-[11px] text-slate-500">{d.EVIA_ARCHIVO}</td>
                            <td className="py-2 px-3 text-slate-600">
                              {d.EVIA_TAMANIO_ARCHIVO
                                ? `${Math.round(Number(d.EVIA_TAMANIO_ARCHIVO) / 1024)} KB`
                                : 'PDF'}
                            </td>
                            <td className="py-2 px-3 text-slate-500">{d.FECH_ING}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>

              {/* Panel de Visación Electrónica (Doble Firma) */}
              <div className="bg-slate-50 p-4 rounded-xl border border-slate-200 space-y-3">
                <h4 className="text-xs font-bold text-[#016098] uppercase tracking-wider">
                  Visación Electrónica · Flujo de Doble Firma APS
                </h4>
                <div>
                  <label className="block text-[11px] font-semibold text-slate-600 mb-1">
                    Observación de Visación / Reparo:
                  </label>
                  <input
                    type="text"
                    value={observacionFirma}
                    onChange={(e) => setObservacionFirma(e.target.value)}
                    placeholder="Ingrese comentario de aprobación o motivo de rechazo..."
                    className="w-full px-3 py-2 text-xs bg-white border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
                  />
                </div>
                <div className="flex flex-wrap gap-2 pt-1">
                  <button
                    onClick={() => handleVisar('2', 1)}
                    className="px-3.5 py-2 bg-sky-600 hover:bg-sky-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
                  >
                    ✓ Firma 1: Aprobar como Director CESFAM (Estado 2)
                  </button>
                  <button
                    onClick={() => handleVisar('1', 1)}
                    className="px-3.5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
                  >
                    ✕ Firma 1: Rechazar Director (Estado 1)
                  </button>
                  <button
                    onClick={() => handleVisar('4', 2)}
                    className="px-3.5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
                  >
                    ✓✓ Firma 2: Aprobar Referente Técnico (Estado 4)
                  </button>
                  <button
                    onClick={() => handleVisar('3', 2)}
                    className="px-3.5 py-2 bg-[#EB567F] hover:bg-[#d6456d] text-white rounded-lg text-xs font-semibold cursor-pointer"
                  >
                    ✕ Firma 2: Rechazar Referente Técnico (Estado 3)
                  </button>
                </div>
              </div>

              {/* Bitácora de Auditoría (BHO_EVIDENCIA_LOG) */}
              <div>
                <h4 className="text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                  Historial de Estados y Auditoría (BHO_EVIDENCIA_LOG)
                </h4>
                <div className="border border-slate-200 rounded-xl overflow-hidden max-h-48 overflow-y-auto">
                  <table className="w-full text-left text-xs">
                    <thead className="bg-slate-100 text-slate-600 text-[11px] uppercase">
                      <tr>
                        <th className="py-2 px-3">Log ID</th>
                        <th className="py-2 px-3">Fecha / Hora</th>
                        <th className="py-2 px-3">Usuario</th>
                        <th className="py-2 px-3">Estado</th>
                        <th className="py-2 px-3">Observación</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-200">
                      {detalle.logs.length === 0 ? (
                        <tr>
                          <td colSpan={5} className="py-3 px-3 text-center text-slate-400">
                            Sin eventos registrados en BHO_EVIDENCIA_LOG.
                          </td>
                        </tr>
                      ) : (
                        detalle.logs.map((l: any) => (
                          <tr key={l.EVLG_SEC}>
                            <td className="py-2 px-3 font-mono">#{l.EVLG_SEC}</td>
                            <td className="py-2 px-3 font-mono text-slate-600">{l.FECH_ING}</td>
                            <td className="py-2 px-3 font-semibold">{l.EVIA_USER_ING}</td>
                            <td className="py-2 px-3">{l.ESTADO_DESC}</td>
                            <td className="py-2 px-3 text-slate-600">{l.EVIA_OBSERVACION || '—'}</td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Evidencias;
