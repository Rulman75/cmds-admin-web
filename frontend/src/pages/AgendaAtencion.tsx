import React, { useState, useEffect, useCallback } from 'react';

interface SolicitudAgenda {
  DASO_SEC: number;
  DASO_TIPO_DOCTO: string;
  DASO_RUT: number;
  DASO_DV: string;
  SOLICITANTE: string;
  DASO_CELULAR: string;
  DASO_EMAIL: string;
  DEPA_SEC: number;
  DEPARTAMENTO: string;
  FECHA_ATENCION: string;
  DAHO_HORA: string;
  DASO_ID_UNICO: string;
  DASO_FLAG_ENVIO_WSP: string;
  DASO_FLAG_ENVIO_EMAIL: string;
  DASO_ESTADO: string;
  DASO_OBSERV: string;
}

export default function AgendaAtencion() {
  const [activeTab, setActiveTab] = useState<'citas' | 'campanas' | 'pacientes'>('citas');
  const [solicitudes, setSolicitudes] = useState<SolicitudAgenda[]>([]);
  const [campanas, setCampanas] = useState<any[]>([]);
  const [pacientes, setPacientes] = useState<any[]>([]);
  const [catalogos, setCatalogos] = useState<{
    departamentos: any[];
    bloquesHora: any[];
    especialidades: any[];
  }>({ departamentos: [], bloquesHora: [], especialidades: [] });
  const [loading, setLoading] = useState(true);
  const [feedback, setFeedback] = useState<{ type: 'ok' | 'err'; msg: string } | null>(null);

  const [filtroDepa, setFiltroDepa] = useState('');
  const [filtroEstado, setFiltroEstado] = useState('');
  const [search, setSearch] = useState('');

  // Modal Nueva Cita Agenda
  const [showNewCitaModal, setShowNewCitaModal] = useState(false);
  const [citaForm, setCitaForm] = useState({
    rut: '',
    dv: 'K',
    nombre: '',
    apePat: '',
    apeMat: '',
    celular: '+569',
    email: '',
    depaSec: 2,
    fechaAtencion: '2026-11-12',
    hora: '10:00',
    observacion: ''
  });

  // Modal Inscribir Cupo Campaña Salud
  const [showNewCupoModal, setShowNewCupoModal] = useState(false);
  const [cupoForm, setCupoForm] = useState({
    campSec: 1,
    espeCod: 'OFT',
    rut: '',
    dv: '9',
    nombres: '',
    apePat: '',
    apeMat: '',
    edad: 55,
    genero: 'F',
    direccion: '',
    celular: '+569'
  });

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtroDepa) params.set('depaSec', filtroDepa);
      if (filtroEstado) params.set('estado', filtroEstado);
      if (search) params.set('search', search);

      const res = await fetch(`/api/agenda-atencion?${params.toString()}`);
      const json = await res.json();
      if (json.status === 'ok') {
        setSolicitudes(json.solicitudes || []);
        setCampanas(json.campanas || []);
        setPacientes(json.pacientes || []);
        setCatalogos(json.catalogos || { departamentos: [], bloquesHora: [], especialidades: [] });
      }
    } catch (err) {
      console.error('Error cargando Agenda de Atención:', err);
    } finally {
      setLoading(false);
    }
  }, [filtroDepa, filtroEstado, search]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleCreateCita = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/agenda-atencion/solicitudes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(citaForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewCitaModal(false);
        setCitaForm({
          rut: '',
          dv: 'K',
          nombre: '',
          apePat: '',
          apeMat: '',
          celular: '+569',
          email: '',
          depaSec: 2,
          fechaAtencion: '2026-11-12',
          hora: '10:00',
          observacion: ''
        });
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleUpdateCita = async (dasoSec: number, nuevoEstado: string) => {
    try {
      const res = await fetch(`/api/agenda-atencion/solicitudes/${dasoSec}/estado`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nuevoEstado })
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        fetchData();
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const handleCreateCupo = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/agenda-atencion/campanas-cupo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(cupoForm)
      });
      const json = await res.json();
      if (json.status === 'ok') {
        setFeedback({ type: 'ok', msg: json.message });
        setShowNewCupoModal(false);
        setCupoForm({
          campSec: 1,
          espeCod: 'OFT',
          rut: '',
          dv: '9',
          nombres: '',
          apePat: '',
          apeMat: '',
          edad: 55,
          genero: 'F',
          direccion: '',
          celular: '+569'
        });
        fetchData();
      } else {
        setFeedback({ type: 'err', msg: json.message });
      }
    } catch (err: any) {
      setFeedback({ type: 'err', msg: err.message });
    }
  };

  const badgeEstado = (est: string) => {
    const u = (est || '').toUpperCase();
    if (u === 'ATENDIDO') return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    if (u === 'CONFIRMADO') return 'bg-blue-100 text-blue-800 border-blue-200';
    if (u === 'ANULADO') return 'bg-rose-100 text-rose-800 border-rose-200';
    return 'bg-amber-100 text-amber-800 border-amber-200';
  };

  const confirmadas = solicitudes.filter((s) => s.DASO_ESTADO === 'CONFIRMADO').length;
  const atendidas = solicitudes.filter((s) => s.DASO_ESTADO === 'ATENDIDO').length;
  const totalCuposCampana = campanas.reduce((acc, c) => acc + Number(c.CAMP_CNT_CUPO || 0), 0);

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#016098] text-white">
              FASE 3 · MÓDULO 10 · ADM_OBS.OBS_DATOS_SOLICITUD & SAL_*
            </span>
            <span className="text-xs text-slate-500 font-medium">PostgreSQL 18 (bd_cmds_admin)</span>
          </div>
          <h1 className="text-xl font-bold text-slate-800 mt-1">
            Agenda de Atención por Departamento y Operativos de Salud
          </h1>
          <p className="text-xs text-slate-500">
            Reserva de horas de atención presencial en Casa Central CMDS (con notificación WhatsApp/Email) y gestión de cupos de Campañas Clínicas APS.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <button
            onClick={() => setShowNewCitaModal(true)}
            className="px-3.5 py-2 rounded-lg bg-[#016098] hover:bg-[#014b76] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Agendar Hora de Atención
          </button>
          <button
            onClick={() => setShowNewCupoModal(true)}
            className="px-3.5 py-2 rounded-lg bg-[#39BABD] hover:bg-[#2da3a6] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            + Inscribir Paciente Campaña
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
          <p className="text-xs text-slate-500 font-semibold uppercase">Solicitudes de Hora</p>
          <p className="text-2xl font-extrabold text-slate-800 mt-1">{solicitudes.length}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Tabla adm_obs.obs_datos_solicitud</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-blue-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Citas Confirmadas</p>
          <p className="text-2xl font-extrabold text-blue-600 mt-1">{confirmadas}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Con aviso WhatsApp / Correo enviado</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-emerald-500">
          <p className="text-xs text-slate-500 font-semibold uppercase">Atenciones Realizadas</p>
          <p className="text-2xl font-extrabold text-emerald-600 mt-1">{atendidas}</p>
          <p className="text-[11px] text-slate-400 mt-0.5">Atendidas por departamento</p>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 border-l-4 border-l-[#39BABD]">
          <p className="text-xs text-slate-500 font-semibold uppercase">Campañas Salud Activas</p>
          <p className="text-2xl font-extrabold text-[#016098] mt-1">
            {campanas.length}{' '}
            <span className="text-xs font-bold text-slate-400">({totalCuposCampana} cupos)</span>
          </p>
          <p className="text-[11px] text-slate-400 mt-0.5">UAPO, Mamografía y Odontología</p>
        </div>
      </div>

      {/* Pestañas */}
      <div className="flex flex-wrap gap-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('citas')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'citas'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Agenda de Atención por Departamento ({solicitudes.length})
        </button>
        <button
          onClick={() => setActiveTab('campanas')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'campanas'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Campañas y Operativos de Salud ({campanas.length})
        </button>
        <button
          onClick={() => setActiveTab('pacientes')}
          className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
            activeTab === 'pacientes'
              ? 'bg-[#016098] text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          Fichas de Pacientes Inscritos ({pacientes.length})
        </button>
      </div>

      {activeTab === 'citas' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200 grid grid-cols-1 md:grid-cols-4 gap-3">
            <input
              type="text"
              placeholder="Buscar por RUT, nombre o código de reserva..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            />
            <select
              value={filtroDepa}
              onChange={(e) => setFiltroDepa(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Departamentos</option>
              {catalogos.departamentos.map((d: any) => (
                <option key={d.DEPA_SEC} value={d.DEPA_SEC}>
                  {d.DEPA_NOMBRE}
                </option>
              ))}
            </select>
            <select
              value={filtroEstado}
              onChange={(e) => setFiltroEstado(e.target.value)}
              className="px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white"
            >
              <option value="">Todos los Estados</option>
              <option value="CONFIRMADO">CONFIRMADO</option>
              <option value="PENDIENTE">PENDIENTE</option>
              <option value="ATENDIDO">ATENDIDO</option>
            </select>
            <button
              onClick={() => {
                setFiltroDepa('');
                setFiltroEstado('');
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
                  <th className="py-3 px-4">Ticket / Hora</th>
                  <th className="py-3 px-4">Solicitante / RUT</th>
                  <th className="py-3 px-4">Departamento Destino</th>
                  <th className="py-3 px-4">Motivo de Atención</th>
                  <th className="py-3 px-3">Notificación</th>
                  <th className="py-3 px-3 text-center">Estado</th>
                  <th className="py-3 px-4 text-center">Acción</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={7} className="py-8 text-center text-slate-400">
                      Cargando agenda de atención desde PostgreSQL...
                    </td>
                  </tr>
                ) : (
                  solicitudes.map((s) => (
                    <tr key={s.DASO_SEC} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-4">
                        <div className="font-mono font-bold text-[#016098]">{s.DASO_ID_UNICO}</div>
                        <div className="text-[11px] font-semibold text-slate-700">
                          {s.FECHA_ATENCION} · {s.DAHO_HORA} hrs
                        </div>
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-bold text-slate-800">{s.SOLICITANTE}</div>
                        <div className="text-[11px] text-slate-400">
                          RUT: {s.DASO_RUT}-{s.DASO_DV} · {s.DASO_CELULAR}
                        </div>
                      </td>
                      <td className="py-3 px-4 font-semibold text-slate-700">{s.DEPARTAMENTO}</td>
                      <td className="py-3 px-4 max-w-xs text-slate-600">{s.DASO_OBSERV}</td>
                      <td className="py-3 px-3">
                        <div className="flex items-center gap-1.5">
                          <span className="px-2 py-0.5 rounded bg-emerald-50 text-emerald-700 text-[10px] font-bold border border-emerald-200">
                            WSP: {s.DASO_FLAG_ENVIO_WSP}
                          </span>
                          <span className="px-2 py-0.5 rounded bg-blue-50 text-blue-700 text-[10px] font-bold border border-blue-200">
                            Mail: {s.DASO_FLAG_ENVIO_EMAIL}
                          </span>
                        </div>
                      </td>
                      <td className="py-3 px-3 text-center">
                        <span
                          className={`inline-block px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${badgeEstado(
                            s.DASO_ESTADO
                          )}`}
                        >
                          {s.DASO_ESTADO}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-center">
                        {s.DASO_ESTADO !== 'ATENDIDO' && (
                          <button
                            onClick={() => handleUpdateCita(s.DASO_SEC, 'ATENDIDO')}
                            className="px-2.5 py-1 rounded-md bg-emerald-600 hover:bg-emerald-700 text-white text-[11px] font-bold transition-colors cursor-pointer"
                          >
                            Marcar Atendido
                          </button>
                        )}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'campanas' && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {campanas.map((c: any) => (
            <div key={c.CAMP_SEC} className="bg-white rounded-xl p-5 shadow-sm border border-slate-200 flex flex-col justify-between space-y-4">
              <div>
                <div className="flex items-center justify-between">
                  <span className="font-mono text-xs font-bold text-[#016098]">Campaña #{c.CAMP_SEC}</span>
                  <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                    {c.CAMP_ESTADO}
                  </span>
                </div>
                <h3 className="text-sm font-bold text-slate-800 mt-2">{c.CAMP_DESC}</h3>
                <p className="text-xs text-slate-500 mt-1">
                  Vigencia: {c.FECHA_INICIO} al {c.FECHA_FIN}
                </p>
              </div>
              <div className="pt-3 border-t border-slate-100 flex items-center justify-between text-xs">
                <span className="text-slate-500">Cupos Habilitados: <strong>{c.CAMP_CNT_CUPO}</strong></span>
                <span className="font-bold text-[#016098]">Inscritos: {c.CUPOS_OCUPADOS}</span>
              </div>
            </div>
          ))}
        </div>
      )}

      {activeTab === 'pacientes' && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="p-4 bg-slate-50 border-b border-slate-200">
            <h3 className="text-sm font-bold text-slate-800">
              Pacientes Inscritos en Operativos de Salud (SAL_FICHA_PACIENTE)
            </h3>
          </div>
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-slate-100 text-slate-600 uppercase text-[11px] border-b border-slate-200">
                <th className="py-3 px-4">Cupo #</th>
                <th className="py-3 px-4">Paciente / RUT</th>
                <th className="py-3 px-3">Edad / Género</th>
                <th className="py-3 px-4">Especialidad</th>
                <th className="py-3 px-4">Campaña</th>
                <th className="py-3 px-4">Dirección / Contacto</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {pacientes.map((p: any) => (
                <tr key={`${p.CAMP_SEC}-${p.CACU_NRO_ATENCION}`} className="hover:bg-slate-50">
                  <td className="py-2.5 px-4 font-mono font-bold text-[#016098]">#{p.CACU_NRO_ATENCION}</td>
                  <td className="py-2.5 px-4">
                    <div className="font-bold text-slate-800">{p.PACIENTE}</div>
                    <div className="text-[11px] text-slate-400">
                      {p.FIPA_RUT}-{p.FIPA_DV}
                    </div>
                  </td>
                  <td className="py-2.5 px-3">
                    {p.FIPA_EDAD} años · {p.FIPA_GENERO}
                  </td>
                  <td className="py-2.5 px-4 font-semibold text-[#016098]">{p.ESPECIALIDAD}</td>
                  <td className="py-2.5 px-4 text-slate-700">{p.CAMPANA_DESC}</td>
                  <td className="py-2.5 px-4 text-slate-500">
                    {p.FIPA_DIRECCION} · {p.FIPA_CELULAR}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Modal Agendar Cita */}
      {showNewCitaModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#016098] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Agendar Nueva Hora de Atención</h3>
              <button onClick={() => setShowNewCitaModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateCita} className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div className="sm:col-span-2">
                  <label className="block font-bold text-slate-700 mb-1">RUT Solicitante (sin puntos) *</label>
                  <input
                    type="number"
                    required
                    placeholder="Ej: 15432890"
                    value={citaForm.rut}
                    onChange={(e) => setCitaForm({ ...citaForm, rut: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">DV *</label>
                  <input
                    type="text"
                    maxLength={1}
                    required
                    value={citaForm.dv}
                    onChange={(e) => setCitaForm({ ...citaForm, dv: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Nombres *</label>
                  <input
                    type="text"
                    required
                    value={citaForm.nombre}
                    onChange={(e) => setCitaForm({ ...citaForm, nombre: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Apellido Paterno *</label>
                  <input
                    type="text"
                    required
                    value={citaForm.apePat}
                    onChange={(e) => setCitaForm({ ...citaForm, apePat: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Apellido Materno</label>
                  <input
                    type="text"
                    value={citaForm.apeMat}
                    onChange={(e) => setCitaForm({ ...citaForm, apeMat: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Departamento</label>
                  <select
                    value={citaForm.depaSec}
                    onChange={(e) => setCitaForm({ ...citaForm, depaSec: Number(e.target.value) })}
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
                  <label className="block font-bold text-slate-700 mb-1">Fecha Atención</label>
                  <input
                    type="date"
                    value={citaForm.fechaAtencion}
                    onChange={(e) => setCitaForm({ ...citaForm, fechaAtencion: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Bloque Horario</label>
                  <select
                    value={citaForm.hora}
                    onChange={(e) => setCitaForm({ ...citaForm, hora: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.bloquesHora.map((b: any) => (
                      <option key={b.DAHO_NRO} value={b.DAHO_HORA}>
                        {b.DAHO_HORA} hrs
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">Motivo / Observación de la Consulta</label>
                <textarea
                  rows={2}
                  value={citaForm.observacion}
                  onChange={(e) => setCitaForm({ ...citaForm, observacion: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowNewCitaModal(false)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#016098] text-white font-bold cursor-pointer"
                >
                  Reservar Hora en PostgreSQL
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal Inscribir Paciente Campaña */}
      {showNewCupoModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-xl max-w-xl w-full overflow-hidden">
            <div className="p-4 bg-[#39BABD] text-white flex items-center justify-between">
              <h3 className="text-sm font-bold">Inscribir Paciente en Operativo / Campaña de Salud</h3>
              <button onClick={() => setShowNewCupoModal(false)} className="text-white/80 hover:text-white cursor-pointer">
                ✕
              </button>
            </div>
            <form onSubmit={handleCreateCupo} className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Campaña Activa</label>
                  <select
                    value={cupoForm.campSec}
                    onChange={(e) => setCupoForm({ ...cupoForm, campSec: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {campanas.map((c: any) => (
                      <option key={c.CAMP_SEC} value={c.CAMP_SEC}>
                        {c.CAMP_DESC}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Especialidad</label>
                  <select
                    value={cupoForm.espeCod}
                    onChange={(e) => setCupoForm({ ...cupoForm, espeCod: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  >
                    {catalogos.especialidades.map((es: any) => (
                      <option key={es.ESPE_COD} value={es.ESPE_COD}>
                        {es.ESPE_DESC}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">RUT Paciente *</label>
                  <input
                    type="number"
                    required
                    value={cupoForm.rut}
                    onChange={(e) => setCupoForm({ ...cupoForm, rut: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Nombres *</label>
                  <input
                    type="text"
                    required
                    value={cupoForm.nombres}
                    onChange={(e) => setCupoForm({ ...cupoForm, nombres: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Apellido Paterno *</label>
                  <input
                    type="text"
                    required
                    value={cupoForm.apePat}
                    onChange={(e) => setCupoForm({ ...cupoForm, apePat: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Edad</label>
                  <input
                    type="number"
                    value={cupoForm.edad}
                    onChange={(e) => setCupoForm({ ...cupoForm, edad: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
                <div className="sm:col-span-2">
                  <label className="block font-bold text-slate-700 mb-1">Dirección / Domicilio</label>
                  <input
                    type="text"
                    value={cupoForm.direccion}
                    onChange={(e) => setCupoForm({ ...cupoForm, direccion: e.target.value })}
                    className="w-full px-3 py-2 rounded-lg border border-slate-300"
                  />
                </div>
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowNewCupoModal(false)}
                  className="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 font-semibold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-[#39BABD] text-white font-bold cursor-pointer"
                >
                  Asignar Cupo en PostgreSQL
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
