const express = require('express');
const router = express.Router();

const ProductoController = require('../controllers/productoController');
const UsuarioController = require('../controllers/usuarioController');
const AuthController = require('../controllers/authController');
const AuthMiddleware = require('../middlewares/authMiddleware');
const CarritoController = require('../controllers/carritoController');

// =========================
// RUTAS PÚBLICAS
// =========================

// Página principal: listado de productos
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

// Eliminar lógicamente
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

module.exports = router;