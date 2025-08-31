import React from 'react'
import { ThemeProvider, createGlobalStyle } from 'styled-components'
import { light, dark } from './theme'
import Navbar from './components/Navbar'
import ProductCard from './components/ProductCard'
import { products } from './data/products'

const Global = createGlobalStyle`
  *{box-sizing:border-box} html,body,#root{height:100%}
  body{margin:0;background:${p=>p.theme.bg};color:${p=>p.theme.fg};font-family:Inter,system-ui}
  :focus-visible{outline:3px solid ${p=>p.theme.primary};outline-offset:2px}
  .container{max-width:1200px;margin:0 auto;padding:24px}
`

export default function App(){
  const [themeKey,setThemeKey]=React.useState(()=>localStorage.getItem('theme') || 'light')
  React.useEffect(()=> localStorage.setItem('theme', themeKey), [themeKey])
  const theme = themeKey === 'dark' ? dark : light
  const [cart,setCart]=React.useState([])
  const [loading,setLoading]=React.useState(true)
  React.useEffect(()=>{ const t=setTimeout(()=>setLoading(false),900); return ()=>clearTimeout(t); },[])
  const add = id => setCart(c=>[...c,id])

  return (
    <ThemeProvider theme={theme}>
      <Global />
      <Navbar cartCount={cart.length} themeKey={themeKey} setThemeKey={setThemeKey} />
      <main className="container">
        <section style={{display:'grid',gap:24, gridTemplateColumns:'repeat(4,1fr)'}} aria-live="polite">
          {loading ? Array.from({length:6}).map((_,i)=>(<div key={i} style={{background:theme.card,border:`1px solid ${theme.border}`,borderRadius:12,overflow:'hidden'}}></div>))
           : products.map(p => <ProductCard key={p.id} p={p} onAdd={add} />)}
        </section>
      </main>
    </ThemeProvider>
  )
}
