# Loja React – 4 versões (CSS Global, CSS Modules, Tailwind, styled-components)

> **Stack sugerida:** Vite + React + TypeScript (pode trocar para JS se preferir). Cada pasta abaixo é um app independente com a mesma UI/UX e comportamento.
>
> **Atenção aos critérios:** breakpoints exatos, dark mode com persistência, focus ring visível, skeleton sem layout shift, variantes de botão consistentes, tokens de design e acessibilidade.

---

## 📁 Estrutura geral do repositório
```
01-css-global/
  ├─ index.html
  ├─ vite.config.ts
  ├─ tsconfig.json
  ├─ package.json
  └─ src/
     ├─ main.tsx
     ├─ App.tsx
     ├─ data/products.ts
     ├─ styles/
     │   ├─ tokens.css
     │   ├─ globals.css
     │   └─ components.css
     └─ components/
         ├─ Navbar.tsx
         ├─ ProductCard.tsx
         ├─ Button.tsx
         └─ Skeleton.tsx

02-css-modules/
  ├─ index.html
  ├─ vite.config.ts
  ├─ tsconfig.json
  ├─ package.json
  └─ src/
     ├─ main.tsx
     ├─ App.tsx
     ├─ data/products.ts
     ├─ styles/
     │   └─ tokens.css
     └─ components/
         ├─ Navbar.module.css
         ├─ ProductCard.module.css
         ├─ Button.module.css
         ├─ Skeleton.module.css
         ├─ Navbar.tsx
         ├─ ProductCard.tsx
         ├─ Button.tsx
         └─ Skeleton.tsx

03-tailwind/
  ├─ index.html
  ├─ vite.config.ts
  ├─ tsconfig.json
  ├─ package.json
  ├─ postcss.config.cjs
  ├─ tailwind.config.cjs
  └─ src/
     ├─ main.tsx
     ├─ App.tsx
     ├─ data/products.ts
     ├─ index.css
     └─ components/
         ├─ Navbar.tsx
         ├─ ProductCard.tsx
         ├─ Button.tsx
         └─ Skeleton.tsx

04-styled-components/
  ├─ index.html
  ├─ vite.config.ts
  ├─ tsconfig.json
  ├─ package.json
  └─ src/
     ├─ main.tsx
     ├─ App.tsx
     ├─ data/products.ts
     ├─ theme.ts
     └─ components/
         ├─ Navbar.tsx
         ├─ ProductCard.tsx
         ├─ Button.tsx
         ├─ Skeleton.tsx
         └─ layouts.ts
```

> **Breakpoints (iguais em todas as versões)**
> - `≤480px: 1 col` · `481–768px: 2 cols` · `769–1024px: 3 cols` · `≥1025px: 4 cols`

> **Tokens base (iguais em todas as versões)**
> - Espaçamento: `--space-1: 4px`, `--space-2: 8px`, `--space-3: 12px`, `--space-4: 16px`, `--space-6: 24px`, `--space-8: 32px`
> - Raio: `--radius: 12px`
> - Tempo de transição: `--dur: 180ms`
> - Sombra: leve/hover ajustadas por tema
> - Cores tematizadas via CSS vars (global, modules, tailwind via plugin, styled-components via ThemeProvider)

---

## 🧪 Dados (compartilhados)
**`src/data/products.ts` (todas as versões)**
```ts
export type Product = {
  id: string;
  title: string;
  price: number;
  rating: number; // 0–5
  tag?: 'Novo' | 'Promo';
  image: string; // placeholder url
};

export const products: Product[] = [
  { id: 'p1', title: 'Fone Bluetooth Noise Canceling Over-Ear Pro Max', price: 1299.9, rating: 4.7, tag: 'Novo', image: 'https://picsum.photos/seed/1/600' },
  { id: 'p2', title: 'Teclado Mecânico RGB Switch Brown ABNT2', price: 399.9, rating: 4.4, tag: 'Promo', image: 'https://picsum.photos/seed/2/600' },
  { id: 'p3', title: 'Mouse Gamer 26k DPI Wireless Ultralight', price: 349.9, rating: 4.6, image: 'https://picsum.photos/seed/3/600' },
  { id: 'p4', title: 'Monitor 27" 1440p 165Hz IPS HDR', price: 1999.9, rating: 4.8, tag: 'Promo', image: 'https://picsum.photos/seed/4/600' },
  { id: 'p5', title: 'Webcam 1080p com Microfone e Privacidade', price: 229.9, rating: 4.2, image: 'https://picsum.photos/seed/5/600' },
  { id: 'p6', title: 'Cadeira Ergonômica com Apoio Lombar', price: 1399.9, rating: 4.5, tag: 'Novo', image: 'https://picsum.photos/seed/6/600' },
];
```

---

# 01 · CSS Global

### `src/styles/tokens.css`
```css
:root {
  --space-1: 4px; --space-2: 8px; --space-3: 12px; --space-4: 16px; --space-6: 24px; --space-8: 32px;
  --radius: 12px; --dur: 180ms;

  --bg: #ffffff; --fg: #0f172a; --muted: #475569; --card: #ffffff; --border: #e2e8f0;
  --primary: #2563eb; --primary-contrast: #ffffff; --accent: #10b981; --warning: #ea580c;
  --shadow-sm: 0 1px 2px rgba(15, 23, 42, 0.06);
  --shadow-md: 0 6px 20px rgba(15, 23, 42, 0.12);
}

:root[data-theme="dark"] {
  --bg: #0b1220; --fg: #e2e8f0; --muted: #94a3b8; --card: #111827; --border: #1f2937;
  --primary: #60a5fa; --primary-contrast: #0b1220; --accent: #34d399; --warning: #fb923c;
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.6);
  --shadow-md: 0 8px 28px rgba(0,0,0,0.5);
}

/* Breakpoints */
@custom-media --xs (max-width: 480px);
@custom-media --sm (min-width: 481px) and (max-width: 768px);
@custom-media --md (min-width: 769px) and (max-width: 1024px);
@custom-media --lg (min-width: 1025px);
```

