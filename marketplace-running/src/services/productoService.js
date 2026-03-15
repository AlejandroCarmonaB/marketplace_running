const pool = require('../config/db');

class ProductoService {
  static async obtenerProductosActivos() {
    const query = `
      SELECT 
        p.id_prod,
        p.titulo,
        p.descripcion,
        p.precio,
        p.stock,
        p.estado_fisico,
        p.estado_publicacion,
        c.nombre_categoria,
        u.nickname AS vendedor,
        (
          SELECT ip.url_imagen
          FROM imagen_producto ip
          WHERE ip.id_prod = p.id_prod
          ORDER BY ip.id_imagen ASC
          LIMIT 1
        ) AS imagen_principal
      FROM producto p
      JOIN categoria c ON p.id_categoria = c.id_categoria
      JOIN usuario u ON p.id_vendedor = u.id_usuario
      WHERE p.estado_publicacion = 'activo'
      ORDER BY p.id_prod ASC
    `;

    const result = await pool.query(query);
    return result.rows;
  }

  static async obtenerProductoPorId(idProducto) {
    const query = `
      SELECT 
        p.id_prod,
        p.titulo,
        p.descripcion,
        p.precio,
        p.stock,
        p.estado_fisico,
        p.estado_publicacion,
        c.nombre_categoria,
        u.nickname AS vendedor
      FROM producto p
      JOIN categoria c ON p.id_categoria = c.id_categoria
      JOIN usuario u ON p.id_vendedor = u.id_usuario
      WHERE p.id_prod = $1
      AND p.estado_publicacion = 'activo'
    `;

    const result = await pool.query(query, [idProducto]);
    return result.rows[0];
  }
}

module.exports = ProductoService;