const pool = require('../config/db');

class UsuarioService {
  static async obtenerIdRol(nombreRol) {
    const query = `
      SELECT id_rol
      FROM rol
      WHERE nombre_rol = $1
    `;

    const result = await pool.query(
      query,
      [nombreRol.trim().toLowerCase()]
    );

    return result.rows[0]?.id_rol || null;
  }

  static async existeEmailONickname(email, nickname) {
    const query = `
      SELECT id_usuario
      FROM usuario
      WHERE email = $1 OR nickname = $2
    `;

    const result = await pool.query(query, [email, nickname]);
    return result.rows.length > 0;
  }

  static async crearUsuario({ idRol, nombre, apellidos, nickname, email, passwordHash }) {
    const query = `
      INSERT INTO usuario (
        id_rol,
        nombre,
        apellidos,
        nickname,
        email,
        password,
        estado_cuenta
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id_usuario, nombre, apellidos, nickname, email
    `;

    const values = [
      idRol,
      nombre,
      apellidos,
      nickname,
      email,
      passwordHash,
      'activa'
    ];

    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async obtenerUsuarioPorEmail(email) {
    const query = `
      SELECT 
        u.id_usuario,
        u.id_rol,
        u.nombre,
        u.apellidos,
        u.nickname,
        u.email,
        u.password,
        u.estado_cuenta,
        r.nombre_rol
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE u.email = $1
    `;

    const result = await pool.query(query, [email.trim().toLowerCase()]);
    return result.rows[0] || null;
  }

  static async obtenerUsuarioPorId(idUsuario) {
    const query = `
      SELECT 
        u.id_usuario,
        u.id_rol,
        u.nombre,
        u.apellidos,
        u.nickname,
        u.email,
        u.estado_cuenta,
        r.nombre_rol
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE u.id_usuario = $1
    `;

    const result = await pool.query(query, [idUsuario]);
    return result.rows[0] || null;
  }

  static async obtenerUsuariosParaAdmin({ termino = '', estado = '' }) {
    let query = `
      SELECT
        u.id_usuario,
        u.nombre,
        u.apellidos,
        u.nickname,
        u.email,
        u.estado_cuenta,
        r.nombre_rol
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE 1 = 1
    `;

    const values = [];
    let index = 1;

    if (termino && termino.trim() !== '') {
      query += `
        AND (
          LOWER(u.email) LIKE LOWER($${index})
          OR LOWER(u.nickname) LIKE LOWER($${index})
        )
      `;
      values.push(`%${termino.trim()}%`);
      index++;
    }

    if (estado && ['activa', 'bloqueada'].includes(estado)) {
      query += ` AND u.estado_cuenta = $${index}`;
      values.push(estado);
      index++;
    }

    query += ` ORDER BY u.id_usuario ASC`;

    const result = await pool.query(query, values);
    return result.rows;
  }

  static async actualizarEstadoCuenta(idUsuario, nuevoEstado) {
    const query = `
      UPDATE usuario
      SET estado_cuenta = $1
      WHERE id_usuario = $2
      RETURNING id_usuario, estado_cuenta
    `;

    const result = await pool.query(query, [nuevoEstado, idUsuario]);
    return result.rows[0] || null;
  }
}

module.exports = UsuarioService;