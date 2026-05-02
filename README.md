# RunCycle — Marketplace de productos deportivos de segunda mano

RunCycle es una plataforma web de compraventa de segunda mano especializada en productos de running, diseñada para ofrecer un entorno seguro mediante un sistema de verificación de transacciones.

---

## Tecnologías utilizadas

| Capa | Tecnología |
|------|------------|
| Backend | Node.js + Express |
| Motor de plantillas | EJS |
| Base de datos | PostgreSQL (Neon) |
| Almacenamiento de imágenes | Cloudinary |
| Gestión de sesiones | express-session |
| Despliegue | Render |
| Control de versiones | Git + GitHub |

---

## ⚙️ Requisitos previos

- Node.js v18 o superior
- Cuenta en [Neon](https://neon.tech) con una base de datos PostgreSQL creada
- Cuenta en [Cloudinary](https://cloudinary.com) para el almacenamiento de imágenes

---

## Instalación y ejecución en local

### 1. Clonar el repositorio

```bash
git clone https://github.com/AlejandroCarmonaB/marketplace_running.git
cd marketplace_running
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Configurar las variables de entorno

Crea un archivo `.env` en la raíz del proyecto con el siguiente contenido:

```env
DATABASE_URL=tu_url_de_neon
SESSION_SECRET=tu_secreto_de_sesion
CLOUDINARY_CLOUD_NAME=tu_cloud_name
CLOUDINARY_API_KEY=tu_api_key
CLOUDINARY_API_SECRET=tu_api_secret
PORT=3000
NODE_ENV=development
```


### 4. Arrancar la aplicación

```bash
npm start
```

La aplicación estará disponible en `http://localhost:3000`.

---

## Roles del sistema

| Rol | Descripción |
|-----|-------------|
| **Usuario** | Puede comprar, vender y dejar reseñas |
| **Verificador** | Revisa y aprueba o rechaza transacciones |
| **Administrador** | Gestiona usuarios y productos de la plataforma |
| **Analista** | Accede al dashboard de métricas y estadísticas |
| **Superadministrador** | Gestión avanzada: roles, restauración y auditoría |

---

## Estructura del proyecto

```
marketplace_running/
├── src/
│   ├── app.js               # Punto de entrada de la aplicación
│   ├── config/              # Configuración de base de datos y Cloudinary
│   ├── controllers/         # Lógica de negocio por módulo
│   ├── middlewares/         # Autenticación y control de roles
│   ├── models/              # Consultas a la base de datos
│   ├── routes/              # Definición de rutas
│   └── public/              # Archivos estáticos (CSS, imágenes)
├── views/                   # Plantillas EJS
├── .env                     # Variables de entorno (no incluido en el repo)
├── .gitignore
└── package.json
```

---

## Flujo principal

1. El usuario añade productos al carrito
2. Se genera una transacción en estado `pago_retenido`
3. El producto pasa a verificación
4. Resultado:
   -  Aprobado → transacción completada, pago liberado al vendedor
   -  Rechazado → reembolso al comprador

---

## Módulos principales

- **R01 — Usuarios:** registro, autenticación y gestión de roles
- **R02 — Productos:** publicación, edición, filtrado y búsqueda
- **R03 — Compras:** carrito, transacciones y sistema escrow (pago retenido)
- **R04 — Verificación:** revisión, aprobación y rechazo de transacciones
- **R05 — Reseñas:** valoración de productos y vendedores
- **R06 — Administración:** gestión de usuarios, productos y auditoría
- **R07 — Analítica:** dashboard con métricas de ventas, comisiones y verificaciones

---

## Despliegue en Render

La aplicación está desplegada en Render con conexión a Neon (PostgreSQL) y Cloudinary y accesible en la siguiente URL: https://marketplace-running.onrender.com

- **Build Command:** `npm install`
- **Start Command:** `node src/app.js`
- Las variables de entorno se configuran directamente en el panel de Render

Cualquier push a la rama `main` redespliega la aplicación automáticamente.

---

## Licencia

Proyecto desarrollado como Trabajo de Fin de Grado (TFG). Todos los derechos reservados.
