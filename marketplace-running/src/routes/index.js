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
const SuperadminController = require('../controllers/superadminController');

// Middlewares
const AuthMiddleware = require('../middlewares/authMiddleware');
const upload = require('../config/multer');

// =========================
// RUTAS PÚBLICAS
// =========================

router.get('/', ProductoController.mostrarProductos);
router.get('/producto/:id', ProductoController.mostrarDetalleProducto);
router.get('/vendedor/:id', ResenyaUsuarioController.verPerfilVendedor);

// =========================
// AUTENTICACIÓN
// =========================

router.get('/login', AuthMiddleware.redirigirSiAutenticado, AuthController.mostrarFormularioLogin);
router.post('/login', AuthController.iniciarSesion);
router.get('/logout', AuthController.cerrarSesion);

// =========================
// REGISTRO
// =========================

router.get('/register', AuthMiddleware.redirigirSiAutenticado, UsuarioController.mostrarFormularioRegistro);
router.post('/register', UsuarioController.registrarUsuario);

// =========================
// PRODUCTOS (SOLO USUARIO)
// =========================

router.get(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarFormularioPublicar
);

router.post(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  upload.array('imagenes', 5),
  ProductoController.publicarProducto
);

router.get(
  '/mis-productos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarMisProductos
);

router.get(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarFormularioEditar
);

router.post(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  upload.array('imagenes', 5),
  ProductoController.editarProducto
);

router.post(
  '/eliminar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.eliminarProducto
);

// =========================
// CARRITO (SOLO USUARIO)
// =========================

router.post(
  '/carrito/agregar/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.agregarAlCarrito
);

router.get(
  '/carrito',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.verCarrito
);

router.post(
  '/carrito/eliminar/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.eliminarDelCarrito
);

router.post(
  '/carrito/vaciar',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.vaciarCarrito
);

router.post(
  '/carrito/comprar',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  CarritoController.comprar
);

// =========================
// PEDIDOS
// =========================

router.get(
  '/mis-pedidos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  TransaccionController.mostrarMisPedidos
);

// =========================
// RESEÑAS
// =========================

router.post(
  '/producto/:id/resena',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ResenyaProductoController.guardarResenya
);

router.post(
  '/vendedor/:id/resena',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ResenyaUsuarioController.guardarResenya
);

// =========================
// VERIFICACIONES (ADMIN / VERIFICADOR / SUPERADMIN)
// =========================

router.get(
  '/verificaciones',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOVerificador,
  VerificacionController.mostrarPendientes
);

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
  AuthMiddleware.soloAdminOSuperAdmin,
  AdminController.mostrarUsuarios
);

router.post(
  '/admin/usuarios/:id/estado',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOSuperAdmin,
  AdminController.cambiarEstadoCuenta
);

router.post(
  '/admin/usuarios/:id/programar-baja',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOSuperAdmin,
  AdminController.programarBajaUsuario
);

// =========================
// ADMINISTRACIÓN DE PRODUCTOS
// =========================

router.get(
  '/admin/productos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOSuperAdmin,
  AdminController.mostrarProductos
);

router.post(
  '/admin/productos/:id/estado',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOSuperAdmin,
  AdminController.cambiarEstadoProducto
);

router.post(
  '/admin/productos/:id/programar-baja',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOSuperAdmin,
  AdminController.programarBajaProducto
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

// =========================
// SUPERADMIN
// =========================

router.get(
  '/superadmin',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloSuperAdmin,
  SuperadminController.mostrarPanel
);

router.post(
  '/superadmin/usuarios/:id/rol',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloSuperAdmin,
  SuperadminController.cambiarRolUsuario
);

router.post(
  '/superadmin/usuarios/:id/estado',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloSuperAdmin,
  SuperadminController.cambiarEstadoCuenta
);

router.post(
  '/superadmin/usuarios/:id/restaurar',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloSuperAdmin,
  SuperadminController.restaurarUsuario
);

router.post(
  '/superadmin/productos/:id/restaurar',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloSuperAdmin,
  SuperadminController.restaurarProducto
);

module.exports = router;