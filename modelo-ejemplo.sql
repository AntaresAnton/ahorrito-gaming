-- Creación de la base de datos
CREATE DATABASE ahorrito_gaming;
USE ahorrito_gaming;

-- Tabla de Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    direccion TEXT,
    ciudad VARCHAR(100),
    region VARCHAR(100),
    codigo_postal VARCHAR(20),
    pais VARCHAR(100) DEFAULT 'Chile',
    tipo_usuario ENUM('cliente', 'admin', 'editor', 'soporte', 'super_admin') DEFAULT 'cliente',
    estado ENUM('activo', 'inactivo', 'suspendido', 'pendiente') DEFAULT 'pendiente',
    ultimo_acceso DATETIME,
    ip_ultimo_acceso VARCHAR(45),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE INDEX idx_email (email)
);

-- Tabla de Permisos de Administrador
CREATE TABLE permisos_admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    gestion_productos BOOLEAN DEFAULT FALSE,
    gestion_pedidos BOOLEAN DEFAULT FALSE,
    gestion_usuarios BOOLEAN DEFAULT FALSE,
    gestion_admins BOOLEAN DEFAULT FALSE,
    acceso_informes BOOLEAN DEFAULT FALSE,
    configuracion_sistema BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de Plataformas
CREATE TABLE plataformas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(255),
    color_badge VARCHAR(50) DEFAULT '#7b4cff',
    activo BOOLEAN DEFAULT TRUE,
    UNIQUE INDEX idx_slug (slug)
);

-- Tabla de Categorías
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(255),
    imagen VARCHAR(255),
    categoria_padre_id INT NULL,
    orden INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_padre_id) REFERENCES categorias(id) ON DELETE SET NULL,
    UNIQUE INDEX idx_slug (slug)
);

-- Tabla de Productos
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    descripcion TEXT,
    descripcion_corta VARCHAR(500),
    precio DECIMAL(10, 2) NOT NULL,
    precio_descuento DECIMAL(10, 2),
    porcentaje_descuento INT,
    stock INT DEFAULT 0,
    sku VARCHAR(100) UNIQUE,
    imagen_principal VARCHAR(255),
    fecha_lanzamiento DATE,
    desarrollador VARCHAR(255),
    editor VARCHAR(255),
    clasificacion_edad VARCHAR(50),
    idiomas_disponibles TEXT,
    requisitos_sistema TEXT,
    tipo_producto ENUM('juego', 'dlc', 'giftcard', 'software') DEFAULT 'juego',
    es_destacado BOOLEAN DEFAULT FALSE,
    es_precompra BOOLEAN DEFAULT FALSE,
    es_oferta_flash BOOLEAN DEFAULT FALSE,
    oferta_flash_fin DATETIME,
    visibilidad ENUM('visible', 'oculto', 'archivado') DEFAULT 'visible',
    estado ENUM('activo', 'inactivo', 'agotado') DEFAULT 'activo',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    creado_por INT,
    FOREIGN KEY (creado_por) REFERENCES usuarios(id) ON DELETE SET NULL,
    UNIQUE INDEX idx_slug (slug),
    INDEX idx_tipo_producto (tipo_producto),
    INDEX idx_estado (estado)
);

-- Tabla de relación Productos-Plataformas
CREATE TABLE producto_plataforma (
    producto_id INT NOT NULL,
    plataforma_id INT NOT NULL,
    PRIMARY KEY (producto_id, plataforma_id),
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (plataforma_id) REFERENCES plataformas(id) ON DELETE CASCADE
);

-- Tabla de relación Productos-Categorías
CREATE TABLE producto_categoria (
    producto_id INT NOT NULL,
    categoria_id INT NOT NULL,
    PRIMARY KEY (producto_id, categoria_id),
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
);

-- Tabla de Imágenes de Productos
CREATE TABLE imagenes_producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,
    orden INT DEFAULT 0,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de Claves de Productos