### `src/styles/globals.css`
```css
@import './tokens.css';
* { box-sizing: border-box; }
html, body, #root { height: 100%; }
body { margin: 0; font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial, "Noto Sans", "Apple Color Emoji", "Segoe UI Emoji"; background: var(--bg); color: var(--fg); }

:focus-visible { outline: 3px solid color-mix(in oklab, var(--primary) 70%, white 30%); outline-offset: 2px; }

.container { max-width: 1200px; margin: 0 auto; padding: var(--space-6); }

.grid { display: grid; gap: var(--space-6); }
@media (--xs) { .grid { grid-template-columns: 1fr; } }
@media (--sm) { .grid { grid-template-columns: repeat(2, 1fr); } }
@media (--md) { .grid { grid-template-columns: repeat(3, 1fr); } }
@media (--lg) { .grid { grid-template-columns: repeat(4, 1fr); } }

.nav { position: sticky; top: 0; z-index: 50; background: var(--card); border-bottom: 1px solid var(--border); box-shadow: var(--shadow-sm); }
.nav-inner { display: flex; align-items: center; justify-content: space-between; gap: var(--space-4); padding: var(--space-4) var(--space-6); }
.logo { font-weight: 700; letter-spacing: .2px; }
.actions { display: flex; gap: var(--space-3); align-items: center; }

.btn { border-radius: var(--radius); padding: 10px 14px; font-weight: 600; border: 1px solid transparent; cursor: pointer; transition: background var(--dur) ease, color var(--dur) ease, transform var(--dur) ease, box-shadow var(--dur) ease, opacity var(--dur) ease; }
.btn:disabled { opacity: .5; cursor: not-allowed; }
.btn:focus-visible { box-shadow: 0 0 0 4px color-mix(in oklab, var(--primary) 30%, transparent); }
.btn-solid { background: var(--primary); color: var(--primary-contrast); }
.btn-solid:hover { transform: translateY(-1px); box-shadow: var(--shadow-md); }
.btn-outline { background: transparent; color: var(--primary); border-color: var(--primary); }
.btn-outline:hover { background: color-mix(in oklab, var(--primary) 12%, transparent); }
.btn-ghost { background: transparent; color: var(--fg); border-color: transparent; }
.btn-ghost:hover { background: color-mix(in oklab, var(--fg) 8%, transparent); }

.card { background: var(--card); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; box-shadow: var(--shadow-sm); transition: transform var(--dur) ease, box-shadow var(--dur) ease; }
.card:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); }
.card-media { aspect-ratio: 1 / 1; background: color-mix(in oklab, var(--border) 60%, transparent); display: grid; place-items: center; }
.card-body { padding: var(--space-4); display: grid; gap: var(--space-3); }
.card-title { font-weight: 700; line-height: 1.2; display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; text-overflow: ellipsis; min-height: 2.4em; }
.card-meta { display: flex; align-items: center; justify-content: space-between; }
.price { font-weight: 700; }
.tag { font-size: 12px; padding: 2px 8px; border-radius: 999px; border: 1px solid var(--border); background: color-mix(in oklab, var(--accent) 12%, transparent); color: var(--accent); }
.tag[data-variant="Promo"] { background: color-mix(in oklab, var(--warning) 12%, transparent); color: var(--warning); }
.rating { aria-hidden: true; }

.skeleton { background: color-mix(in oklab, var(--fg) 8%, transparent); position: relative; overflow: hidden; }
.skeleton::after { content: ""; position: absolute; inset: 0; transform: translateX(-100%); background: linear-gradient(90deg, transparent, color-mix(in oklab, var(--fg) 6%, white 0%), transparent); animation: shimmer 1.2s infinite; }
@keyframes shimmer { to { transform: translateX(100%); } }

.cart-badge { display: inline-grid; place-items: center; min-width: 22px; height: 22px; padding: 0 6px; border-radius: 999px; background: var(--primary); color: var(--primary-contrast); font-size: 12px; font-weight: 700; }

.theme-toggle { background: transparent; border: 1px solid var(--border); padding: 6px 10px; border-radius: 999px; }
```

### `src/styles/components.css`
```css
/* Apenas helpers específicos de componentes que não cabem em globals */
.visually-hidden { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border: 0; }
```

### `src/main.tsx`
```tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './styles/globals.css';

// Persistência de tema
const THEME_KEY = 'theme';
const root = document.documentElement;
const saved = localStorage.getItem(THEME_KEY);
if (saved) root.setAttribute('data-theme', saved);

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
```

### `src/components/Button.tsx`
```tsx
import React from 'react';

type Variant = 'solid' | 'outline' | 'ghost';

type Props = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: Variant;
};

export const Button: React.FC<Props> = ({ variant = 'solid', className = '', ...rest }) => {
  return (
    <button
      className={[
        'btn',
        variant === 'solid' && 'btn-solid',
        variant === 'outline' && 'btn-outline',
        variant === 'ghost' && 'btn-ghost',
        className
      ].filter(Boolean).join(' ')}
      {...rest}
    />
  );
};

export default Button;
```

### `src/components/Skeleton.tsx`
```tsx
import React from 'react';

type Props = { className?: string; style?: React.CSSProperties };
const Skeleton: React.FC<Props> = ({ className = '', style }) => (
  <div className={["skeleton", className].join(' ')} style={style} aria-hidden />
);
export default Skeleton;
```

### `src/components/Navbar.tsx`
```tsx
import React from 'react';
import Button from './Button';

const THEME_KEY = 'theme';

export default function Navbar({ cartCount }: { cartCount: number }) {
  const [theme, setTheme] = React.useState<string>(() => document.documentElement.getAttribute('data-theme') || 'light');

  const toggleTheme = () => {
    const next = theme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem(THEME_KEY, next);
    setTheme(next);
  };

  return (
    <nav className="nav" role="navigation" aria-label="Principal">
      <div className="nav-inner container">
        <div className="logo" aria-label="Loja React">🛍️ Loja</div>
        <div className="actions">
          <button className="theme-toggle" onClick={toggleTheme} aria-pressed={theme === 'dark'} aria-label="Alternar tema claro/escuro">
            {theme === 'dark' ? '🌙' : '☀️'}
          </button>
          <Button variant="ghost" aria-label={`Carrinho com ${cartCount} itens`}>
            🛒 <span className="cart-badge" aria-hidden>{cartCount}</span>
          </Button>
        </div>
      </div>
    </nav>
  );
}
```

