CREATE DATABASE marketplace_running;

CREATE TABLE rol (
    id_rol INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_rol VARCHAR(20) UNIQUE NOT NULL,
    descripcion_rol VARCHAR(200)
);

CREATE TABLE categoria (
    id_categoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_categoria VARCHAR(60) UNIQUE NOT NULL,
    descripcion_categoria VARCHAR(200)
);

CREATE TABLE usuario (
    id_usuario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_rol INTEGER NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    nickname VARCHAR(40) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_cuenta VARCHAR(15) NOT NULL CHECK (estado_cuenta IN ('activa','bloqueada','suspendida')),

    FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

CREATE TABLE producto (
    id_prod INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_vendedor INTEGER NOT NULL,
    id_categoria INTEGER NOT NULL,
    titulo VARCHAR(120) NOT NULL,
    descripcion TEXT NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_fisico VARCHAR(15) NOT NULL CHECK (estado_fisico IN ('nuevo','usado','reacondicionado')),
    estado_publicacion VARCHAR(15) NOT NULL CHECK (estado_publicacion IN ('activo','reservado','vendido','inactivo')),

    FOREIGN KEY (id_vendedor) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE imagen_producto (
    id_imagen INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_prod INTEGER NOT NULL,
    url_imagen TEXT NOT NULL,

    FOREIGN KEY (id_prod) REFERENCES producto(id_prod)
);

CREATE TABLE transaccion (
    id_transaccion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_comprador INTEGER NOT NULL,
    id_vendedor INTEGER NOT NULL,
    fecha_transaccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_transaccion NUMERIC(10,2) NOT NULL,
    estado_transaccion VARCHAR(30) NOT NULL CHECK (
        estado_transaccion IN (
            'pendiente_pago',
            'pago_retenido',
            'en_verificacion',
            'verificada_aprobada',
            'verificada_rechazada',
            'enviada',
            'finalizada',
            'reembolsada'
        )
    ),
    comision_plataforma NUMERIC(10,2) NOT NULL,
    importe_vendedor NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (id_comprador) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_vendedor) REFERENCES usuario(id_usuario)
);

CREATE TABLE detalle_transaccion (
    id_detalle INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_transaccion INTEGER NOT NULL,
    id_prod INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (id_transaccion) REFERENCES transaccion(id_transaccion),
    FOREIGN KEY (id_prod) REFERENCES producto(id_prod)
);

CREATE TABLE verificacion (
    id_verificacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_transaccion INTEGER UNIQUE NOT NULL,
    id_revisor INTEGER NOT NULL,
    resultado_verificacion VARCHAR(20) NOT NULL CHECK (resultado_verificacion IN ('aprobada','rechazada')),
    motivo_rechazo TEXT,
    fecha_revision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_transaccion) REFERENCES transaccion(id_transaccion),
    FOREIGN KEY (id_revisor) REFERENCES usuario(id_usuario)
);

CREATE TABLE resenya_producto (
    id_resenya_prod INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario_autor INTEGER NOT NULL,
    id_prod INTEGER NOT NULL,
    valoracion INTEGER NOT NULL CHECK (valoracion BETWEEN 1 AND 5),
    comentario TEXT NOT NULL,
    fecha_resenya TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario_autor) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_prod) REFERENCES producto(id_prod)
);

CREATE TABLE resenya_usuario (
    id_resenya_usuario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario_autor INTEGER NOT NULL,
    id_usuario_resenyado INTEGER NOT NULL,
    valoracion INTEGER NOT NULL CHECK (valoracion BETWEEN 1 AND 5),
    comentario TEXT NOT NULL,
    fecha_resenya TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario_autor) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_usuario_resenyado) REFERENCES usuario(id_usuario)
);