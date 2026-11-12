import React, { useState, useEffect } from 'react';
import { Outlet, Link, useNavigate, useLocation } from 'react-router-dom';
import { useAppVersion } from '../version';

export default function Layout() {
  const { display: versionDisplay, tooltip: versionTooltip } = useAppVersion();
  const navigate = useNavigate();
  const location = useLocation();

  const [menuBoletasOpen, setMenuBoletasOpen] = useState(true);
  const [menuEvidenciaOpen, setMenuEvidenciaOpen] = useState(true);
  const [menuFase2Open, setMenuFase2Open] = useState(true);
  const [menuFase3Open, setMenuFase3Open] = useState(true);
  const [menuMantenedorOpen, setMenuMantenedorOpen] = useState(true);

  const [userData, setUserData] = useState({
    username: '',
    nombre: '',
    unidad: '',
    tipo: 'A'
  });

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        setUserData({
          username: payload.username || '',
          nombre: payload.nombre || payload.username || '',
          unidad: payload.unidad || 'CASA CENTRAL',
          tipo: (payload.tipo || 'A').trim().toUpperCase()
        });
      } catch {
        navigate('/login');
      }
    } else {
      navigate('/login');
    }
  }, [navigate]);

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    navigate('/login');
  };

  const isActive = (path: string) => location.pathname === path;

  return (
    <div className="flex flex-col md:flex-row h-screen bg-[#f4f7f6] font-sans text-[#1e293b] print:bg-white print:h-auto">
      {/* Sidebar Corporativo CMDS (Idéntico a Licencias Médicas y Sistema de Archivo) */}
      <aside className="w-full md:w-[270px] bg-[#016098] text-white shrink-0 shadow-lg flex flex-col justify-between print:hidden">
        <div className="p-4 overflow-y-auto max-h-[calc(100vh-76px)] custom-scrollbar">
          {/* Logo / Header del Sidebar */}
          <div className="flex flex-col items-center pb-5 mb-5 border-b border-white/20 text-center">
            <img
              src="/logo.png"
              alt="Logo CMDS"
              className="max-w-[90px] h-auto mb-2.5 bg-white p-2 rounded-lg shadow-md"
              onError={(e) => {
                (e.target as HTMLImageElement).style.display = 'none';
              }}
            />
            <h4 className="text-[1.05rem] font-bold tracking-wide m-0 leading-tight">
              Sistema CMDS ADMIN
            </h4>
            <p className="text-[0.72rem] text-blue-200 mt-0.5">
              Fases 0, 1, 2 y 3 · Gestión Corporativa
            </p>
            <span
              title={versionTooltip}
              className="mt-1.5 inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-semibold bg-white/10 text-blue-100 border border-white/15 tracking-wider"
            >
              Versión {versionDisplay} · PostgreSQL 18
            </span>

            {userData.username && (
              <div className="mt-3 bg-[#024a8d] px-3 py-1.5 rounded-full text-xs font-medium text-blue-100 flex items-center gap-1.5 border border-white/10 shadow-inner max-w-full">
                <div className="w-2 h-2 rounded-full bg-green-400 animate-pulse shrink-0"></div>
                <span className="truncate max-w-[145px]" title={userData.nombre}>
                  {userData.nombre || userData.username}
                </span>
                <span className="text-[10px] bg-blue-800 px-1.5 py-0.5 rounded text-blue-200 uppercase shrink-0">
                  {userData.tipo}
                </span>
              </div>
            )}
          </div>

          {/* Navegación Principal */}
          <nav className="space-y-1 text-sm">
            {/* 1. Inicio / Dashboard */}
            <Link
              to="/inicio"
              className={`flex items-center gap-2.5 py-2.5 px-3 rounded-lg transition-colors font-semibold ${
                isActive('/inicio')
                  ? 'bg-[#39BABD] text-white shadow-sm'
                  : 'text-white/90 hover:bg-white/10'
              }`}
            >
              <svg className="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
                />
              </svg>
              <span>Inicio (Dashboard)</span>
            </Link>

            {/* 2. Módulo 1: Boletas de Honorarios (Fase 1) */}
            <div className="pt-1">
              <button
                onClick={() => setMenuBoletasOpen(!menuBoletasOpen)}
                className="w-full flex items-center justify-between py-2.5 px-3 rounded-lg text-white/90 hover:bg-white/10 transition-colors font-semibold text-left cursor-pointer"
              >
                <span className="flex items-center gap-2.5">
                  <svg className="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                    />
                  </svg>
                  <span>Boletas Honorarios</span>
                </span>
                <svg
                  className={`w-3.5 h-3.5 transition-transform ${menuBoletasOpen ? 'rotate-180' : ''}`}
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {menuBoletasOpen && (
                <div className="ml-4 pl-3 border-l border-white/20 space-y-1 mt-1 text-xs">
                  <Link
                    to="/boletas/bandeja"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/boletas/bandeja')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Bandeja y Gestión de Boletas
                  </Link>
                  <Link
                    to="/boletas/funcionarios"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/boletas/funcionarios')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Prestadores / Funcionarios BHO
                  </Link>
                  <Link
                    to="/boletas/interfaces"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/boletas/interfaces')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Interfaces (Softland / Servipag)
                  </Link>
                </div>
              )}
            </div>

            {/* 3. Módulo 7: Evidencias (Fase 1) */}
            <div className="pt-1">
              <button
                onClick={() => setMenuEvidenciaOpen(!menuEvidenciaOpen)}
                className="w-full flex items-center justify-between py-2.5 px-3 rounded-lg text-white/90 hover:bg-white/10 transition-colors font-semibold text-left cursor-pointer"
              >
                <span className="flex items-center gap-2.5">
                  <svg className="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                  <span>Control de Evidencias</span>
                </span>
                <svg
                  className={`w-3.5 h-3.5 transition-transform ${menuEvidenciaOpen ? 'rotate-180' : ''}`}
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {menuEvidenciaOpen && (
                <div className="ml-4 pl-3 border-l border-white/20 space-y-1 mt-1 text-xs">
                  <Link
                    to="/evidencias"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/evidencias')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Visación y Expedientes Digitales
                  </Link>
                </div>
              )}
            </div>

            {/* 3B. FASE 2: Gestión Operativa, Obras, Hoja de Ruta y Mercado Público */}
            <div className="pt-1">
              <button
                onClick={() => setMenuFase2Open(!menuFase2Open)}
                className="w-full flex items-center justify-between py-2.5 px-3 rounded-lg text-white/90 hover:bg-white/10 transition-colors font-semibold text-left cursor-pointer"
              >
                <span className="flex items-center gap-2.5">
                  <svg className="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                    />
                  </svg>
                  <span>Operación y Compras (Fase 2)</span>
                </span>
                <svg
                  className={`w-3.5 h-3.5 transition-transform ${menuFase2Open ? 'rotate-180' : ''}`}
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {menuFase2Open && (
                <div className="ml-4 pl-3 border-l border-white/20 space-y-1 mt-1 text-xs">
                  <Link
                    to="/oficina-partes"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/oficina-partes')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Oficina de Partes y Valorados
                  </Link>
                  <Link
                    to="/ordenes-servicio"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/ordenes-servicio')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Órdenes de Servicio (ODS)
                  </Link>
                  <Link
                    to="/obras"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/obras')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Mantenimiento de Obras (OT)
                  </Link>
                  <Link
                    to="/hoja-ruta"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/hoja-ruta')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Hoja de Ruta y CDP Ppto.
                  </Link>
                  <Link
                    to="/mercado-publico"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/mercado-publico')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Mercado Público (OC #1111614)
                  </Link>
                </div>
              )}
            </div>

            {/* 3C. FASE 3: Salud APS, REM y Agenda de Atención */}
            <div className="pt-1">
              <button
                onClick={() => setMenuFase3Open(!menuFase3Open)}
                className="w-full flex items-center justify-between py-2.5 px-3 rounded-lg text-white/90 hover:bg-white/10 transition-colors font-semibold text-left cursor-pointer"
              >
                <span className="flex items-center gap-2.5">
                  <svg className="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
                    />
                  </svg>
                  <span>Salud APS y Agenda (Fase 3)</span>
                </span>
                <svg
                  className={`w-3.5 h-3.5 transition-transform ${menuFase3Open ? 'rotate-180' : ''}`}
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {menuFase3Open && (
                <div className="ml-4 pl-3 border-l border-white/20 space-y-1 mt-1 text-xs">
                  <Link
                    to="/rrhh-aps"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/rrhh-aps')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    RRHH APS y Repositorio REM
                  </Link>
                  <Link
                    to="/agenda-atencion"
                    className={`block py-2 px-3 rounded-md transition-colors ${
                      isActive('/agenda-atencion')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Agenda de Atención y Campañas
                  </Link>
                </div>
              )}
            </div>

            {/* 4. Módulo 4: Mantenedor General (Fase 0) */}
            <div className="pt-1">
              <button
                onClick={() => setMenuMantenedorOpen(!menuMantenedorOpen)}
                className="w-full flex items-center justify-between py-2.5 px-3 rounded-lg text-white/90 hover:bg-white/10 transition-colors font-semibold text-left cursor-pointer"
              >
                <span className="flex items-center gap-2.5">
                  <svg className="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                    />
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                    />
                  </svg>
                  <span>Mantenedor General</span>
                </span>
                <svg
                  className={`w-3.5 h-3.5 transition-transform ${menuMantenedorOpen ? 'rotate-180' : ''}`}
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {menuMantenedorOpen && (
                <div className="ml-4 pl-3 border-l border-white/20 space-y-1 mt-1 text-xs">
                  <Link
                    to="/mantenedor?tab=unidades"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.pathname === '/mantenedor' &&
                      (location.search.includes('tab=unidades') || !location.search)
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Unidades y Establecimientos
                  </Link>
                  <Link
                    to="/mantenedor?tab=cecos"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.search.includes('tab=cecos')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Centros de Costo (CECO)
                  </Link>
                  <Link
                    to="/mantenedor?tab=convenios"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.search.includes('tab=convenios')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Convenios y Programas
                  </Link>
                  <Link
                    to="/mantenedor?tab=actividades"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.search.includes('tab=actividades')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Actividades y Tarifas
                  </Link>
                  <Link
                    to="/mantenedor?tab=periodos"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.search.includes('tab=periodos')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Períodos de Boletas
                  </Link>
                  <Link
                    to="/mantenedor?tab=departamentos"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.search.includes('tab=departamentos')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Departamentos y Jefaturas
                  </Link>
                  <Link
                    to="/mantenedor?tab=usuarios"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.search.includes('tab=usuarios')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Usuarios y Accesos (ADM_AUTH)
                  </Link>
                  <Link
                    to="/mantenedor?tab=dominios"
                    className={`block py-1.5 px-3 rounded-md transition-colors ${
                      location.search.includes('tab=dominios')
                        ? 'bg-[#39BABD] text-white font-bold'
                        : 'text-blue-100 hover:bg-white/10'
                    }`}
                  >
                    Dominios y Parámetros (REF_CODES)
                  </Link>
                </div>
              )}
            </div>
          </nav>
        </div>

        {/* Botón Cerrar Sesión */}
        <div className="p-4 border-t border-white/15">
          <button
            onClick={handleLogout}
            className="w-full flex items-center justify-center gap-2 py-2.5 px-4 rounded-lg bg-[#EB567F] hover:bg-[#d6416a] text-white text-xs font-bold shadow transition-colors cursor-pointer"
          >
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
              />
            </svg>
            Cerrar Sesión
          </button>
        </div>
      </aside>

      {/* Contenedor Principal Derecho */}
      <div className="flex-1 flex flex-col h-screen overflow-hidden print:h-auto print:overflow-visible">
        <div className="flex-1 overflow-auto p-5 md:p-7 print:p-0 print:overflow-visible">
          <Outlet />
        </div>
      </div>
    </div>
  );
}