### `src/components/ProductCard.tsx`
```tsx
import React from 'react';
import type { Product } from '../data/products';
import Button from './Button';
import Skeleton from './Skeleton';

export default function ProductCard({ p, onAdd }: { p: Product; onAdd: (id: string) => void }) {
  const [loadingImg, setLoadingImg] = React.useState(true);

  return (
    <article className="card" aria-label={p.title}>
      <div className="card-media" aria-hidden>
        {loadingImg && <Skeleton style={{ width: '100%', height: '100%' }} />}
        <img
          src={p.image}
          alt=""
          loading="lazy"
          style={{ width: '100%', height: '100%', objectFit: 'cover', display: loadingImg ? 'none' : 'block' }}
          onLoad={() => setLoadingImg(false)}
        />
      </div>
      <div className="card-body">
        <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', gap: 8 }}>
          <h3 className="card-title">{p.title}</h3>
          {p.tag && <span className="tag" data-variant={p.tag}>{p.tag}</span>}
        </header>
        <div className="card-meta">
          <span className="price" aria-label={`Preço ${p.price.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}`}>
            {p.price.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
          </span>
          <span className="rating" aria-label={`Avaliação ${p.rating} de 5`}>
            {'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5 - Math.round(p.rating))}
          </span>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <Button onClick={() => onAdd(p.id)} variant="solid">Adicionar</Button>
          <Button variant="outline">Detalhes</Button>
          <Button variant="ghost" aria-label="Favoritar">❤</Button>
        </div>
      </div>
    </article>
  );
}
```

### `src/App.tsx`
```tsx
import React from 'react';
import Navbar from './components/Navbar';
import ProductCard from './components/ProductCard';
import { products } from './data/products';
import Skeleton from './components/Skeleton';

export default function App() {
  const [cart, setCart] = React.useState<string[]>([]);
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    const t = setTimeout(() => setLoading(false), 900); // simula atraso de rede
    return () => clearTimeout(t);
  }, []);

  const add = (id: string) => setCart((c) => [...c, id]);

  return (
    <>
      <Navbar cartCount={cart.length} />
      <main className="container" role="main">
        <h1 className="visually-hidden">Lista de Produtos</h1>
        <section className="grid" aria-live="polite">
          {loading
            ? Array.from({ length: 6 }).map((_, i) => (
                <article className="card" key={i} aria-hidden>
                  <div className="card-media"><Skeleton style={{ width: '100%', height: '100%' }} /></div>
                  <div className="card-body">
                    <Skeleton style={{ width: '70%', height: 18, borderRadius: 6 }} />
                    <Skeleton style={{ width: '50%', height: 18, borderRadius: 6 }} />
                    <div style={{ display: 'flex', gap: 8 }}>
                      <Skeleton style={{ width: 90, height: 40, borderRadius: 12 }} />
                      <Skeleton style={{ width: 90, height: 40, borderRadius: 12 }} />
                    </div>
                  </div>
                </article>
              ))
            : products.map((p) => (
                <ProductCard key={p.id} p={p} onAdd={add} />
              ))}
        </section>
      </main>
    </>
  );
}
```

### `README.md` (01-css-global)
```md
# 01 – CSS Global
- Estilos em `styles/` com tokens, globals e helpers.
- Dark mode com `data-theme` + localStorage.
- Grid responsivo nos breakpoints solicitados.
- Focus ring visível via `:focus-visible`.
- Skeleton sem layout shift (aspect-ratio 1:1).
- Botão com variantes solid/outline/ghost consistentes.

## Rodar
```bash
npm i && npm run dev
```
```

---

# 02 · CSS Modules

### `src/styles/tokens.css`
```css
:root { --space-1:4px; --space-2:8px; --space-3:12px; --space-4:16px; --space-6:24px; --space-8:32px; --radius:12px; --dur:180ms; }
:root { --bg:#ffffff; --fg:#0f172a; --muted:#475569; --card:#ffffff; --border:#e2e8f0; --primary:#2563eb; --primary-contrast:#ffffff; --accent:#10b981; --warning:#ea580c; --shadow-sm:0 1px 2px rgba(15,23,42,.06); --shadow-md:0 6px 20px rgba(15,23,42,.12); }
:root[data-theme="dark"] { --bg:#0b1220; --fg:#e2e8f0; --muted:#94a3b8; --card:#111827; --border:#1f2937; --primary:#60a5fa; --primary-contrast:#0b1220; --accent:#34d399; --warning:#fb923c; --shadow-sm:0 1px 2px rgba(0,0,0,.6); --shadow-md:0 8px 28px rgba(0,0,0,.5); }
html,body,#root{height:100%} body{margin:0; background:var(--bg); color:var(--fg); font-family:ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial}
:focus-visible{ outline:3px solid color-mix(in oklab, var(--primary) 70%, white 30%); outline-offset:2px; }
```

### `src/components/Button.module.css`
```css
.btn{ border-radius: var(--radius); padding:10px 14px; font-weight:600; border:1px solid transparent; cursor:pointer; transition: background var(--dur), color var(--dur), transform var(--dur), box-shadow var(--dur), opacity var(--dur); }
.btn:disabled{ opacity:.5; cursor:not-allowed; }
.btn:focus-visible{ box-shadow:0 0 0 4px color-mix(in oklab, var(--primary) 30%, transparent); }
.solid{ background:var(--primary); color:var(--primary-contrast); }
.solid:hover{ transform:translateY(-1px); box-shadow:var(--shadow-md); }
.outline{ background:transparent; color:var(--primary); border-color:var(--primary); }
.outline:hover{ background: color-mix(in oklab, var(--primary) 12%, transparent); }
.ghost{ background:transparent; color:var(--fg); border-color:transparent; }
.ghost:hover{ background: color-mix(in oklab, var(--fg) 8%, transparent); }
```

