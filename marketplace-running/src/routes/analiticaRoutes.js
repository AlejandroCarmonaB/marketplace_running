// Rutas relacionadas con la analítica (dashboard de ventas, productos más vendidos, etc.).
const express = require('express');
const router = express.Router();

const AnaliticaController = require('../controllers/analiticaController');
const AuthMiddleware = require('../middlewares/authMiddleware');

router.get(
  '/analitica',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloAdminOAnalista,
  AnaliticaController.mostrarDashboard
);

module.exports = router;