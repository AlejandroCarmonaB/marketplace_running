const pool = require('../config/db');

class AnaliticaService {
  static async obtenerAniosDisponibles() {
    const query = `
      SELECT DISTINCT EXTRACT(YEAR FROM fecha_transaccion)::int AS anio
      FROM transaccion
      ORDER BY anio DESC
    `;
    const result = await pool.query(query);
    return result.rows;
  }

  static async obtenerResumenGeneral({ anio = '', categoria = '' }) {
    let query = `
      SELECT
        COUNT(*) FILTER (WHERE t.estado_transaccion = 'completada') AS total_pedidos_completados,
        COALESCE(SUM(t.total_transaccion) FILTER (WHERE t.estado_transaccion = 'completada'), 0) AS ingresos_totales
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE 1 = 1
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async obtenerTotalProductosVendidos({ anio = '', categoria = '' }) {
    let query = `
      SELECT COUNT(DISTINCT dt.id_prod) AS total_productos_vendidos
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.estado_transaccion = 'completada'
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async obtenerVentasRetenidas({ anio = '', categoria = '' }) {
    let query = `
      SELECT 
        COUNT(DISTINCT t.id_transaccion) AS total_retenidas,
        COALESCE(SUM(t.total_transaccion), 0) AS importe_retenido
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.estado_transaccion = 'pago_retenido'
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async obtenerResumenValoraciones({ anio = '', categoria = '' }) {
    let query = `
      SELECT
        COALESCE(ROUND(AVG(rp.valoracion)::numeric, 2), 0) AS media_valoraciones,
        COUNT(*) AS total_resenyas
      FROM resenya_producto rp
      JOIN producto p ON rp.id_prod = p.id_prod
      WHERE 1 = 1
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM rp.fecha_resenya) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async obtenerVentasPorMes({ anio = '', categoria = '' }) {
    let query = `
      SELECT 
        TO_CHAR(t.fecha_transaccion, 'YYYY-MM') AS mes,
        COUNT(DISTINCT t.id_transaccion) AS total_pedidos,
        COALESCE(SUM(DISTINCT t.total_transaccion), 0) AS ingresos
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.estado_transaccion = 'completada'
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    query += ` GROUP BY mes ORDER BY mes ASC`;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerVentasPorCategoria({ anio = '', categoria = '' }) {
    let query = `
      SELECT 
        c.nombre_categoria,
        COUNT(dt.id_prod) AS total_vendidos
      FROM detalle_transaccion dt
      JOIN producto p ON dt.id_prod = p.id_prod
      JOIN categoria c ON p.id_categoria = c.id_categoria
      JOIN transaccion t ON dt.id_transaccion = t.id_transaccion
      WHERE t.estado_transaccion = 'completada'
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    query += ` GROUP BY c.nombre_categoria ORDER BY total_vendidos DESC`;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerEstadoProductos({ categoria = '' }) {
    let query = `
      SELECT estado_publicacion, COUNT(*) AS total
      FROM producto
      WHERE 1 = 1
    `;

    const values = [];
    let index = 1;

    if (categoria) {
      query += ` AND id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    query += ` GROUP BY estado_publicacion`;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerTopVendedores({ anio = '', categoria = '' }) {
    let query = `
      SELECT 
        u.nickname,
        COUNT(DISTINCT t.id_transaccion) AS ventas
      FROM transaccion t
      JOIN usuario u ON t.id_vendedor = u.id_usuario
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.estado_transaccion = 'completada'
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    query += ` GROUP BY u.nickname ORDER BY ventas DESC LIMIT 5`;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerTopCompradores({ anio = '', categoria = '' }) {
    let query = `
      SELECT 
        u.nickname,
        COUNT(DISTINCT t.id_transaccion) AS compras
      FROM transaccion t
      JOIN usuario u ON t.id_comprador = u.id_usuario
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.estado_transaccion = 'completada'
    `;

    const values = [];
    let index = 1;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    query += ` GROUP BY u.nickname ORDER BY compras DESC LIMIT 5`;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerResumenUsuario({ usuario, anio = '', categoria = '' }) {
    const usuarioQuery = `
      SELECT u.id_usuario, u.nickname, u.email
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE r.nombre_rol = 'usuario'
        AND (u.nickname = $1 OR u.email = $1)
      LIMIT 1
    `;

    const usuarioResult = await pool.query(usuarioQuery, [usuario]);
    const usuarioEncontrado = usuarioResult.rows[0] || null;

    if (!usuarioEncontrado) {
      return null;
    }

    let comprasQuery = `
      SELECT
        COUNT(DISTINCT t.id_transaccion) AS total_compras,
        COALESCE(SUM(t.total_transaccion), 0) AS gasto_total
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.id_comprador = $1
        AND t.estado_transaccion = 'completada'
    `;

    let ventasQuery = `
      SELECT
        COUNT(DISTINCT t.id_transaccion) AS total_ventas,
        COALESCE(SUM(t.total_transaccion), 0) AS ingresos_total
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.id_vendedor = $1
        AND t.estado_transaccion = 'completada'
    `;

    const comprasValues = [usuarioEncontrado.id_usuario];
    const ventasValues = [usuarioEncontrado.id_usuario];
    let comprasIndex = 2;
    let ventasIndex = 2;

    if (anio) {
      comprasQuery += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${comprasIndex}`;
      comprasValues.push(Number(anio));
      comprasIndex++;

      ventasQuery += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${ventasIndex}`;
      ventasValues.push(Number(anio));
      ventasIndex++;
    }

    if (categoria) {
      comprasQuery += ` AND p.id_categoria = $${comprasIndex}`;
      comprasValues.push(Number(categoria));
      comprasIndex++;

      ventasQuery += ` AND p.id_categoria = $${ventasIndex}`;
      ventasValues.push(Number(categoria));
      ventasIndex++;
    }

    const [comprasResult, ventasResult] = await Promise.all([
      pool.query(comprasQuery, comprasValues),
      pool.query(ventasQuery, ventasValues)
    ]);

    return {
      id_usuario: usuarioEncontrado.id_usuario,
      nickname: usuarioEncontrado.nickname,
      email: usuarioEncontrado.email,
      total_compras: Number(comprasResult.rows[0]?.total_compras || 0),
      total_ventas: Number(ventasResult.rows[0]?.total_ventas || 0),
      gasto_total: Number(comprasResult.rows[0]?.gasto_total || 0),
      ingresos_total: Number(ventasResult.rows[0]?.ingresos_total || 0)
    };
  }

  static async obtenerResenasUsuario(usuarioId) {
    const query = `
      SELECT 
        COUNT(*) AS total_resenyas,
        COALESCE(ROUND(AVG(valoracion)::numeric, 2), 0) AS media
      FROM resenya_usuario
      WHERE id_usuario_resenyado = $1
    `;

    const result = await pool.query(query, [usuarioId]);
    return result.rows[0];
  }

  static async obtenerUltimasCompras(usuarioId, { anio = '', categoria = '' }) {
    let query = `
      SELECT 
        t.fecha_transaccion,
        p.titulo,
        dt.precio_unitario,
        t.estado_transaccion
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.id_comprador = $1
    `;

    const values = [usuarioId];
    let index = 2;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    query += `
      ORDER BY t.fecha_transaccion DESC
      LIMIT 5
    `;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerUltimasVentas(usuarioId, { anio = '', categoria = '' }) {
    let query = `
      SELECT 
        t.fecha_transaccion,
        p.titulo,
        dt.precio_unitario,
        t.estado_transaccion
      FROM transaccion t
      JOIN detalle_transaccion dt ON t.id_transaccion = dt.id_transaccion
      JOIN producto p ON dt.id_prod = p.id_prod
      WHERE t.id_vendedor = $1
    `;

    const values = [usuarioId];
    let index = 2;

    if (anio) {
      query += ` AND EXTRACT(YEAR FROM t.fecha_transaccion) = $${index}`;
      values.push(Number(anio));
      index++;
    }

    if (categoria) {
      query += ` AND p.id_categoria = $${index}`;
      values.push(Number(categoria));
      index++;
    }

    query += `
      ORDER BY t.fecha_transaccion DESC
      LIMIT 5
    `;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async obtenerUsuariosParaAnalitica() {
    const query = `
      SELECT 
        u.id_usuario,
        u.nickname,
        u.email
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE r.nombre_rol = 'usuario'
      ORDER BY u.nickname ASC
    `;

    const result = await pool.query(query);
    return result.rows;
  }
}

module.exports = AnaliticaService;