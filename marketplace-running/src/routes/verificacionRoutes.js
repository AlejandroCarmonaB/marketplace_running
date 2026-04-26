// Rutas relacionadas con la verificación de productos (mostrar pendientes, aprobar/rechazar).
const express = require('express');
const router = express.Router();

const VerificacionController = require('../controllers/verificacionController');
const AuthMiddleware = require('../middlewares/authMiddleware');

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

module.exports = router;