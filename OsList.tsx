
import React, { useEffect, useState } from 'react'
export default function OsList(){
  const [list, setList] = useState([])
  useEffect(()=>{ window.api.invoke('os:list').then(setList) }, [])
  return (<div><h2>Ordens de Serviço</h2><table><thead><tr><th>ID</th><th>Cliente</th><th>Status</th></tr></thead><tbody>{list.map(o=>(<tr key={o.id}><td>{o.id}</td><td>{o.cliente_id}</td><td>{o.status}</td></tr>))}</tbody></table></div>)
}
