// Rutas relacionadas con la administración (gestión de usuarios y productos, programación de bajas).
const express = require('express');
const router = express.Router();

const AdminController = require('../controllers/adminController');
const AuthMiddleware = require('../middlewares/authMiddleware');

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

module.exports = router;