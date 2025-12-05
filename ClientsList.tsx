
import React, { useEffect, useState } from 'react'
export default function ClientsList(){
  const [clients, setClients] = useState([])
  useEffect(()=>{ window.api.invoke('clients:list').then(setClients) }, [])
  return (<div><h2>Clientes</h2><table><thead><tr><th>Nome</th><th>Telefone</th></tr></thead><tbody>{clients.map(c=>(<tr key={c.id}><td>{c.nome}</td><td>{c.telefone}</td></tr>))}</tbody></table></div>)
}
