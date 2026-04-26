// Rutas relacionadas con las reseñas de usuarios (ver perfil de vendedor, publicar reseña).
const express = require('express');
const router = express.Router();

const ResenyaUsuarioController = require('../controllers/resenyaUsuarioController');
const AuthMiddleware = require('../middlewares/authMiddleware');

router.get('/vendedor/:id', ResenyaUsuarioController.verPerfilVendedor);

router.post(
  '/vendedor/:id/resena',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ResenyaUsuarioController.guardarResenya
);

module.exports = router;