// Rutas de autenticación (registro, login, logout).
const express = require('express');
const router = express.Router();

const AuthController = require('../controllers/authController');
const UsuarioController = require('../controllers/usuarioController');
const AuthMiddleware = require('../middlewares/authMiddleware');

router.get('/login', AuthMiddleware.redirigirSiAutenticado, AuthController.mostrarFormularioLogin);
router.post('/login', AuthController.iniciarSesion);
router.get('/logout', AuthController.cerrarSesion);

router.get('/register', AuthMiddleware.redirigirSiAutenticado, UsuarioController.mostrarFormularioRegistro);
router.post('/register', UsuarioController.registrarUsuario);

module.exports = router;