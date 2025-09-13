import React, { useState, useEffect } from 'react';
import Navbar from './components/Navbar';
import ProductCard from './components/ProductCard';
import ProductCardSkeleton from './components/ProductCardSkeleton';
import { products } from './data/products';

// Função auxiliar para determinar o tema inicial
const getInitialTheme = () => {
  // 1. Verifica se há um tema salvo no localStorage
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme) {
    return savedTheme;
  }
  // 2. Se não, verifica a preferência do sistema do usuário
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
};

export default function App() {
  const [cart, setCart] = useState([]);
  const [loading, setLoading] = useState(true);
  // Gerenciando o estado do tema
  const [theme, setTheme] = useState(getInitialTheme);

  // Função para trocar o tema
  const toggleTheme = () => {
    setTheme(prevTheme => (prevTheme === 'light' ? 'dark' : 'light'));
  };

  useEffect(() => {
    const t = setTimeout(() => setLoading(false), 1200);
    return () => clearTimeout(t);
  }, []);

  // Efeito para aplicar o tema no HTML e salvar no localStorage
  useEffect(() => {
    // Aplica o atributo `data-theme` na tag <html>
    document.documentElement.setAttribute('data-theme', theme);
    // Salva a escolha do usuário no localStorage
    localStorage.setItem('theme', theme);
  }, [theme]); // Roda sempre que o estado 'theme' mudar

  const add = (id) => setCart(c => [...c, id]);

  return (
    <>
      {/* Passando o tema atual e a função de troca para o Navbar */}
      <Navbar 
        cartCount={cart.length} 
        theme={theme} 
        onToggleTheme={toggleTheme} 
      />
      <main className="container">
        <section className="grid" aria-live="polite">
          {loading
            ? Array.from({ length: 6 }).map((_, i) => <ProductCardSkeleton key={i} />)
            : products.map(p => <ProductCard key={p.id} p={p} onAdd={add} />)}
        </section>
      </main>
    </>
  );
}