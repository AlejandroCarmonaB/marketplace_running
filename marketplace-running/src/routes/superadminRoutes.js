// Rutas relacionadas con el panel de superadministración (gestión avanzada de usuarios y productos).
const express = require('express');
const router = express.Router();

const SuperadminController = require('../controllers/superadminController');
const AuthMiddleware = require('../middlewares/authMiddleware');

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