CREATE TABLE claves_producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    clave VARCHAR(255) NOT NULL,
    estado ENUM('disponible', 'reservada', 'vendida') DEFAULT 'disponible',
    pedido_id INT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_venta DATETIME,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE SET NULL,
    UNIQUE INDEX idx_clave (clave)
);

-- Tabla de Reseñas de Productos
CREATE TABLE resenas_producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    usuario_id INT NOT NULL,
    calificacion TINYINT NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    titulo VARCHAR(255),
    comentario TEXT,
    estado ENUM('pendiente', 'aprobada', 'rechazada') DEFAULT 'pendiente',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_usuario_producto (usuario_id, producto_id)
);

-- Tabla de Favoritos
CREATE TABLE favoritos (
    usuario_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, producto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de Carritos
CREATE TABLE carritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    sesion_id VARCHAR(255) NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_sesion_id (sesion_id)
);

-- Tabla de Items de Carrito
CREATE TABLE items_carrito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    carrito_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (carrito_id) REFERENCES carritos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_carrito_producto (carrito_id, producto_id)
);

-- Tabla de Pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    codigo_pedido VARCHAR(50) NOT NULL UNIQUE,
    email_cliente VARCHAR(150) NOT NULL,
    nombre_cliente VARCHAR(100) NOT NULL,
    apellido_cliente VARCHAR(100) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    descuento DECIMAL(10, 2) DEFAULT 0,
    impuestos DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    estado ENUM('pendiente', 'pagado', 'completado', 'cancelado', 'reembolsado') DEFAULT 'pendiente',
    metodo_pago VARCHAR(100),
    referencia_pago VARCHAR(255),
    notas TEXT,
    ip_cliente VARCHAR(45),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_codigo_pedido (codigo_pedido),
    INDEX idx_estado (estado)
);

-- Tabla de Items de Pedido
CREATE TABLE items_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    nombre_producto VARCHAR(255) NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    clave_id INT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE SET NULL,
    FOREIGN KEY (clave_id) REFERENCES claves_producto(id) ON DELETE SET NULL
);

-- Tabla de Historial de Estados de Pedido
CREATE TABLE historial_estados_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    estado ENUM('pendiente', 'pagado', 'completado', 'cancelado', 'reembolsado') NOT NULL,
    comentario TEXT,
    usuario_id INT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de Cupones de Descuento
CREATE TABLE cupones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    tipo ENUM('porcentaje', 'monto_fijo', 'envio_gratis') NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(255),
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    uso_maximo INT NULL,
    uso_actual INT DEFAULT 0,
    monto_minimo DECIMAL(10, 2) DEFAULT 0,
    es_primer_compra BOOLEAN DEFAULT FALSE,
    plataformas_aplicables TEXT,
    categorias_aplicables TEXT,
    productos_aplicables TEXT,
    activo BOOLEAN DEFAULT TRUE,
    creado_por INT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creado_por) REFERENCES usuarios(id) ON DELETE SET NULL,
    UNIQUE INDEX idx_codigo (codigo)
);

-- Tabla de Uso de Cupones
CREATE TABLE uso_cupones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cupon_id INT NOT NULL,
    pedido_id INT NOT NULL,
    usuario_id INT NULL,
    descuento_aplicado DECIMAL(10, 2) NOT NULL,
    fecha_uso DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cupon_id) REFERENCES cupones(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de Métodos de Pago
CREATE TABLE metodos_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    imagen VARCHAR(255),
    comision DECIMAL(5, 2) DEFAULT 0,
    instrucciones TEXT,
    activo BOOLEAN DEFAULT TRUE,
    orden INT DEFAULT 0
);

-- Tabla de Suscripciones a Newsletter
CREATE TABLE suscripciones_newsletter (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    nombre VARCHAR(100),
    fecha_suscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    token_confirmacion VARCHAR(255),
    fecha_confirmacion DATETIME,
    ip_suscripcion VARCHAR(45),
    UNIQUE INDEX idx_email (email)
);

