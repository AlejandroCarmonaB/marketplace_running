// Rutas relacionadas con las reseñas de productos (publicar reseña).
const express = require('express');
const router = express.Router();

const ResenyaProductoController = require('../controllers/resenyaProductoController');
const AuthMiddleware = require('../middlewares/authMiddleware');

router.post(
  '/producto/:id/resena',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ResenyaProductoController.guardarResenya
);

module.exports = router;