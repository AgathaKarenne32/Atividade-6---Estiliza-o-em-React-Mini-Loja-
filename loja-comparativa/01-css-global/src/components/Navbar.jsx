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
