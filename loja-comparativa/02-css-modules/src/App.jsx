import React from 'react'
import Navbar from './components/Navbar'
import ProductCard from './components/ProductCard'
import { products } from './data/products'
import styles from './components/Layout.module.css'

export default function App(){
  const [cart, setCart] = React.useState([])
  const [loading, setLoading] = React.useState(true)
  React.useEffect(()=>{ const t = setTimeout(()=>setLoading(false), 900); return ()=>clearTimeout(t); },[])
  const add = (id) => setCart(c => [...c, id])

  return (
    <>
      <Navbar cartCount={cart.length} />
      <main className={styles.container}>
        <section className={styles.grid} aria-live="polite">
          {loading ? Array.from({length:6}).map((_,i)=>(
            <article className={styles.card} key={i} aria-hidden>
              <div className={styles.media + ' ' + styles.skeleton} />
              <div className={styles.body}>
                <div className={styles.sline + ' ' + styles.w70} />
                <div className={styles.sline + ' ' + styles.w50} />
              </div>
            </article>
          )) : products.map(p => <ProductCard key={p.id} p={p} onAdd={add} />)}
        </section>
      </main>
    </>
  )
}
