const pool = require('../config/db');

class ResenyaProductoService {

  static async puedeResenyarProducto(idAutor, idProducto) {
    const query = `
      SELECT 1
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      WHERE t.id_comprador = $1
        AND dt.id_prod = $2
        AND t.estado_transaccion = 'completada'
      LIMIT 1
    `;
    const result = await pool.query(query, [idAutor, idProducto]);
    return result.rows.length > 0;
  }

  static async obtenerResenyaProductoUsuario(idAutor, idProducto) {
    const query = `
      SELECT id_resenya_prod, valoracion, comentario, fecha_resenya
      FROM resenya_producto
      WHERE id_usuario_autor = $1 AND id_prod = $2
      LIMIT 1
    `;
    const result = await pool.query(query, [idAutor, idProducto]);
    return result.rows[0] || null;
  }

  static async guardarResenyaProducto({ idAutor, idProducto, valoracion, comentario }) {
    const valoracionNumerica = Number(valoracion);

    if (!Number.isInteger(valoracionNumerica) || valoracionNumerica < 1 || valoracionNumerica > 5) {
      throw new Error('La valoración debe ser un número entero entre 1 y 5');
    }

    if (!comentario || !comentario.trim()) {
      throw new Error('El comentario es obligatorio');
    }

    const puede = await this.puedeResenyarProducto(idAutor, idProducto);
    if (!puede) {
      throw new Error('No puedes reseñar este producto sin haberlo comprado');
    }

    const query = `
      INSERT INTO resenya_producto
        (id_usuario_autor, id_prod, valoracion, comentario, fecha_resenya)
      VALUES ($1, $2, $3, $4, NOW())
      ON CONFLICT (id_usuario_autor, id_prod)
      DO UPDATE SET
        valoracion = EXCLUDED.valoracion,
        comentario = EXCLUDED.comentario,
        fecha_resenya = NOW()
      RETURNING id_resenya_prod, valoracion, comentario, fecha_resenya
    `;

    const result = await pool.query(query, [idAutor, idProducto, valoracionNumerica, comentario.trim()]);
    return result.rows[0];
  }

  static async obtenerResenyasDeProducto(idProducto) {
    const query = `
      SELECT
        rp.id_resenya_prod,
        rp.valoracion,
        rp.comentario,
        rp.fecha_resenya,
        u.nickname AS autor
      FROM resenya_producto rp
      JOIN usuario u ON rp.id_usuario_autor = u.id_usuario
      WHERE rp.id_prod = $1
      ORDER BY rp.fecha_resenya DESC
    `;
    const result = await pool.query(query, [idProducto]);
    return result.rows;
  }

  static async obtenerResumenValoracionesProducto(idProducto) {
    const query = `
      SELECT
        COALESCE(ROUND(AVG(valoracion)::numeric, 2), 0) AS media_valoraciones,
        COUNT(*) AS total_resenyas
      FROM resenya_producto
      WHERE id_prod = $1
    `;
    const result = await pool.query(query, [idProducto]);
    return result.rows[0];
  }
}

module.exports = ResenyaProductoService;