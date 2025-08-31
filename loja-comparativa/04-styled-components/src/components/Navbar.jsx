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
