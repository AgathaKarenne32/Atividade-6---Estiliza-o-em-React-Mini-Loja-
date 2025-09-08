import React from 'react';

// Para resolver o erro de importação, o componente Skeleton foi definido
// diretamente neste arquivo. Ele cria o elemento visual para o estado de carregamento.
function Skeleton({ style = {}, className = '' }) {
  const finalClassName = ['skeleton', className].filter(Boolean).join(' ');
  return <div className={finalClassName} style={style} aria-hidden="true" />;
}


// Este componente encapsula a aparência de um card em estado de carregamento.
// Usá-lo garante que todos os skeletons de card sejam idênticos e
// que a lógica de sua estrutura não "polua" outros componentes.
export default function ProductCardSkeleton() {
  return (
    // A estrutura externa (<article className="card">) é idêntica à do ProductCard
    // para garantir que não haja "salto" no layout (layout shift) quando o conteúdo carregar.
    <article className="card" aria-hidden="true">
      
      {/* Skeleton da imagem: .card-media define o aspect-ratio, e o componente Skeleton aplica a animação. */}
      <Skeleton className="card-media" />

      <div className="card-body">
        {/* Skeletons do corpo do card, usando as classes utilitárias que já definimos no globals.css */}
        <Skeleton className="s-line s-line-70" />
        <Skeleton className="s-line s-line-50" />
        
        {/* Skeletons dos botões, para simular a área de ações. O marginTop: 'auto' é importante
            para empurrar os botões para o final do card, assim como no design real. */}
        <div style={{ display: 'flex', gap: '8px', marginTop: 'auto' }}>
          <Skeleton className="s-box" style={{ flex: '1' }} />
          <Skeleton className="s-box" style={{ flex: '1' }} />
          <Skeleton className="s-box" style={{ width: '40px' }} />
        </div>
      </div>
    </article>
  );
}
