#!/usr/bin/env bash
set -e

ROOT_DIR="$(pwd)"

echo "Criando 4 projetos de loja em: $ROOT_DIR"

# Função utilitária pra criar produto comum (arquivo data)
create_products_file() {
  local target="$1"
  mkdir -p "$target/src/data"
  cat <<'EOF' > "$target/src/data/products.js"
export const products = [
  { id: 'p1', title: 'Fone Bluetooth Noise Canceling Over-Ear Pro Max', price: 1299.9, rating: 4.7, tag: 'Novo', image: 'https://picsum.photos/seed/1/600' },
  { id: 'p2', title: 'Teclado Mecânico RGB Switch Brown ABNT2', price: 399.9, rating: 4.4, tag: 'Promo', image: 'https://picsum.photos/seed/2/600' },
  { id: 'p3', title: 'Mouse Gamer 26k DPI Wireless Ultralight', price: 349.9, rating: 4.6, image: 'https://picsum.photos/seed/3/600' },
  { id: 'p4', title: 'Monitor 27\" 1440p 165Hz IPS HDR', price: 1999.9, rating: 4.8, tag: 'Promo', image: 'https://picsum.photos/seed/4/600' },
  { id: 'p5', title: 'Webcam 1080p com Microfone e Privacidade', price: 229.9, rating: 4.2, image: 'https://picsum.photos/seed/5/600' },
  { id: 'p6', title: 'Cadeira Ergonômica com Apoio Lombar', price: 1399.9, rating: 4.5, tag: 'Novo', image: 'https://picsum.photos/seed/6/600' },
];
EOF
}

# ------------- 01 - CSS Global -------------
DIR1="$ROOT_DIR/01-css-global"
mkdir -p "$DIR1"
cd "$DIR1"
echo "Criando projeto Vite (React) em $DIR1"
npm create vite@latest . -- --template react >/dev/null 2>&1 || true
npm install >/dev/null 2>&1
create_products_file "$DIR1"

# Criar arquivos principais (App + components + styles)
mkdir -p "$DIR1/src/components" "$DIR1/src/styles"
cat <<'EOF' > "$DIR1/src/main.jsx"
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import './styles/globals.css'

createRoot(document.getElementById('root')).render(<App />)
EOF

cat <<'EOF' > "$DIR1/src/App.jsx"
import React from 'react'
import Navbar from './components/Navbar'
import ProductCard from './components/ProductCard'
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
EOF

cat <<'EOF' > "$DIR1/src/components/Navbar.jsx"
import React from 'react'
const THEME_KEY = 'theme'
export default function Navbar({ cartCount }){
  const [theme, setTheme] = React.useState(()=> document.documentElement.getAttribute('data-theme') || 'light')
  const toggle = ()=>{
    const next = theme === 'dark' ? 'light' : 'dark'
    document.documentElement.setAttribute('data-theme', next)
    localStorage.setItem(THEME_KEY, next)
    setTheme(next)
  }
  return (
    <nav className="nav" role="navigation" aria-label="Principal">
      <div className="nav-inner container">
        <div className="logo" aria-label="Loja React">🛍️ Loja</div>
        <div className="actions">
          <button className="theme-toggle" onClick={toggle} aria-pressed={theme==='dark'} aria-label="Alternar tema">
            {theme==='dark' ? '🌙' : '☀️'}
          </button>
          <button className="btn btn-ghost" aria-label={`Carrinho com ${cartCount} itens`}>
            🛒 <span className="cart-badge" aria-hidden>{cartCount}</span>
          </button>
        </div>
      </div>
    </nav>
  )
}
EOF

cat <<'EOF' > "$DIR1/src/components/Button.jsx"
import React from 'react'
export default function Button({ variant='solid', children, ...rest }){
  return <button className={['btn', variant==='solid'?'btn-solid':variant==='outline'?'btn-outline':'btn-ghost'].join(' ')} {...rest}>{children}</button>
}
EOF

cat <<'EOF' > "$DIR1/src/components/Skeleton.jsx"
import React from 'react'
export default function Skeleton({ style={}, className='' }){
  return <div className={['skeleton', className].join(' ')} style={style} aria-hidden />
}
EOF

