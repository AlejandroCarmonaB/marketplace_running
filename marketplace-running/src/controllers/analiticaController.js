const AnaliticaService = require('../services/analiticaService');

class AnaliticaController {

  static async mostrarDashboard(req, res) {
    try {
      const ventas = await AnaliticaService.obtenerVentasPorMes();

      const labels = ventas.map(v => v.mes);
      const datos = ventas.map(v => Number(v.total));

      res.render('analitica', {
        labels,
        datos
      });

    } catch (error) {
      console.error('Error en analítica:', error);
      res.status(500).send('Error al cargar la analítica');
    }
  }

}

module.exports = AnaliticaController;