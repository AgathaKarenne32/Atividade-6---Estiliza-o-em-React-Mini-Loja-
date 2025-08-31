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
