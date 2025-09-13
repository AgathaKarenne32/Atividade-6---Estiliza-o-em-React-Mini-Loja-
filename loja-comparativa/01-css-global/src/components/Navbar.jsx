import React from 'react';
import Button from './Button';

// Recebendo as novas props: theme e onToggleTheme
export default function Navbar({ cartCount = 0, theme, onToggleTheme }) {
  return (
    <nav className="nav">
      <div className="container">
        <div className="nav-inner">
          <span className="logo">TechStore</span>
          <div className="actions">
            {/* O botão agora tem um onClick e exibe o ícone correto */}
            <button 
              className="theme-toggle" 
              onClick={onToggleTheme} 
              aria-label={`Mudar para tema ${theme === 'light' ? 'escuro' : 'claro'}`}
            >
              {theme === 'light' ? '🌙' : '☀️'}
            </button>
            <Button variant="ghost">
              Carrinho <span className="cart-badge">{cartCount}</span>
            </Button>
          </div>
        </div>
      </div>
    </nav>
  );
}
