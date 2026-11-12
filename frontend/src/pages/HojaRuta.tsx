import React, { useState, useEffect, useCallback } from 'react';

interface IniciativaHr {
  INIC_SEC: number;
  INIC_FOLIO: string;
  INIC_NOM_PROYECTO: string;
  DEPA_SEC: number;
  DEPARTAMENTO: string;
  INIC_MONTO: number;
  FECHA_ING: string;
  INIC_ESTADO: string;
  OBSERVACIONES: string;
  INIC_TIPO_FINAN: number;
  FINANCIAMIENTO: string;
  INIC_IND_VB: string;
  INIC_NOM_DOC_VB: string;
  PASOS: any[];
}

export default function HojaRuta() {
  const [activeTab, setActiveTab] = useState<'iniciativas' | 'cdp' | 'departamentos'>('iniciativas');
  const [iniciativas, setIniciativas] = useState<IniciativaHr[]>([]);
  const [disponibilidades, setDisponibilidades] = useState<any[]>([]);
  const [catalogos, setCatalogos] = useState<{
    departamentos: any[];
    tiposFinanciamiento: any[];
  }>({ departamentos: [], tiposFinanciamiento: [] });
  const [loading, setLoading] = useState(true);
  const [feedback, setFeedback] = useState<{ type: 'ok' | 'err'; msg: string } | null>(null);

  // Modal Nueva Iniciativa
  const [showNewInicModal, setShowNewInicModal] = useState(false);
  const [inicForm, setInicForm] = useState({
    nombreProyecto: '',
    depaSec: 2,
    tifiSec: 1,
    monto: '',
    observaciones: ''
  });

  // Modal Nuevo CDP
  const [showNewCdpModal, setShowNewCdpModal] = useState(false);
  const [cdpForm, setCdpForm] = useState({
    nombreProyecto: '',
    depaSec: 2,
    tifiSec: 1,
    monto: '',
    glosa: 'Subtítulo 22 / 29 Clasificador Presupuestario',
    observacionPpto: 'Saldo disponible verificado en cuenta presupuestaria vigente',
    ordenCompra: ''
  });

  // Modal Evaluar Iniciativa
  const [selectedInic, setSelectedInic] = useState<IniciativaHr | null>(null);
  const [evalForm, setEvalForm] = useState({
    nuevoEstado: 'APROBADA DAF',
    observacion: ''
  });

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/hoja-ruta');
      const json = await res.json();
      if (json.status === 'ok') {
        setIniciativas(json.iniciativas || []);
        setDisponibilidades(json.disponibilidades || []);
        setCatalogos(json.catalogos || { departamentos: [], tiposFinanciamiento: [] });
      }
    } catch (err) {
      console.error('Error cargando Hoja de Ruta:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleCreateInic = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/hoja-ruta/iniciativas', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...inicForm,
          monto: Number(inicForm.monto || 0)
        })
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewInicModal(false);
        setInicForm({
          nombreProyecto: '',
          depaSec: 2,
          tifiSec: 1,
          monto: '',
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

  const handleCreateCdp = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/hoja-ruta/cdp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...cdpForm,
          monto: Number(cdpForm.monto || 0)
        })
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewCdpModal(false);
        setCdpForm({
          nombreProyecto: '',
          depaSec: 2,
          tifiSec: 1,
          monto: '',
          glosa: 'Subtítulo 22 / 29 Clasificador Presupuestario',
          observacionPpto: 'Saldo disponible verificado en cuenta presupuestaria vigente',
          ordenCompra: ''
        });
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleEvaluar = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedInic) return;
    try {
      const res = await fetch(`/api/hoja-ruta/iniciativas/${selectedInic.INIC_SEC}/evaluar`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(evalForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setSelectedInic(null);
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const totalMontoInic = iniciativas.reduce((acc, i) => acc + Number(i.INIC_MONTO || 0), 0);
  const totalMontoCdp = disponibilidades.reduce((acc, d) => acc + Number(d.DIPP_MONTO || 0), 0);

  const badgeEstado = (est: string) => {
    const u = (est || '').toUpperCase();
    if (u.includes('APROB') || u.includes('CDP') || u.includes('EMITIDO'))
      return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    if (u.includes('OBSERV')) return 'bg-rose-100 text-rose-800 border-rose-200';
    return 'bg-amber-100 text-amber-800 border-amber-200';
  };

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#016098] text-white">
              FASE 2 · ADM_OBS.HR_*
            </span>
            <span className="text-xs text-slate-500 font-medium">PostgreSQL 18 (bd_cmds_admin)</span>
          </div>
          <h1 className="text-xl font-bold text-slate-800 mt-1">
            Hoja de Ruta de Iniciativas y Disponibilidad Presupuestaria (CDP)
          </h1>
          <p className="text-xs text-slate-500">
            Flujo de evaluación multicapa por unidad técnica, Control Presupuestario y DAF (HR_INICIATIVA / HR_HOJA_RUTA / HR_DISPONIBILIDAD_PPTO).
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <button
            onClick={() => setShowNewInicModal(true)}
            className="px-3.5 py-2 rounded-lg bg-[#016098] hover:bg-[#014b76] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Nueva Iniciativa
          </button>
          <button
            onClick={() => setShowNewCdpModal(true)}
            className="px-3.5 py-2 rounded-lg bg-[#39BABD] hover:bg-[#2da3a6] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Emitir CDP
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
          <p className="text-xs text-slate-500 font-semibold uppercase">Iniciativas en Hoja de Ruta</p>
          <p className="text-2xl font-extrabold text-slate-800 mt-1">{iniciativas.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.hr_iniciativa</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-amber-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Monto Total Iniciativas</p>
          <p className="text-2xl font-extrabold text-[#016098] mt-1">
            ${totalMontoInic.toLocaleString('es-CL')}
          </p>
          <p className="text-[11px] text-slate-400 mt-0.5">SEP, PIE, FAEP, PRAPS y Fondos Propios</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Certificados CDP Emitidos</p>
          <p className="text-2xl font-extrabold text-emerald-600 mt-1">{disponibilidades.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.hr_disponibilidad_ppto</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#39BABD]">
          <p className="text-xs text-slate-500 font-semibold uppercase">Monto Respaldado con CDP</p>
          <p className="text-2xl font-extrabold text-emerald-700 mt-1">
            ${totalMontoCdp.toLocaleString('es-CL')}
          </p>
          <p className="text-[11px] text-slate-400 mt-0.5">Imputación presupuestaria validada</p>
        </div>
      </div>

      {/* Pestañas */}
      <div className="flex flex-wrap gap-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('iniciativas')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'iniciativas'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Iniciativas y Flujo Hoja de Ruta ({iniciativas.length})
        </button>
        <button
          onClick={() => setActiveTab('cdp')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'cdp'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Disponibilidad Presupuestaria CDP ({disponibilidades.length})
        </button>
        <button
          onClick={() => setActiveTab('departamentos')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'departamentos'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Unidades Evaluadoras y Financiamientos
        </button>
      </div>

      {activeTab === 'iniciativas' && (
        <div className="space-y-4">
          {loading ? (
            <div className="bg-white rounded-xl p-8 text-center text-xs text-slate-400 border border-slate-200">
              Cargando iniciativas y hojas de ruta desde PostgreSQL...
            </div>
          ) : (
            iniciativas.map((inic) => (
              <div
                key={inic.INIC_SEC}
                className="bg-white rounded-xl p-5 shadow-sm border border-slate-200 space-y-4"
              >
                <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-mono font-bold text-xs px-2.5 py-0.5 rounded bg-blue-50 text-[#016098] border border-blue-200">
                        {inic.INIC_FOLIO}
                      </span>
                      <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${badgeEstado(inic.INIC_ESTADO)}`}>
                        {inic.INIC_ESTADO}
                      </span>
                      <span className="text-xs text-slate-400">Ingreso: {inic.FECHA_ING}</span>
                    </div>
                    <h3 className="text-sm font-bold text-slate-800 mt-1.5">{inic.INIC_NOM_PROYECTO}</h3>
                    <p className="text-xs text-slate-500 mt-0.5">
                      Unidad Técnica: <strong className="text-slate-700">{inic.DEPARTAMENTO}</strong> · Financiamiento:{' '}
                      <strong className="text-[#016098]">{inic.FINANCIAMIENTO}</strong>
                    </p>
                  </div>

                  <div className="flex items-center gap-4">
                    <div className="text-right">
                      <div className="text-[11px] text-slate-400 uppercase font-semibold">Monto Solicitado</div>
                      <div className="text-lg font-extrabold text-slate-800">
                        ${Number(inic.INIC_MONTO).toLocaleString('es-CL')}
                      </div>
                    </div>
                    <button
                      onClick={() => {
                        setSelectedInic(inic);
                        setEvalForm({
                          nuevoEstado: inic.INIC_ESTADO === 'APROBADA DAF' ? 'CON CDP EMITIDO' : 'APROBADA DAF',
                          observacion: ''
                        });
                      }}
                      className="px-3 py-2 rounded-lg bg-[#39BABD] hover:bg-[#2da3a6] text-white text-xs font-bold cursor-pointer"
                    >
                      Visar / Evaluar
                    </button>
                  </div>
                </div>

                {/* Línea de tiempo de pasos Hoja de Ruta */}
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-2.5 pt-2 border-t border-slate-100">
                  {(inic.PASOS || []).map((paso: any) => (
                    <div
                      key={`${inic.INIC_SEC}-${paso.HORU_ORDEN}`}
                      className="p-2.5 rounded-lg bg-slate-50 border border-slate-200 text-xs"
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-bold text-slate-700">Paso {paso.HORU_ORDEN}</span>
                        <span
                          className={`px-2 py-0.5 rounded-full text-[9px] font-bold border ${badgeEstado(
                            paso.HORU_ESTADO
                          )}`}
                        >
                          {paso.HORU_ESTADO}
                        </span>
                      </div>
                      <div className="font-semibold text-[#016098] text-[11px] mt-1 truncate">
                        {paso.DEPARTAMENTO}
                      </div>
                      <div className="text-[10px] text-slate-500 mt-0.5 line-clamp-2">{paso.OBSERVACION}</div>
                    </div>
                  ))}
                </div>
              </div>
            ))
          )}
        </div>
      )}

      {activeTab === 'cdp' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200">
            <h3 className="text-sm font-bold text-slate-800">
              Certificados de Disponibilidad Presupuestaria (HR_DISPONIBILIDAD_PPTO)
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-3 px-4">ID / Proyecto CDP</th>
                  <th className="py-3 px-4">Financiamiento / Cuenta</th>
                  <th className="py-3 px-4">Observación Presupuesto / DAF</th>
                  <th className="py-3 px-3">OC Asociada</th>
                  <th className="py-3 px-3 text-right">Monto Certificado</th>
                  <th className="py-3 px-3 text-center">Estado</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {disponibilidades.map((d: any) => (
                  <tr key={d.DIPP_SEC} className="hover:bg-slate-50">
                    <td className="py-3 px-4">
                      <div className="font-bold text-[#016098]">{d.DIPP_NOMBRE_PROYECTO}</div>
                      <div className="text-[11px] text-slate-400">
                        {d.DEPARTAMENTO} · Fecha: {d.FECHA_CDP}
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="font-semibold text-slate-800">{d.FINANCIAMIENTO}</div>
                      <div className="text-[11px] text-slate-500">{d.DIPP_GLOSA}</div>
                    </td>
                    <td className="py-3 px-4 max-w-sm">
                      <div className="text-slate-700">{d.DIPP_OBSERVACION_PPTO}</div>
                      <div className="text-[11px] text-slate-400">{d.DIPP_OBSERVACION_PPTO_DAF}</div>
                    </td>
                    <td className="py-3 px-3 font-mono font-bold text-[#016098]">
                      {d.DIPP_ORDEN_COMPRA || '—'}
                    </td>
                    <td className="py-3 px-3 text-right font-extrabold text-slate-800">
                      ${Number(d.DIPP_MONTO).toLocaleString('es-CL')}
                    </td>
                    <td className="py-3 px-3 text-center">
                      <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${badgeEstado(d.DIPP_ESTADO)}`}>
                        {d.DIPP_ESTADO}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'departamentos' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="p-4 bg-slate-50 border-b border-slate-200">
              <h3 className="text-sm font-bold text-slate-800">Unidades Evaluadoras (HR_DEPARTAMENTO)</h3>
            </div>
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-2.5 px-4">Orden</th>
                  <th className="py-2.5 px-4">Departamento</th>
                  <th className="py-2.5 px-4">Responsable</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {catalogos.departamentos.map((d: any) => (
                  <tr key={d.DEPA_SEC}>
                    <td className="py-2.5 px-4 font-bold">#{d.DEPA_ORDEN || d.DEPA_SEC}</td>
                    <td className="py-2.5 px-4 font-semibold text-slate-800">{d.DEPA_NOMBRE}</td>
                    <td className="py-2.5 px-4 text-slate-600">{d.DEPA_NOMBRE_RESP}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="p-4 bg-slate-50 border-b border-slate-200">
              <h3 className="text-sm font-bold text-slate-800">Fuentes de Financiamiento (HR_TIPO_FINANCIAMIENTO)</h3>
            </div>
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                  <th className="py-2.5 px-4">ID</th>
                  <th className="py-2.5 px-4">Fuente de Financiamiento</th>
                  <th className="py-2.5 px-4">Estado</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {catalogos.tiposFinanciamiento.map((tf: any) => (
                  <tr key={tf.TIFI_SEC}>
                    <td className="py-2.5 px-4 font-mono">#{tf.TIFI_SEC}</td>
                    <td className="py-2.5 px-4 font-semibold text-slate-800">{tf.TIFI_NOMBRE}</td>
                    <td className="py-2.5 px-4 text-emerald-700 font-bold">{tf.TIFI_FINAN_ULT_ESTADO}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Modal Nueva Iniciativa */}
      {showNewInicModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Ingresar Nueva Iniciativa a Hoja de Ruta</h3>
              <button onClick={() => setShowNewInicModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateInic} className="p-5 space-y-4 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Nombre del Proyecto / Iniciativa *</label>
                <input
                  type="text"
                  required
                  placeholder="Ej: ADQUISICION EQUIPAMIENTO LABORATORIO CIENCIAS LICEO A-17"
                  value={inicForm.nombreProyecto}
                  onChange={(e) => setInicForm({ ...inicForm, nombreProyecto: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Unidad Técnica</label>
                  <select
                    value={inicForm.depaSec}
                    onChange={(e) => setInicForm({ ...inicForm, depaSec: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.departamentos.map((d: any) => (
                      <option key={d.DEPA_SEC} value={d.DEPA_SEC}>
                        {d.DEPA_NOMBRE}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Financiamiento</label>
                  <select
                    value={inicForm.tifiSec}
                    onChange={(e) => setInicForm({ ...inicForm, tifiSec: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.tiposFinanciamiento.map((tf: any) => (
                      <option key={tf.TIFI_SEC} value={tf.TIFI_SEC}>
                        {tf.TIFI_NOMBRE}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Monto Estimado ($) *</label>
                  <input
                    type="number"
                    required
                    placeholder="15000000"
                    value={inicForm.monto}
                    onChange={(e) => setInicForm({ ...inicForm, monto: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Justificación Técnica / PME / PRAPS</label>
                <textarea
                  rows={3}
                  value={inicForm.observaciones}
                  onChange={(e) => setInicForm({ ...inicForm, observaciones: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowNewInicModal(false)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#016098] text-white font-bold cursor-pointer"
                >
                  Crear Iniciativa
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal Emitir CDP */}
      {showNewCdpModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#39BABD] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Emitir Certificado de Disponibilidad Presupuestaria (CDP)</h3>
              <button onClick={() => setShowNewCdpModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateCdp} className="p-5 space-y-4 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Proyecto / Glosa del CDP *</label>
                <input
                  type="text"
                  required
                  placeholder="Ej: ADQUISICION MOBILIARIO ESCOLAR ESCUELA D-68"
                  value={cdpForm.nombreProyecto}
                  onChange={(e) => setCdpForm({ ...cdpForm, nombreProyecto: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Financiamiento</label>
                  <select
                    value={cdpForm.tifiSec}
                    onChange={(e) => setCdpForm({ ...cdpForm, tifiSec: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.tiposFinanciamiento.map((tf: any) => (
                      <option key={tf.TIFI_SEC} value={tf.TIFI_SEC}>
                        {tf.TIFI_NOMBRE}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Monto Certificado ($) *</label>
                  <input
                    type="number"
                    required
                    value={cdpForm.monto}
                    onChange={(e) => setCdpForm({ ...cdpForm, monto: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Cuenta Presupuestaria / Subtítulo</label>
                  <input
                    type="text"
                    value={cdpForm.glosa}
                    onChange={(e) => setCdpForm({ ...cdpForm, glosa: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Orden de Compra Asociada (Opcional)</label>
                  <input
                    type="text"
                    placeholder="Ej: 1111614-109-CM26"
                    value={cdpForm.ordenCompra}
                    onChange={(e) => setCdpForm({ ...cdpForm, ordenCompra: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowNewCdpModal(false)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#39BABD] text-white font-bold cursor-pointer"
                >
                  Emitir CDP en PostgreSQL
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal Evaluar Iniciativa */}
      {selectedInic && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-md w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Visar Iniciativa {selectedInic.INIC_FOLIO}</h3>
              <button onClick={() => setSelectedInic(null)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleEvaluar} className="p-5 space-y-4 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Dictamen / Nuevo Estado</label>
                <select
                  value={evalForm.nuevoEstado}
                  onChange={(e) => setEvalForm({ ...evalForm, nuevoEstado: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                >
                  <option value="APROBADA DAF">APROBADA DAF (VISACION COMPLETA)</option>
                  <option value="CON CDP EMITIDO">CON CDP EMITIDO (LISTA PARA COMPRA)</option>
                  <option value="OBSERVADA">OBSERVADA (DEVOLVER A UNIDAD)</option>
                </select>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Observación de Evaluación</label>
                <textarea
                  rows={3}
                  placeholder="Comentarios del evaluador técnico, presupuesto o DAF..."
                  value={evalForm.observacion}
                  onChange={(e) => setEvalForm({ ...evalForm, observacion: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setSelectedInic(null)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#016098] text-white font-bold cursor-pointer"
                >
                  Registrar Evaluación
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
