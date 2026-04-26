// Rutas relacionadas con pedidos (ver mis pedidos).
const express = require('express');
const router = express.Router();

const TransaccionController = require('../controllers/transaccionController');
const AuthMiddleware = require('../middlewares/authMiddleware');

router.get(
  '/mis-pedidos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  TransaccionController.mostrarMisPedidos
);

module.exports = router;