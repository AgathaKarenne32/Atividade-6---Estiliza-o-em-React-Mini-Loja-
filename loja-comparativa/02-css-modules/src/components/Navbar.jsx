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
