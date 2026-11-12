import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Login from './components/Login';
import Layout from './components/Layout';
import Inicio from './pages/Inicio';
import BoletasHonorarios from './pages/BoletasHonorarios';
import InterfacesReportes from './pages/InterfacesReportes';
import Evidencias from './pages/Evidencias';
import MantenedorGeneral from './pages/MantenedorGeneral';
import OficinaPartes from './pages/OficinaPartes';
import OrdenesServicio from './pages/OrdenesServicio';
import MantenimientoObras from './pages/MantenimientoObras';
import HojaRuta from './pages/HojaRuta';
import MercadoPublico from './pages/MercadoPublico';
import RrhhAps from './pages/RrhhAps';
import AgendaAtencion from './pages/AgendaAtencion';

const App: React.FC = () => {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<Layout />}>
          <Route index element={<Navigate to="/inicio" replace />} />
          <Route path="inicio" element={<Inicio />} />
          <Route path="boletas" element={<Navigate to="/boletas/bandeja" replace />} />
          <Route path="boletas/bandeja" element={<BoletasHonorarios />} />
          <Route path="boletas/funcionarios" element={<BoletasHonorarios />} />
          <Route path="boletas/interfaces" element={<InterfacesReportes />} />
          <Route path="evidencias" element={<Evidencias />} />
          <Route path="oficina-partes" element={<OficinaPartes />} />
          <Route path="ordenes-servicio" element={<OrdenesServicio />} />
          <Route path="obras" element={<MantenimientoObras />} />
          <Route path="hoja-ruta" element={<HojaRuta />} />
          <Route path="mercado-publico" element={<MercadoPublico />} />
          <Route path="rrhh-aps" element={<RrhhAps />} />
          <Route path="agenda-atencion" element={<AgendaAtencion />} />
          <Route path="mantenedor" element={<MantenedorGeneral />} />
        </Route>
        <Route path="*" element={<Navigate to="/inicio" replace />} />
      </Routes>
    </Router>
  );
};

export default App;
