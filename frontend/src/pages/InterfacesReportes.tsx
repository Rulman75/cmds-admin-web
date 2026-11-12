import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import { exportToExcel, exportToTextFile } from '../utils/exportUtils';

const INTERFACE_TYPES = [
  {
    id: 'softland',
    label: 'Interfaz Contable Softland (CW)',
    table: 'ADM_OBS.ADM_REPORTE_SOFTLAND',
    desc: 'Archivo plano de asientos contables por Período, Sector y Área de Cuenta para importación en Softland ERP.'
  },
  {
    id: 'nomina',
    label: 'Nómina Bancaria / Servipag',
    table: 'ADM_OBS.BHO_REPORTE_NOMINA',
    desc: 'Archivo plano de pago masivo de honorarios por banco, unidad y cuenta corriente/vista.'
  },
  {
    id: 'consolidado',
    label: 'Reporte Consolidado de Boletas',
    table: 'ADM_OBS.BHO_REPORTE_CONSOLIDADO',
    desc: 'Consolidado mensual de boletas emitidas, aprobadas y pagadas por sector (Salud / Educación / Administración).'
  },
  {
    id: 'presupuesto',
    label: 'Imputación Presupuestaria',
    table: 'ADM_OBS.BHO_REPORTE_PRESUPUESTO',
    desc: 'Cuadratura de gasto devengado en honorarios por Centro de Costo, Convenio y Subtítulo Presupuestario.'
  },
  {
    id: 'transparencia',
    label: 'Portal de Transparencia Activa',
    table: 'ADM_OBS.BHO_REPORTE_TRANSPARENCIA',
    desc: 'Nómina oficial para publicación mensual en Portal de Transparencia Ley N° 20.285 (Personal contratado a Honorarios).'
  }
];