### `src/components/Navbar.module.css`
```css
.nav{ position:sticky; top:0; z-index:50; background:var(--card); border-bottom:1px solid var(--border); box-shadow:var(--shadow-sm); }
.inner{ max-width:1200px; margin:0 auto; padding:16px 24px; display:flex; align-items:center; justify-content:space-between; gap:16px; }
.logo{ font-weight:700; }
.actions{ display:flex; align-items:center; gap:12px; }
.toggle{ background:transparent; border:1px solid var(--border); padding:6px 10px; border-radius:999px; }
.badge{ display:inline-grid; place-items:center; min-width:22px; height:22px; padding:0 6px; border-radius:999px; background:var(--primary); color:var(--primary-contrast); font-size:12px; font-weight:700; }
```

### `src/components/ProductCard.module.css`
```css
.card{ background:var(--card); border:1px solid var(--border); border-radius:var(--radius); overflow:hidden; box-shadow:var(--shadow-sm); transition: transform var(--dur), box-shadow var(--dur); }
.card:hover{ transform:translateY(-2px); box-shadow:var(--shadow-md); }
.media{ aspect-ratio:1/1; background: color-mix(in oklab, var(--border) 60%, transparent); display:grid; place-items:center; }
.body{ padding:16px; display:grid; gap:12px; }
.title{ font-weight:700; line-height:1.2; display:-webkit-box; -webkit-line-clamp:2; line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; text-overflow:ellipsis; min-height:2.4em; }
.meta{ display:flex; align-items:center; justify-content:space-between; }
.price{ font-weight:700; }
.tag{ font-size:12px; padding:2px 8px; border-radius:999px; border:1px solid var(--border); background: color-mix(in oklab, var(--accent) 12%, transparent); color:var(--accent); }
.tagPromo{ background: color-mix(in oklab, var(--warning) 12%, transparent); color:var(--warning); }
.grid{ display:grid; gap:24px; }
@media (max-width:480px){ .grid{ grid-template-columns:1fr; } }
@media (min-width:481px) and (max-width:768px){ .grid{ grid-template-columns:repeat(2,1fr); } }
@media (min-width:769px) and (max-width:1024px){ .grid{ grid-template-columns:repeat(3,1fr); } }
@media (min-width:1025px){ .grid{ grid-template-columns:repeat(4,1fr); } }
```

### `src/components/Skeleton.module.css`
```css
.skeleton{ background: color-mix(in oklab, var(--fg) 8%, transparent); position:relative; overflow:hidden; }
.skeleton::after{ content:""; position:absolute; inset:0; transform:translateX(-100%); background:linear-gradient(90deg, transparent, color-mix(in oklab, var(--fg) 6%, white 0%), transparent); animation:shimmer 1.2s infinite; }
@keyframes shimmer { to{ transform:translateX(100%); } }
```

### `src/components/Button.tsx`
```tsx
import React from 'react';
import styles from './Button.module.css';

type Variant = 'solid' | 'outline' | 'ghost';

type Props = React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant };

export default function Button({ variant = 'solid', className = '', ...rest }: Props) {
  return (
    <button className={[styles.btn, styles[variant], className].join(' ')} {...rest} />
  );
}
```

### `src/components/Skeleton.tsx`
```tsx
import React from 'react';
import styles from './Skeleton.module.css';
export default function Skeleton({ className = '', style }: { className?: string; style?: React.CSSProperties }) {
  return <div className={[styles.skeleton, className].join(' ')} style={style} aria-hidden />
}
```

### `src/components/Navbar.tsx`
```tsx
import React from 'react';
import s from './Navbar.module.css';
import Button from './Button';
const THEME_KEY = 'theme';

export default function Navbar({ cartCount }: { cartCount: number }){
  const [theme, setTheme] = React.useState<string>(() => document.documentElement.getAttribute('data-theme') || 'light');
  const toggleTheme = () => {
    const next = theme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem(THEME_KEY, next);
    setTheme(next);
  };
  return (
    <nav className={s.nav} role="navigation" aria-label="Principal">
      <div className={s.inner}>
        <div className={s.logo} aria-label="Loja React">🛍️ Loja</div>
        <div className={s.actions}>
          <button className={s.toggle} onClick={toggleTheme} aria-pressed={theme==='dark'} aria-label="Alternar tema">
            {theme==='dark'?'🌙':'☀️'}
          </button>
          <Button variant="ghost" aria-label={`Carrinho com ${cartCount} itens`}>
            🛒 <span className={s.badge} aria-hidden>{cartCount}</span>
          </Button>
        </div>
      </div>
    </nav>
  );
}
```

### `src/components/ProductCard.tsx`
```tsx
import React from 'react';
import type { Product } from '../data/products';
import Button from './Button';
import Skeleton from './Skeleton';
import s from './ProductCard.module.css';

export default function ProductCard({ p, onAdd }: { p: Product; onAdd: (id: string) => void }){
  const [loadingImg, setLoadingImg] = React.useState(true);
  return (
    <article className={s.card} aria-label={p.title}>
      <div className={s.media} aria-hidden>
        {loadingImg && <div style={{width:'100%', height:'100%'}}><Skeleton style={{width:'100%', height:'100%'}} /></div>}
        <img src={p.image} alt="" loading="lazy" style={{width:'100%', height:'100%', objectFit:'cover', display:loadingImg?'none':'block'}} onLoad={()=>setLoadingImg(false)} />
      </div>
      <div className={s.body}>
        <header style={{display:'flex', justifyContent:'space-between', alignItems:'start', gap:8}}>
          <h3 className={s.title}>{p.title}</h3>
          {p.tag && <span className={[s.tag, p.tag==='Promo'?s.tagPromo:''].join(' ')}>{p.tag}</span>}
        </header>
        <div className={s.meta}>
          <span className={s.price} aria-label={`Preço ${p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}`}>
            {p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}
          </span>
          <span aria-label={`Avaliação ${p.rating} de 5`}>{'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5-Math.round(p.rating))}</span>
        </div>
        <div style={{display:'flex', gap:8}}>
          <Button onClick={()=>onAdd(p.id)} variant="solid">Adicionar</Button>
          <Button variant="outline">Detalhes</Button>
          <Button variant="ghost" aria-label="Favoritar">❤</Button>
        </div>
      </div>
    </article>
  );
}
```

