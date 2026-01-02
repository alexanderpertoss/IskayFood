// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

document.addEventListener('turbo:load', () => {
  let lastScrollTop = 0;
  const navbar = document.getElementById('navigation-bar');
  const navbarHeight = navbar.offsetHeight; // Obtiene la altura real de la barra

  // Temporizador para esconder si el scroll se detiene
  let scrollTimeout;

  jarallax(document.querySelectorAll('.jarallax'), {
    speed: 0.5
  });

  window.addEventListener('scroll', () => {
    // 1. Detectar la Dirección del Scroll
    const currentScroll = window.pageYOffset || document.documentElement.scrollTop;

    if (currentScroll > lastScrollTop && currentScroll > navbarHeight) {
      // Scroll hacia ABAJO (Ocultar)
      navbar.classList.add('navbar-hidden');
    } else {
      // Scroll hacia ARRIBA (Mostrar)
      navbar.classList.remove('navbar-hidden');
    }
    
    lastScrollTop = currentScroll <= 0 ? 0 : currentScroll; 

    // 2. Lógica del Timeout (Esconder si se detiene)
    // Limpia el timeout anterior
    clearTimeout(scrollTimeout); 
    
    // Configura un nuevo timeout (ej. 2000 milisegundos = 2 segundos)
    scrollTimeout = setTimeout(() => {
        // Solo ocultamos si NO estamos en el tope (para no ocultarla al cargar la página)
        if (currentScroll > navbarHeight) {
            navbar.classList.add('navbar-hidden');
        }
    }, 3000); // <-- AJUSTA ESTE TIEMPO (en milisegundos)
    
  }, false);
});

document.addEventListener("DOMContentLoaded", function () {
  
});