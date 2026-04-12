const VerificacionService = require('../services/verificacionService');

class VerificacionController {
  static async mostrarPendientes(req, res) {
    try {
      const pendientes = await VerificacionService.obtenerPendientes();

      const mensajeExito = req.session.mensajeExito || null;
      const mensajeError = req.session.mensajeError || null;
      delete req.session.mensajeExito;
      delete req.session.mensajeError;

      res.render('verificaciones', {
        pendientes,
        mensajeExito,
        mensajeError
      });
    } catch (error) {
      console.error(error);
      res.status(500).send('Error interno');
    }
  }

  static async procesarVerificacion(req, res) {
    try {
      const idTransaccion = req.params.id;
      const { resultado, motivo } = req.body;

      const valoresValidos = ['aprobada', 'rechazada'];

      if (!valoresValidos.includes(resultado)) {
        req.session.mensajeError = 'Resultado de verificación no válido.';
        return res.redirect('/verificaciones');
      }

      if (resultado === 'rechazada' && (!motivo || !motivo.trim())) {
        req.session.mensajeError = 'Debes indicar un motivo al rechazar una verificación.';
        return res.redirect('/verificaciones');
      }

      const idRevisor = req.session.usuario.id_usuario;

      await VerificacionService.registrarVerificacion({
        idTransaccion,
        idRevisor,
        resultado,
        motivo
      });

      req.session.mensajeExito = 'Verificación procesada correctamente.';
      return res.redirect('/verificaciones');
    } catch (error) {
      console.error(error);
      req.session.mensajeError = error.message || 'Error al procesar verificación.';
      return res.redirect('/verificaciones');
    }
  }
}

module.exports = VerificacionController;