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
