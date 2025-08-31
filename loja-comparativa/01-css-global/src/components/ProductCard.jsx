import React from 'react'
import Button from './Button'
import Skeleton from './Skeleton'

export default function ProductCard({ p, onAdd }){
  const [loadingImg, setLoadingImg] = React.useState(true)
  return (
    <article className="card" aria-label={p.title}>
      <div className="card-media" aria-hidden>
        {loadingImg && <Skeleton style={{width:'100%',height:'100%'}}/>}
        <img src={p.image} alt="" loading="lazy" style={{width:'100%',height:'100%',objectFit:'cover',display:loadingImg? 'none':'block'}} onLoad={()=>setLoadingImg(false)} />
      </div>
      <div className="card-body">
        <header style={{display:'flex',justifyContent:'space-between',alignItems:'start',gap:8}}>
          <h3 className="card-title">{p.title}</h3>
          {p.tag && <span className="tag" data-variant={p.tag}>{p.tag}</span>}
        </header>
        <div className="card-meta">
          <span className="price">{p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}</span>
          <span className="rating" aria-label={`Avaliação ${p.rating} de 5`}>{'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5-Math.round(p.rating))}</span>
        </div>
        <div style={{display:'flex',gap:8}}>
          <Button onClick={()=>onAdd(p.id)} variant="solid">Adicionar</Button>
          <Button variant="outline">Detalhes</Button>
          <Button variant="ghost" aria-label="Favoritar">❤</Button>
        </div>
      </div>
    </article>
  )
}
