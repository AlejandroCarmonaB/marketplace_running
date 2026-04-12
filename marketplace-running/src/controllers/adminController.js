const UsuarioService = require('../services/usuarioService');
const ProductoService = require('../services/productoService');

class AdminController {
  static async mostrarUsuarios(req, res) {
    try {
      const termino = req.query.q || '';
      const estado = req.query.estado || '';

      const usuarios = await UsuarioService.obtenerUsuariosParaAdmin({
        termino,
        estado
      });

      const mensajeExito = req.session.mensajeExito || null;
      const mensajeError = req.session.mensajeError || null;
      delete req.session.mensajeExito;
      delete req.session.mensajeError;

      res.render('admin_users', {
        usuarios,
        termino,
        estado,
        mensajeExito,
        mensajeError,
        usuarioSesion: req.session.usuario
      });
    } catch (error) {
      console.error('Error al mostrar usuarios de administración:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async cambiarEstadoCuenta(req, res) {
    try {
      const idUsuario = parseInt(req.params.id);

      if (isNaN(idUsuario) || idUsuario <= 0) {
        req.session.mensajeError = 'ID de usuario no válido.';
        return res.redirect('/admin/usuarios');
      }

      if (req.session.usuario.id_usuario === idUsuario) {
        req.session.mensajeError = 'No puedes cambiar el estado de tu propia cuenta.';
        return res.redirect('/admin/usuarios');
      }

      const { nuevoEstado } = req.body;

      if (!['activa', 'bloqueada'].includes(nuevoEstado)) {
        req.session.mensajeError = 'Estado de cuenta no válido.';
        return res.redirect('/admin/usuarios');
      }

      const actualizado = await UsuarioService.actualizarEstadoCuenta(idUsuario, nuevoEstado);

      if (!actualizado) {
        req.session.mensajeError = 'Usuario no encontrado.';
        return res.redirect('/admin/usuarios');
      }

      req.session.mensajeExito = `Estado de cuenta actualizado a "${nuevoEstado}" correctamente.`;
      return res.redirect('/admin/usuarios');
    } catch (error) {
      console.error('Error al cambiar estado de cuenta:', error);
      req.session.mensajeError = 'Error al actualizar el estado de la cuenta.';
      return res.redirect('/admin/usuarios');
    }
  }

  static async mostrarProductos(req, res) {
    try {
      const termino = req.query.q || '';
      const estado = req.query.estado || '';

      const productos = await ProductoService.obtenerProductosParaAdmin({
        termino,
        estado
      });

      const mensajeExito = req.session.mensajeExito || null;
      const mensajeError = req.session.mensajeError || null;
      delete req.session.mensajeExito;
      delete req.session.mensajeError;

      res.render('admin_products', {
        productos,
        termino,
        estado,
        mensajeExito,
        mensajeError,
        usuarioSesion: req.session.usuario
      });
    } catch (error) {
      console.error('Error al mostrar productos de administración:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async cambiarEstadoProducto(req, res) {
    try {
      const idProducto = parseInt(req.params.id);

      if (isNaN(idProducto) || idProducto <= 0) {
        req.session.mensajeError = 'ID de producto no válido.';
        return res.redirect('/admin/productos');
      }

      const { nuevoEstado } = req.body;

      if (!['activo', 'inactivo', 'rechazado'].includes(nuevoEstado)) {
        req.session.mensajeError = 'Estado de publicación no válido.';
        return res.redirect('/admin/productos');
      }

      const actualizado = await ProductoService.actualizarEstadoPublicacionAdmin(idProducto, nuevoEstado);

      if (!actualizado) {
        req.session.mensajeError = 'Producto no encontrado o no modificable.';
        return res.redirect('/admin/productos');
      }

      req.session.mensajeExito = `Estado del producto actualizado a "${nuevoEstado}" correctamente.`;
      return res.redirect('/admin/productos');
    } catch (error) {
      console.error('Error al cambiar estado del producto:', error);
      req.session.mensajeError = 'Error al actualizar el estado del producto.';
      return res.redirect('/admin/productos');
    }
  }
}

module.exports = AdminController;