const express = require('express');
const router = express.Router();

const ResenyaProductoController = require('../controllers/resenyaProductoController');

router.post('/producto/:id/resena', ResenyaProductoController.guardarResenya);

module.exports = router;