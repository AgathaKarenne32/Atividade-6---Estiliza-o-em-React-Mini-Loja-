import React from 'react';
import Button from './Button'; 

export default function ProductCard({ p, onAdd }) {
  return (
    <article className="card">
      <div className="card-media">
        <img src={p.image} alt={p.title} width="600" height="600" />
      </div>

      <div className="card-body">
        {p.tag && <span className="tag" data-variant={p.tag}>{p.tag}</span>}
        <h3 className="card-title">{p.title}</h3>
        
        <div className="card-meta">
          <span className="price">R$ {p.price.toFixed(2).replace('.', ',')}</span>
          <span>⭐ {p.rating}</span>
        </div>

        <div style={{ display: 'flex', gap: '8px', marginTop: 'auto' }}>
          <Button variant="solid" style={{ flex: '1' }} onClick={() => onAdd(p.id)}>
            Adicionar
          </Button>
          <Button variant="outline" style={{ flex: '1' }}>
            Detalhes
          </Button>
          <Button variant="ghost">
            ♡
          </Button>
        </div>
      </div>
    </article>
  );
}