cat <<'EOF' > "$DIR1/src/components/ProductCard.jsx"
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
EOF

cat <<'EOF' > "$DIR1/src/styles/globals.css"
:root{
  --space-2:8px; --space-4:16px; --space-6:24px; --radius:12px; --dur:180ms;
  --bg:#ffffff; --fg:#0f172a; --muted:#475569; --card:#ffffff; --border:#e2e8f0;
  --primary:#2563eb; --primary-contrast:#ffffff; --accent:#10b981; --warning:#ea580c;
  --shadow-sm: 0 1px 2px rgba(15,23,42,.06); --shadow-md: 0 6px 20px rgba(15,23,42,.12);
}
:root[data-theme="dark"]{
  --bg:#0b1220; --fg:#e2e8f0; --muted:#94a3b8; --card:#111827; --border:#1f2937;
  --primary:#60a5fa; --primary-contrast:#0b1220; --accent:#34d399; --warning:#fb923c;
  --shadow-sm: 0 1px 2px rgba(0,0,0,.6); --shadow-md: 0 8px 28px rgba(0,0,0,.5);
}
*{box-sizing:border-box}
html,body,#root{height:100%}
body{margin:0;font-family:Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto; background:var(--bg); color:var(--fg);}
.container{max-width:1200px;margin:0 auto;padding:var(--space-6);}
.nav{position:sticky;top:0;z-index:50;background:var(--card);border-bottom:1px solid var(--border);box-shadow:var(--shadow-sm);}
.nav-inner{display:flex;align-items:center;justify-content:space-between;padding:var(--space-4) 0;}
.logo{font-weight:700;}
.actions{display:flex;gap:8px;align-items:center;}
.theme-toggle{background:transparent;border:1px solid var(--border);padding:6px 10px;border-radius:999px;}
.cart-badge{display:inline-grid;place-items:center;min-width:22px;height:22px;padding:0 6px;border-radius:999px;background:var(--primary);color:var(--primary-contrast);font-size:12px;font-weight:700;}
.grid{display:grid;gap:var(--space-6);}
/* Breakpoints exactly as requested */
@media (max-width:480px){ .grid{grid-template-columns:1fr;} }
@media (min-width:481px) and (max-width:768px){ .grid{grid-template-columns:repeat(2,1fr);} }
@media (min-width:769px) and (max-width:1024px){ .grid{grid-template-columns:repeat(3,1fr);} }
@media (min-width:1025px){ .grid{grid-template-columns:repeat(4,1fr);} }

.card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow-sm);transition:transform var(--dur), box-shadow var(--dur);}
.card:hover{transform:translateY(-4px);box-shadow:var(--shadow-md);}
.card-media{aspect-ratio:1/1;background:var(--border);display:grid;place-items:center;}
.card-body{padding:var(--space-4);display:grid;gap:12px;}
.card-title{font-weight:700;line-height:1.2;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;text-overflow:ellipsis;min-height:2.4em;}
.card-meta{display:flex;align-items:center;justify-content:space-between;}
.price{font-weight:700;}
.tag{font-size:12px;padding:2px 8px;border-radius:999px;border:1px solid var(--border);background:transparent;color:var(--accent);}
.tag[data-variant="Promo"]{color:var(--warning);}

/* Button */
.btn{border-radius:var(--radius);padding:8px 12px;font-weight:600;border:1px solid transparent;cursor:pointer;transition:transform var(--dur) ease,box-shadow var(--dur) ease,opacity var(--dur) ease;}
.btn:disabled{opacity:.5;cursor:not-allowed;}
.btn-solid{background:var(--primary);color:var(--primary-contrast);}
.btn-outline{background:transparent;color:var(--primary);border-color:var(--primary);}
.btn-ghost{background:transparent;color:var(--fg);}

/* Focus visible */
:focus-visible{outline:3px solid color-mix(in oklab, var(--primary) 60%, white 40%);outline-offset:2px}

