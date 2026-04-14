const express = require('express');
const router = express.Router();

// Controllers
const ProductoController = require('../controllers/productoController');
const UsuarioController = require('../controllers/usuarioController');
const AuthController = require('../controllers/authController');
const CarritoController = require('../controllers/carritoController');
const TransaccionController = require('../controllers/transaccionController');
const VerificacionController = require('../controllers/verificacionController');
const AdminController = require('../controllers/adminController');
const AnaliticaController = require('../controllers/analiticaController');
const ResenyaProductoController = require('../controllers/resenyaProductoController');
const ResenyaUsuarioController = require('../controllers/resenyaUsuarioController');

// Middlewares
const AuthMiddleware = require('../middlewares/authMiddleware');
const upload = require('../config/multer');


// =========================
// RUTAS PÚBLICAS
// =========================

// Página principal (catálogo)
router.get('/', ProductoController.mostrarProductos);

// Detalle de producto
router.get('/producto/:id', ProductoController.mostrarDetalleProducto);

// Perfil de vendedor
router.get('/vendedor/:id', ResenyaUsuarioController.verPerfilVendedor);


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
// PRODUCTOS (SOLO USUARIO)
// =========================

// Formulario publicar producto
router.get(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarFormularioPublicar
);

// Guardar producto
router.post(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  upload.array('imagenes', 5),
  ProductoController.publicarProducto
);

// Mis productos
router.get(
  '/mis-productos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarMisProductos
);

// Formulario editar producto
router.get(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarFormularioEditar
);

// Guardar edición
router.post(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  upload.array('imagenes', 5),
  ProductoController.editarProducto
);

// Eliminación lógica
router.post(
  '/eliminar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.eliminarProducto
);


// =========================
// CARRITO (SOLO USUARIO)
// =========================

// Añadir al carrito
router.post(
  '/carrito/agregar/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.agregarAlCarrito
);

// Ver carrito
router.get(
  '/carrito',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.verCarrito
);

// Eliminar del carrito
router.post(
  '/carrito/eliminar/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.eliminarDelCarrito
);

// Comprar
router.post(
  '/carrito/comprar',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.comprar
);


// =========================
// PEDIDOS (SOLO USUARIO)
// =========================

// Mis pedidos
router.get(
  '/mis-pedidos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  TransaccionController.mostrarMisPedidos
);


// =========================
// RESEÑAS (SOLO USUARIO)
// =========================

// Reseña de producto
router.post(
  '/producto/:id/resena',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ResenyaProductoController.guardarResenya
);

// Reseña de vendedor
router.post(
  '/vendedor/:id/resena',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ResenyaUsuarioController.guardarResenya
);


// =========================
// VERIFICACIONES (ADMIN / VERIFICADOR)
// =========================

// Ver transacciones pendientes
router.get(
  '/verificaciones',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOVerificador,
  VerificacionController.mostrarPendientes
);

// Procesar verificación
router.post(
  '/verificaciones/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOVerificador,
  VerificacionController.procesarVerificacion
);


// =========================
// ADMINISTRACIÓN DE USUARIOS
// =========================

router.get(
  '/admin/usuarios',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdmin,
  AdminController.mostrarUsuarios
);

router.post(
  '/admin/usuarios/:id/estado',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdmin,
  AdminController.cambiarEstadoCuenta
);


// =========================
// ADMINISTRACIÓN DE PRODUCTOS
// =========================

router.get(
  '/admin/productos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdmin,
  AdminController.mostrarProductos
);

router.post(
  '/admin/productos/:id/estado',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdmin,
  AdminController.cambiarEstadoProducto
);


// =========================
// ANALÍTICA
// =========================

router.get(
  '/analitica',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOAnalista,
  AnaliticaController.mostrarDashboard
);

module.exports = router;