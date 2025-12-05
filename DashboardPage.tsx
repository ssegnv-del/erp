
import React, { useEffect, useState } from 'react'
export default function DashboardPage(){
  const [data, setData] = useState(null)
  useEffect(()=>{ window.api.invoke('dashboard:data').then(setData) }, [])
  if (!data) return <div>Carregando...</div>
  return (<div><h2>Dashboard</h2><pre>{JSON.stringify(data, null, 2)}</pre></div>)
}