/* Skeleton */
.skeleton{background: color-mix(in oklab, var(--fg) 8%, transparent); position:relative; overflow:hidden;}
.skeleton::after{content:"";position:absolute;inset:0;transform:translateX(-100%);background:linear-gradient(90deg, transparent, color-mix(in oklab, var(--fg) 6%, white 0%), transparent);animation:shimmer 1.2s infinite;}
@keyframes shimmer{to{transform:translateX(100%)}}
.s-line{height:18px;border-radius:8px;background:transparent}
.s-line-70{width:70%}
.s-line-50{width:50%}
.s-box{width:90px;height:40px;border-radius:12px;background:transparent}
EOF

cat <<'EOF' > "$DIR1/README.md"
# 01 - CSS Global
Versão com CSS Global. Breakpoints exatamente: <=480px (1col), 481-768 (2col), 769-1024 (3col), >=1025 (4col).
Dark mode persistente via data-theme + localStorage.
Run:
npm install
npm run dev
EOF

echo "01-css-global criado."

# ------------- 02 - CSS Modules -------------
DIR2="$ROOT_DIR/02-css-modules"
mkdir -p "$DIR2"
cd "$DIR2"
echo "Criando projeto Vite (React) em $DIR2"
npm create vite@latest . -- --template react >/dev/null 2>&1 || true
npm install >/dev/null 2>&1
create_products_file "$DIR2"

mkdir -p "$DIR2/src/components" "$DIR2/src/styles"
# main.jsx
cat <<'EOF' > "$DIR2/src/main.jsx"
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import './styles/tokens.css'
createRoot(document.getElementById('root')).render(<App />)
EOF

# App.jsx
cat <<'EOF' > "$DIR2/src/App.jsx"
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
EOF

