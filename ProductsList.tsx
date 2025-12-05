
import React, { useEffect, useState } from 'react'
export default function ProductsList(){
  const [products, setProducts] = useState([])
  useEffect(()=>{ window.api.invoke('products:list').then(setProducts) }, [])
  return (<div><h2>Produtos</h2><table><thead><tr><th>SKU</th><th>Descrição</th><th>Estoque</th></tr></thead><tbody>{products.map(p=>(<tr key={p.id}><td>{p.sku}</td><td>{p.descricao}</td><td>{p.estoque}</td></tr>))}</tbody></table></div>)
}
