import React from 'react'
export default function ProductCard({p,onAdd}){
  const [loading,setLoading]=React.useState(true)
  return (
    <article className="bg-white dark:bg-slate-800 border dark:border-slate-700 rounded-[12px] overflow-hidden shadow-sm transition duration-180 hover:-translate-y-0.5 hover:shadow-md" aria-label={p.title}>
      <div className="aspect-square grid place-items-center bg-slate-100 dark:bg-slate-800/50">
        {loading && <div className="w-full h-full animate-pulse bg-slate-200 dark:bg-slate-700"/>}
        <img src={p.image} alt="" loading="lazy" className={loading? 'hidden':'block'} style={{width:'100%',height:'100%',objectFit:'cover'}} onLoad={()=>setLoading(false)} />
      </div>
      <div className="p-4 grid gap-3">
        <header className="flex justify-between items-start gap-2">
          <h3 className="font-bold leading-tight line-clamp-2 min-h-[2.4em]">{p.title}</h3>
          {p.tag && <span className={`text-xs px-2 py-0.5 rounded-full ${p.tag==='Promo' ? 'text-orange-600' : 'text-emerald-600'}`}>{p.tag}</span>}
        </header>
        <div className="flex items-center justify-between">
          <span className="font-bold">{p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}</span>
          <span>{'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5-Math.round(p.rating))}</span>
        </div>
        <div className="flex gap-2">
          <button className="rounded-[12px] px-3 py-2 bg-blue-600 text-white font-semibold">Adicionar</button>
          <button className="rounded-[12px] px-3 py-2 border border-blue-600">Detalhes</button>
          <button className="rounded-[12px] px-3 py-2">❤</button>
        </div>
      </div>
    </article>
  )
}
