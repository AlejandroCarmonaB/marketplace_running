const UsuarioService = require('../services/usuarioService');
const ProductoService = require('../services/productoService');
const AuditoriaService = require('../services/auditoriaService');

class SuperadminController {
  static async mostrarPanel(req, res) {
    try {
      const [
        usuariosGestionables,
        usuariosPendientes,
        productosPendientes,
        logs,
        roles
      ] = await Promise.all([
        UsuarioService.obtenerUsuariosParaAdmin({ termino: '', estado: '' }),
        UsuarioService.obtenerUsuariosPendientesBaja(),
        ProductoService.obtenerProductosPendientesBaja(),
        AuditoriaService.obtenerUltimosLogs(50),
        UsuarioService.obtenerRolesDisponibles()
      ]);

      const mensajeExito = req.session.mensajeExito || null;
      const mensajeError = req.session.mensajeError || null;
      delete req.session.mensajeExito;
      delete req.session.mensajeError;

      res.render('superadmin_panel', {
        usuariosGestionables,
        usuariosPendientes,
        productosPendientes,
        logs,
        roles,
        mensajeExito,
        mensajeError,
        usuarioSesion: req.session.usuario
      });
    } catch (error) {
      console.error('Error al cargar panel de superadmin:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async cambiarRolUsuario(req, res) {
    try {
      const esAjax = req.get('X-Requested-With') === 'XMLHttpRequest';
      const idUsuario = parseInt(req.params.id);
      const idRolNuevo = parseInt(req.body.id_rol);

      if (req.session.usuario.id_usuario === idUsuario) {
        if (esAjax) {
          return res.status(403).json({ ok: false, mensaje: 'No puedes cambiar tu propio rol.' });
        }

        req.session.mensajeError = 'No puedes cambiar tu propio rol.';
        return res.redirect('/superadmin');
      }

      const usuario = await UsuarioService.obtenerUsuarioPorId(idUsuario);

      if (!usuario) {
        if (esAjax) {
          return res.status(404).json({ ok: false, mensaje: 'Usuario no encontrado.' });
        }

        req.session.mensajeError = 'Usuario no encontrado.';
        return res.redirect('/superadmin');
      }

      const actualizado = await UsuarioService.cambiarRolUsuario(idUsuario, idRolNuevo);

      if (!actualizado) {
        if (esAjax) {
          return res.status(400).json({ ok: false, mensaje: 'No se pudo actualizar el rol.' });
        }

        req.session.mensajeError = 'No se pudo actualizar el rol.';
        return res.redirect('/superadmin');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'CAMBIAR_ROL_USUARIO',
        entidad: 'usuario',
        idObjetivoUsuario: idUsuario,
        detalle: `Nuevo id_rol: ${idRolNuevo}`
      });

      if (esAjax) {
        return res.json({
          ok: true,
          accion: 'actualizar_rol',
          idUsuario,
          mensaje: 'Rol actualizado correctamente.'
        });
      }

      req.session.mensajeExito = 'Rol actualizado correctamente.';
      return res.redirect('/superadmin');
    } catch (error) {
      console.error('Error al cambiar rol de usuario:', error);

      if (req.get('X-Requested-With') === 'XMLHttpRequest') {
        return res.status(500).json({ ok: false, mensaje: 'Error al cambiar el rol.' });
      }

      req.session.mensajeError = 'Error al cambiar el rol.';
      return res.redirect('/superadmin');
    }
  }

  static async cambiarEstadoCuenta(req, res) {
    try {
      const esAjax = req.get('X-Requested-With') === 'XMLHttpRequest';
      const idUsuario = parseInt(req.params.id);
      const { nuevoEstado } = req.body;

      if (req.session.usuario.id_usuario === idUsuario) {
        if (esAjax) {
          return res.status(403).json({ ok: false, mensaje: 'No puedes cambiar el estado de tu propia cuenta.' });
        }

        req.session.mensajeError = 'No puedes cambiar el estado de tu propia cuenta.';
        return res.redirect('/superadmin');
      }

      const actualizado = await UsuarioService.actualizarEstadoCuenta(idUsuario, nuevoEstado);

      if (!actualizado) {
        if (esAjax) {
          return res.status(400).json({ ok: false, mensaje: 'No se pudo actualizar el estado.' });
        }

        req.session.mensajeError = 'No se pudo actualizar el estado.';
        return res.redirect('/superadmin');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN',
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
          mensaje: 'Estado de la cuenta actualizado correctamente.'
        });
      }

      req.session.mensajeExito = 'Estado de la cuenta actualizado correctamente.';
      return res.redirect('/superadmin');
    } catch (error) {
      console.error('Error al cambiar estado desde superadmin:', error);

      if (req.get('X-Requested-With') === 'XMLHttpRequest') {
        return res.status(500).json({ ok: false, mensaje: 'Error al cambiar el estado de la cuenta.' });
      }

      req.session.mensajeError = 'Error al cambiar el estado de la cuenta.';
      return res.redirect('/superadmin');
    }
  }

  static async restaurarUsuario(req, res) {
    try {
      const esAjax = req.get('X-Requested-With') === 'XMLHttpRequest';
      const idUsuario = parseInt(req.params.id);

      const restaurado = await UsuarioService.restaurarUsuario(idUsuario);

      if (!restaurado) {
        if (esAjax) {
          return res.status(400).json({ ok: false, mensaje: 'No se pudo restaurar el usuario.' });
        }

        req.session.mensajeError = 'No se pudo restaurar el usuario.';
        return res.redirect('/superadmin');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'RESTAURAR_USUARIO',
        entidad: 'usuario',
        idObjetivoUsuario: idUsuario,
        detalle: 'Restauración antes de la purga definitiva'
      });

      if (esAjax) {
        return res.json({
          ok: true,
          accion: 'eliminar_fila',
          idUsuario,
          mensaje: 'Usuario restaurado correctamente.'
        });
      }

      req.session.mensajeExito = 'Usuario restaurado correctamente.';
      return res.redirect('/superadmin');
    } catch (error) {
      console.error('Error al restaurar usuario:', error);

      if (req.get('X-Requested-With') === 'XMLHttpRequest') {
        return res.status(500).json({ ok: false, mensaje: 'Error al restaurar el usuario.' });
      }

      req.session.mensajeError = 'Error al restaurar el usuario.';
      return res.redirect('/superadmin');
    }
  }

  static async restaurarProducto(req, res) {
    try {
      const esAjax = req.get('X-Requested-With') === 'XMLHttpRequest';
      const idProducto = parseInt(req.params.id);

      const restaurado = await ProductoService.restaurarProducto(idProducto);

      if (!restaurado) {
        if (esAjax) {
          return res.status(400).json({ ok: false, mensaje: 'No se pudo restaurar el producto.' });
        }

        req.session.mensajeError = 'No se pudo restaurar el producto.';
        return res.redirect('/superadmin');
      }

      await AuditoriaService.registrar({
        idActor: req.session.usuario.id_usuario,
        accion: 'RESTAURAR_PRODUCTO',
        entidad: 'producto',
        idObjetivoProducto: idProducto,
        detalle: 'Restauración antes de la purga definitiva'
      });

      if (esAjax) {
        return res.json({
          ok: true,
          accion: 'eliminar_fila',
          idProducto,
          mensaje: 'Producto restaurado correctamente.'
        });
      }

      req.session.mensajeExito = 'Producto restaurado correctamente.';
      return res.redirect('/superadmin');
    } catch (error) {
      console.error('Error al restaurar producto:', error);

      if (req.get('X-Requested-With') === 'XMLHttpRequest') {
        return res.status(500).json({ ok: false, mensaje: 'Error al restaurar el producto.' });
      }

      req.session.mensajeError = 'Error al restaurar el producto.';
      return res.redirect('/superadmin');
    }
  }
}

module.exports = SuperadminController;