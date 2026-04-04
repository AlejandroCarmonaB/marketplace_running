const TransaccionService = require('../services/transaccionService');

class TransaccionController {
  static async mostrarMisPedidos(req, res) {
    try {
      const idComprador = req.session.usuario.id_usuario;
      const pedidos = await TransaccionService.obtenerPedidosPorComprador(idComprador);

      res.render('orders', { pedidos });
    } catch (error) {
      console.error('Error al obtener los pedidos del usuario:', error);
      res.status(500).send('Error interno del servidor');
    }
  }
}

module.exports = TransaccionController;