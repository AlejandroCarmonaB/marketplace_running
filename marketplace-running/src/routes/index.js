const express = require('express');
const router = express.Router();
const ProductoController = require('../controllers/productoController');
const UsuarioController = require('../controllers/usuarioController');

// Ruta principal: listado de productos
router.get('/', ProductoController.mostrarProductos);

// Ruta detalle producto
router.get('/producto/:id', ProductoController.mostrarDetalleProducto);

// Ruta login
router.get('/login', (req, res) => {
  res.render('login');
});

// Ruta registro
router.get('/register', UsuarioController.mostrarFormularioRegistro);
router.post('/register', UsuarioController.registrarUsuario);

module.exports = router;