-- Tabla de Entradas de Blog
CREATE TABLE blog_entradas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    contenido TEXT NOT NULL,
    extracto VARCHAR(500),
    imagen_destacada VARCHAR(255),
    autor_id INT NOT NULL,
    estado ENUM('borrador', 'publicado', 'archivado') DEFAULT 'borrador',
    fecha_publicacion DATETIME,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (autor_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_slug (slug)
);

-- Tabla de Categorías de Blog
CREATE TABLE blog_categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    UNIQUE INDEX idx_slug (slug)
);

-- Tabla de relación Entradas-Categorías de Blog
CREATE TABLE blog_entrada_categoria (
    entrada_id INT NOT NULL,
    categoria_id INT NOT NULL,
    PRIMARY KEY (entrada_id, categoria_id),
    FOREIGN KEY (entrada_id) REFERENCES blog_entradas(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES blog_categorias(id) ON DELETE CASCADE
);

-- Tabla de Comentarios de Blog
CREATE TABLE blog_comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entrada_id INT NOT NULL,
    usuario_id INT NULL,
    nombre VARCHAR(100),
    email VARCHAR(150),
    contenido TEXT NOT NULL,
    estado ENUM('pendiente', 'aprobado', 'spam', 'rechazado') DEFAULT 'pendiente',
    comentario_padre_id INT NULL,
    ip VARCHAR(45),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (entrada_id) REFERENCES blog_entradas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    FOREIGN KEY (comentario_padre_id) REFERENCES blog_comentarios(id) ON DELETE CASCADE
);

-- Tabla de Configuración del Sistema
CREATE TABLE configuracion_sistema (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT,
    tipo ENUM('texto', 'numero', 'booleano', 'json', 'fecha') DEFAULT 'texto',
    descripcion VARCHAR(255),
    grupo VARCHAR(100) DEFAULT 'general',
    es_publico BOOLEAN DEFAULT FALSE,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    actualizado_por INT NULL,
    FOREIGN KEY (actualizado_por) REFERENCES usuarios(id) ON DELETE SET NULL,
    UNIQUE INDEX idx_clave (clave)
);

-- Tabla de Registro de Auditoría
CREATE TABLE registro_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    accion ENUM('creacion', 'modificacion', 'eliminacion', 'acceso', 'aprobacion', 'rechazo', 'intento_fallido') NOT NULL,
    modulo VARCHAR(100) NOT NULL,
    entidad VARCHAR(100) NOT NULL,
    entidad_id VARCHAR(100),
    datos_previos TEXT,
    datos_nuevos TEXT,
    ip VARCHAR(45),
    user_agent VARCHAR(255),
    fecha_accion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_accion (accion),
    INDEX idx_modulo (modulo),
    INDEX idx_entidad (entidad),
    INDEX idx_fecha (fecha_accion)
);

-- Tabla de Configuración de Auditoría
CREATE TABLE configuracion_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    auditar_login BOOLEAN DEFAULT TRUE,
    auditar_productos BOOLEAN DEFAULT TRUE,
    auditar_pedidos BOOLEAN DEFAULT TRUE,
    auditar_usuarios BOOLEAN DEFAULT TRUE,
    auditar_admins BOOLEAN DEFAULT TRUE,
    auditar_config BOOLEAN DEFAULT TRUE,
    auditar_reportes BOOLEAN DEFAULT FALSE,
    periodo_retencion INT DEFAULT 5, -- en años
    frecuencia_backup VARCHAR(50) DEFAULT 'weekly',
    formato_exportacion VARCHAR(20) DEFAULT 'csv',
    cifrar_exportaciones BOOLEAN DEFAULT TRUE,
    notificar_login_fallido BOOLEAN DEFAULT TRUE,
    notificar_cambios_admin BOOLEAN DEFAULT TRUE,
    notificar_cambios_config BOOLEAN DEFAULT TRUE,
    emails_notificacion TEXT,
    registrar_ip BOOLEAN DEFAULT TRUE,
    registrar_user_agent BOOLEAN DEFAULT TRUE,
    proteccion_manipulacion BOOLEAN DEFAULT TRUE,
    firmar_registros BOOLEAN DEFAULT TRUE,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    actualizado_por INT NULL,
    FOREIGN KEY (actualizado_por) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de Sesiones
