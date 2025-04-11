# Ahorrito Gaming 🎮

Este repositorio contiene un mockup funcional UX/UI para la web Ahorrito Gaming, una plataforma de venta de videojuegos.

## Estructura del Repositorio 📁

### Base de Datos 💾

- **modelo-ejemplo.sql** - Esquema de base de datos SQL que define la estructura de tablas para la aplicación:
  - `carritos` - Almacena información de carritos de compra de usuarios
  - `banners` - Gestiona banners promocionales para la web
  - `plataformas` - Catálogo de plataformas de juegos (PC, PlayStation, Xbox, etc.)
  - `notificaciones` - Sistema de notificaciones para usuarios
  - `ciudades` - Información geográfica para envíos y facturación
  - `paginas` - Contenido para páginas estáticas del sitio
  - `mensajes_contacto` - Formularios de contacto enviados por usuarios
  - `regiones` - Divisiones geográficas para envíos
  - `suscripciones_newsletter` - Gestión de suscriptores al boletín
  - `respuestas_pregunta` - Respuestas a preguntas sobre productos
  - `faq` - Preguntas frecuentes del sitio
  - `configuracion_sistema` - Parámetros de configuración de la aplicación
  - `producto_plataforma` - Relación entre productos y plataformas disponibles
  - `producto_categoria` - Categorización de productos
  - `dlc_juego_base` - Relación entre DLCs y sus juegos base

### Documentación 📄

- **README.md** - Información general sobre el proyecto

## Características Principales ✨

- Sistema de carrito de compras
- Gestión de usuarios y notificaciones
- Catálogo de productos con categorías y plataformas
- Sistema de preguntas y respuestas sobre productos
- Gestión de contenido estático (páginas, FAQs)
- Suscripción a newsletter
- Sistema de contacto
- Configuración flexible del sistema

## Tecnologías 🛠️

- Base de datos MySQL
- Diseño UX/UI (mockups funcionales)

## Estructura del Proyecto 📂

```
📦 ahorrito-gaming
 ┣ 📂 admin                      # Panel de administración
 ┃ ┣ 📂 assets                   # Recursos para el panel admin
 ┃ ┣ 📄 categorias.html          # Gestión de categorías
 ┃ ┣ 📄 clientes.html            # Gestión de clientes
 ┃ ┣ 📄 configuracion.html       # Configuración del sistema
 ┃ ┣ 📄 cupones.html             # Gestión de cupones
 ┃ ┣ 📄 dashboard.html           # Panel principal
 ┃ ┣ 📄 pedidos.html             # Gestión de pedidos
 ┃ ┣ 📄 productos.html           # Gestión de productos
 ┃ ┣ 📄 reportes.html            # Informes y estadísticas
 ┃ ┗ 📄 resenas.html             # Gestión de reseñas
 ┣ 📂 atomic                     # Componentes de diseño atómico
 ┃ ┣ 📄 molecules.html           # Componentes moleculares
 ┃ ┣ 📄 organisms.html           # Componentes orgánicos
 ┃ ┗ 📄 templates.html           # Plantillas
 ┣ 📂 css                        # Estilos
 ┃ ┗ 📄 styles.css               # Hoja de estilos principal
 ┣ 📂 img                        # Imágenes y recursos gráficos
 ┣ 📂 includes                   # Componentes reutilizables
 ┃ ┣ 📄 footer.html              # Pie de página
 ┃ ┗ 📄 menu.html                # Menú de navegación
 ┣ 📂 js                         # JavaScript
 ┃ ┗ 📄 scripts.js               # Scripts principales
 ┣ 📂 status                     # Páginas de estado del sistema
 ┃ ┣ 📄 404.html                 # Página de error 404
 ┃ ┣ 📄 500.html                 # Página de error 500
 ┃ ┣ 📄 en-construccion.html     # Página en construcción
 ┃ ┗ 📄 mantenimiento.html       # Página de mantenimiento
 ┣ 📂 utils                      # Utilidades
 ┣ 📄 .gitattributes             # Configuración de Git
 ┣ 📄 afiliados.html             # Página de programa de afiliados
 ┣ 📄 blog.html                  # Blog
 ┣ 📄 carrito.html               # Carrito de compras
 ┣ 📄 categoria.html             # Página de categoría
 ┣ 📄 contacto.html              # Formulario de contacto
 ┣ 📄 dashboard-usuario.html     # Panel de usuario
 ┣ 📄 devoluciones.html          # Política de devoluciones
 ┣ 📄 directorios.bat            # Script para generar estructura
 ┣ 📄 dlcs.html                  # Página de DLCs
 ┣ 📄 estructura_20250411.txt    # Estructura del proyecto actualizada
 ┣ 📄 faq.html                   # Preguntas frecuentes
 ┣ 📄 favoritos.html             # Lista de favoritos
 ┣ 📄 giftcards.html             # Tarjetas de regalo
 ┣ 📄 index.html                 # Página principal
 ┣ 📄 login.html                 # Inicio de sesión
 ┣ 📄 modelo-ejemplo.sql         # Esquema de base de datos
 ┣ 📄 nintendo.html              # Productos Nintendo
 ┣ 📄 ofertas.html               # Ofertas especiales
 ┣ 📄 pc.html                    # Productos para PC
 ┣ 📄 playstation.html           # Productos PlayStation
 ┣ 📄 precompras.html            # Pre-compras
 ┣ 📄 privacidad.html            # Política de privacidad
 ┣ 📄 producto.html              # Página de producto
 ┣ 📄 prompt-django.md           # Documentación Django
 ┣ 📄 README.md                  # Documentación principal
 ┣ 📄 registro.html              # Registro de usuario
 ┣ 📄 resenas-valoraciones.html  # Reseñas y valoraciones
 ┣ 📄 sobre-nosotros.html        # Acerca de la empresa
 ┣ 📄 software.html              # Software
 ┣ 📄 terminos.html              # Términos y condiciones
 ┗ 📄 xbox.html                  # Productos Xbox

```

