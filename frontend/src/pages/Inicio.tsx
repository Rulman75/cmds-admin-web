import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import {
  exportToExcel,
  exportToCorporatePDF,
  formatCurrencyCLP
} from '../utils/exportUtils';
import {
  PieChart,
  Pie,
  Cell,
  Tooltip as RechartsTooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Legend
} from 'recharts';

const COLORS_ESTADO: Record<string, string> = {
  PAGADA: '#10b981',
  APROBADA: '#016098',
  VIGENTE: '#f59e0b',
  RECHAZADA: '#EB567F'
};

export default function Inicio() {
  const [stats, setStats] = useState<any | null>(null);
  const [loading, setLoading] = useState(true);
  const [year, setYear] = useState('');

  const fetchStats = async (selectedYear = year) => {
    setLoading(true);
    try {
      const url = selectedYear
        ? `/api/dashboard/inicio-stats?year=${selectedYear}`
        : '/api/dashboard/inicio-stats';
      const res = await axios.get(url);
      if (res.data.status === 'ok') {
        setStats(res.data.data);
      }
    } catch (err) {
      console.error('Error al obtener estadísticas de inicio', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStats(year);
  }, [year]);

  const handleExportRecientesExcel = () => {
    if (!stats?.recientes?.length) return;
    exportToExcel(
      stats.recientes.map((r: any) => ({
        'Folio Interno': r.boleSec,
        RUT: r.rut,
        Funcionario: r.funcionario,
        Período: r.periodo,
        'N° Boleta': r.nroDocto,
        'Fecha Docto': r.fechaDocto,
        Estado: r.estado,
        'Monto Bruto': r.montoBruto,
        'Retención Impuesto': r.montoImpuesto,
        'Monto Líquido': r.montoLiquido,
        Sector: r.sector,
        Unidad: r.unidad,
        'Centro Costo': r.ceco,
        Convenio: r.convenio
      })),
      `Ultimas_Boletas_CMDS_${year || 'Historico'}`,
      'Boletas Recientes'
    );
  };

  const handleExportRecientesPDF = () => {
    if (!stats?.recientes?.length) return;
    exportToCorporatePDF({
      title: `Resumen Ejecutivo — Boletas de Honorarios y Evidencias (${year || 'Acumulado Histórico'})`,
      subtitle: 'Sistema CMDS ADMIN (Esquema Oracle ADM_OBS En Vivo)',
      meta: [
        { label: 'Filtro Año', value: year || 'Todos los Períodos' },
        { label: 'Total Boletas', value: stats.resumen.totalBoletas.toLocaleString('es-CL') }
      ],
      kpis: [
        {
          label: 'Total Boletas',
          value: stats.resumen.totalBoletas.toLocaleString('es-CL'),
          color: 'blue'
        },
        {
          label: 'Monto Bruto Total',
          value: formatCurrencyCLP(stats.resumen.totalBruto),
          color: 'indigo'
        },
        {
          label: 'Retención Impuesto',
          value: formatCurrencyCLP(stats.resumen.totalImpuesto),
          color: 'amber'
        },
        {
          label: 'Líquido Pagado/Vigente',
          value: formatCurrencyCLP(stats.resumen.totalLiquido),
          color: 'emerald'
        },
        {
          label: 'Total Evidencias',
          value: stats.resumen.totalEvidencias.toLocaleString('es-CL'),
          color: 'slate'
        }
      ],
      columns: [
        { header: 'Folio', key: 'boleSec', align: 'center' },
        { header: 'Período', key: 'periodo', align: 'center' },
        { header: 'RUT', key: 'rut', align: 'left' },
        { header: 'Funcionario', key: 'funcionario', align: 'left' },
        { header: 'N° Docto', key: 'nroDocto', align: 'center' },
        { header: 'Estado', key: 'estado', align: 'center' },
        { header: 'Sector / Unidad', key: 'unidad', align: 'left' },
        { header: 'Bruto', key: 'brutoFmt', align: 'right' },
        { header: 'Impuesto', key: 'impFmt', align: 'right' },
        { header: 'Líquido', key: 'liqFmt', align: 'right' }
      ],
      rows: stats.recientes.map((r: any) => ({
        ...r,
        brutoFmt: formatCurrencyCLP(r.montoBruto),
        impFmt: formatCurrencyCLP(r.montoImpuesto),
        liqFmt: formatCurrencyCLP(r.montoLiquido)
      }))
    });
  };

  return (
    <div className="space-y-6">
      {/* Cabecera Corporativa */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-[#016098]/10 text-[#016098] uppercase tracking-wider">
              CMDS ADMIN · Fases 0, 1, 2 y 3 (100% Completo)
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-700">
              Conectado a PostgreSQL 18.6 (bd_cmds_admin · adm_obs)
            </span>
          </div>
          <h1 className="text-2xl font-extrabold text-[#1e293b] mt-1">
            Panel de Control — Gestión Corporativa CMDS ADMIN
          </h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Consolidación moderna de los 10 módulos prioritarios de Scriptcase sobre PostgreSQL 18 (`adm_obs` y `adm_auth`)
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-2.5">
          <div className="flex items-center gap-2 bg-slate-50 border border-slate-200 rounded-lg px-3 py-1.5">
            <span className="text-xs font-semibold text-slate-600">Año Período:</span>
            <select
              value={year}
              onChange={(e) => setYear(e.target.value)}
              className="text-xs font-bold text-[#016098] bg-transparent focus:outline-none cursor-pointer"
            >
              <option value="">Histórico Completo</option>
              <option value="2026">Año 2026</option>
              <option value="2025">Año 2025</option>
              <option value="2024">Año 2024</option>
              <option value="2023">Año 2023</option>
              <option value="2022">Año 2022</option>
            </select>
          </div>

          <button
            onClick={() => fetchStats(year)}
            className="px-3.5 py-2 rounded-lg bg-[#016098] hover:bg-[#024a8d] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
          >
            Actualizar Datos
          </button>
        </div>
      </div>

      {loading || !stats ? (
        <div className="bg-white rounded-xl p-12 text-center border border-gray-200 shadow-sm">
          <div className="inline-block w-8 h-8 border-4 border-[#016098] border-t-transparent rounded-full animate-spin mb-3"></div>
          <p className="text-sm font-semibold text-slate-600">
            Consultando indicadores en tiempo real desde Oracle 26ai (`ADM_OBS`)...
          </p>
        </div>
      ) : (
        <>
          {/* Fila 1: KPIs Financieros y Operativos de Boletas */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm border-l-4 border-l-[#016098]">
              <div className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                Total Boletas Honorarios
              </div>
              <div className="text-2xl font-extrabold text-[#016098] mt-1">
                {stats.resumen.totalBoletas.toLocaleString('es-CL')}
              </div>
              <div className="mt-2 flex flex-wrap gap-2 text-[11px]">
                <span className="px-2 py-0.5 rounded bg-emerald-50 text-emerald-700 font-semibold">
                  Pagadas: {stats.resumen.pagadas.toLocaleString('es-CL')}
                </span>
                <span className="px-2 py-0.5 rounded bg-amber-50 text-amber-700 font-semibold">
                  Vigentes: {stats.resumen.vigentes.toLocaleString('es-CL')}
                </span>
              </div>
            </div>

            <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm border-l-4 border-l-indigo-600">
              <div className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                Monto Bruto Acumulado (`BOLE_NETO`)
              </div>
              <div className="text-2xl font-extrabold text-indigo-700 mt-1">
                {formatCurrencyCLP(stats.resumen.totalBruto)}
              </div>
              <div className="text-[11px] text-slate-500 mt-2">
                Retención SII: <strong className="text-amber-700">{formatCurrencyCLP(stats.resumen.totalImpuesto)}</strong>
              </div>
            </div>

            <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm border-l-4 border-l-emerald-600">
              <div className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                Monto Líquido Total (`BOLE_TOTAL`)
              </div>
              <div className="text-2xl font-extrabold text-emerald-700 mt-1">
                {formatCurrencyCLP(stats.resumen.totalLiquido)}
              </div>
              <div className="mt-2 flex gap-2 text-[11px]">
                <span className="px-2 py-0.5 rounded bg-blue-50 text-[#016098] font-semibold">
                  Aprobadas: {stats.resumen.aprobadas.toLocaleString('es-CL')}
                </span>
                <span className="px-2 py-0.5 rounded bg-rose-50 text-rose-700 font-semibold">
                  Rechazadas: {stats.resumen.rechazadas.toLocaleString('es-CL')}
                </span>
              </div>
            </div>

            <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm border-l-4 border-l-[#39BABD]">
              <div className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                Expedientes de Evidencia (`BHO_EVIDENCIA`)
              </div>
              <div className="text-2xl font-extrabold text-[#0f766e] mt-1">
                {stats.resumen.totalEvidencias.toLocaleString('es-CL')}
              </div>
              <div className="mt-2 flex flex-wrap gap-1.5 text-[11px]">
                <span className="px-2 py-0.5 rounded bg-emerald-50 text-emerald-700 font-semibold">
                  Visadas: {stats.resumen.evidenciasAprobadas.toLocaleString('es-CL')}
                </span>
                <span className="px-2 py-0.5 rounded bg-amber-50 text-amber-700 font-semibold">
                  Pendientes: {stats.resumen.evidenciasPendientes.toLocaleString('es-CL')}
                </span>
                <span className="text-slate-500">
                  ({stats.resumen.totalDocsEvidencia.toLocaleString('es-CL')} adjuntos)
                </span>
              </div>
            </div>
          </div>

          {/* Fila 2: Tarjetas Rápidas de Catálogos Maestros (Fase 0) */}
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
            <Link
              to="/boletas/funcionarios"
              className="bg-white hover:bg-blue-50/40 transition-colors p-3.5 rounded-xl border border-gray-200 shadow-sm"
            >
              <div className="text-[11px] font-bold text-slate-500">Prestadores BHO</div>
              <div className="text-lg font-extrabold text-[#016098]">
                {stats.resumen.totalFuncionariosBho.toLocaleString('es-CL')}
              </div>
            </Link>
            <Link
              to="/mantenedor?tab=unidades"
              className="bg-white hover:bg-blue-50/40 transition-colors p-3.5 rounded-xl border border-gray-200 shadow-sm"
            >
              <div className="text-[11px] font-bold text-slate-500">Unidades / Colegios / CESFAM</div>
              <div className="text-lg font-extrabold text-[#016098]">
                {stats.resumen.totalUnidades.toLocaleString('es-CL')}
              </div>
            </Link>
            <Link
              to="/mantenedor?tab=cecos"
              className="bg-white hover:bg-blue-50/40 transition-colors p-3.5 rounded-xl border border-gray-200 shadow-sm"
            >
              <div className="text-[11px] font-bold text-slate-500">Centros de Costo</div>
              <div className="text-lg font-extrabold text-[#016098]">
                {stats.resumen.totalCecos.toLocaleString('es-CL')}
              </div>
            </Link>
            <Link
              to="/mantenedor?tab=convenios"
              className="bg-white hover:bg-blue-50/40 transition-colors p-3.5 rounded-xl border border-gray-200 shadow-sm"
            >
              <div className="text-[11px] font-bold text-slate-500">Convenios Activos</div>
              <div className="text-lg font-extrabold text-[#016098]">
                {stats.resumen.totalConvenios.toLocaleString('es-CL')}
              </div>
            </Link>
            <Link
              to="/mantenedor?tab=actividades"
              className="bg-white hover:bg-blue-50/40 transition-colors p-3.5 rounded-xl border border-gray-200 shadow-sm"
            >
              <div className="text-[11px] font-bold text-slate-500">Actividades / Tarifas</div>
              <div className="text-lg font-extrabold text-[#016098]">
                {stats.resumen.totalActividades.toLocaleString('es-CL')}
              </div>
            </Link>
            <Link
              to="/mantenedor?tab=usuarios"
              className="bg-white hover:bg-blue-50/40 transition-colors p-3.5 rounded-xl border border-gray-200 shadow-sm"
            >
              <div className="text-[11px] font-bold text-slate-500">Usuarios Activos (`ADM_AUTH`)</div>
              <div className="text-lg font-extrabold text-emerald-700">
                {stats.resumen.totalUsuariosActivos.toLocaleString('es-CL')}
              </div>
            </Link>
          </div>

          {/* Fila 2B: Accesos Directos a Módulos de Fase 2 y Fase 3 */}
          <div className="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 gap-3">
            <Link
              to="/oficina-partes"
              className="bg-white hover:bg-[#016098]/5 transition-colors p-3 rounded-xl border border-gray-200 shadow-sm border-t-2 border-t-[#016098]"
            >
              <div className="text-[10px] font-bold text-[#016098] uppercase">Fase 2 · Mód. 2</div>
              <div className="text-xs font-extrabold text-slate-800 mt-0.5">Oficina de Partes</div>
              <div className="text-[10px] text-slate-500 mt-0.5">Doctos. y Valorados</div>
            </Link>
            <Link
              to="/ordenes-servicio"
              className="bg-white hover:bg-[#016098]/5 transition-colors p-3 rounded-xl border border-gray-200 shadow-sm border-t-2 border-t-[#016098]"
            >
              <div className="text-[10px] font-bold text-[#016098] uppercase">Fase 2 · Mód. 3</div>
              <div className="text-xs font-extrabold text-slate-800 mt-0.5">Órdenes Servicio</div>
              <div className="text-[10px] text-slate-500 mt-0.5">ODS y Cuadrillas</div>
            </Link>
            <Link
              to="/obras"
              className="bg-white hover:bg-[#016098]/5 transition-colors p-3 rounded-xl border border-gray-200 shadow-sm border-t-2 border-t-[#016098]"
            >
              <div className="text-[10px] font-bold text-[#016098] uppercase">Fase 2 · Mód. 5</div>
              <div className="text-xs font-extrabold text-slate-800 mt-0.5">Obras y OT</div>
              <div className="text-[10px] text-slate-500 mt-0.5">Contratistas y Presup.</div>
            </Link>
            <Link
              to="/hoja-ruta"
              className="bg-white hover:bg-[#016098]/5 transition-colors p-3 rounded-xl border border-gray-200 shadow-sm border-t-2 border-t-[#016098]"
            >
              <div className="text-[10px] font-bold text-[#016098] uppercase">Fase 2 · Mód. 6</div>
              <div className="text-xs font-extrabold text-slate-800 mt-0.5">Hoja de Ruta y CDP</div>
              <div className="text-[10px] text-slate-500 mt-0.5">Iniciativas e Imputación</div>
            </Link>
            <Link
              to="/mercado-publico"
              className="bg-white hover:bg-[#016098]/5 transition-colors p-3 rounded-xl border border-gray-200 shadow-sm border-t-2 border-t-[#016098]"
            >
              <div className="text-[10px] font-bold text-[#016098] uppercase">Fase 2 · Mód. 8</div>
              <div className="text-xs font-extrabold text-slate-800 mt-0.5">Mercado Público</div>
              <div className="text-[10px] text-slate-500 mt-0.5">OC y Licitaciones</div>
            </Link>
            <Link
              to="/rrhh-aps"
              className="bg-white hover:bg-[#39BABD]/10 transition-colors p-3 rounded-xl border border-gray-200 shadow-sm border-t-2 border-t-[#39BABD]"
            >
              <div className="text-[10px] font-bold text-[#0f766e] uppercase">Fase 3 · Mód. 9</div>
              <div className="text-xs font-extrabold text-slate-800 mt-0.5">RRHH APS y REM</div>
              <div className="text-[10px] text-slate-500 mt-0.5">Dotación CESFAM y Series</div>
            </Link>
            <Link
              to="/agenda-atencion"
              className="bg-white hover:bg-[#EB567F]/10 transition-colors p-3 rounded-xl border border-gray-200 shadow-sm border-t-2 border-t-[#EB567F]"
            >
              <div className="text-[10px] font-bold text-[#EB567F] uppercase">Fase 3 · Mód. 10</div>
              <div className="text-xs font-extrabold text-slate-800 mt-0.5">Agenda y Campañas</div>
              <div className="text-[10px] text-slate-500 mt-0.5">Citas y Operativos Salud</div>
            </Link>
          </div>

          {/* Fila 3: Gráficos de Evolución por Período y Distribución por Sector / Estado */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
            <div className="lg:col-span-2 bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <h3 className="text-sm font-bold text-[#1e293b]">
                    Evolución de Boletas por Período Mensual (`BHO_PERIODOS`)
                  </h3>
                  <p className="text-xs text-slate-500">
                    Cantidad de boletas procesadas en los últimos 12 períodos registrados
                  </p>
                </div>
                <Link
                  to="/boletas/bandeja"
                  className="text-xs font-bold text-[#016098] hover:underline"
                >
                  Ir a Bandeja &rarr;
                </Link>
              </div>
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={stats.evolucion}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
                    <XAxis dataKey="periodo" tick={{ fontSize: 11 }} />
                    <YAxis tick={{ fontSize: 11 }} />
                    <RechartsTooltip />
                    <Legend wrapperStyle={{ fontSize: 11 }} />
                    <Bar dataKey="pagadas" name="Pagadas" stackId="a" fill="#10b981" />
                    <Bar dataKey="aprobadas" name="Aprobadas" stackId="a" fill="#016098" />
                    <Bar dataKey="vigentes" name="Vigentes" stackId="a" fill="#f59e0b" />
                    <Bar dataKey="rechazadas" name="Rechazadas" stackId="a" fill="#EB567F" />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>

            <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm flex flex-col justify-between">
              <div>
                <h3 className="text-sm font-bold text-[#1e293b]">
                  Distribución por Sector Corporativo (`ADM_SECTOR`)
                </h3>
                <p className="text-xs text-slate-500 mb-3">
                  Participación en monto bruto y cantidad de boletas
                </p>
                <div className="h-44">
                  <ResponsiveContainer width="100%" height="100%">
                    <PieChart>
                      <Pie
                        data={stats.porSector}
                        dataKey="cantidad"
                        nameKey="sector"
                        cx="50%"
                        cy="50%"
                        outerRadius={68}
                        label={({ name, percent }: any) =>
                          `${name} (${((percent || 0) * 100).toFixed(0)}%)`
                        }
                      >
                        {stats.porSector.map((entry: any, index: number) => (
                          <Cell
                            key={entry.sector}
                            fill={['#016098', '#39BABD', '#10b981', '#f59e0b', '#EB567F'][index % 5]}
                          />
                        ))}
                      </Pie>
                      <RechartsTooltip
                        formatter={(val: any) => [Number(val).toLocaleString('es-CL'), 'Boletas']}
                      />
                    </PieChart>
                  </ResponsiveContainer>
                </div>
              </div>

              <div className="space-y-1.5 border-t border-slate-100 pt-3">
                {stats.porSector.map((s: any) => (
                  <div key={s.sector} className="flex items-center justify-between text-xs">
                    <span className="font-semibold text-slate-700">{s.sector}</span>
                    <span className="text-slate-500">
                      {s.cantidad.toLocaleString('es-CL')} bol. ·{' '}
                      <strong className="text-[#016098]">{formatCurrencyCLP(s.montoBruto)}</strong>
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Fila 4: Top 10 Unidades y Resumen de Estados de Evidencias */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
            <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
              <h3 className="text-sm font-bold text-[#1e293b] mb-1">
                Top 10 Unidades / Establecimientos por Volumen (`ADM_UNIDAD`)
              </h3>
              <p className="text-xs text-slate-500 mb-3">
                CESFAM, Escuelas, Liceos y Direcciones con mayor emisión de boletas
              </p>
              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left border-collapse">
                  <thead>
                    <tr className="bg-slate-100 text-slate-700 uppercase text-[10px]">
                      <th className="py-2 px-2.5">Cód.</th>
                      <th className="py-2 px-2.5">Unidad / Establecimiento</th>
                      <th className="py-2 px-2.5 text-right">Boletas</th>
                      <th className="py-2 px-2.5 text-right">Prestadores</th>
                      <th className="py-2 px-2.5 text-right">Monto Bruto</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {stats.topUnidades.map((u: any) => (
                      <tr key={u.codUnidad} className="hover:bg-slate-50">
                        <td className="py-2 px-2.5 font-mono font-bold text-[#016098]">
                          {u.codUnidad}
                        </td>
                        <td className="py-2 px-2.5 font-medium text-slate-800">{u.unidad}</td>
                        <td className="py-2 px-2.5 text-right font-semibold">
                          {u.cantidad.toLocaleString('es-CL')}
                        </td>
                        <td className="py-2 px-2.5 text-right text-slate-600">
                          {u.funcionarios.toLocaleString('es-CL')}
                        </td>
                        <td className="py-2 px-2.5 text-right font-bold text-emerald-700">
                          {formatCurrencyCLP(u.montoBruto)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
              <div className="flex items-center justify-between mb-1">
                <h3 className="text-sm font-bold text-[#1e293b]">
                  Flujo de Visación de Evidencias (`DM_ESTADO_EVI`)
                </h3>
                <Link
                  to="/evidencias"
                  className="text-xs font-bold text-[#016098] hover:underline"
                >
                  Gestionar Evidencias &rarr;
                </Link>
              </div>
              <p className="text-xs text-slate-500 mb-3">
                Estado de los expedientes de respaldo de honorarios en CESFAM y Referentes Técnicos
              </p>
              <div className="space-y-2.5">
                {stats.estadosEvidencia.map((ev: any) => {
                  const pct =
                    stats.resumen.totalEvidencias > 0
                      ? Math.round((ev.cantidad / stats.resumen.totalEvidencias) * 100)
                      : 0;
                  return (
                    <div
                      key={ev.codigo}
                      className="p-3 rounded-lg bg-slate-50 border border-slate-200 flex items-center justify-between"
                    >
                      <div>
                        <div className="text-xs font-bold text-slate-800">
                          [{ev.codigo}] {ev.descripcion}
                        </div>
                        <div className="w-48 bg-slate-200 h-1.5 rounded-full mt-1.5 overflow-hidden">
                          <div
                            className="bg-[#016098] h-full rounded-full"
                            style={{ width: `${Math.max(pct, 3)}%` }}
                          />
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-sm font-extrabold text-[#016098]">
                          {ev.cantidad.toLocaleString('es-CL')}
                        </div>
                        <div className="text-[10px] text-slate-500">{pct}% del total</div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>

          {/* Fila 5: Últimas Boletas Registradas en Oracle */}
          <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
              <div>
                <h3 className="text-sm font-bold text-[#1e293b]">
                  Últimas Boletas de Honorarios Registradas (`ADM_OBS.BHO_BOLETAS`)
                </h3>
                <p className="text-xs text-slate-500">
                  Registros más recientes extraídos directamente desde la base de datos productiva
                </p>
              </div>
              <div className="flex items-center gap-2">
                <button
                  onClick={handleExportRecientesExcel}
                  className="px-3 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
                >
                  Exportar Excel (.xlsx)
                </button>
                <button
                  onClick={handleExportRecientesPDF}
                  className="px-3 py-1.5 rounded-lg bg-[#016098] hover:bg-[#024a8d] text-white text-xs font-bold shadow-sm transition-colors cursor-pointer"
                >
                  Reporte PDF Corporativo
                </button>
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-xs text-left border-collapse">
                <thead>
                  <tr className="bg-[#016098] text-white uppercase text-[10px]">
                    <th className="py-2.5 px-3">Folio</th>
                    <th className="py-2.5 px-3">Período</th>
                    <th className="py-2.5 px-3">RUT</th>
                    <th className="py-2.5 px-3">Prestador / Funcionario</th>
                    <th className="py-2.5 px-3 text-center">N° Docto</th>
                    <th className="py-2.5 px-3 text-center">Fecha</th>
                    <th className="py-2.5 px-3">Sector / Unidad</th>
                    <th className="py-2.5 px-3">CECO / Conv.</th>
                    <th className="py-2.5 px-3 text-right">Bruto</th>
                    <th className="py-2.5 px-3 text-right">Líquido</th>
                    <th className="py-2.5 px-3 text-center">Estado</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200">
                  {stats.recientes.map((r: any) => (
                    <tr key={r.boleSec} className="hover:bg-blue-50/40">
                      <td className="py-2 px-3 font-mono font-bold text-[#016098]">#{r.boleSec}</td>
                      <td className="py-2 px-3 font-semibold">{r.periodo}</td>
                      <td className="py-2 px-3 font-mono whitespace-nowrap">{r.rut}</td>
                      <td className="py-2 px-3 font-semibold text-slate-800">{r.funcionario}</td>
                      <td className="py-2 px-3 text-center font-mono font-bold">{r.nroDocto}</td>
                      <td className="py-2 px-3 text-center whitespace-nowrap">{r.fechaDocto}</td>
                      <td className="py-2 px-3">
                        <span className="font-semibold text-slate-700">{r.sector}</span>
                        <span className="block text-[10px] text-slate-500">{r.unidad}</span>
                      </td>
                      <td className="py-2 px-3 font-mono text-[11px]">
                        {r.ceco} / {r.convenio}
                      </td>
                      <td className="py-2 px-3 text-right font-semibold">
                        {formatCurrencyCLP(r.montoBruto)}
                      </td>
                      <td className="py-2 px-3 text-right font-bold text-emerald-700">
                        {formatCurrencyCLP(r.montoLiquido)}
                      </td>
                      <td className="py-2 px-3 text-center">
                        <span
                          className="px-2 py-0.5 rounded-full text-[10px] font-bold text-white"
                          style={{ backgroundColor: COLORS_ESTADO[r.estado] || '#64748b' }}
                        >
                          {r.estado}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