CREATE TABLE sesiones (
    id VARCHAR(255) PRIMARY KEY,
    usuario_id INT NULL,
    ip VARCHAR(45),
    user_agent VARCHAR(255),
    datos TEXT,
    ultima_actividad DATETIME,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_ultima_actividad (ultima_actividad)
);

-- Tabla de Tokens de Recuperación de Contraseña
CREATE TABLE tokens_recuperacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    fecha_expiracion DATETIME NOT NULL,
    usado BOOLEAN DEFAULT FALSE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_token (token)
);

-- Tabla de Historial de Precios
CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    precio_anterior DECIMAL(10, 2) NOT NULL,
    precio_nuevo DECIMAL(10, 2) NOT NULL,
    usuario_id INT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de Notificaciones
CREATE TABLE notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    mensaje TEXT NOT NULL,
    tipo VARCHAR(50) DEFAULT 'info',
    leida BOOLEAN DEFAULT FALSE,
    enlace VARCHAR(255),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario_leida (usuario_id, leida)
);

-- Tabla de Estadísticas de Visitas
CREATE TABLE estadisticas_visitas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pagina VARCHAR(255) NOT NULL,
    ip VARCHAR(45),
    user_agent VARCHAR(255),
    referrer VARCHAR(255),
    usuario_id INT NULL,
    fecha_visita DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_pagina (pagina),
    INDEX idx_fecha (fecha_visita)
);

-- Tabla de Estadísticas de Productos
CREATE TABLE estadisticas_productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    vistas INT DEFAULT 0,
    busquedas INT DEFAULT 0,
    carrito_agregados INT DEFAULT 0,
    carrito_eliminados INT DEFAULT 0,
    compras INT DEFAULT 0,
    fecha_actualizacion DATE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_producto_fecha (producto_id, fecha_actualizacion)
);

-- Tabla de Preguntas y Respuestas de Productos
CREATE TABLE preguntas_producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    usuario_id INT NOT NULL,
    pregunta TEXT NOT NULL,
    estado ENUM('pendiente', 'respondida', 'rechazada') DEFAULT 'pendiente',
    fecha_pregunta DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de Respuestas a Preguntas
