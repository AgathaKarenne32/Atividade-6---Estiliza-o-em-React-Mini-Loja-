import React from 'react'
import Navbar from './components/Navbar'
import ProductCard from './components/ProductCard'
import { products } from './data/products'
export default function App(){
  const [cart,setCart]=React.useState([])
  const [loading,setLoading]=React.useState(true)
  React.useEffect(()=>{ const t=setTimeout(()=>setLoading(false),900); return ()=>clearTimeout(t) },[])
  const add = id => setCart(c=>[...c,id])
  return (<>
    <Navbar cartCount={cart.length} />
    <main className="max-w-[1200px] mx-auto p-6">
      <section className="grid gap-6 xs:grid-cols-1 smx:grid-cols-2 mdx:grid-cols-3 lgx:grid-cols-4" aria-live="polite">
        {loading ? Array.from({length:6}).map((_,i)=>(<div key={i} className="bg-white dark:bg-slate-800 border rounded-[12px] overflow-hidden shadow-sm"><div className="aspect-square bg-slate-100 dark:bg-slate-800/50" /><div className="p-4"><div className="h-4 w-[70%] bg-slate-200 rounded mb-2" /><div className="h-4 w-[50%] bg-slate-200 rounded" /></div></div>)) : products.map(p=><ProductCard key={p.id} p={p} onAdd={add} />)}
      </section>
    </main>
  </>)
}
