const pool = require('../config/db');

class AuditoriaService {
  static async registrar({
    idActor = null,
    accion,
    entidad,
    idObjetivoUsuario = null,
    idObjetivoProducto = null,
    detalle = null
  }) {
    const query = `
      INSERT INTO log_auditoria
        (
          id_actor,
          accion,
          entidad,
          id_objetivo_usuario,
          id_objetivo_producto,
          detalle
        )
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING id_log
    `;

    const values = [
      idActor,
      accion,
      entidad,
      idObjetivoUsuario,
      idObjetivoProducto,
      detalle
    ];

    const result = await pool.query(query, values);
    return result.rows[0] || null;
  }

  static async obtenerUltimosLogs(limit = 50) {
    const query = `
      SELECT
        la.id_log,
        la.accion,
        la.entidad,
        la.id_objetivo_usuario,
        la.id_objetivo_producto,
        la.detalle,
        la.fecha_accion,
        u.nickname AS actor
      FROM log_auditoria la
      LEFT JOIN usuario u ON la.id_actor = u.id_usuario
      ORDER BY la.fecha_accion DESC
      LIMIT $1
    `;

    const result = await pool.query(query, [limit]);
    return result.rows;
  }
}

module.exports = AuditoriaService;