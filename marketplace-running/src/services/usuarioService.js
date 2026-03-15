const pool = require('../config/db');

class UsuarioService {
  static async obtenerIdRol(nombreRol) {
    const query = `
      SELECT id_rol
      FROM rol
      WHERE nombre_rol = $1
    `;

    const result = await pool.query(query, [nombreRol]);
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

    const values = [idRol, nombre, apellidos, nickname, email, passwordHash, 'activa'];

    const result = await pool.query(query, values);
    return result.rows[0];
  }
}

module.exports = UsuarioService;