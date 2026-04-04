const express = require('express');
const router = express.Router();

// Controllers
const ProductoController = require('../controllers/productoController');
const UsuarioController = require('../controllers/usuarioController');
const AuthController = require('../controllers/authController');
const CarritoController = require('../controllers/carritoController');
const TransaccionController = require('../controllers/transaccionController');
const VerificacionController = require('../controllers/verificacionController');

// Middlewares
const AuthMiddleware = require('../middlewares/authMiddleware');


// =========================
// RUTAS PÚBLICAS
// =========================

// Página principal (catálogo)
router.get('/', ProductoController.mostrarProductos);

// Detalle de producto
router.get('/producto/:id', ProductoController.mostrarDetalleProducto);


// =========================
// AUTENTICACIÓN
// =========================

// Login
router.get(
  '/login',
  AuthMiddleware.redirigirSiAutenticado,
  AuthController.mostrarFormularioLogin
);

router.post('/login', AuthController.iniciarSesion);

// Logout
router.get('/logout', AuthController.cerrarSesion);


// =========================
// REGISTRO
// =========================

router.get(
  '/register',
  AuthMiddleware.redirigirSiAutenticado,
  UsuarioController.mostrarFormularioRegistro
);

router.post('/register', UsuarioController.registrarUsuario);


// =========================
// PRODUCTOS (PROTEGIDO)
// =========================

// Formulario publicar producto
router.get(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  ProductoController.mostrarFormularioPublicar
);

// Guardar producto
router.post(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  ProductoController.publicarProducto
);

// Mis productos
router.get(
  '/mis-productos',
  AuthMiddleware.asegurarAutenticacion,
  ProductoController.mostrarMisProductos
);

// Formulario editar producto
router.get(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  ProductoController.mostrarFormularioEditar
);

// Guardar edición
router.post(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  ProductoController.editarProducto
);

// Eliminación lógica
router.post(
  '/eliminar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  ProductoController.eliminarProducto
);


// =========================
// CARRITO
// =========================

// Añadir al carrito
router.post(
  '/carrito/agregar/:id',
  AuthMiddleware.asegurarAutenticacion,
  CarritoController.agregarAlCarrito
);

// Ver carrito
router.get(
  '/carrito',
  AuthMiddleware.asegurarAutenticacion,
  CarritoController.verCarrito
);

// Eliminar del carrito
router.post(
  '/carrito/eliminar/:id',
  AuthMiddleware.asegurarAutenticacion,
  CarritoController.eliminarDelCarrito
);

// Comprar
router.post(
  '/carrito/comprar',
  AuthMiddleware.asegurarAutenticacion,
  CarritoController.comprar
);


// =========================
// PEDIDOS (HISTORIAL)
// =========================

// Mis pedidos
router.get(
  '/mis-pedidos',
  AuthMiddleware.asegurarAutenticacion,
  TransaccionController.mostrarMisPedidos
);


// =========================
// VERIFICACIONES (ADMIN)
// =========================

// Ver transacciones pendientes
router.get(
  '/verificaciones',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdmin,
  VerificacionController.mostrarPendientes
);

// Procesar verificación
router.post(
  '/verificaciones/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdmin,
  VerificacionController.procesarVerificacion
);


module.exports = router;