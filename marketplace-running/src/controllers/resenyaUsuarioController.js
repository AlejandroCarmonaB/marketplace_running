const ResenyaUsuarioService = require('../services/resenyaUsuarioService');

class ResenyaUsuarioController {
  static async verPerfilVendedor(req, res) {
    try {
      const idVendedor = req.params.id;
      const usuarioSesion = req.session.usuario;

      const vendedor = await ResenyaUsuarioService.obtenerVendedorPorId(idVendedor);

      if (!vendedor) {
        return res.status(404).send('Vendedor no encontrado');
      }

      const [
        resumen,
        resenyas,
        productosActivos,
        totalProductosActivos
      ] = await Promise.all([
        ResenyaUsuarioService.obtenerResumenValoracionesVendedor(idVendedor),
        ResenyaUsuarioService.obtenerResenyasDeVendedor(idVendedor),
        ResenyaUsuarioService.obtenerProductosActivosVendedor(idVendedor),
        ResenyaUsuarioService.contarProductosActivosVendedor(idVendedor)
      ]);

      let resenyaUsuario = null;
      if (usuarioSesion && usuarioSesion.nombre_rol === 'usuario') {
        resenyaUsuario = await ResenyaUsuarioService.obtenerResenyaUsuario(
          usuarioSesion.id_usuario,
          idVendedor
        );
      }

      const mensajeExito = req.session.mensajeExito || null;
      const mensajeError = req.session.mensajeError || null;
      delete req.session.mensajeExito;
      delete req.session.mensajeError;

      res.render('seller_profile', {
        vendedor,
        resumen,
        resenyas,
        resenyaUsuario,
        productosActivos,
        totalProductosActivos,
        usuarioSesion,
        mensajeExito,
        mensajeError
      });
    } catch (error) {
      console.error(error);
      res.status(500).send('Error al cargar el perfil del vendedor');
    }
  }

  static async guardarResenya(req, res) {
    try {
      const usuarioSesion = req.session.usuario;

      if (!usuarioSesion) {
        return res.redirect('/login');
      }

      if (usuarioSesion.nombre_rol !== 'usuario') {
        return res.status(403).send('Solo los usuarios pueden enviar reseñas.');
      }

      const idAutor = usuarioSesion.id_usuario;
      const idVendedor = req.params.id;
      const { valoracion, comentario } = req.body;

      await ResenyaUsuarioService.guardarResenyaVendedor({
        idAutor,
        idVendedor,
        valoracion,
        comentario
      });

      req.session.mensajeExito = 'Reseña del vendedor guardada correctamente.';
      return res.redirect(`/vendedor/${idVendedor}`);
    } catch (error) {
      console.error(error);
      req.session.mensajeError = error.message || 'Error al guardar la reseña del vendedor.';
      return res.redirect(`/vendedor/${req.params.id}`);
    }
  }
}

module.exports = ResenyaUsuarioController;