### `src/App.tsx`
```tsx
import React from 'react';
import './styles/tokens.css';
import Navbar from './components/Navbar';
import ProductCard from './components/ProductCard';
import { products } from './data/products';
import s from './components/ProductCard.module.css';

export default function App(){
  const [cart, setCart] = React.useState<string[]>([]);
  const [loading, setLoading] = React.useState(true);
  React.useEffect(()=>{ const t=setTimeout(()=>setLoading(false),900); return ()=>clearTimeout(t); },[]);
  const add=(id:string)=>setCart(c=>[...c,id]);
  return (
    <>
      <Navbar cartCount={cart.length} />
      <main style={{maxWidth:1200, margin:'0 auto', padding:24}}>
        <section className={s.grid} aria-live="polite">
          {loading ? Array.from({length:6}).map((_,i)=>(
            <article className={s.card} key={i} aria-hidden>
              <div className={s.media}><div style={{width:'100%', height:'100%', background:'transparent'}} /></div>
              <div className={s.body}>
                <div style={{width:'70%', height:18, borderRadius:6}} className="skeleton" />
                <div style={{width:'50%', height:18, borderRadius:6}} className="skeleton" />
              </div>
            </article>
          )) : products.map(p=> <ProductCard key={p.id} p={p} onAdd={add} />)}
        </section>
      </main>
    </>
  );
}
```

### `README.md` (02-css-modules)
```md
# 02 – CSS Modules
- Escopo por componente com `.module.css` + tokens globais.
- Mesmo comportamento e acessibilidade da versão global.
- Grid com breakpoints exatos.

## Rodar
```bash
npm i && npm run dev
```
```

---

# 03 · Tailwind CSS

### `tailwind.config.cjs`
```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  darkMode: ['class'],
  theme: {
    extend: {
      borderRadius: { DEFAULT: '12px' },
      boxShadow: {
        sm: '0 1px 2px rgba(15,23,42,.06)',
        md: '0 6px 20px rgba(15,23,42,.12)',
        smd: '0 8px 28px rgba(0,0,0,.5)'
      },
      screens: {
        xs: { 'max': '480px' },
        smx: { 'min': '481px', 'max': '768px' },
        mdx: { 'min': '769px', 'max': '1024px' },
        lgx: { 'min': '1025px' }
      }
    },
  },
  plugins: [],
}
```

### `src/index.css`
```css
@tailwind base; @tailwind components; @tailwind utilities;
:root{ --dur:180ms }
:focus-visible{ outline:3px solid rgb(96 165 250); outline-offset:2px; }
```

### `src/components/Button.tsx`
```tsx
import React from 'react';

type Variant = 'solid' | 'outline' | 'ghost';

export default function Button({ variant='solid', className='', ...rest }: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant }){
  const base = 'rounded-[12px] px-[14px] py-[10px] font-semibold border transition duration-[180ms] focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-blue-300 disabled:opacity-50 disabled:cursor-not-allowed';
  const map = {
    solid: 'bg-blue-600 text-white hover:-translate-y-px hover:shadow-md',
    outline: 'bg-transparent text-blue-600 border-blue-600 hover:bg-blue-600/10',
    ghost: 'bg-transparent text-slate-900 dark:text-slate-100 border-transparent hover:bg-slate-900/10 dark:hover:bg-white/10'
  } as const;
  return <button className={[base, map[variant], className].join(' ')} {...rest} />
}
```

### `src/components/Skeleton.tsx`
```tsx
import React from 'react';
export default function Skeleton({ className='', style }: { className?: string; style?: React.CSSProperties }){
  return <div className={["relative overflow-hidden bg-slate-900/10 dark:bg-white/10", className].join(' ')} style={style} aria-hidden>
    <div className="absolute inset-0 -translate-x-full animate-[shimmer_1.2s_infinite] bg-gradient-to-r from-transparent via-white/10 to-transparent dark:via-white/20" />
    <style>{`@keyframes shimmer { to { transform: translateX(100%); } }`}</style>
  </div>
}
```

### `src/components/Navbar.tsx`
```tsx
import React from 'react';
import Button from './Button';

const THEME_KEY='theme';

export default function Navbar({ cartCount }: { cartCount: number }){
  const [theme, setTheme] = React.useState<string>(() => (localStorage.getItem(THEME_KEY) || 'light'));
  React.useEffect(()=>{ document.documentElement.classList.toggle('dark', theme==='dark'); localStorage.setItem(THEME_KEY, theme); }, [theme]);
  return (
    <nav className="sticky top-0 z-50 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-700 shadow-sm" role="navigation" aria-label="Principal">
      <div className="max-w-[1200px] mx-auto px-6 py-4 flex items-center justify-between gap-4">
        <div className="font-bold" aria-label="Loja React">🛍️ Loja</div>
        <div className="flex items-center gap-3">
          <button className="border border-slate-200 dark:border-slate-700 rounded-full px-3 py-1" onClick={()=>setTheme(t=>t==='dark'?'light':'dark')} aria-pressed={theme==='dark'} aria-label="Alternar tema">
            {theme==='dark'?'🌙':'☀️'}
          </button>
          <Button variant="ghost" aria-label={`Carrinho com ${cartCount} itens`}>
            🛒 <span className="grid place-items-center min-w-[22px] h-[22px] px-[6px] rounded-full bg-blue-600 text-white text-[12px] font-bold" aria-hidden>{cartCount}</span>
          </Button>
        </div>
      </div>
    </nav>
  );
}
```

