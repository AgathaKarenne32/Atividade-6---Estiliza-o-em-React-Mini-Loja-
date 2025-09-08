import React from 'react'
import Navbar from './components/Navbar'
import ProductCard from './components/ProductCardSkeleton'
import { products } from './data/products'

export default function App(){
  const [cart, setCart] = React.useState([])
  const [loading, setLoading] = React.useState(true)
  React.useEffect(()=>{ const t = setTimeout(()=>setLoading(false), 900); return ()=>clearTimeout(t); },[])
  const add = (id) => setCart(c => [...c, id])

  return (
    <>
      <Navbar cartCount={cart.length} />
      <main className="container">
        <section className="grid" aria-live="polite">
          {loading 
            ? Array.from({length:6}).map((_,i)=>(
                <article className="card" key={i} aria-hidden>
                  <div className="card-media skeleton" />
                  <div className="card-body">
                    <div className="s-line s-line-70" />
                    <div className="s-line s-line-50" />
                    <div style={{display:'flex',gap:8}}>
                      <div className="s-box" />
                      <div className="s-box" />
                    </div>
                  </div>
                </article>
              ))
            : products.map(p => <ProductCard key={p.id} p={p} onAdd={add} />)
          }
        </section>
      </main>
    </>
  )
}
