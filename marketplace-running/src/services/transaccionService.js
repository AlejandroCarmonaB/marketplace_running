const pool = require('../config/db');

class TransaccionService {
  static async obtenerPedidosPorComprador(idComprador) {
    const query = `
      SELECT
        t.id_transaccion,
        t.fecha_transaccion,
        t.total_transaccion,
        t.estado_transaccion,
        t.comision_plataforma,
        t.importe_vendedor,
        t.id_vendedor,
        u.nickname AS vendedor,
        dt.id_prod,
        p.titulo,
        dt.cantidad,
        dt.precio_unitario
      FROM transaccion t
      JOIN usuario u
        ON t.id_vendedor = u.id_usuario
      JOIN detalle_transaccion dt
        ON t.id_transaccion = dt.id_transaccion
      JOIN producto p
        ON dt.id_prod = p.id_prod
      WHERE t.id_comprador = $1
      ORDER BY t.fecha_transaccion DESC, t.id_transaccion DESC
    `;

    const result = await pool.query(query, [idComprador]);

    const pedidosMap = new Map();

    for (const row of result.rows) {
      if (!pedidosMap.has(row.id_transaccion)) {
        pedidosMap.set(row.id_transaccion, {
          id_transaccion: row.id_transaccion,
          fecha_transaccion: row.fecha_transaccion,
          total_transaccion: row.total_transaccion,
          estado_transaccion: row.estado_transaccion,
          comision_plataforma: row.comision_plataforma,
          importe_vendedor: row.importe_vendedor,
          id_vendedor: row.id_vendedor,
          vendedor: row.vendedor,
          productos: []
        });
      }

      pedidosMap.get(row.id_transaccion).productos.push({
        id_prod: row.id_prod,
        titulo: row.titulo,
        cantidad: row.cantidad,
        precio_unitario: row.precio_unitario
      });
    }

    return Array.from(pedidosMap.values());
  }
}

module.exports = TransaccionService;