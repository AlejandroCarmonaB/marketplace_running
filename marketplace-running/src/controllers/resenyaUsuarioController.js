const ResenyaUsuarioService = require('../services/resenyaUsuarioService');
const pool = require('../config/db');

class ResenyaUsuarioController {
  static async verPerfilVendedor(req, res) {
    try {
      const idVendedor = req.params.id;
      const usuarioSesion = req.session.usuario;

      const vendedorQuery = `
        SELECT id_usuario, nickname, email
        FROM usuario
        WHERE id_usuario = $1
      `;
      const vendedorResult = await pool.query(vendedorQuery, [idVendedor]);
      const vendedor = vendedorResult.rows[0];

      if (!vendedor) {
        return res.status(404).send('Vendedor no encontrado');
      }

      const resumen = await ResenyaUsuarioService.obtenerResumenValoracionesVendedor(idVendedor);
      const resenyas = await ResenyaUsuarioService.obtenerResenyasDeVendedor(idVendedor);

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