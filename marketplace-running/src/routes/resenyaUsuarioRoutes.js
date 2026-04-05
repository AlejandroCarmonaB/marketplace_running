const express = require('express');
const router = express.Router();

const ResenyaUsuarioController = require('../controllers/resenyaUsuarioController');

// 🔹 Ver perfil del vendedor
router.get('/vendedor/:id', ResenyaUsuarioController.verPerfilVendedor);

// 🔹 Guardar reseña (crear o editar)
router.post('/vendedor/:id/resena', ResenyaUsuarioController.guardarResenya);

module.exports = router;