const InterfacesReportes: React.FC = () => {
  const [tipo, setTipo] = useState('softland');
  const [periSec, setPeriSec] = useState('');
  const [sectSec, setSectSec] = useState('');
  const [filtros, setFiltros] = useState<any>({ periodos: [], sectores: [] });
  const [rows, setRows] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedRow, setSelectedRow] = useState<any | null>(null);

  useEffect(() => {
    axios
      .get('/api/boletas/filtros')
      .then((res) => {
        if (res.data.status === 'ok') {
          setFiltros(res.data.data);
        }
      })
      .catch(console.error);
  }, []);

  const fetchInterfaces = useCallback(async () => {
    setLoading(true);
    try {
      const res = await axios.get('/api/boletas/interfaces', {
        params: { tipo, periSec, sectSec }
      });
      if (res.data.status === 'ok') {
        const list = res.data.data || [];
        setRows(list);
        setSelectedRow(list[0] || null);
      }
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [tipo, periSec, sectSec]);

  useEffect(() => {
    fetchInterfaces();
  }, [fetchInterfaces]);

  const currentMeta = INTERFACE_TYPES.find((t) => t.id === tipo) || INTERFACE_TYPES[0];

  const handleDownloadTxt = (row: any, index: number) => {
    const content = row.CONTENIDO_TXT || '';
    const filename = `${tipo.toUpperCase()}_${row.PERIODO || row.PERI_SEC || 'PERIODO'}_${row.SECTOR_DESC || row.SECT_SEC || index}.txt`.replace(/\s+/g, '_');
    exportToTextFile(content, filename);
  };

  const handleExportAllTxt = () => {
    const combined = rows.map((r) => r.CONTENIDO_TXT || '').join('\r\n');
    const filename = `${tipo.toUpperCase()}_CONSOLIDADO_${periSec || 'HISTORICO'}.txt`;
    exportToTextFile(combined, filename);
  };

  return (
    <div className="space-y-5">
      {/* Banner Superior */}
      <div className="bg-white rounded-xl p-5 shadow-sm border border-slate-200 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-[#016098]/10 text-[#016098] uppercase tracking-wider">
              Fase 1 · Interfaces Oficiales
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
              {currentMeta.table}
            </span>
          </div>
          <h2 className="text-lg font-bold text-slate-800 mt-1">{currentMeta.label}</h2>
          <p className="text-xs text-slate-500 mt-0.5">{currentMeta.desc}</p>
        </div>

        <div className="flex flex-wrap gap-2">
          <button
            onClick={handleExportAllTxt}
            disabled={rows.length === 0}
            className="bg-[#016098] hover:bg-[#014f7d] text-white px-4 py-2 rounded-lg text-xs font-semibold shadow-sm transition-colors cursor-pointer disabled:opacity-50"
          >
            Descargar Lote Completo (.TXT)
          </button>
          <button
            onClick={() => exportToExcel(rows, `Interfaz_${tipo.toUpperCase()}`)}
            disabled={rows.length === 0}
            className="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg text-xs font-semibold shadow-sm transition-colors cursor-pointer disabled:opacity-50"
          >
            Exportar Grilla (.XLSX)
          </button>
        </div>
      </div>

      {/* Selector de Tipo de Interfaz */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
        {INTERFACE_TYPES.map((item) => {
          const active = item.id === tipo;
          return (
            <button
              key={item.id}
              onClick={() => setTipo(item.id)}
              className={`text-left p-3.5 rounded-xl border transition-all cursor-pointer ${
                active
                  ? 'bg-[#016098] text-white border-[#016098] shadow-md'
                  : 'bg-white text-slate-700 border-slate-200 hover:border-[#39BABD]'
              }`}
            >
              <div className={`text-[10px] font-mono uppercase ${active ? 'text-[#39BABD]' : 'text-slate-400'}`}>
                {item.table.replace('ADM_OBS.', '')}
              </div>
              <div className="font-bold text-xs mt-1 leading-snug">{item.label}</div>
            </button>
          );
        })}
      </div>

      {/* Filtros de Período y Sector */}
      <div className="bg-white rounded-xl p-4 shadow-sm border border-slate-200 flex flex-wrap items-end gap-4">
        <div className="w-60">
          <label className="block text-[11px] font-bold text-slate-600 uppercase mb-1">Período Contable</label>
          <select
            value={periSec}
            onChange={(e) => setPeriSec(e.target.value)}
            className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
          >
            <option value="">Todos los Períodos (Últimos 50)</option>
            {filtros.periodos?.slice(0, 60).map((p: any) => (
              <option key={p.PERI_SEC} value={p.PERI_SEC}>
                {p.PERI_NOMBRE} — Sector #{p.SECT_SEC} ({p.PERI_ESTADO})
              </option>
            ))}
          </select>
        </div>

        <div className="w-52">
          <label className="block text-[11px] font-bold text-slate-600 uppercase mb-1">Sector CMDS</label>
          <select
            value={sectSec}
            onChange={(e) => setSectSec(e.target.value)}
            className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg focus:outline-none focus:border-[#016098]"
          >
            <option value="">Todos los Sectores</option>
            {filtros.sectores?.map((s: any) => (
              <option key={s.SECT_SEC} value={s.SECT_SEC}>
                {s.SECT_DESC} (#{s.SECT_SEC})
              </option>
            ))}
          </select>
        </div>

        <button
          onClick={fetchInterfaces}
          className="bg-slate-800 hover:bg-slate-900 text-white px-4 py-2 rounded-lg text-xs font-semibold transition-colors cursor-pointer"
        >
          Consultar Registros
        </button>

        <div className="ml-auto text-xs text-slate-500">
          Registros encontrados: <strong className="text-slate-800">{rows.length}</strong>
        </div>
      </div>

      {/* Grilla + Visor de Registro Plano */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-5">
        <div className="lg:col-span-6 bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div className="px-4 py-3 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
            <h3 className="text-xs font-bold text-slate-700 uppercase tracking-wider">
              Registros Generados en Oracle ({rows.length})
            </h3>
          </div>
          <div className="overflow-x-auto max-h-[520px]">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-[#016098] text-white text-[11px] uppercase tracking-wider">
                  <th className="py-2.5 px-3">Período</th>
                  <th className="py-2.5 px-3">Sector</th>
                  <th className="py-2.5 px-3">Área / Meta</th>
                  <th className="py-2.5 px-3 text-right">Acción</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200 text-xs">
                {loading ? (
                  <tr>
                    <td colSpan={4} className="py-10 text-center text-slate-500">
                      Consultando {currentMeta.table} en Oracle...
                    </td>
                  </tr>
                ) : rows.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="py-10 text-center text-slate-400">
                      No hay registros para el filtro seleccionado.
                    </td>
                  </tr>
                ) : (
                  rows.map((r, idx) => {
                    const isSelected = selectedRow === r;
                    return (
                      <tr
                        key={idx}
                        onClick={() => setSelectedRow(r)}
                        className={`cursor-pointer transition-colors ${
                          isSelected ? 'bg-[#39BABD]/15 font-semibold' : 'hover:bg-slate-50'
                        }`}
                      >
                        <td className="py-2.5 px-3 font-mono text-slate-800">
                          {r.PERIODO || `ID ${r.PERI_SEC}`}
                        </td>
                        <td className="py-2.5 px-3 text-slate-700">{r.SECTOR_DESC}</td>
                        <td className="py-2.5 px-3 text-slate-500">
                          {r.ACTI_AREA_CUENTA || r.UNID_CODIGO || r.TIPO_ARCHIVO || 'Línea Oficial'}
                        </td>
                        <td className="py-2.5 px-3 text-right">
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              handleDownloadTxt(r, idx);
                            }}
                            className="px-2.5 py-1 bg-[#016098]/10 hover:bg-[#016098] text-[#016098] hover:text-white rounded text-[11px] font-semibold transition-colors cursor-pointer"
                          >
                            .TXT
                          </button>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Visor de Contenido Plano */}
        <div className="lg:col-span-6 bg-slate-900 rounded-xl shadow-sm border border-slate-800 p-4 flex flex-col justify-between min-h-[380px]">
          <div>
            <div className="flex justify-between items-center pb-3 mb-3 border-b border-slate-800">
              <div>
                <span className="text-[11px] font-bold text-[#39BABD] uppercase tracking-wider">
                  Previsualización de Registro Plano (Posicional / CSV)
                </span>
                {selectedRow && (
                  <p className="text-xs text-slate-400 mt-0.5">
                    Período: <strong className="text-white">{selectedRow.PERIODO || selectedRow.PERI_SEC}</strong> · Sector:{' '}
                    <strong className="text-white">{selectedRow.SECTOR_DESC}</strong>
                  </p>
                )}
              </div>
              {selectedRow && (
                <button
                  onClick={() => handleDownloadTxt(selectedRow, 0)}
                  className="bg-[#39BABD] hover:bg-[#2fa3a6] text-white px-3 py-1.5 rounded-lg text-xs font-semibold cursor-pointer"
                >
                  Descargar Línea (.TXT)
                </button>
              )}
            </div>

            <pre className="text-xs font-mono text-emerald-300 bg-slate-950 p-4 rounded-lg overflow-x-auto whitespace-pre-wrap break-all leading-relaxed max-h-[380px]">
              {selectedRow
                ? selectedRow.CONTENIDO_TXT || '(Sin contenido de texto)'
                : 'Seleccione un registro de la tabla izquierda para inspeccionar la trama exacta generada en Oracle.'}
            </pre>
          </div>

          <div className="mt-4 pt-3 border-t border-slate-800 flex justify-between items-center text-[11px] text-slate-400">
            <span>Codificación: ISO-8859-1 / UTF-8 compatible Softland CW y Servipag</span>
            <span>Longitud: {(selectedRow?.CONTENIDO_TXT || '').length} caracteres</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default InterfacesReportes;
