const pool = require('../config/db');

class VerificacionService {
  static async obtenerPendientes() {
    const query = `
      SELECT
        t.id_transaccion,
        t.fecha_transaccion,
        t.total_transaccion,
        t.estado_transaccion,
        u.nickname AS comprador,
        v.nickname AS vendedor,
        dt.id_prod,
        p.titulo,
        dt.cantidad,
        dt.precio_unitario
      FROM transaccion t
      JOIN usuario u
        ON t.id_comprador = u.id_usuario
      JOIN usuario v
        ON t.id_vendedor = v.id_usuario
      JOIN detalle_transaccion dt
        ON t.id_transaccion = dt.id_transaccion
      JOIN producto p
        ON dt.id_prod = p.id_prod
      WHERE t.estado_transaccion = 'pago_retenido'
      ORDER BY t.fecha_transaccion ASC, t.id_transaccion ASC
    `;

    const result = await pool.query(query);

    const pendientesMap = new Map();

    for (const row of result.rows) {
      if (!pendientesMap.has(row.id_transaccion)) {
        pendientesMap.set(row.id_transaccion, {
          id_transaccion: row.id_transaccion,
          fecha_transaccion: row.fecha_transaccion,
          total_transaccion: row.total_transaccion,
          estado_transaccion: row.estado_transaccion,
          comprador: row.comprador,
          vendedor: row.vendedor,
          productos: []
        });
      }

      pendientesMap.get(row.id_transaccion).productos.push({
        id_prod: row.id_prod,
        titulo: row.titulo,
        cantidad: row.cantidad,
        precio_unitario: row.precio_unitario
      });
    }

    return Array.from(pendientesMap.values());
  }

  static async registrarVerificacion({ idTransaccion, idRevisor, resultado, motivo }) {
    const client = await pool.connect();

    try {
      // 1) Validación básica del resultado recibido
      if (!['aprobada', 'rechazada'].includes(resultado)) {
        throw new Error('Resultado de verificación no válido');
      }

      await client.query('BEGIN');

      // 2) Si la verificación es aprobada, no debe guardarse motivo de rechazo
      const motivoFinal = resultado === 'rechazada' ? (motivo || null) : null;

      await client.query(
        `INSERT INTO verificacion
        (id_transaccion, id_revisor, resultado_verificacion, motivo_rechazo, fecha_revision)
        VALUES ($1, $2, $3, $4, NOW())`,
        [idTransaccion, idRevisor, resultado, motivoFinal]
      );

      let nuevoEstado = 'completada';

      if (resultado === 'rechazada') {
        nuevoEstado = 'reembolsada';

        const detalles = await client.query(
          `SELECT id_prod
           FROM detalle_transaccion
           WHERE id_transaccion = $1`,
          [idTransaccion]
        );

        for (const detalle of detalles.rows) {
          await client.query(
            `UPDATE producto
             SET stock = 1,
                 estado_publicacion = 'rechazado'
             WHERE id_prod = $1`,
            [detalle.id_prod]
          );
        }
      }

      await client.query(
        `UPDATE transaccion
         SET estado_transaccion = $1
         WHERE id_transaccion = $2`,
        [nuevoEstado, idTransaccion]
      );

      await client.query('COMMIT');
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }
}

module.exports = VerificacionService;