# tokens.css
cat <<'EOF' > "$DIR2/src/styles/tokens.css"
:root{ --radius:12px; --dur:180ms; --space-6:24px; --primary:#2563eb; --primary-contrast:#fff; }
:root[data-theme="dark"]{ --primary:#60a5fa; }
EOF

# Layout.module.css (grid + utilities + skeleton)
cat <<'EOF' > "$DIR2/src/components/Layout.module.css"
.container{max-width:1200px;margin:0 auto;padding:24px}
.grid{display:grid;gap:24px}
@media (max-width:480px){ .grid{grid-template-columns:1fr} }
@media (min-width:481px) and (max-width:768px){ .grid{grid-template-columns:repeat(2,1fr)} }
@media (min-width:769px) and (max-width:1024px){ .grid{grid-template-columns:repeat(3,1fr)} }
@media (min-width:1025px){ .grid{grid-template-columns:repeat(4,1fr)} }

.card{background:var(--card, #fff);border:1px solid var(--border, #e2e8f0);border-radius:var(--radius);overflow:hidden}
.media{aspect-ratio:1/1;background:var(--border, #e2e8f0)}
.body{padding:16px}
.skeleton{background:linear-gradient(90deg, rgba(0,0,0,0.04) 25%, rgba(0,0,0,0.06) 50%, rgba(0,0,0,0.04) 75%);height:100%}
.sline{height:18px;border-radius:8px;background:rgba(0,0,0,0.06);margin-bottom:8px}
.w70{width:70%}.w50{width:50%}
EOF

# Minimal components for modules version (Navbar, ProductCard, Button, Skeleton)
cat <<'EOF' > "$DIR2/src/components/Navbar.jsx"
import React from 'react'
import s from './Navbar.module.css'
const THEME_KEY='theme'
export default function Navbar({ cartCount }){
  const [theme,setTheme]=React.useState(()=>document.documentElement.getAttribute('data-theme')||'light')
  const toggle=()=>{ const next = theme==='dark'?'light':'dark'; document.documentElement.setAttribute('data-theme', next); localStorage.setItem(THEME_KEY, next); setTheme(next) }
  return (
    <nav className={s.nav} role="navigation">
      <div className={s.inner}>
        <div className={s.logo}>🛍️ Loja</div>
        <div className={s.actions}>
          <button className={s.toggle} onClick={toggle} aria-pressed={theme==='dark'}>{theme==='dark'?'🌙':'☀️'}</button>
          <button className={s.ghost}>🛒 <span className={s.badge}>{cartCount}</span></button>
        </div>
      </div>
    </nav>
  )
}
EOF

cat <<'EOF' > "$DIR2/src/components/Navbar.module.css"
.nav{position:sticky;top:0;background:var(--card,#fff);border-bottom:1px solid var(--border,#e2e8f0);box-shadow:0 1px 2px rgba(0,0,0,0.04)}
.inner{max-width:1200px;margin:0 auto;padding:16px;display:flex;justify-content:space-between;align-items:center}
.actions{display:flex;gap:8px;align-items:center}
.toggle{padding:6px 10px;border-radius:999px;border:1px solid var(--border,#e2e8f0);background:transparent}
.ghost{background:transparent;border:0}
.badge{display:inline-grid;place-items:center;min-width:22px;height:22px;padding:0 6px;border-radius:999px;background:var(--primary,#2563eb);color:#fff}
EOF

cat <<'EOF' > "$DIR2/src/components/Button.jsx"
import React from 'react'
import s from './Button.module.css'
export default function Button({variant='solid',children,...rest}){
  return <button className={variant==='solid'?s.solid:variant==='outline'?s.outline:s.ghost} {...rest}>{children}</button>
}
EOF

cat <<'EOF' > "$DIR2/src/components/Button.module.css"
.solid{padding:8px 12px;border-radius:12px;background:var(--primary,#2563eb);color:var(--primary-contrast,#fff);border:1px solid transparent}
.outline{padding:8px 12px;border-radius:12px;background:transparent;color:var(--primary,#2563eb);border:1px solid var(--primary,#2563eb)}
.ghost{padding:8px 12px;border-radius:12px;background:transparent;border:0}
:focus-visible{outline:3px solid rgba(37,99,235,0.5);outline-offset:2px}
EOF

cat <<'EOF' > "$DIR2/src/components/ProductCard.jsx"
import React from 'react'
import Button from './Button'
import s from './ProductCard.module.css'
import Skeleton from './Skeleton'
export default function ProductCard({p,onAdd}){
  const [loadingImg,setLoadingImg]=React.useState(true)
  return (
    <article className={s.card} aria-label={p.title}>
      <div className={s.media} aria-hidden>{loadingImg && <Skeleton style={{width:'100%',height:'100%'}}/>}<img src={p.image} alt="" loading="lazy" style={{width:'100%',height:'100%',objectFit:'cover',display:loadingImg?'none':'block'}} onLoad={()=>setLoadingImg(false)}/></div>
      <div className={s.body}>
        <div style={{display:'flex',justifyContent:'space-between'}}><h3 className={s.title}>{p.title}</h3>{p.tag && <span className={s.tag}>{p.tag}</span>}</div>
        <div className={s.meta}><span className={s.price}>{p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}</span><span aria-label={`Avaliação ${p.rating} de 5`}>{'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5-Math.round(p.rating))}</span></div>
        <div style={{display:'flex',gap:8}}><Button onClick={()=>onAdd(p.id)} variant="solid">Adicionar</Button><Button variant="outline">Detalhes</Button><Button variant="ghost" aria-label="Favoritar">❤</Button></div>
      </div>
    </article>
  )
}
EOF

cat <<'EOF' > "$DIR2/src/components/ProductCard.module.css"
.card{background:var(--card,#fff);border:1px solid var(--border,#e2e8f0);border-radius:12px;overflow:hidden;transition:transform 180ms,box-shadow 180ms}
.card:hover{transform:translateY(-4px);box-shadow:0 6px 20px rgba(0,0,0,0.08)}
.media{aspect-ratio:1/1;background:var(--border,#e2e8f0);display:grid;place-items:center}
.body{padding:16px}
.title{font-weight:700;line-height:1.2;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
.tag{font-size:12px;padding:2px 8px;border-radius:999px;background:#e6fffa;color:#10b981}
.meta{display:flex;justify-content:space-between;align-items:center}
.price{font-weight:700}
EOF

cat <<'EOF' > "$DIR2/src/components/Skeleton.jsx"
import React from 'react'
export default function Skeleton({style={},className=''}){ return <div className={className} style={{background:'linear-gradient(90deg, rgba(0,0,0,0.04) 25%, rgba(0,0,0,0.06) 50%, rgba(0,0,0,0.04) 75%)', ...style}} aria-hidden/> }
EOF

cat <<'EOF' > "$DIR2/README.md"
# 02 - CSS Modules
Versão com CSS Modules. Use npm install && npm run dev.
EOF

echo "02-css-modules criado."

# ------------- 03 - Tailwind -------------
DIR3="$ROOT_DIR/03-tailwind"
mkdir -p "$DIR3"
cd "$DIR3"
echo "Criando projeto Vite (React) em $DIR3"
npm create vite@latest . -- --template react >/dev/null 2>&1 || true
npm install >/dev/null 2>&1
create_products_file "$DIR3"

# Instalar Tailwind
npm install -D tailwindcss postcss autoprefixer >/dev/null 2>&1 || true
npx tailwindcss init -p >/dev/null 2>&1 || true

cat <<'EOF' > "$DIR3/tailwind.config.cjs"
module.exports = {
  content: ["./index.html","./src/**/*.{js,jsx}"],
  darkMode: 'class',
  theme: {
    extend: {
      borderRadius: { DEFAULT: '12px' },
      screens: { xs: {'max':'480px'}, smx: {'min':'481px','max':'768px'}, mdx: {'min':'769px','max':'1024px'}, lgx: {'min':'1025px'} }
    }
  },
  plugins: [require('@tailwindcss/line-clamp')],
}
EOF

cat <<'EOF' > "$DIR3/src/index.css"
@tailwind base;
@tailwind components;
@tailwind utilities;
:focus-visible{outline:3px solid rgba(96,165,250,0.6);outline-offset:2px}
EOF

# Criar componentes minimalistas usando Tailwind
mkdir -p "$DIR3/src/components"
cat <<'EOF' > "$DIR3/src/main.jsx"
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import './index.css'
createRoot(document.getElementById('root')).render(<App />)
EOF

cat <<'EOF' > "$DIR3/src/App.jsx"
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
EOF

cat <<'EOF' > "$DIR3/src/components/Navbar.jsx"
import React from 'react'
export default function Navbar({cartCount}){
  const [theme,setTheme]=React.useState(()=> localStorage.getItem('theme') || 'light')
  React.useEffect(()=>{ document.documentElement.classList.toggle('dark', theme==='dark'); localStorage.setItem('theme', theme); },[theme])
  return (
    <nav className="sticky top-0 z-50 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-700 shadow-sm">
      <div className="max-w-[1200px] mx-auto px-6 py-4 flex items-center justify-between">
        <div className="font-bold">🛍️ Loja</div>
        <div className="flex items-center gap-3">
          <button onClick={()=>setTheme(t=>t==='dark'?'light':'dark')} className="border rounded-full px-3 py-1">Theme</button>
          <button className="px-3 py-1">🛒 <span className="inline-grid place-items-center min-w-[22px] h-[22px] px-[6px] rounded-full bg-blue-600 text-white text-[12px] font-bold">{cartCount}</span></button>
        </div>
      </div>
    </nav>
  )
}
EOF

cat <<'EOF' > "$DIR3/src/components/ProductCard.jsx"
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
EOF

cat <<'EOF' > "$DIR3/README.md"
# 03 - Tailwind
Versão com TailwindCSS. Execute:
npm install
npm run dev
EOF

echo "03-tailwind criado."

# ------------- 04 - styled-components -------------
DIR4="$ROOT_DIR/04-styled-components"
mkdir -p "$DIR4"
cd "$DIR4"
echo "Criando projeto Vite (React) em $DIR4"
npm create vite@latest . -- --template react >/dev/null 2>&1 || true
npm install >/dev/null 2>&1
create_products_file "$DIR4"

# instalar styled-components
npm install styled-components >/dev/null 2>&1 || true
npm install -D @types/styled-components >/dev/null 2>&1 || true

mkdir -p "$DIR4/src/components"
cat <<'EOF' > "$DIR4/src/main.jsx"
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
createRoot(document.getElementById('root')).render(<App />)
EOF

cat <<'EOF' > "$DIR4/src/theme.js"
export const light = {
  bg:'#ffffff', fg:'#0f172a', card:'#ffffff', border:'#e2e8f0', primary:'#2563eb', primaryContrast:'#fff', shadowSm:'0 1px 2px rgba(15,23,42,.06)', shadowMd:'0 6px 20px rgba(15,23,42,.12)'
}
export const dark = {
  bg:'#0b1220', fg:'#e2e8f0', card:'#111827', border:'#1f2937', primary:'#60a5fa', primaryContrast:'#0b1220', shadowSm:'0 1px 2px rgba(0,0,0,.6)', shadowMd:'0 8px 28px rgba(0,0,0,.5)'
}
EOF

cat <<'EOF' > "$DIR4/src/App.jsx"
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
EOF

cat <<'EOF' > "$DIR4/src/components/Navbar.jsx"
import React from 'react'
import styled from 'styled-components'
const Nav = styled.nav`position:sticky;top:0;z-index:50;background:${p=>p.theme.card};border-bottom:1px solid ${p=>p.theme.border};box-shadow:${p=>p.theme.shadowSm}`
const Inner = styled.div`max-width:1200px;margin:0 auto;padding:16px;display:flex;justify-content:space-between;align-items:center`
const Badge = styled.span`display:inline-grid;place-items:center;min-width:22px;height:22px;padding:0 6px;border-radius:999px;background:${p=>p.theme.primary};color:${p=>p.theme.primaryContrast}`
export default function Navbar({cartCount, themeKey, setThemeKey}){
  return (
    <Nav role="navigation">
      <Inner>
        <div style={{fontWeight:700}}>🛍️ Loja</div>
        <div style={{display:'flex',gap:12,alignItems:'center'}}>
          <button onClick={()=>setThemeKey(t=>t==='dark'?'light':'dark')}>Theme</button>
          <button>🛒 <Badge aria-hidden>{cartCount}</Badge></button>
        </div>
      </Inner>
    </Nav>
  )
}
EOF

cat <<'EOF' > "$DIR4/src/components/ProductCard.jsx"
import React from 'react'
import styled from 'styled-components'
const Card = styled.article`background:${p=>p.theme.card};border:1px solid ${p=>p.theme.border};border-radius:12px;overflow:hidden;transition:transform 180ms, box-shadow 180ms;&:hover{transform:translateY(-4px);box-shadow:${p=>p.theme.shadowMd}}`
const Media = styled.div`aspect-ratio:1/1;background: ${p=>p.theme.border};display:grid;place-items:center`
const Body = styled.div`padding:16px;display:grid;gap:12px`
const Title = styled.h3`font-weight:700;line-height:1.2;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden`
const Tag = styled.span`font-size:12px;padding:2px 8px;border-radius:999px;background:transparent`
export default function ProductCard({p,onAdd}){
  const [loading,setLoading]=React.useState(true)
  return (
    <Card aria-label={p.title}>
      <Media aria-hidden>{loading && <div style={{width:'100%',height:'100%',background:'rgba(0,0,0,0.04)'}}/>}<img src={p.image} alt="" loading="lazy" style={{width:'100%',height:'100%',objectFit:'cover',display:loading?'none':'block'}} onLoad={()=>setLoading(false)} /></Media>
      <Body>
        <div style={{display:'flex',justifyContent:'space-between'}}><Title>{p.title}</Title>{p.tag && <Tag>{p.tag}</Tag>}</div>
        <div style={{display:'flex',justifyContent:'space-between'}}><strong>{p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}</strong><span>{'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5-Math.round(p.rating))}</span></div>
        <div style={{display:'flex',gap:8}}><button style={{borderRadius:12,padding:'8px 12px',background:'#2563eb',color:'#fff'}}>Adicionar</button><button style={{borderRadius:12,padding:'8px 12px',border:'1px solid #2563eb'}}>Detalhes</button></div>
      </Body>
    </Card>
  )
}
EOF

cat <<'EOF' > "$DIR4/README.md"
# 04 - styled-components
Versão com styled-components e ThemeProvider. Execute:
npm install
npm run dev
EOF

echo "04-styled-components criado."

cd "$ROOT_DIR"
echo "Todos os projetos foram criados.
Para cada pasta (ex: 01-css-global) execute:
  cd pasta && npm install && npm run dev
"
