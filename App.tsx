
import React, { useState } from 'react'
import ClientsList from './components/ClientsList'
import ProductsList from './components/ProductsList'
import OsList from './components/OsList'
import DashboardPage from './components/DashboardPage'

export default function App(){
  const [view, setView] = useState('dashboard')
  return (
    <div style={{fontFamily: 'sans-serif'}}>
      <header style={{background:'#01243a', color:'#fff', padding:12}}>
        <h1>Solutions - ERP</h1>
        <nav>
          <button onClick={()=>setView('dashboard')}>Dashboard</button>
          <button onClick={()=>setView('clients')}>Clientes</button>
          <button onClick={()=>setView('products')}>Produtos</button>
          <button onClick={()=>setView('os')}>OS</button>
        </nav>
      </header>
      <main style={{padding:20}}>
        {view==='dashboard' && <DashboardPage />}
        {view==='clients' && <ClientsList />}
        {view==='products' && <ProductsList />}
        {view==='os' && <OsList />}
      </main>
    </div>
  )
}
