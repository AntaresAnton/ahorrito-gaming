Quiero convertir mi proyecto web estático "Ahorrito Gaming" (tienda de juegos digitales) a una aplicación Django completa. El proyecto actual está construido con HTML, CSS, JavaScript y Bootstrap 5.

Necesito instrucciones detalladas para:

1. Configurar la estructura inicial del proyecto Django:
   - Crear el proyecto y las aplicaciones necesarias
   - Organizar los archivos estáticos (CSS, JS, imágenes)
   - Convertir los HTML estáticos a plantillas Django con herencia

2. Modelar la base de datos para:
   - Productos (juegos, DLCs, gift cards)
   - Categorías y plataformas
   - Usuarios y autenticación
   - Carritos de compra y pedidos
   - Blog y contenido estático

3. Implementar las vistas y URLs para cada página HTML existente:
   - index.html (Página principal)
   - pc.html, playstation.html, xbox.html, nintendo.html (Catálogos por plataforma)
   - ofertas.html (Sección de ofertas)
   - precompras.html (Juegos en pre-venta)
   - dlcs.html (Contenido descargable)
   - giftcards.html (Tarjetas de regalo)
   - software.html (Software y aplicaciones)
   - login.html, registro.html (Autenticación)
   - carrito.html (Carrito de compras)
   - favoritos.html (Lista de favoritos)
   - blog.html (Blog y noticias)
   - contacto.html (Formulario de contacto)
   - sobre-nosotros.html, faq.html, terminos.html, privacidad.html, devoluciones.html, afiliados.html (Páginas estáticas)

4. Añadir funcionalidades dinámicas:
   - Sistema de búsqueda
   - Filtrado de productos
   - Contador de ofertas flash
   - Notificaciones de carrito
   - Gestión de favoritos
   - Sistema de reseñas

5. Configurar el deploy de prueba:
   - Preparación para producción
   - Opciones de hosting (preferiblemente económicas/gratuitas)
   - Configuración de archivos estáticos y media
   - Configuración de base de datos

Estructura actual del proyecto:
- index.html (página principal)
- ahorrito-links.html (página con enlaces)
- includes/menu.html (componente de navegación)
- pc.html, playstation.html, xbox.html, nintendo.html (catálogos por plataforma)
- ofertas.html, precompras.html, dlcs.html, giftcards.html, software.html (categorías especiales)
- login.html, registro.html (autenticación)
- carrito.html, favoritos.html (funcionalidades de usuario)
- blog.html, contacto.html (contenido adicional)
- sobre-nosotros.html, faq.html, terminos.html, privacidad.html, devoluciones.html, afiliados.html (páginas informativas)
- assets/css/styles.css
- assets/js/scripts.js

Tecnologías actuales:
- HTML5
- CSS3 (Bootstrap 5)
- JavaScript
- Font Awesome
- Google Fonts

Quiero mantener el diseño visual actual pero implementando toda la funcionalidad con Django, creando los modelos, vistas y controladores necesarios para cada sección del sitio.
