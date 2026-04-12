const pool = require('../config/db');

class AnaliticaService {

  static async obtenerVentasPorMes() {
    const query = `
      SELECT 
        TO_CHAR(fecha_transaccion, 'YYYY-MM') AS mes,
        SUM(total_transaccion) AS total
      FROM transaccion
      WHERE estado_transaccion = 'completada'
      GROUP BY mes
      ORDER BY mes ASC
    `;

    const result = await pool.query(query);
    return result.rows;
  }

}

module.exports = AnaliticaService;