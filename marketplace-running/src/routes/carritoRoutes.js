// Rutas relacionadas con el carrito de compras (agregar, ver, eliminar, vaciar, comprar).
const express = require('express');
const router = express.Router();

const CarritoController = require('../controllers/carritoController');
const AuthMiddleware = require('../middlewares/authMiddleware');

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

module.exports = router;