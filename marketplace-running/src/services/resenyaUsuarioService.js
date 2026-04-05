const pool = require('../config/db');

class ResenyaUsuarioService {
  /**
   * Comprueba si un comprador puede reseñar a un vendedor.
   * Debe existir al menos una transacción completada entre ambos.
   */
  static async puedeResenyarVendedor(idAutor, idVendedor) {
    const query = `
      SELECT 1
      FROM transaccion
      WHERE id_comprador = $1
        AND id_vendedor = $2
        AND estado_transaccion = 'completada'
      LIMIT 1
    `;

    const result = await pool.query(query, [idAutor, idVendedor]);
    return result.rows.length > 0;
  }

  /**
   * Obtiene la reseña que un usuario ya dejó sobre un vendedor, si existe.
   * Sirve para rellenar el formulario en modo edición.
   */
  static async obtenerResenyaUsuario(idAutor, idVendedor) {
    const query = `
      SELECT
        id_resenya_usuario,
        valoracion,
        comentario,
        fecha_resenya
      FROM resenya_usuario
      WHERE id_usuario_autor = $1
        AND id_usuario_resenyado = $2
      LIMIT 1
    `;

    const result = await pool.query(query, [idAutor, idVendedor]);
    return result.rows[0] || null;
  }

  /**
   * Inserta o actualiza la reseña de un usuario sobre un vendedor.
   * Usa ON CONFLICT para mantener una sola reseña por pareja autor-vendedor.
   */
  static async guardarResenyaVendedor({ idAutor, idVendedor, valoracion, comentario }) {
    const valoracionNumerica = Number(valoracion);

    if (!Number.isInteger(valoracionNumerica) || valoracionNumerica < 1 || valoracionNumerica > 5) {
      throw new Error('La valoración debe ser un número entero entre 1 y 5');
    }

    if (!comentario || !comentario.trim()) {
      throw new Error('El comentario es obligatorio');
    }

    if (Number(idAutor) === Number(idVendedor)) {
      throw new Error('Un usuario no puede reseñarse a sí mismo');
    }

    const puedeResenyar = await this.puedeResenyarVendedor(idAutor, idVendedor);

    if (!puedeResenyar) {
      throw new Error('No puedes reseñar a este vendedor sin haber completado una transacción con él');
    }

    const query = `
      INSERT INTO resenya_usuario
        (id_usuario_autor, id_usuario_resenyado, valoracion, comentario, fecha_resenya)
      VALUES ($1, $2, $3, $4, NOW())
      ON CONFLICT (id_usuario_autor, id_usuario_resenyado)
      DO UPDATE SET
        valoracion = EXCLUDED.valoracion,
        comentario = EXCLUDED.comentario,
        fecha_resenya = NOW()
      RETURNING
        id_resenya_usuario,
        valoracion,
        comentario,
        fecha_resenya
    `;

    const result = await pool.query(query, [
      idAutor,
      idVendedor,
      valoracionNumerica,
      comentario.trim()
    ]);

    return result.rows[0];
  }

  /**
   * Devuelve la media de valoraciones y el número total de reseñas de un vendedor.
   */
  static async obtenerResumenValoracionesVendedor(idVendedor) {
    const query = `
      SELECT
        COALESCE(ROUND(AVG(valoracion)::numeric, 2), 0) AS media_valoraciones,
        COUNT(*) AS total_resenyas
      FROM resenya_usuario
      WHERE id_usuario_resenyado = $1
    `;

    const result = await pool.query(query, [idVendedor]);
    return result.rows[0];
  }

  /**
   * Devuelve el listado de reseñas recibidas por un vendedor.
   */
  static async obtenerResenyasDeVendedor(idVendedor) {
    const query = `
      SELECT
        ru.id_resenya_usuario,
        ru.valoracion,
        ru.comentario,
        ru.fecha_resenya,
        u.nickname AS autor
      FROM resenya_usuario ru
      JOIN usuario u
        ON ru.id_usuario_autor = u.id_usuario
      WHERE ru.id_usuario_resenyado = $1
      ORDER BY ru.fecha_resenya DESC
    `;

    const result = await pool.query(query, [idVendedor]);
    return result.rows;
  }
}

module.exports = ResenyaUsuarioService;