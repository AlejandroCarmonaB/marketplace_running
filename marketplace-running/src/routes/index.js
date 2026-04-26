// Archivo principal de rutas que importa y utiliza todas las rutas específicas.
const express = require('express');
const router = express.Router();

const authRoutes = require('./authRoutes');
const productoRoutes = require('./productoRoutes');
const carritoRoutes = require('./carritoRoutes');
const pedidoRoutes = require('./pedidoRoutes');
const verificacionRoutes = require('./verificacionRoutes');
const adminRoutes = require('./adminRoutes');
const analiticaRoutes = require('./analiticaRoutes');
const superadminRoutes = require('./superadminRoutes');
const resenyaProductoRoutes = require('./resenyaProductoRoutes');
const resenyaUsuarioRoutes = require('./resenyaUsuarioRoutes');

router.use('/', authRoutes);
router.use('/', productoRoutes);
router.use('/', carritoRoutes);
router.use('/', pedidoRoutes);
router.use('/', verificacionRoutes);
router.use('/', adminRoutes);
router.use('/', analiticaRoutes);
router.use('/', superadminRoutes);
router.use('/', resenyaProductoRoutes);
router.use('/', resenyaUsuarioRoutes);

module.exports = router;