// Rutas relacionadas con productos (listado, detalle, publicación, edición, eliminación).
const express = require('express');
const router = express.Router();

const ProductoController = require('../controllers/productoController');
const AuthMiddleware = require('../middlewares/authMiddleware');
const upload = require('../config/multer');

router.get('/', ProductoController.mostrarProductos);
router.get('/producto/:id', ProductoController.mostrarDetalleProducto);

router.get(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarFormularioPublicar
);

router.post(
  '/publicar-producto',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  upload.array('imagenes', 5),
  ProductoController.publicarProducto
);

router.get(
  '/mis-productos',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarMisProductos
);

router.get(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.mostrarFormularioEditar
);

router.post(
  '/editar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  upload.array('imagenes', 5),
  ProductoController.editarProducto
);

router.post(
  '/eliminar-producto/:id',
  AuthMiddleware.asegurarAutenticacion,
  AuthMiddleware.soloUsuario,
  ProductoController.eliminarProducto
);

module.exports = router;