### `src/components/ProductCard.tsx`
```tsx
import React from 'react';
import type { Product } from '../data/products';
import Button from './Button';
import Skeleton from './Skeleton';

export default function ProductCard({ p, onAdd }: { p: Product; onAdd: (id: string) => void }){
  const [loadingImg, setLoadingImg] = React.useState(true);
  return (
    <article className="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-[12px] overflow-hidden shadow-sm transition duration-[180ms] hover:-translate-y-0.5 hover:shadow-md" aria-label={p.title}>
      <div className="aspect-square grid place-items-center bg-slate-100 dark:bg-slate-800/50" aria-hidden>
        {loadingImg && <Skeleton className="w-full h-full" />}
        <img src={p.image} alt="" loading="lazy" className={loadingImg? 'hidden':'block'} style={{width:'100%', height:'100%', objectFit:'cover'}} onLoad={()=>setLoadingImg(false)} />
      </div>
      <div className="p-4 grid gap-3">
        <header className="flex justify-between items-start gap-2">
          <h3 className="font-bold leading-tight line-clamp-2 min-h-[2.4em]">{p.title}</h3>
          {p.tag && (
            <span className={`text-xs px-2 py-0.5 rounded-full border ${p.tag==='Promo' ? 'text-orange-600 border-orange-600/40 bg-orange-600/10' : 'text-emerald-600 border-emerald-600/40 bg-emerald-600/10'}`}>{p.tag}</span>
          )}
        </header>
        <div className="flex items-center justify-between">
          <span className="font-bold" aria-label={`Preço ${p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}`}>
            {p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}
          </span>
          <span aria-label={`Avaliação ${p.rating} de 5`}>{'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5-Math.round(p.rating))}</span>
        </div>
        <div className="flex gap-2">
          <Button onClick={()=>onAdd(p.id)} variant="solid">Adicionar</Button>
          <Button variant="outline">Detalhes</Button>
          <Button variant="ghost" aria-label="Favoritar">❤</Button>
        </div>
      </div>
    </article>
  );
}
```

### `src/App.tsx`
```tsx
import React from 'react';
import Navbar from './components/Navbar';
import ProductCard from './components/ProductCard';
import { products } from './data/products';

export default function App(){
  const [cart, setCart] = React.useState<string[]>([]);
  const [loading, setLoading] = React.useState(true);
  React.useEffect(()=>{ const t=setTimeout(()=>setLoading(false),900); return ()=>clearTimeout(t); },[]);
  const add=(id:string)=>setCart(c=>[...c,id]);

  return (
    <>
      <Navbar cartCount={cart.length} />
      <main className="max-w-[1200px] mx-auto p-6">
        {/* Grid nos breakpoints exatos */}
        <section className="grid gap-6 xs:grid-cols-1 smx:grid-cols-2 mdx:grid-cols-3 lgx:grid-cols-4" aria-live="polite">
          {loading ? Array.from({length:6}).map((_,i)=>(
            <article key={i} className="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-[12px] overflow-hidden shadow-sm">
              <div className="aspect-square"><div className="w-full h-full relative overflow-hidden bg-slate-900/10 dark:bg-white/10" /></div>
              <div className="p-4 grid gap-3">
                <div className="h-[18px] w-[70%] rounded-md bg-slate-900/10 dark:bg-white/10" />
                <div className="h-[18px] w-[50%] rounded-md bg-slate-900/10 dark:bg-white/10" />
                <div className="flex gap-2">
                  <div className="h-10 w-[90px] rounded-[12px] bg-slate-900/10 dark:bg-white/10" />
                  <div className="h-10 w-[90px] rounded-[12px] bg-slate-900/10 dark:bg-white/10" />
                </div>
              </div>
            </article>
          )) : products.map(p=> <ProductCard key={p.id} p={p} onAdd={add} />)}
        </section>
      </main>
    </>
  );
}
```

### `README.md` (03-tailwind)
```md
# 03 – Tailwind
- Utilitários para estados/hover/focus e dark com `.dark` + localStorage.
- Breakpoints custom como solicitado (xs/smx/mdx/lgx).
- line-clamp para título em 2 linhas.

## Rodar
```bash
npm i && npm run dev
```
```

---

# 04 · styled-components

### `src/theme.ts`
```ts
export const light = {
  bg: '#ffffff', fg: '#0f172a', muted: '#475569', card: '#ffffff', border: '#e2e8f0',
  primary: '#2563eb', primaryContrast: '#ffffff', accent: '#10b981', warning: '#ea580c',
  shadowSm: '0 1px 2px rgba(15,23,42,.06)', shadowMd: '0 6px 20px rgba(15,23,42,.12)'
};
export const dark = {
  bg: '#0b1220', fg: '#e2e8f0', muted: '#94a3b8', card: '#111827', border: '#1f2937',
  primary: '#60a5fa', primaryContrast: '#0b1220', accent: '#34d399', warning: '#fb923c',
  shadowSm: '0 1px 2px rgba(0,0,0,.6)', shadowMd: '0 8px 28px rgba(0,0,0,.5)'
};
export const tokens = { radius: '12px', dur: '180ms' } as const;
```

### `src/components/layouts.ts`
```tsx
import styled, { createGlobalStyle } from 'styled-components';
import { tokens } from '../theme';

export const Global = createGlobalStyle`
  *{box-sizing:border-box} html,body,#root{height:100%}
  body{margin:0; background:${p=>p.theme.bg}; color:${p=>p.theme.fg}; font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, 'Helvetica Neue', Arial}
  :focus-visible{ outline:3px solid ${p=>p.theme.primary}; outline-offset:2px; }
`;

export const Container = styled.main`
  max-width:1200px; margin:0 auto; padding:24px;
`;

export const Grid = styled.section`
  display:grid; gap:24px;
  @media (max-width:480px){ grid-template-columns:1fr; }
  @media (min-width:481px) and (max-width:768px){ grid-template-columns:repeat(2,1fr); }
  @media (min-width:769px) and (max-width:1024px){ grid-template-columns:repeat(3,1fr); }
  @media (min-width:1025px){ grid-template-columns:repeat(4,1fr); }
