const UsuarioService = require('../services/usuarioService');
const ProductoService = require('../services/productoService');
const AuditoriaService = require('../services/auditoriaService');

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
      const esAjax = req.get('X-Requested-With') === 'XMLHttpRequest';
      const idUsuario = parseInt(req.params.id);

      if (isNaN(idUsuario) || idUsuario <= 0) {
        if (esAjax) {
          return res.status(400).json({ ok: false, mensaje: 'ID de usuario no válido.' });
        }

        req.session.mensajeError = 'ID de usuario no válido.';
        return res.redirect('/admin/usuarios');
      }

      if (req.session.usuario.id_usuario === idUsuario) {
        if (esAjax) {
          return res.status(403).json({ ok: false, mensaje: 'No puedes cambiar el estado de tu propia cuenta.' });
        }

        req.session.mensajeError = 'No puedes cambiar el estado de tu propia cuenta.';
        return res.redirect('/admin/usuarios');
      }

      const { nuevoEstado } = req.body;

      if (!['activa', 'bloqueada'].includes(nuevoEstado)) {
        if (esAjax) {
          return res.status(400).json({ ok: false, mensaje: 'Estado de cuenta no válido.' });
        }

        req.session.mensajeError = 'Estado de cuenta no válido.';
        return res.redirect('/admin/usuarios');
      }

      const usuarioObjetivo = await UsuarioService.obtenerUsuarioPorId(idUsuario);

      if (!usuarioObjetivo) {
        if (esAjax) {
          return res.status(404).json({ ok: false, mensaje: 'Usuario no encontrado.' });
        }

        req.session.mensajeError = 'Usuario no encontrado.';
        return res.redirect('/admin/usuarios');
      }

      if (
        usuarioObjetivo.nombre_rol === 'administrador' ||
        usuarioObjetivo.nombre_rol === 'superadministrador'
      ) {
        if (esAjax) {
          return res.status(403).json({
            ok: false,
            mensaje: 'No puedes cambiar el estado de administradores ni superadministradores desde este panel.'
          });
        }

        req.session.mensajeError = 'No puedes cambiar el estado de administradores ni superadministradores desde este panel.';
        return res.redirect('/admin/usuarios');
      }

      const actualizado = await UsuarioService.actualizarEstadoCuenta(idUsuario, nuevoEstado);

      if (!actualizado) {
        if (esAjax) {
          return res.status(404).json({ ok: false, mensaje: 'Usuario no encontrado.' });
        }

        req.session.mensajeError = 'Usuario no encontrado.';
        return res.redirect('/admin/usuarios');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'CAMBIAR_ESTADO_USUARIO',
        entidad: 'usuario',
        idObjetivoUsuario: idUsuario,
        detalle: `Nuevo estado: ${nuevoEstado}`
      });

      if (esAjax) {
        return res.json({
          ok: true,
          accion: 'actualizar_estado',
          idUsuario,
          nuevoEstado,
          mensaje: `Estado actualizado a ${nuevoEstado}.`
        });
      }

      req.session.mensajeExito = `Estado de cuenta actualizado a "${nuevoEstado}" correctamente.`;
      return res.redirect('/admin/usuarios');
    } catch (error) {
      console.error('Error al cambiar estado de cuenta:', error);

      if (req.get('X-Requested-With') === 'XMLHttpRequest') {
        return res.status(500).json({ ok: false, mensaje: 'Error al actualizar el estado de la cuenta.' });
      }

      req.session.mensajeError = 'Error al actualizar el estado de la cuenta.';
      return res.redirect('/admin/usuarios');
    }
  }

  static async programarBajaUsuario(req, res) {
    try {
      const esAjax = req.get('X-Requested-With') === 'XMLHttpRequest';
      const idUsuario = parseInt(req.params.id);
      const motivo = req.body.motivo?.trim() || 'Baja administrativa';
      const diasGracia = 7;

      const usuarioObjetivo = await UsuarioService.obtenerUsuarioPorId(idUsuario);

      if (!usuarioObjetivo) {
        if (esAjax) {
          return res.status(404).json({ ok: false, mensaje: 'Usuario no encontrado.' });
        }

        req.session.mensajeError = 'Usuario no encontrado.';
        return res.redirect('/admin/usuarios');
      }

      if (
        usuarioObjetivo.nombre_rol === 'administrador' ||
        usuarioObjetivo.nombre_rol === 'superadministrador'
      ) {
        if (esAjax) {
          return res.status(403).json({
            ok: false,
            mensaje: 'No puedes programar la baja de administradores ni superadministradores.'
          });
        }

        req.session.mensajeError = 'No puedes programar la baja de administradores ni superadministradores.';
        return res.redirect('/admin/usuarios');
      }

      const resultado = await UsuarioService.programarBajaLogicaUsuario({
        idUsuarioObjetivo: idUsuario,
        idActor: req.session.usuario.id_usuario,
        motivo,
        diasGracia
      });

      if (!resultado) {
        if (esAjax) {
          return res.status(400).json({ ok: false, mensaje: 'No se pudo programar la baja del usuario.' });
        }

        req.session.mensajeError = 'No se pudo programar la baja del usuario.';
        return res.redirect('/admin/usuarios');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'PROGRAMAR_BAJA_USUARIO',
        entidad: 'usuario',
        idObjetivoUsuario: idUsuario,
        detalle: `Baja programada hasta ${resultado.fecha_baja_programada}. Motivo: ${motivo}`
      });

      if (esAjax) {
        return res.json({
          ok: true,
          accion: 'eliminar_tarjeta',
          idUsuario,
          mensaje: 'Baja lógica del usuario programada correctamente.'
        });
      }

      req.session.mensajeExito = 'Baja lógica del usuario programada correctamente.';
      return res.redirect('/admin/usuarios');
    } catch (error) {
      console.error('Error al programar baja lógica de usuario:', error);

      if (req.get('X-Requested-With') === 'XMLHttpRequest') {
        return res.status(500).json({ ok: false, mensaje: 'Error al programar la baja del usuario.' });
      }

      req.session.mensajeError = 'Error al programar la baja del usuario.';
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
      const { nuevoEstado } = req.body;

      const estadosValidos = ['activo', 'inactivo', 'rechazado'];

      if (isNaN(idProducto) || idProducto <= 0) {
        req.session.mensajeError = 'ID de producto no válido.';
        return res.redirect('/admin/productos');
      }

      if (!estadosValidos.includes(nuevoEstado)) {
        req.session.mensajeError = 'Estado de producto no válido.';
        return res.redirect('/admin/productos');
      }

      const actualizado = await ProductoService.actualizarEstadoPublicacionAdmin(idProducto, nuevoEstado);

      if (!actualizado) {
        req.session.mensajeError = 'Producto no encontrado.';
        return res.redirect('/admin/productos');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'CAMBIAR_ESTADO_PRODUCTO',
        entidad: 'producto',
        idObjetivoProducto: idProducto,
        detalle: `Nuevo estado: ${nuevoEstado}`
      });

      req.session.mensajeExito = `Estado del producto actualizado a "${nuevoEstado}".`;
      return res.redirect('/admin/productos');
    } catch (error) {
      console.error('Error al cambiar estado de producto:', error);
      req.session.mensajeError = 'Error al actualizar el estado del producto.';
      return res.redirect('/admin/productos');
    }
  }

  static async programarBajaProducto(req, res) {
    try {
      const idProducto = parseInt(req.params.id);
      const motivo = req.body.motivo?.trim() || 'Baja administrativa';
      const diasGracia = 7;

      const resultado = await ProductoService.programarBajaLogicaProducto({
        idProducto,
        idActor: req.session.usuario.id_usuario,
        motivo,
        diasGracia
      });

      if (!resultado) {
        req.session.mensajeError = 'No se pudo programar la baja del producto.';
        return res.redirect('/admin/productos');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'PROGRAMAR_BAJA_PRODUCTO',
        entidad: 'producto',
        idObjetivoProducto: idProducto,
        detalle: `Baja programada hasta ${resultado.fecha_baja_programada}. Motivo: ${motivo}`
      });

      req.session.mensajeExito = 'Baja lógica del producto programada correctamente.';
      return res.redirect('/admin/productos');
    } catch (error) {
      console.error('Error al programar baja lógica de producto:', error);
      req.session.mensajeError = 'Error al programar la baja del producto.';
      return res.redirect('/admin/productos');
    }
  }
}

module.exports = AdminController;