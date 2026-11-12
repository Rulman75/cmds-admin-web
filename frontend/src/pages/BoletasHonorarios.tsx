import React, { useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios';
import {
  exportToExcel,
  exportToCorporatePDF,
  formatCurrencyCLP
} from '../utils/exportUtils';

const BADGE_ESTADO: Record<string, string> = {
  PAGADA: 'bg-emerald-100 text-emerald-800 border-emerald-200',
  APROBADA: 'bg-blue-100 text-[#016098] border-blue-200',
  VIGENTE: 'bg-amber-100 text-amber-800 border-amber-200',
  RECHAZADA: 'bg-rose-100 text-rose-800 border-rose-200'
};

export default function BoletasHonorarios() {
  const location = useLocation();
  const navigate = useNavigate();
  const vistaActiva = location.pathname.includes('/funcionarios') ? 'funcionarios' : 'bandeja';

  const [filtrosCat, setFiltrosCat] = useState<any>({
    sectores: [],
    periodos: [],
    unidades: [],
    cecos: [],
    actividades: [],
    convenios: [],
    formaciones: [],
    bancos: []
  });

  // Filtros Bandeja Boletas
  const [periodo, setPeriodo] = useState('202610');
  const [sectSec, setSectSec] = useState('');
  const [estado, setEstado] = useState('');
  const [unidad, setUnidad] = useState('');
  const [ceco, setCeco] = useState('');
  const [convenio, setConvenio] = useState('');
  const [search, setSearch] = useState('');
  const [limit, setLimit] = useState('100');

  const [boletas, setBoletas] = useState<any[]>([]);
  const [loadingBoletas, setLoadingBoletas] = useState(false);

  // Detalle Modal
  const [detalleModal, setDetalleModal] = useState<any | null>(null);
  const [loadingDetalle, setLoadingDetalle] = useState(false);

  // Nueva Boleta Modal
  const [nuevaModal, setNuevaModal] = useState(false);
  const [nuevaForm, setNuevaForm] = useState({
    rut: '',
    funcionario: '',
    email: '',
    periodo: '202610',
    sectSec: '21',
    nroDocto: '',
    fechaDocto: new Date().toISOString().slice(0, 10),
    horas: '44',
    montoBruto: '',
    codUnidad: '0018',
    actiCodigo: '006',
    cecoCod: '8-02-000',
    convCodigo: '090',
    detalle: 'PRESTACIÓN DE SERVICIOS PROFESIONALES SEGÚN CONVENIO VIGENTE'
  });

  // Vista Funcionarios BHO
  const [searchFunc, setSearchFunc] = useState('');
  const [sectFunc, setSectFunc] = useState('');
  const [funcionarios, setFuncionarios] = useState<any[]>([]);
  const [loadingFunc, setLoadingFunc] = useState(false);

  // Mensaje feedback
  const [alerta, setAlerta] = useState<{ tipo: 'ok' | 'err'; texto: string } | null>(null);

  const mostrarAlerta = (tipo: 'ok' | 'err', texto: string) => {
    setAlerta({ tipo, texto });
    setTimeout(() => setAlerta(null), 5000);
  };

  useEffect(() => {
    axios
      .get('/api/boletas/filtros')
      .then((res) => {
        if (res.data.status === 'ok') {
          setFiltrosCat(res.data.data);
        }
      })
      .catch(() => {});
  }, []);

  const cargarBoletas = async () => {
    setLoadingBoletas(true);
    try {
      const res = await axios.get('/api/boletas', {
        params: { periodo, sectSec, estado, unidad, ceco, convenio, search, limit }
      });
      if (res.data.status === 'ok') {
        setBoletas(res.data.data);
      }
    } catch (err) {
      console.error('Error cargando boletas:', err);
    } finally {
      setLoadingBoletas(false);
    }
  };

  const cargarFuncionarios = async () => {
    setLoadingFunc(true);
    try {
      const res = await axios.get('/api/boletas/funcionarios', {
        params: { search: searchFunc, sectSec: sectFunc, limit: 150 }
      });
      if (res.data.status === 'ok') {
        setFuncionarios(res.data.data);
      }
    } catch (err) {
      console.error('Error cargando funcionarios:', err);
    } finally {
      setLoadingFunc(false);
    }
  };

  useEffect(() => {
    if (vistaActiva === 'bandeja') {
      cargarBoletas();
    } else {
      cargarFuncionarios();
    }
  }, [vistaActiva, periodo, sectSec, estado, unidad, ceco, convenio, limit, sectFunc]);

  const abrirDetalleBoleta = async (boleSec: number) => {
    setLoadingDetalle(true);
    setDetalleModal({ loading: true, boleSec });
    try {
      const res = await axios.get(`/api/boletas/${boleSec}/detalle`);
      if (res.data.status === 'ok') {
        setDetalleModal(res.data.data);
      }
    } catch (err) {
      console.error('Error detalle boleta:', err);
      setDetalleModal(null);
    } finally {
      setLoadingDetalle(false);
    }
  };

  const cambiarEstadoBoleta = async (boleSec: number, nuevoEstado: string) => {
    try {
      const userRaw = localStorage.getItem('user');
      const userObj = userRaw ? JSON.parse(userRaw) : {};
      const res = await axios.put(`/api/boletas/${boleSec}/estado`, {
        nuevoEstado,
        usuario: userObj.rut || '10633447'
      });
      if (res.data.status === 'ok') {
        mostrarAlerta('ok', res.data.message);
        cargarBoletas();
        if (detalleModal?.boleta?.BOLE_SEC && Number(detalleModal.boleta.BOLE_SEC) === boleSec) {
          abrirDetalleBoleta(boleSec);
        }
      }
    } catch (err: any) {
      mostrarAlerta('err', err.response?.data?.message || 'Error al actualizar estado');
    }
  };

  const handleCrearBoleta = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!nuevaForm.rut || !nuevaForm.funcionario || !nuevaForm.nroDocto || !nuevaForm.montoBruto) {
      mostrarAlerta('err', 'Complete RUT, Nombre del Prestador, N° de Boleta y Monto Bruto.');
      return;
    }
    try {
      const unidObj = filtrosCat.unidades.find((u: any) => u.UNID_CODIGO === nuevaForm.codUnidad);
      const sectObj = filtrosCat.sectores.find(
        (s: any) => String(s.SECT_SEC) === String(nuevaForm.sectSec)
      );
      const res = await axios.post('/api/boletas', {
        ...nuevaForm,
        unidadDesc: unidObj?.UNID_DESC || nuevaForm.codUnidad,
        sectorDesc: sectObj?.SECT_DESC || 'SALUD'
      });
      if (res.data.status === 'ok') {
        mostrarAlerta('ok', res.data.message);
        setNuevaModal(false);
        cargarBoletas();
      }
    } catch (err: any) {
      mostrarAlerta('err', err.response?.data?.message || 'Error registrando boleta');
    }
  };

  const totalBruto = boletas.reduce((a, b) => a + Number(b.BOLE_NETO || 0), 0);
  const totalImp = boletas.reduce((a, b) => a + Number(b.BOLE_IMPUESTO || 0), 0);
  const totalLiq = boletas.reduce((a, b) => a + Number(b.BOLE_TOTAL || 0), 0);

  const periodosUnicos = Array.from(
    new Set((filtrosCat.periodos || []).map((p: any) => p.PERI_NOMBRE))
  ) as string[];

  const exportarBoletasExcel = () => {
    exportToExcel(
      boletas.map((b) => ({
        Folio: b.BOLE_SEC,
        Período: b.PERIODO,
        RUT: `${b.FUNC_RUT}-${b.FUNC_DV}`,
        Prestador: b.FUNCIONARIO,
        'N° Boleta': b.BOLE_NRO_DOCTO,
        'Fecha Docto': b.FECHA_DOCTO,
        Estado: b.ESTADO,
        Sector: b.SECTOR_DESC,
        'Cód. Unidad': b.BOLE_UNIDAD,
        Unidad: b.UNIDAD_DESC,
        'Centro Costo': b.BOLE_CECO_COD,
        Convenio: b.CONVENIO_DESC,
        Actividad: b.ACTIVIDAD_DESC,
        Horas: b.BOLE_HORAS,
        'Monto Bruto': b.BOLE_NETO,
        'Retención Impuesto': b.BOLE_IMPUESTO,
        'Monto Líquido': b.BOLE_TOTAL
      })),
      `Boletas_Honorarios_CMDS_${periodo || 'Todos'}`,
      'Boletas Honorarios'
    );
  };

  const exportarBoletasPDF = () => {
    exportToCorporatePDF({
      title: `Nómina de Boletas de Honorarios (${periodo || 'Todos los Períodos'})`,
      subtitle: 'Sistema CMDS ADMIN — Módulo Boletas de Honorarios (ADM_OBS.BHO_BOLETAS)',
      meta: [
        { label: 'Período', value: periodo || 'Todos' },
        { label: 'Estado', value: estado || 'Todos' }
      ],
      kpis: [
        { label: 'Registros Listados', value: boletas.length.toLocaleString('es-CL'), color: 'blue' },
        { label: 'Total Bruto', value: formatCurrencyCLP(totalBruto), color: 'indigo' },
        { label: 'Total Retención', value: formatCurrencyCLP(totalImp), color: 'amber' },
        { label: 'Total Líquido', value: formatCurrencyCLP(totalLiq), color: 'emerald' }
      ],
      columns: [
        { header: 'Folio', key: 'BOLE_SEC', align: 'center' },
        { header: 'Período', key: 'PERIODO', align: 'center' },
        { header: 'RUT', key: 'rutFmt', align: 'left' },
        { header: 'Prestador', key: 'FUNCIONARIO', align: 'left' },
        { header: 'N° Bol.', key: 'BOLE_NRO_DOCTO', align: 'center' },
        { header: 'Fecha', key: 'FECHA_DOCTO', align: 'center' },
        { header: 'Unidad / Establecimiento', key: 'UNIDAD_DESC', align: 'left' },
        { header: 'CECO', key: 'BOLE_CECO_COD', align: 'center' },
        { header: 'Bruto', key: 'brutoFmt', align: 'right' },
        { header: 'Impuesto', key: 'impFmt', align: 'right' },
        { header: 'Líquido', key: 'liqFmt', align: 'right' },
        { header: 'Estado', key: 'ESTADO', align: 'center' }
      ],
      rows: boletas.map((b) => ({
        ...b,
        rutFmt: `${b.FUNC_RUT}-${b.FUNC_DV}`,
        brutoFmt: formatCurrencyCLP(b.BOLE_NETO),
        impFmt: formatCurrencyCLP(b.BOLE_IMPUESTO),
        liqFmt: formatCurrencyCLP(b.BOLE_TOTAL)
      })),
      totalsRow: {
        FUNCIONARIO: 'TOTALES DE LA SELECCIÓN',
        brutoFmt: formatCurrencyCLP(totalBruto),
        impFmt: formatCurrencyCLP(totalImp),
        liqFmt: formatCurrencyCLP(totalLiq)
      }
    });
  };

  return (
    <div className="space-y-5">
      {/* Encabezado y Selector de Sub-Módulo */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-[#016098]/10 text-[#016098] uppercase tracking-wider">
            Módulo 1 · Boletas de Honorarios (`MENU_ID = 2`)
          </span>
          <h1 className="text-xl font-extrabold text-[#1e293b] mt-1">
            {vistaActiva === 'bandeja'
              ? 'Bandeja, Ingreso y Flujo de Aprobación de Boletas de Honorarios'
              : 'Catálogo Maestro de Prestadores / Funcionarios a Honorarios (BHO_FUNCIONARIOS)'}
          </h1>
          <p className="text-xs text-slate-500">
            Reemplaza `blank_dashboard_ingreso_boleta`, `blank_dashboard_boletas`, `BHO_FUNCIONARIOS_grid` y `BHO_FLUJO_ESTADO`
          </p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => navigate('/boletas/bandeja')}
            className={`px-3.5 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
              vistaActiva === 'bandeja'
                ? 'bg-[#016098] text-white shadow-sm'
                : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
            }`}
          >
            Bandeja de Boletas
          </button>
          <button
            onClick={() => navigate('/boletas/funcionarios')}
            className={`px-3.5 py-2 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
              vistaActiva === 'funcionarios'
                ? 'bg-[#016098] text-white shadow-sm'
                : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
            }`}
          >
            Prestadores BHO (2.469)
          </button>
          {vistaActiva === 'bandeja' && (
            <button
              onClick={() => setNuevaModal(true)}
              className="px-3.5 py-2 rounded-lg bg-[#39BABD] hover:bg-[#2da3a6] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
            >
              + Ingresar Boleta
            </button>
          )}
        </div>
      </div>

      {alerta && (
        <div
          className={`p-3.5 rounded-xl border text-xs font-bold flex items-center justify-between ${
            alerta.tipo === 'ok'
              ? 'bg-emerald-50 border-emerald-300 text-emerald-800'
              : 'bg-rose-50 border-rose-300 text-rose-800'
          }`}
        >
          <span>{alerta.texto}</span>
          <button onClick={() => setAlerta(null)} className="text-slate-500 hover:text-slate-800">
            ✕
          </button>
        </div>
      )}

      {vistaActiva === 'bandeja' ? (
        <>
          {/* Panel de Filtros Unificados */}
          <div className="bg-white rounded-xl p-4 border border-gray-200 shadow-sm space-y-3">
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-3">
              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">Período</label>
                <select
                  value={periodo}
                  onChange={(e) => setPeriodo(e.target.value)}
                  className="w-full px-2.5 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#016098]"
                >
                  <option value="">Todos los Períodos</option>
                  {periodosUnicos.map((p) => (
                    <option key={p} value={p}>
                      {p}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">Sector</label>
                <select
                  value={sectSec}
                  onChange={(e) => setSectSec(e.target.value)}
                  className="w-full px-2.5 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#016098]"
                >
                  <option value="">Todos los Sectores</option>
                  {(filtrosCat.sectores || []).map((s: any) => (
                    <option key={s.SECT_SEC} value={s.SECT_SEC}>
                      {s.SECT_DESC}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">
                  Estado (`DM_ESTADO_DOCTO`)
                </label>
                <select
                  value={estado}
                  onChange={(e) => setEstado(e.target.value)}
                  className="w-full px-2.5 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#016098]"
                >
                  <option value="">Todos los Estados</option>
                  <option value="VIGENTE">VIGENTE</option>
                  <option value="APROBADA">APROBADA</option>
                  <option value="PAGADA">PAGADA</option>
                  <option value="RECHAZADA">RECHAZADA</option>
                </select>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">
                  Unidad / Establecimiento
                </label>
                <select
                  value={unidad}
                  onChange={(e) => setUnidad(e.target.value)}
                  className="w-full px-2.5 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#016098]"
                >
                  <option value="">Todas las Unidades</option>
                  {(filtrosCat.unidades || []).map((u: any) => (
                    <option key={u.UNID_CODIGO} value={u.UNID_CODIGO}>
                      {u.UNID_CODIGO} - {u.UNID_DESC}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">
                  Centro de Costo
                </label>
                <select
                  value={ceco}
                  onChange={(e) => setCeco(e.target.value)}
                  className="w-full px-2.5 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#016098]"
                >
                  <option value="">Todos los CECO</option>
                  {(filtrosCat.cecos || []).map((c: any) => (
                    <option key={c.CECO_COD} value={c.CECO_COD}>
                      {c.CECO_COD} - {c.CECO_DESC}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">
                  Buscar RUT / Prestador / N° Bol.
                </label>
                <input
                  type="text"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && cargarBoletas()}
                  placeholder="Ej: 14308375 o GAROTE"
                  className="w-full px-2.5 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#016098]"
                />
              </div>

              <div className="flex items-end gap-1.5">
                <button
                  onClick={cargarBoletas}
                  className="w-full py-1.5 px-3 bg-[#016098] hover:bg-[#024a8d] text-white text-xs font-bold rounded-lg shadow-sm cursor-pointer"
                >
                  Filtrar
                </button>
                <button
                  onClick={() => {
                    setPeriodo('202610');
                    setSectSec('');
                    setEstado('');
                    setUnidad('');
                    setCeco('');
                    setConvenio('');
                    setSearch('');
                  }}
                  className="py-1.5 px-2.5 bg-slate-200 hover:bg-slate-300 text-slate-700 text-xs font-bold rounded-lg cursor-pointer"
                  title="Limpiar filtros"
                >
                  ↺
                </button>
              </div>
            </div>

            {/* Resumen de Totales y Exportación */}
            <div className="pt-3 border-t border-slate-100 flex flex-wrap items-center justify-between gap-3">
              <div className="flex flex-wrap items-center gap-4 text-xs">
                <span>
                  Mostrando: <strong className="text-[#016098]">{boletas.length}</strong> boletas
                </span>
                <span>
                  Total Bruto: <strong className="text-indigo-700">{formatCurrencyCLP(totalBruto)}</strong>
                </span>
                <span>
                  Retención: <strong className="text-amber-700">{formatCurrencyCLP(totalImp)}</strong>
                </span>
                <span>
                  Total Líquido: <strong className="text-emerald-700">{formatCurrencyCLP(totalLiq)}</strong>
                </span>
              </div>

              <div className="flex items-center gap-2">
                <select
                  value={limit}
                  onChange={(e) => setLimit(e.target.value)}
                  className="px-2 py-1 text-xs border border-slate-300 rounded-lg bg-slate-50"
                >
                  <option value="50">50 filas</option>
                  <option value="100">100 filas</option>
                  <option value="250">250 filas</option>
                  <option value="500">500 filas</option>
                </select>
                <button
                  onClick={exportarBoletasExcel}
                  className="px-3 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold cursor-pointer"
                >
                  Excel (.xlsx)
                </button>
                <button
                  onClick={exportarBoletasPDF}
                  className="px-3 py-1.5 rounded-lg bg-[#016098] hover:bg-[#024a8d] text-white text-xs font-bold cursor-pointer"
                >
                  PDF Corporativo
                </button>
              </div>
            </div>
          </div>

          {/* Grilla de Boletas */}
          <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
            {loadingBoletas ? (
              <div className="p-10 text-center">
                <div className="inline-block w-7 h-7 border-4 border-[#016098] border-t-transparent rounded-full animate-spin mb-2"></div>
                <p className="text-xs font-semibold text-slate-600">
                  Consultando `ADM_OBS.BHO_BOLETAS` en Oracle 26ai...
                </p>
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left border-collapse">
                  <thead>
                    <tr className="bg-[#016098] text-white uppercase text-[10px]">
                      <th className="py-2.5 px-3">Folio</th>
                      <th className="py-2.5 px-3">Período</th>
                      <th className="py-2.5 px-3">RUT</th>
                      <th className="py-2.5 px-3">Prestador</th>
                      <th className="py-2.5 px-3 text-center">N° Bol.</th>
                      <th className="py-2.5 px-3 text-center">Fecha</th>
                      <th className="py-2.5 px-3">Sector / Unidad</th>
                      <th className="py-2.5 px-3">CECO / Convenio</th>
                      <th className="py-2.5 px-3 text-right">Bruto</th>
                      <th className="py-2.5 px-3 text-right">Impuesto</th>
                      <th className="py-2.5 px-3 text-right">Líquido</th>
                      <th className="py-2.5 px-3 text-center">Estado</th>
                      <th className="py-2.5 px-3 text-center">Acciones</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-200">
                    {boletas.map((b) => (
                      <tr key={b.BOLE_SEC} className="hover:bg-blue-50/40">
                        <td className="py-2 px-3 font-mono font-bold text-[#016098]">
                          #{b.BOLE_SEC}
                        </td>
                        <td className="py-2 px-3 font-semibold">{b.PERIODO}</td>
                        <td className="py-2 px-3 font-mono whitespace-nowrap">
                          {b.FUNC_RUT}-{b.FUNC_DV}
                        </td>
                        <td className="py-2 px-3 font-semibold text-slate-800">
                          {b.FUNCIONARIO}
                          {b.ACTIVIDAD_DESC && (
                            <span className="block text-[10px] text-slate-500 font-normal">
                              {b.ACTIVIDAD_DESC} ({b.BOLE_HORAS} hrs)
                            </span>
                          )}
                        </td>
                        <td className="py-2 px-3 text-center font-mono font-bold">
                          {b.BOLE_NRO_DOCTO}
                        </td>
                        <td className="py-2 px-3 text-center whitespace-nowrap">{b.FECHA_DOCTO}</td>
                        <td className="py-2 px-3">
                          <span className="font-semibold text-slate-700">{b.SECTOR_DESC}</span>
                          <span className="block text-[10px] text-slate-500">
                            {b.BOLE_UNIDAD} - {b.UNIDAD_DESC}
                          </span>
                        </td>
                        <td className="py-2 px-3">
                          <span className="font-mono font-semibold text-slate-700">
                            {b.BOLE_CECO_COD}
                          </span>
                          <span className="block text-[10px] text-slate-500 truncate max-w-[160px]">
                            {b.CONVENIO_DESC}
                          </span>
                        </td>
                        <td className="py-2 px-3 text-right font-semibold">
                          {formatCurrencyCLP(b.BOLE_NETO)}
                        </td>
                        <td className="py-2 px-3 text-right text-amber-700">
                          {formatCurrencyCLP(b.BOLE_IMPUESTO)}
                        </td>
                        <td className="py-2 px-3 text-right font-bold text-emerald-700">
                          {formatCurrencyCLP(b.BOLE_TOTAL)}
                        </td>
                        <td className="py-2 px-3 text-center">
                          <span
                            className={`px-2 py-0.5 rounded-full text-[10px] font-bold border ${
                              BADGE_ESTADO[b.ESTADO] || 'bg-slate-100 text-slate-700'
                            }`}
                          >
                            {b.ESTADO}
                          </span>
                        </td>
                        <td className="py-2 px-3 text-center whitespace-nowrap">
                          <div className="inline-flex items-center gap-1">
                            <button
                              onClick={() => abrirDetalleBoleta(Number(b.BOLE_SEC))}
                              className="px-2 py-1 rounded bg-[#016098] hover:bg-[#024a8d] text-white text-[10px] font-bold cursor-pointer"
                              title="Ver Expediente y Flujo de Estados"
                            >
                              Expediente
                            </button>
                            {b.ESTADO === 'VIGENTE' && (
                              <button
                                onClick={() => cambiarEstadoBoleta(Number(b.BOLE_SEC), 'APROBADA')}
                                className="px-2 py-1 rounded bg-emerald-600 hover:bg-emerald-700 text-white text-[10px] font-bold cursor-pointer"
                                title="Aprobar Boleta"
                              >
                                Aprobar
                              </button>
                            )}
                            {b.ESTADO === 'APROBADA' && (
                              <button
                                onClick={() => cambiarEstadoBoleta(Number(b.BOLE_SEC), 'PAGADA')}
                                className="px-2 py-1 rounded bg-[#39BABD] hover:bg-[#2da3a6] text-white text-[10px] font-bold cursor-pointer"
                                title="Marcar como Pagada"
                              >
                                Pagar
                              </button>
                            )}
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </>
      ) : (
        /* VISTA PRESTADORES / FUNCIONARIOS A HONORARIOS (BHO_FUNCIONARIOS) */
        <div className="space-y-4">
          <div className="bg-white rounded-xl p-4 border border-gray-200 shadow-sm flex flex-wrap items-end justify-between gap-3">
            <div className="flex flex-wrap items-end gap-3">
              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">
                  Buscar RUT o Nombre Prestador
                </label>
                <input
                  type="text"
                  value={searchFunc}
                  onChange={(e) => setSearchFunc(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && cargarFuncionarios()}
                  placeholder="Ej: 14308375 o GAROTE"
                  className="w-64 px-3 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50"
                />
              </div>
              <div>
                <label className="block text-[11px] font-bold text-slate-600 mb-1">Sector</label>
                <select
                  value={sectFunc}
                  onChange={(e) => setSectFunc(e.target.value)}
                  className="px-3 py-1.5 text-xs border border-slate-300 rounded-lg bg-slate-50"
                >
                  <option value="">Todos los Sectores</option>
                  {(filtrosCat.sectores || []).map((s: any) => (
                    <option key={s.SECT_SEC} value={s.SECT_SEC}>
                      {s.SECT_DESC}
                    </option>
                  ))}
                </select>
              </div>
              <button
                onClick={cargarFuncionarios}
                className="px-4 py-1.5 rounded-lg bg-[#016098] hover:bg-[#024a8d] text-white text-xs font-bold cursor-pointer"
              >
                Buscar Prestador
              </button>
            </div>

            <button
              onClick={() =>
                exportToExcel(funcionarios, 'Prestadores_Honorarios_BHO_CMDS', 'Funcionarios BHO')
              }
              className="px-3.5 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold cursor-pointer"
            >
              Exportar Prestadores Excel (.xlsx)
            </button>
          </div>

          <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
            {loadingFunc ? (
              <div className="p-10 text-center text-xs font-semibold text-slate-600">
                Consultando `ADM_OBS.BHO_FUNCIONARIOS`...
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left border-collapse">
                  <thead>
                    <tr className="bg-[#016098] text-white uppercase text-[10px]">
                      <th className="py-2.5 px-3">ID</th>
                      <th className="py-2.5 px-3">RUT</th>
                      <th className="py-2.5 px-3">Nombre Completo</th>
                      <th className="py-2.5 px-3">Formación / Profesión</th>
                      <th className="py-2.5 px-3">Sector</th>
                      <th className="py-2.5 px-3">Banco / Tipo Cuenta</th>
                      <th className="py-2.5 px-3">N° Cuenta</th>
                      <th className="py-2.5 px-3">Correo Electrónico</th>
                      <th className="py-2.5 px-3 text-center">Boletas</th>
                      <th className="py-2.5 px-3 text-center">Estado</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-200">
                    {funcionarios.map((f) => (
                      <tr key={f.FUNC_SEC} className="hover:bg-blue-50/40">
                        <td className="py-2 px-3 font-mono font-bold text-[#016098]">
                          #{f.FUNC_SEC}
                        </td>
                        <td className="py-2 px-3 font-mono whitespace-nowrap">
                          {f.FUNC_RUT}-{f.FUNC_DV}
                        </td>
                        <td className="py-2 px-3 font-semibold text-slate-800">
                          {f.NOMBRE_COMPLETO}
                        </td>
                        <td className="py-2 px-3">{f.FUNC_FORMACION || f.FUNC_COD_FORMACION}</td>
                        <td className="py-2 px-3 font-semibold text-slate-700">
                          {f.SECTOR_DESC || f.FUNC_SECTOR}
                        </td>
                        <td className="py-2 px-3">
                          {f.FUNC_BANCO} · <span className="text-slate-500">{f.FUNC_TIPO_CTA}</span>
                        </td>
                        <td className="py-2 px-3 font-mono">{f.FUNC_NRO_CTA}</td>
                        <td className="py-2 px-3 text-slate-600">{f.FUNC_MAIL}</td>
                        <td className="py-2 px-3 text-center font-bold text-[#016098]">
                          {f.TOTAL_BOLETAS}
                        </td>
                        <td className="py-2 px-3 text-center">
                          <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                            {f.FUNC_ESTADO === 'ESTA1' ? 'ACTIVO' : f.FUNC_ESTADO || 'ACTIVO'}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      )}

      {/* MODAL DETALLE DE BOLETA Y TRAZABILIDAD (BHO_FLUJO_ESTADO + BHO_EVIDENCIA) */}
      {detalleModal && (
        <div className="fixed inset-0 bg-slate-900/60 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl border border-slate-200">
            <div className="bg-[#016098] text-white px-6 py-4 flex items-center justify-between rounded-t-2xl">
              <div>
                <h3 className="text-base font-extrabold">
                  Expediente de Boleta de Honorarios #{detalleModal.boleta?.BOLE_SEC || detalleModal.boleSec}
                </h3>
                <p className="text-xs text-blue-200">
                  Trazabilidad completa en `ADM_OBS.BHO_BOLETAS`, `BHO_FLUJO_ESTADO` y `BHO_EVIDENCIA`
                </p>
              </div>
              <button
                onClick={() => setDetalleModal(null)}
                className="text-white/80 hover:text-white text-lg font-bold cursor-pointer"
              >
                ✕
              </button>
            </div>

            {loadingDetalle || !detalleModal.boleta ? (
              <div className="p-10 text-center text-xs font-semibold text-slate-600">
                Cargando historial y respaldos de la boleta...
              </div>
            ) : (
              <div className="p-6 space-y-6 text-xs">
                {/* Datos Principales */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 bg-slate-50 p-4 rounded-xl border border-slate-200">
                  <div>
                    <div className="text-[10px] font-bold text-slate-500 uppercase">Prestador</div>
                    <div className="text-sm font-extrabold text-slate-800 mt-0.5">
                      {detalleModal.boleta.FUNCIONARIO}
                    </div>
                    <div className="text-slate-600 font-mono">
                      RUT: {detalleModal.boleta.FUNC_RUT}-{detalleModal.boleta.FUNC_DV}
                    </div>
                    <div className="text-slate-500 mt-1">{detalleModal.boleta.FUNC_MAIL}</div>
                  </div>
                  <div>
                    <div className="text-[10px] font-bold text-slate-500 uppercase">
                      Imputación y Unidad
                    </div>
                    <div className="font-bold text-[#016098] mt-0.5">
                      {detalleModal.boleta.SECTOR_DESC} · {detalleModal.boleta.UNIDAD_DESC}
                    </div>
                    <div className="text-slate-600">
                      CECO: <strong>{detalleModal.boleta.BOLE_CECO_COD}</strong> ({detalleModal.boleta.CECO_DESC})
                    </div>
                    <div className="text-slate-600">
                      Convenio: <strong>{detalleModal.boleta.CONVENIO_DESC}</strong>
                    </div>
                  </div>
                  <div>
                    <div className="text-[10px] font-bold text-slate-500 uppercase">
                      Montos y Documento
                    </div>
                    <div className="font-bold text-slate-800 mt-0.5">
                      Boleta N° {detalleModal.boleta.BOLE_NRO_DOCTO} · Período {detalleModal.boleta.PERIODO}
                    </div>
                    <div className="text-slate-600">
                      Bruto: <strong>{formatCurrencyCLP(detalleModal.boleta.BOLE_NETO)}</strong> | Imp:{' '}
                      <strong>{formatCurrencyCLP(detalleModal.boleta.BOLE_IMPUESTO)}</strong>
                    </div>
                    <div className="text-sm font-extrabold text-emerald-700 mt-0.5">
                      Líquido: {formatCurrencyCLP(detalleModal.boleta.BOLE_TOTAL)}
                    </div>
                  </div>
                </div>

                {/* Glosa / Detalle de Actividad */}
                <div className="bg-white p-3.5 rounded-xl border border-slate-200">
                  <div className="text-[10px] font-bold text-slate-500 uppercase mb-1">
                    Glosa / Detalle de Prestación (`BOLE_DETALLE`)
                  </div>
                  <p className="text-slate-700">
                    {detalleModal.boleta.BOLE_DETALLE ||
                      detalleModal.boleta.ACTIVIDAD_DESC ||
                      'Sin glosa adicional registrada.'}
                  </p>
                </div>

                {/* Botonera de Cambio de Estado */}
                <div className="flex flex-wrap items-center justify-between gap-3 bg-blue-50/60 p-3.5 rounded-xl border border-blue-200">
                  <div>
                    <span className="font-bold text-slate-700">Estado Actual: </span>
                    <span
                      className={`px-2.5 py-0.5 rounded-full text-[11px] font-bold border ${
                        BADGE_ESTADO[detalleModal.boleta.ESTADO] || 'bg-slate-100'
                      }`}
                    >
                      {detalleModal.boleta.ESTADO}
                    </span>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="text-[11px] text-slate-600 font-semibold">
                      Cambiar estado en flujo:
                    </span>
                    {['VIGENTE', 'APROBADA', 'PAGADA', 'RECHAZADA'].map((est) => (
                      <button
                        key={est}
                        onClick={() =>
                          cambiarEstadoBoleta(Number(detalleModal.boleta.BOLE_SEC), est)
                        }
                        className={`px-2.5 py-1 rounded-lg text-[11px] font-bold cursor-pointer transition-colors ${
                          detalleModal.boleta.ESTADO === est
                            ? 'bg-[#016098] text-white'
                            : 'bg-white border border-slate-300 text-slate-700 hover:bg-slate-100'
                        }`}
                      >
                        {est}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Bitácora de Flujo de Estado (BHO_FLUJO_ESTADO) */}
                <div>
                  <h4 className="text-xs font-extrabold text-[#1e293b] uppercase mb-2">
                    Historial de Estados (`ADM_OBS.BHO_FLUJO_ESTADO`)
                  </h4>
                  <div className="overflow-x-auto border border-slate-200 rounded-xl">
                    <table className="w-full text-xs text-left border-collapse">
                      <thead>
                        <tr className="bg-slate-100 text-slate-700 uppercase text-[10px]">
                          <th className="py-2 px-3">ID Flujo</th>
                          <th className="py-2 px-3">Estado</th>
                          <th className="py-2 px-3">Fecha Inicio</th>
                          <th className="py-2 px-3">Fecha Término</th>
                          <th className="py-2 px-3">Usuario Registro</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-slate-100">
                        {(detalleModal.flujoEstados || []).map((fl: any) => (
                          <tr key={fl.FEST_SEC}>
                            <td className="py-2 px-3 font-mono">#{fl.FEST_SEC}</td>
                            <td className="py-2 px-3 font-bold text-[#016098]">{fl.FEST_ESTADO}</td>
                            <td className="py-2 px-3">{fl.FECHA_INI}</td>
                            <td className="py-2 px-3">{fl.FECHA_TER || 'Vigente'}</td>
                            <td className="py-2 px-3 font-mono">{fl.FEST_USER_ING}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

                {/* Evidencias Vinculadas */}
                <div>
                  <h4 className="text-xs font-extrabold text-[#1e293b] uppercase mb-2">
                    Expedientes de Evidencia Asociados (`ADM_OBS.BHO_EVIDENCIA`)
                  </h4>
                  {detalleModal.evidencias?.length ? (
                    <div className="overflow-x-auto border border-slate-200 rounded-xl">
                      <table className="w-full text-xs text-left border-collapse">
                        <thead>
                          <tr className="bg-slate-100 text-slate-700 uppercase text-[10px]">
                            <th className="py-2 px-3">ID Evidencia</th>
                            <th className="py-2 px-3">Estado Visación</th>
                            <th className="py-2 px-3">Firma 1 (CESFAM)</th>
                            <th className="py-2 px-3">Firma 2 (Ref. Técnico)</th>
                            <th className="py-2 px-3 text-center">Documentos</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-100">
                          {detalleModal.evidencias.map((ev: any) => (
                            <tr key={ev.EVIA_SEC}>
                              <td className="py-2 px-3 font-mono font-bold text-[#016098]">
                                #{ev.EVIA_SEC}
                              </td>
                              <td className="py-2 px-3 font-semibold">{ev.ESTADO_DESC}</td>
                              <td className="py-2 px-3">
                                {ev.EVIA_USER_FIRMA_1
                                  ? `${ev.EVIA_USER_FIRMA_1} (${ev.FECH_FIRMA_1})`
                                  : 'Pendiente'}
                              </td>
                              <td className="py-2 px-3">
                                {ev.EVIA_USER_FIRMA_2
                                  ? `${ev.EVIA_USER_FIRMA_2} (${ev.FECH_FIRMA_2})`
                                  : 'Pendiente'}
                              </td>
                              <td className="py-2 px-3 text-center font-bold">{ev.CANT_DOCS}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  ) : (
                    <p className="text-slate-500 italic">
                      No se registran expedientes en `BHO_EVIDENCIA` para este N° de boleta.
                    </p>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* MODAL NUEVA BOLETA DE HONORARIOS */}
      {nuevaModal && (
        <div className="fixed inset-0 bg-slate-900/60 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl max-w-2xl w-full shadow-2xl border border-slate-200 overflow-hidden">
            <div className="bg-[#016098] text-white px-6 py-4 flex items-center justify-between">
              <div>
                <h3 className="text-base font-extrabold">Ingresar Nueva Boleta de Honorarios</h3>
                <p className="text-xs text-blue-200">
                  Registro directo en el flujo `BHO_BOLETAS` + `BHO_FLUJO_ESTADO`
                </p>
              </div>
              <button
                onClick={() => setNuevaModal(false)}
                className="text-white/80 hover:text-white text-lg font-bold cursor-pointer"
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleCrearBoleta} className="p-6 space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">RUT Prestador *</label>
                  <input
                    type="text"
                    value={nuevaForm.rut}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, rut: e.target.value })}
                    placeholder="Ej: 14308375-6"
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                    required
                  />
                </div>
                <div className="sm:col-span-2">
                  <label className="block font-bold text-slate-700 mb-1">
                    Nombre Completo Prestador *
                  </label>
                  <input
                    type="text"
                    value={nuevaForm.funcionario}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, funcionario: e.target.value })}
                    placeholder="Ej: JESSICA GAROTE"
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                    required
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-4 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Período *</label>
                  <input
                    type="text"
                    value={nuevaForm.periodo}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, periodo: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">N° Boleta SII *</label>
                  <input
                    type="text"
                    value={nuevaForm.nroDocto}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, nroDocto: e.target.value })}
                    placeholder="Ej: 485"
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                    required
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Fecha Emisión</label>
                  <input
                    type="date"
                    value={nuevaForm.fechaDocto}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, fechaDocto: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Monto Bruto ($) *</label>
                  <input
                    type="number"
                    value={nuevaForm.montoBruto}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, montoBruto: e.target.value })}
                    placeholder="Ej: 450000"
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg font-bold text-[#016098]"
                    required
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Sector</label>
                  <select
                    value={nuevaForm.sectSec}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, sectSec: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  >
                    {(filtrosCat.sectores || []).map((s: any) => (
                      <option key={s.SECT_SEC} value={s.SECT_SEC}>
                        {s.SECT_DESC}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Unidad</label>
                  <select
                    value={nuevaForm.codUnidad}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, codUnidad: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  >
                    {(filtrosCat.unidades || []).map((u: any) => (
                      <option key={u.UNID_CODIGO} value={u.UNID_CODIGO}>
                        {u.UNID_CODIGO} - {u.UNID_DESC}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Centro de Costo</label>
                  <select
                    value={nuevaForm.cecoCod}
                    onChange={(e) => setNuevaForm({ ...nuevaForm, cecoCod: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  >
                    {(filtrosCat.cecos || []).map((c: any) => (
                      <option key={c.CECO_COD} value={c.CECO_COD}>
                        {c.CECO_COD} - {c.CECO_DESC}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">
                  Glosa / Descripción de la Prestación
                </label>
                <textarea
                  rows={2}
                  value={nuevaForm.detalle}
                  onChange={(e) => setNuevaForm({ ...nuevaForm, detalle: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setNuevaModal(false)}
                  className="px-4 py-2 rounded-lg bg-slate-200 text-slate-700 font-bold cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 rounded-lg bg-[#016098] hover:bg-[#024a8d] text-white font-bold shadow cursor-pointer"
                >
                  Guardar Boleta
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