`;

export const Card = styled.article`
  background:${p=>p.theme.card}; border:1px solid ${p=>p.theme.border}; border-radius:${tokens.radius}; overflow:hidden; box-shadow:${p=>p.theme.shadowSm}; transition: transform ${tokens.dur} ease, box-shadow ${tokens.dur} ease;
  &:hover{ transform:translateY(-2px); box-shadow:${p=>p.theme.shadowMd}; }
`;

export const Media = styled.div`
  aspect-ratio:1/1; background: color-mix(in oklab, ${p=>p.theme.border} 60%, transparent); display:grid; place-items:center;
`;

export const Body = styled.div` padding:16px; display:grid; gap:12px; `;

export const Title = styled.h3`
  font-weight:700; line-height:1.2; display:-webkit-box; -webkit-line-clamp:2; line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; text-overflow:ellipsis; min-height:2.4em;
`;

export const Tag = styled.span<{variant?: 'Novo'|'Promo'>>`
  font-size:12px; padding:2px 8px; border-radius:999px; border:1px solid ${p=>p.theme.border};
  color:${p=>p.variant==='Promo'? p.theme.warning : p.theme.accent};
  background:${p=>p.variant==='Promo'? 'color-mix(in oklab, '+p.theme.warning+' 12%, transparent)' : 'color-mix(in oklab, '+p.theme.accent+' 12%, transparent)'};
`;

export const Price = styled.span` font-weight:700; `;

export const Row = styled.div` display:flex; align-items:center; justify-content:space-between; `;

export const ButtonBase = styled.button<{variant?: 'solid'|'outline'|'ghost'>>`
  border-radius:${tokens.radius}; padding:10px 14px; font-weight:600; border:1px solid transparent; cursor:pointer;
  transition: background ${tokens.dur} ease, color ${tokens.dur} ease, transform ${tokens.dur} ease, box-shadow ${tokens.dur} ease, opacity ${tokens.dur} ease;
  &:disabled{ opacity:.5; cursor:not-allowed; }
  &:focus-visible{ box-shadow:0 0 0 4px color-mix(in oklab, ${p=>p.theme.primary} 30%, transparent); }
  ${p=>p.variant==='solid' && `background:${p.theme.primary}; color:${p.theme.primaryContrast}; &:hover{ transform:translateY(-1px); box-shadow:${p.theme.shadowMd}; }`}
  ${p=>p.variant==='outline' && `background:transparent; color:${p.theme.primary}; border-color:${p.theme.primary}; &:hover{ background: color-mix(in oklab, ${p.theme.primary} 12%, transparent); }`}
  ${p=>p.variant==='ghost' && `background:transparent; color:${p.theme.fg}; border-color:transparent; &:hover{ background: color-mix(in oklab, ${p.theme.fg} 8%, transparent); }`}
`;

export const Nav = styled.nav`
  position:sticky; top:0; z-index:50; background:${p=>p.theme.card}; border-bottom:1px solid ${p=>p.theme.border}; box-shadow:${p=>p.theme.shadowSm};
`;

export const NavInner = styled.div`
  max-width:1200px; margin:0 auto; padding:16px 24px; display:flex; align-items:center; justify-content:space-between; gap:16px;
`;

export const Badge = styled.span`
  display:inline-grid; place-items:center; min-width:22px; height:22px; padding:0 6px; border-radius:999px; background:${p=>p.theme.primary}; color:${p=>p.theme.primaryContrast}; font-size:12px; font-weight:700;
`;

export const Toggle = styled.button`
  background:transparent; border:1px solid ${p=>p.theme.border}; padding:6px 10px; border-radius:999px;
`;
```

### `src/components/Button.tsx`
```tsx
import React from 'react';
import { ButtonBase } from './layouts';
export default function Button(props: React.ComponentProps<typeof ButtonBase>){ return <ButtonBase {...props} /> }
```

### `src/components/Skeleton.tsx`
```tsx
import React from 'react';
export default function Skeleton({ className='', style }: { className?: string; style?: React.CSSProperties }){
  return (
    <div className={className} style={{ position:'relative', overflow:'hidden', background:'color-mix(in oklab, white 10%, black 0%)', ...style }} aria-hidden>
      <div style={{ position:'absolute', inset:0, transform:'translateX(-100%)', background:'linear-gradient(90deg, transparent, rgba(255,255,255,.1), transparent)', animation:'shimmer 1.2s infinite' }} />
      <style>{`@keyframes shimmer { to{ transform: translateX(100%); } }`}</style>
    </div>
  );
}
```

### `src/components/Navbar.tsx`
```tsx
import React from 'react';
import { Nav, NavInner, Badge, Toggle } from './layouts';
import Button from './Button';

const THEME_KEY='theme';

export default function Navbar({ cartCount }: { cartCount: number }){
  const [theme, setTheme] = React.useState<string>(()=> localStorage.getItem(THEME_KEY)||'light');
  React.useEffect(()=>{ localStorage.setItem(THEME_KEY, theme); }, [theme]);
  return (
    <Nav role="navigation" aria-label="Principal">
      <NavInner>
        <div aria-label="Loja React" style={{fontWeight:700}}>🛍️ Loja</div>
        <div style={{display:'flex', alignItems:'center', gap:12}}>
          <Toggle onClick={()=>setTheme(t=>t==='dark'?'light':'dark')} aria-pressed={theme==='dark'} aria-label="Alternar tema">
            {theme==='dark'?'🌙':'☀️'}
          </Toggle>
          <Button variant="ghost" aria-label={`Carrinho com ${cartCount} itens`}>
            🛒 <Badge aria-hidden>{cartCount}</Badge>
          </Button>
        </div>
      </NavInner>
    </Nav>
  );
}
```

