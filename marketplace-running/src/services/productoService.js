const pool = require('../config/db');

class ProductoService {
  static async obtenerProductosActivos() {
    const query = `
      SELECT 
        p.id_prod,
        p.id_vendedor,
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

  static async filtrarProductos({ termino, idCategoria, precioMax }) {
    let query = `
      SELECT 
        p.id_prod,
        p.id_vendedor,
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
    `;

    const values = [];
    let index = 1;

    if (termino && termino.trim() !== '') {
      query += `
        AND (
          LOWER(p.titulo) LIKE LOWER($${index})
          OR LOWER(p.descripcion) LIKE LOWER($${index})
        )
      `;
      values.push(`%${termino.trim()}%`);
      index++;
    }

    if (idCategoria && !isNaN(idCategoria) && Number(idCategoria) > 0) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(idCategoria));
      index++;
    }

    if (precioMax && !isNaN(precioMax) && Number(precioMax) >= 0) {
      query += ` AND p.precio <= $${index}`;
      values.push(Number(precioMax));
      index++;
    }

    query += ' ORDER BY p.id_prod DESC';

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerProductoPorId(idProducto) {
    const query = `
      SELECT 
        p.id_prod,
        p.id_vendedor,
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
      WHERE p.id_prod = $1
    `;

    const result = await pool.query(query, [idProducto]);
    return result.rows[0] || null;
  }

  static async obtenerCategorias() {
    const result = await pool.query(
      'SELECT id_categoria, nombre_categoria FROM categoria ORDER BY nombre_categoria ASC'
    );
    return result.rows;
  }

  static async crearProducto({
    idVendedor,
    idCategoria,
    titulo,
    descripcion,
    precio,
    stock,
    estadoFisico
  }) {
    const query = `
      INSERT INTO producto (
        id_vendedor,
        id_categoria,
        titulo,
        descripcion,
        precio,
        stock,
        estado_fisico,
        estado_publicacion
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, 'activo')
      RETURNING id_prod
    `;

    const result = await pool.query(query, [
      idVendedor,
      idCategoria,
      titulo,
      descripcion,
      precio,
      stock,
      estadoFisico
    ]);

    return result.rows[0] || null;
  }

  static async obtenerProductosPorVendedor(idVendedor) {
    const query = `
      SELECT 
        p.id_prod,
        p.id_vendedor,
        p.titulo,
        p.descripcion,
        p.precio,
        p.stock,
        p.estado_fisico,
        p.estado_publicacion,
        c.nombre_categoria,
        (
          SELECT ip.url_imagen
          FROM imagen_producto ip
          WHERE ip.id_prod = p.id_prod
          ORDER BY ip.id_imagen ASC
          LIMIT 1
        ) AS imagen_principal
      FROM producto p
      JOIN categoria c ON p.id_categoria = c.id_categoria
      WHERE p.id_vendedor = $1
      ORDER BY p.id_prod DESC
    `;

    const result = await pool.query(query, [idVendedor]);
    return result.rows;
  }

  static async obtenerProductoPorIdYVendedor(idProducto, idVendedor) {
    const query = `
      SELECT *
      FROM producto
      WHERE id_prod = $1
        AND id_vendedor = $2
        AND estado_publicacion <> 'vendido'
    `;

    const result = await pool.query(query, [idProducto, idVendedor]);
    return result.rows[0] || null;
  }

  static async actualizarProducto(datos) {
    const query = `
      UPDATE producto
      SET titulo = $1,
          descripcion = $2,
          precio = $3,
          estado_fisico = $4,
          id_categoria = $5
      WHERE id_prod = $6
        AND id_vendedor = $7
        AND estado_publicacion <> 'vendido'
      RETURNING id_prod
    `;

    const values = [
      datos.titulo,
      datos.descripcion,
      datos.precio,
      datos.estadoFisico,
      datos.idCategoria,
      datos.idProducto,
      datos.idVendedor
    ];

    const result = await pool.query(query, values);
    return result.rows[0] || null;
  }

  static async desactivarProducto(idProducto, idVendedor) {
    const query = `
      UPDATE producto
      SET estado_publicacion = 'inactivo'
      WHERE id_prod = $1
        AND id_vendedor = $2
        AND estado_publicacion <> 'vendido'
      RETURNING id_prod
    `;

    const result = await pool.query(query, [idProducto, idVendedor]);
    return result.rows[0] || null;
  }

  static async procesarCompra({ idComprador, carrito }) {
    const client = await pool.connect();

    try {
      await client.query('BEGIN');

      const porVendedor = {};

      for (const producto of carrito) {
        if (!porVendedor[producto.id_vendedor]) {
          porVendedor[producto.id_vendedor] = [];
        }

        porVendedor[producto.id_vendedor].push(producto);
      }

      for (const idVendedor of Object.keys(porVendedor)) {
        const productos = porVendedor[idVendedor];

        for (const producto of productos) {
          const result = await client.query(
            'SELECT stock FROM producto WHERE id_prod = $1 FOR UPDATE',
            [producto.id_prod]
          );

          const productoBD = result.rows[0];

          if (!productoBD || productoBD.stock < 1) {
            throw new Error(`Producto sin stock: ${producto.titulo}`);
          }
        }

        const total = productos.reduce((acc, p) => acc + Number(p.precio), 0);
        const comision = parseFloat((total * 0.05).toFixed(2));
        const importeVendedor = parseFloat((total - comision).toFixed(2));

        const transResult = await client.query(
          `INSERT INTO transaccion
            (
              id_comprador,
              id_vendedor,
              fecha_transaccion,
              total_transaccion,
              estado_transaccion,
              comision_plataforma,
              importe_vendedor
            )
           VALUES ($1, $2, NOW(), $3, 'pago_retenido', $4, $5)
           RETURNING id_transaccion`,
          [idComprador, idVendedor, total, comision, importeVendedor]
        );

        const idTransaccion = transResult.rows[0].id_transaccion;

        for (const producto of productos) {
          await client.query(
            `INSERT INTO detalle_transaccion
              (
                id_transaccion,
                id_prod,
                cantidad,
                precio_unitario
              )
             VALUES ($1, $2, 1, $3)`,
            [idTransaccion, producto.id_prod, producto.precio]
          );

          await client.query(
            `UPDATE producto
             SET stock = 0,
                 estado_publicacion = 'vendido'
             WHERE id_prod = $1`,
            [producto.id_prod]
          );
        }
      }

      await client.query('COMMIT');
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }
}

module.exports = ProductoService;