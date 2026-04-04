const VerificacionService = require('../services/verificacionService');

class VerificacionController {
  static async mostrarPendientes(req, res) {
    try {
      const pendientes = await VerificacionService.obtenerPendientes();
      res.render('verificaciones', { pendientes });
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
        return res.status(400).send('Resultado de verificación no válido');
      }

      const idRevisor = req.session.usuario.id_usuario;

      await VerificacionService.registrarVerificacion({
        idTransaccion,
        idRevisor,
        resultado,
        motivo
      });

      res.redirect('/verificaciones');
    } catch (error) {
      console.error(error);
      res.status(500).send('Error al procesar verificación');
    }
  }
}

module.exports = VerificacionController;