# Componentes Reutilizables: Sistema de Includes 🧩

## ¿Qué son los Includes? 📋

Los includes son fragmentos de código HTML que se diseñan para ser reutilizados en múltiples páginas de un sitio web. En Ahorrito Gaming, implementamos un sistema de includes para mejorar la mantenibilidad y consistencia del código.

## Estructura de Includes 📂

```
📂 includes
 ┣ 📄 footer.html    # Pie de página común para todas las páginas
 ┗ 📄 menu.html      # Menú de navegación principal
```

## ¿Por qué implementamos Includes? 🤔

### Ventajas principales:

1. **Mantenimiento simplificado** ✅
   - Al modificar un componente (como el menú), el cambio se refleja automáticamente en todas las páginas
   - Reduce la duplicación de código y el riesgo de inconsistencias

2. **Consistencia en la experiencia de usuario** 🔄
   - Garantiza que elementos críticos como la navegación y el pie de página sean idénticos en todo el sitio
   - Mejora la familiaridad y usabilidad para los visitantes

3. **Desarrollo más eficiente** ⚡
   - Permite que diferentes desarrolladores trabajen en componentes específicos sin interferir con otros
   - Facilita la implementación de cambios globales sin editar cada archivo HTML individualmente

## Implementación en Ahorrito Gaming 🎮

### Menú de Navegación (`menu.html`)

El menú se implementó como include porque:
- Es un elemento crítico presente en todas las páginas
- Contiene enlaces a categorías principales (PC, PlayStation, Xbox, Nintendo)
- Incluye funcionalidades como búsqueda, acceso al carrito y cuenta de usuario
- Requiere actualizaciones frecuentes cuando se añaden nuevas secciones

### Pie de Página (`footer.html`)

El footer se implementó como include porque:
- Contiene información legal importante (términos, privacidad)
- Incluye enlaces a páginas informativas (sobre nosotros, contacto, FAQ)
- Presenta métodos de pago y redes sociales
- Debe mantenerse consistente en todo el sitio

## Beneficios para el Proyecto 📈

Esta arquitectura modular nos permite:
- Realizar cambios globales rápidamente
- Mantener una experiencia de usuario coherente
- Reducir el tamaño total del código
- Facilitar la colaboración entre miembros del equipo

---

*La implementación de includes es una práctica estándar en desarrollo web moderno que mejora significativamente la mantenibilidad y escalabilidad del proyecto Ahorrito Gaming.*


---

*Este proyecto es un mockup funcional para demostrar la estructura y funcionalidades de la plataforma Ahorrito Gaming.*
