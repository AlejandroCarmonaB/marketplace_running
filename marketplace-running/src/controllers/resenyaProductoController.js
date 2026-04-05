const ResenyaProductoService = require('../services/resenyaProductoService');

class ResenyaProductoController {
  static async guardarResenya(req, res) {
    try {
      const usuarioSesion = req.session.usuario;

      if (!usuarioSesion) {
        return res.redirect('/login');
      }

      const idAutor = usuarioSesion.id_usuario;
      const idProducto = parseInt(req.params.id);
      const { valoracion, comentario } = req.body;

      if (isNaN(idProducto) || idProducto <= 0) {
        return res.status(400).send('ID de producto no válido');
      }

      await ResenyaProductoService.guardarResenyaProducto({
        idAutor,
        idProducto,
        valoracion,
        comentario
      });

      req.session.mensajeExito = 'Reseña del producto guardada correctamente.';
      return res.redirect(`/producto/${idProducto}`);
    } catch (error) {
      console.error('Error al guardar la reseña del producto:', error);
      req.session.mensajeError = error.message || 'Error al guardar la reseña del producto.';
      return res.redirect(`/producto/${req.params.id}`);
    }
  }
}

module.exports = ResenyaProductoController;