CREATE TABLE respuestas_pregunta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pregunta_id INT NOT NULL,
    usuario_id INT NOT NULL,
    respuesta TEXT NOT NULL,
    fecha_respuesta DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas_producto(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de Requisitos de Sistema
CREATE TABLE requisitos_sistema (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    tipo ENUM('minimos', 'recomendados') NOT NULL,
    sistema_operativo VARCHAR(255),
    procesador VARCHAR(255),
    memoria VARCHAR(255),
    graficos VARCHAR(255),
    almacenamiento VARCHAR(255),
    adicionales TEXT,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_producto_tipo (producto_id, tipo)
);

-- Tabla de DLCs y Juegos Base
CREATE TABLE dlc_juego_base (
    dlc_id INT NOT NULL,
    juego_base_id INT NOT NULL,
    PRIMARY KEY (dlc_id, juego_base_id),
    FOREIGN KEY (dlc_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (juego_base_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de Paquetes de Productos
CREATE TABLE paquetes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    precio_individual_total DECIMAL(10, 2) NOT NULL,
    porcentaje_descuento INT,
    imagen VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE INDEX idx_slug (slug)
);

-- Tabla de Productos en Paquetes
CREATE TABLE productos_paquete (
    paquete_id INT NOT NULL,
    producto_id INT NOT NULL,
    PRIMARY KEY (paquete_id, producto_id),
    FOREIGN KEY (paquete_id) REFERENCES paquetes(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de Wishlist (Lista de Deseos)
CREATE TABLE wishlist (
    usuario_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, producto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de Alertas de Precio
CREATE TABLE alertas_precio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    producto_id INT NOT NULL,
    precio_objetivo DECIMAL(10, 2) NOT NULL,
    activa BOOLEAN DEFAULT TRUE,
    notificada BOOLEAN DEFAULT FALSE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_notificacion DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_usuario_producto (usuario_id, producto_id)
);

-- Tabla de Contacto/Mensajes
CREATE TABLE mensajes_contacto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    asunto VARCHAR(255) NOT NULL,
    mensaje TEXT NOT NULL,
    estado ENUM('pendiente', 'leido', 'respondido', 'archivado') DEFAULT 'pendiente',
    ip VARCHAR(45),
    fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_respuesta DATETIME,
    respondido_por INT NULL,
    FOREIGN KEY (respondido_por) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de FAQ (Preguntas Frecuentes)
CREATE TABLE faq (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pregunta VARCHAR(255) NOT NULL,
    respuesta TEXT NOT NULL,
    categoria VARCHAR(100) DEFAULT 'general',
    orden INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de Páginas Estáticas
CREATE TABLE paginas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    contenido TEXT NOT NULL,
    meta_descripcion VARCHAR(255),
    meta_keywords VARCHAR(255),
    estado ENUM('borrador', 'publicado', 'archivado') DEFAULT 'borrador',
    requiere_autenticacion BOOLEAN DEFAULT FALSE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    creado_por INT NULL,
    FOREIGN KEY (creado_por) REFERENCES usuarios(id) ON DELETE SET NULL,
    UNIQUE INDEX idx_slug (slug)
);

-- Tabla de Banners
CREATE TABLE banners (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    subtitulo VARCHAR(255),
    imagen VARCHAR(255) NOT NULL,
    enlace VARCHAR(255),
    texto_boton VARCHAR(100),
    posicion VARCHAR(100) DEFAULT 'home_principal',
    orden INT DEFAULT 0,
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Logs de Errores
CREATE TABLE logs_errores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nivel VARCHAR(50) NOT NULL,
    mensaje TEXT NOT NULL,
    archivo VARCHAR(255),
    linea INT,
    traza TEXT,
    usuario_id INT NULL,
    ip VARCHAR(45),
    user_agent VARCHAR(255),
    fecha_error DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de Países
CREATE TABLE paises (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(2) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de Regiones/Estados
CREATE TABLE regiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pais_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (pais_id) REFERENCES paises(id) ON DELETE CASCADE
);

-- Tabla de Ciudades
CREATE TABLE ciudades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    region_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (region_id) REFERENCES regiones(id) ON DELETE CASCADE
);

-- Tabla de Direcciones de Usuario
CREATE TABLE direcciones_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    ciudad_id INT,
    region_id INT,
    pais_id INT NOT NULL,
    codigo_postal VARCHAR(20),
    telefono VARCHAR(20),
    es_principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(id) ON DELETE SET NULL,
    FOREIGN KEY (region_id) REFERENCES regiones(id) ON DELETE SET NULL,
    FOREIGN KEY (pais_id) REFERENCES paises(id) ON DELETE CASCADE
);

-- Tabla de Impuestos
CREATE TABLE impuestos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    porcentaje DECIMAL(5, 2) NOT NULL,
    pais_id INT NULL,
    region_id INT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (pais_id) REFERENCES paises(id) ON DELETE CASCADE,
    FOREIGN KEY (region_id) REFERENCES regiones(id) ON DELETE CASCADE
);

-- Índices adicionales para optimizar consultas frecuentes
CREATE INDEX idx_productos_destacados ON productos(es_destacado, estado, visibilidad);
CREATE INDEX idx_productos_ofertas ON productos(es_oferta_flash, oferta_flash_fin, estado, visibilidad);
CREATE INDEX idx_productos_precompra ON productos(es_precompra, fecha_lanzamiento, estado, visibilidad);
CREATE INDEX idx_productos_precio ON productos(precio, precio_descuento);
CREATE INDEX idx_productos_tipo_estado ON productos(tipo_producto, estado, visibilidad);
CREATE INDEX idx_pedidos_usuario_estado ON pedidos(usuario_id, estado);
CREATE INDEX idx_pedidos_fecha ON pedidos(fecha_creacion);
CREATE INDEX idx_usuarios_tipo ON usuarios(tipo_usuario, estado);
CREATE INDEX idx_auditoria_usuario_fecha ON registro_auditoria(usuario_id, fecha_accion);

-- Inserción de datos iniciales

-- Plataformas básicas
INSERT INTO plataformas (nombre, slug, descripcion, color_badge) VALUES 
('PC', 'pc', 'Juegos para computadoras personales', '#28a745'),
('PlayStation 5', 'ps5', 'Juegos para PlayStation 5', '#0275d8'),
('PlayStation 4', 'ps4', 'Juegos para PlayStation 4', '#0275d8'),
('Xbox Series X|S', 'xbox-series', 'Juegos para Xbox Series X|S', '#dc3545'),
('Xbox One', 'xbox-one', 'Juegos para Xbox One', '#dc3545'),
('Nintendo Switch', 'nintendo-switch', 'Juegos para Nintendo Switch', '#ffc107');

-- Categorías principales
INSERT INTO categorias (nombre, slug, descripcion, icono) VALUES 
('Acción', 'accion', 'Juegos de acción y aventura', 'fas fa-fist-raised'),
('RPG', 'rpg', 'Juegos de rol', 'fas fa-dragon'),
('Carreras', 'carreras', 'Juegos de carreras y simuladores', 'fas fa-car'),
('Deportes', 'deportes', 'Juegos de deportes y competición', 'fas fa-futbol'),
('Terror', 'terror', 'Juegos de terror y supervivencia', 'fas fa-ghost'),
('Estrategia', 'estrategia', 'Juegos de estrategia y táctica', 'fas fa-chess');

-- Usuario administrador inicial
INSERT INTO usuarios (nombre, apellido, email, password, tipo_usuario, estado) VALUES 
('Admin', 'Sistema', 'admin@ahorritogaming.cl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'super_admin', 'activo');

-- Permisos para el administrador
INSERT INTO permisos_admin (usuario_id, gestion_productos, gestion_pedidos, gestion_usuarios, gestion_admins, acceso_informes, configuracion_sistema) VALUES 
(1, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE);

-- Configuración inicial del sistema
INSERT INTO configuracion_sistema (clave, valor, tipo, descripcion, grupo, es_publico) VALUES 
('site_name', 'Ahorrito Gaming', 'texto', 'Nombre del sitio web', 'general', TRUE),
('site_description', 'Tu tienda de juegos digitales en Chile', 'texto', 'Descripción del sitio web', 'general', TRUE),
('contact_email', 'contacto@ahorritogaming.cl', 'texto', 'Email de contacto principal', 'contacto', TRUE),
('support_email', 'soporte@ahorritogaming.cl', 'texto', 'Email de soporte técnico', 'contacto', TRUE),
('currency', 'CLP', 'texto', 'Moneda principal del sitio', 'tienda', TRUE),
('currency_symbol', '$', 'texto', 'Símbolo de la moneda', 'tienda', TRUE),
('tax_rate', '19', 'numero', 'Tasa de impuesto (IVA)', 'tienda', TRUE),
('show_prices_with_tax', 'true', 'booleano', 'Mostrar precios con impuestos incluidos', 'tienda', TRUE),
('maintenance_mode', 'false', 'booleano', 'Activar modo mantenimiento', 'sistema', FALSE),
('items_per_page', '12', 'numero', 'Número de items por página en listados', 'sistema', FALSE),
('enable_reviews', 'true', 'booleano', 'Permitir reseñas de productos', 'tienda', TRUE),
('auto_approve_reviews', 'false', 'booleano', 'Aprobar reseñas automáticamente', 'tienda', FALSE),
('enable_blog', 'true', 'booleano', 'Activar sección de blog', 'contenido', TRUE),
('logo_path', 'assets/images/logo.png', 'texto', 'Ruta del logo principal', 'apariencia', TRUE),
('favicon_path', 'assets/images/favicon.ico', 'texto', 'Ruta del favicon', 'apariencia', TRUE),
('primary_color', '#7b4cff', 'texto', 'Color primario del tema', 'apariencia', TRUE),
('secondary_color', '#ff4c8e', 'texto', 'Color secundario del tema', 'apariencia', TRUE),
('analytics_id', '', 'texto', 'ID de Google Analytics', 'marketing', FALSE),
('facebook_url', 'https://facebook.com/ahorritogaming', 'texto', 'URL de Facebook', 'social', TRUE),
('twitter_url', 'https://twitter.com/ahorritogaming', 'texto', 'URL de Twitter', 'social', TRUE),
('instagram_url', 'https://instagram.com/ahorritogaming', 'texto', 'URL de Instagram', 'social', TRUE),
('discord_url', 'https://discord.gg/ahorritogaming', 'texto', 'URL de Discord', 'social', TRUE);

-- Configuración inicial de auditoría
INSERT INTO configuracion_auditoria (
    auditar_login, 
    auditar_productos, 
    auditar_pedidos, 
    auditar_usuarios, 
    auditar_admins, 
    auditar_config, 
    periodo_retencion, 
    emails_notificacion
) VALUES (
    TRUE, 
    TRUE, 
    TRUE, 
    TRUE, 
    TRUE, 
    TRUE, 
    5, 
    'seguridad@ahorritogaming.cl,admin@ahorritogaming.cl'
);

-- Métodos de pago iniciales
INSERT INTO metodos_pago (nombre, descripcion, comision, activo, orden) VALUES 
('WebPay', 'Pago con tarjetas de crédito y débito a través de WebPay', 2.95, TRUE, 1),
('MercadoPago', 'Pago con MercadoPago', 3.49, TRUE, 2),
('Khipu', 'Transferencia bancaria a través de Khipu', 1.99, TRUE, 3),
('Mach', 'Pago con Mach', 1.50, TRUE, 4),
('PayPal', 'Pago con PayPal', 4.99, TRUE, 5),
('Criptomonedas', 'Pago con Bitcoin, Ethereum y otras criptomonedas', 0.00, TRUE, 6);

-- Países iniciales (enfoque en Chile y países cercanos)
INSERT INTO paises (codigo, nombre, activo) VALUES 
('CL', 'Chile', TRUE),
('AR', 'Argentina', TRUE),
('PE', 'Perú', TRUE),
('BO', 'Bolivia', TRUE),
('UY', 'Uruguay', TRUE),
('PY', 'Paraguay', TRUE),
('CO', 'Colombia', TRUE),
('EC', 'Ecuador', TRUE),
('MX', 'México', TRUE);

-- Regiones de Chile
INSERT INTO regiones (pais_id, nombre, codigo, activo) VALUES 
(1, 'Región de Arica y Parinacota', 'CL-AP', TRUE),
(1, 'Región de Tarapacá', 'CL-TA', TRUE),
(1, 'Región de Antofagasta', 'CL-AN', TRUE),
(1, 'Región de Atacama', 'CL-AT', TRUE),
(1, 'Región de Coquimbo', 'CL-CO', TRUE),
(1, 'Región de Valparaíso', 'CL-VS', TRUE),
(1, 'Región Metropolitana de Santiago', 'CL-RM', TRUE),
(1, 'Región del Libertador General Bernardo OHiggins', 'CL-LI', TRUE),
(1, 'Región del Maule', 'CL-ML', TRUE),
(1, 'Región de Ñuble', 'CL-NB', TRUE),
(1, 'Región del Biobío', 'CL-BI', TRUE),
(1, 'Región de La Araucanía', 'CL-AR', TRUE),
(1, 'Región de Los Ríos', 'CL-LR', TRUE),
(1, 'Región de Los Lagos', 'CL-LL', TRUE),
(1, 'Región de Aysén del General Carlos Ibáñez del Campo', 'CL-AI', TRUE),
(1, 'Región de Magallanes y de la Antártica Chilena', 'CL-MA', TRUE);

-- Impuesto IVA Chile
INSERT INTO impuestos (nombre, porcentaje, pais_id, activo) VALUES 
('IVA Chile', 19.00, 1, TRUE);

-- Preguntas frecuentes iniciales
INSERT INTO faq (pregunta, respuesta, categoria, orden) VALUES 
('¿Cómo recibo mis juegos después de la compra?', 'Inmediatamente después de confirmar tu pago, recibirás un correo electrónico con las claves de activación de tus juegos. También podrás encontrarlas en tu cuenta, en la sección "Mis Pedidos".', 'compras', 1),
('¿Qué métodos de pago aceptan?', 'Aceptamos múltiples métodos de pago: tarjetas de crédito y débito a través de WebPay, MercadoPago, Khipu (transferencia bancaria), Mach, PayPal y criptomonedas.', 'pagos', 1),
('¿Las claves son oficiales?', 'Sí, todas nuestras claves son 100% oficiales y se adquieren directamente de los distribuidores autorizados o publishers.', 'productos', 1),
('¿Puedo solicitar un reembolso?', 'Por la naturaleza digital de nuestros productos, no podemos ofrecer reembolsos una vez que la clave ha sido enviada. Sin embargo, si experimentas algún problema con tu compra, nuestro equipo de soporte estará encantado de ayudarte.', 'devoluciones', 1),
('¿Cómo activo mi juego en Steam/Epic/PlayStation/Xbox?', 'En nuestra sección de ayuda encontrarás guías detalladas para activar tus juegos en cada plataforma. También puedes contactar a nuestro soporte si necesitas asistencia adicional.', 'activacion', 1);

-- Páginas estáticas iniciales
INSERT INTO paginas (titulo, slug, contenido, estado, creado_por) VALUES 
('Sobre Nosotros', 'sobre-nosotros', '<h1>Sobre Ahorrito Gaming</h1><p>Somos una tienda chilena especializada en la venta de juegos digitales para todas las plataformas. Nuestro objetivo es ofrecer los mejores precios del mercado y una experiencia de compra rápida y segura.</p>', 'publicado', 1),
('Términos y Condiciones', 'terminos-y-condiciones', '<h1>Términos y Condiciones</h1><p>Al utilizar nuestro sitio web y servicios, aceptas cumplir con estos términos y condiciones...</p>', 'publicado', 1),
('Política de Privacidad', 'politica-de-privacidad', '<h1>Política de Privacidad</h1><p>En Ahorrito Gaming valoramos tu privacidad y nos comprometemos a proteger tus datos personales...</p>', 'publicado', 1),
('Política de Devoluciones', 'politica-de-devoluciones', '<h1>Política de Devoluciones</h1><p>Debido a la naturaleza digital de nuestros productos, no podemos ofrecer reembolsos una vez que la clave ha sido enviada...</p>', 'publicado', 1);

-- Categorías de blog iniciales
INSERT INTO blog_categorias (nombre, slug, descripcion) VALUES 
('Noticias', 'noticias', 'Últimas noticias sobre videojuegos y la industria'),
('Guías', 'guias', 'Guías y tutoriales para tus juegos favoritos'),
('Análisis', 'analisis', 'Análisis y reseñas de los últimos lanzamientos'),
('Ofertas', 'ofertas', 'Información sobre las mejores ofertas disponibles');