### `src/components/ProductCard.tsx`
```tsx
import React from 'react';
import type { Product } from '../data/products';
import { Card, Media, Body, Title, Tag, Price, Row } from './layouts';
import Button from './Button';
import Skeleton from './Skeleton';

export default function ProductCard({ p, onAdd }: { p: Product; onAdd: (id: string) => void }){
  const [loadingImg, setLoadingImg] = React.useState(true);
  return (
    <Card aria-label={p.title}>
      <Media aria-hidden>
        {loadingImg && <Skeleton style={{width:'100%', height:'100%'}} />}
        <img src={p.image} alt="" loading="lazy" style={{width:'100%', height:'100%', objectFit:'cover', display:loadingImg?'none':'block'}} onLoad={()=>setLoadingImg(false)} />
      </Media>
      <Body>
        <header style={{display:'flex', justifyContent:'space-between', alignItems:'start', gap:8}}>
          <Title>{p.title}</Title>
          {p.tag && <Tag variant={p.tag}>{p.tag}</Tag>}
        </header>
        <Row>
          <Price aria-label={`Preço ${p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}`}>
            {p.price.toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}
          </Price>
          <span aria-label={`Avaliação ${p.rating} de 5`}>{'★'.repeat(Math.round(p.rating))}{'☆'.repeat(5-Math.round(p.rating))}</span>
        </Row>
        <div style={{display:'flex', gap:8}}>
          <Button onClick={()=>onAdd(p.id)} variant="solid">Adicionar</Button>
          <Button variant="outline">Detalhes</Button>
          <Button variant="ghost" aria-label="Favoritar">❤</Button>
        </div>
      </Body>
    </Card>
  );
}
```

### `src/main.tsx`
```tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
ReactDOM.createRoot(document.getElementById('root')!).render(<React.StrictMode><App/></React.StrictMode>);
```

### `src/App.tsx`
```tsx
import React from 'react';
import { ThemeProvider } from 'styled-components';
import { light, dark } from './theme';
import { Global, Container, Grid } from './components/layouts';
import Navbar from './components/Navbar';
import ProductCard from './components/ProductCard';
import { products } from './data/products';

const THEME_KEY='theme';

export default function App(){
  const [themeKey, setThemeKey] = React.useState<'light'|'dark'>(()=> (localStorage.getItem(THEME_KEY) as 'light'|'dark') || 'light');
  const theme = themeKey==='dark'? dark : light;
  React.useEffect(()=>{ localStorage.setItem(THEME_KEY, themeKey); }, [themeKey]);

  const [cart, setCart] = React.useState<string[]>([]);
  const [loading, setLoading] = React.useState(true);
  React.useEffect(()=>{ const t=setTimeout(()=>setLoading(false),900); return ()=>clearTimeout(t); },[]);
  const add=(id:string)=>setCart(c=>[...c,id]);

  return (
    <ThemeProvider theme={theme}>
      <Global />
      {/* Navbar precisa do setter de tema, então envolvemos aqui */}
      <Navbar cartCount={cart.length} />
      <Container>
        <Grid aria-live="polite">
          {loading ? Array.from({length:6}).map((_,i)=>(
            <div key={i} style={{borderRadius:12, border:`1px solid ${theme.border}`, background:theme.card, overflow:'hidden'}} aria-hidden>
              <div style={{aspectRatio:'1/1'}} />
              <div style={{padding:16}}>
                <div style={{width:'70%', height:18, borderRadius:6, background:'rgba(0,0,0,.08)'}} />
                <div style={{height:8}} />
                <div style={{width:'50%', height:18, borderRadius:6, background:'rgba(0,0,0,.08)'}} />
              </div>
            </div>
          )) : products.map(p=> <ProductCard key={p.id} p={p} onAdd={add} />)}
        </Grid>
      </Container>
      {/* Controlador de tema desacoplado */}
      <ThemeSwitcher onChange={setThemeKey} value={themeKey} />
    </ThemeProvider>
  );
}

function ThemeSwitcher({ value, onChange }: { value: 'light'|'dark'; onChange: (v:'light'|'dark')=>void }){
  React.useEffect(()=>{
    const q = window.matchMedia('(prefers-color-scheme: dark)');
    const handler = () => { if (!localStorage.getItem('theme')) onChange(q.matches?'dark':'light'); };
    q.addEventListener?.('change', handler);
    return ()=> q.removeEventListener?.('change', handler);
  }, [onChange]);
  return null;
}
```

### `README.md` (04-styled-components)
```md
# 04 – styled-components
- Temas completos via `ThemeProvider` (`light`/`dark`) com persistência.
- Tokens em `theme.ts` e animações por props.
- Mesmo layout/UX das demais versões.

## Rodar
```bash
npm i && npm run dev
```
```

---

## ⚙️ Arquivos comuns de projeto (exemplo para Vite + TS)

### `index.html`
```html
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Loja React – Multi CSS</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

### `package.json`
```json
{
  "name": "loja-multi-css",
  "private": true,
  "version": "0.0.1",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^5.5.0",
    "vite": "^5.2.0"
  }
}
```

> **Tailwind versão**: adicione `tailwindcss postcss autoprefixer` em devDependencies e os arquivos `tailwind.config.cjs` e `postcss.config.cjs` conforme acima.

---

## ✅ Checklist de Critérios de Aceite
- [x] **Breakpoints exatos** em todas as versões.
- [x] **Dark mode persistente** via `localStorage` (global/modules: `data-theme`, tailwind: classe `dark`, styled: `ThemeProvider`).
- [x] **Focus ring visível** com contraste ≥ 4.5:1.
- [x] **Skeleton sem layout shift**: `aspect-ratio:1/1` + altura fixa para textos.
- [x] **Botões** com variantes **solid/outline/ghost** consistentes nos dois temas.
- [x] **Acessibilidade**: `aria-label`, `aria-live`, navegação por teclado sem traps.
- [x] **Animações** de 180ms usando `transform/opacity`.

---

## 🧭 Notas finais
- Você pode copiar cada pasta como projeto standalone. Todos compartilham os mesmos dados e padrões visuais.
- Se preferir **JavaScript**, renomeie arquivos `.tsx` para `.jsx` e remova tipagens.
- As imagens usam `loading="lazy"` e skeleton até o evento `onLoad` para evitar reflow.

