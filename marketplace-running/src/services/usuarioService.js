const pool = require('../config/db');

class UsuarioService {
  static async obtenerIdRol(nombreRol) {
    const query = `
      SELECT id_rol
      FROM rol
      WHERE LOWER(nombre_rol) = LOWER($1)
    `;

    const result = await pool.query(query, [nombreRol.trim()]);
    return result.rows[0]?.id_rol || null;
  }

  static async obtenerRolesDisponibles() {
    const query = `
      SELECT id_rol, nombre_rol
      FROM rol
      ORDER BY id_rol ASC
    `;

    const result = await pool.query(query);
    return result.rows;
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
        u.borrado_logico,
        r.nombre_rol
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE u.email = $1
        AND COALESCE(u.borrado_logico, false) = false
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
        u.borrado_logico,
        u.fecha_baja_programada,
        u.motivo_baja,
        u.eliminado_por,
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
        u.borrado_logico,
        u.fecha_baja_programada,
        r.nombre_rol
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE COALESCE(u.borrado_logico, false) = false
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
        AND COALESCE(borrado_logico, false) = false
      RETURNING id_usuario, estado_cuenta
    `;

    const result = await pool.query(query, [nuevoEstado, idUsuario]);
    return result.rows[0] || null;
  }

  static async cambiarRolUsuario(idUsuario, idRolNuevo) {
    const query = `
      UPDATE usuario
      SET id_rol = $1
      WHERE id_usuario = $2
        AND COALESCE(borrado_logico, false) = false
      RETURNING id_usuario, id_rol
    `;

    const result = await pool.query(query, [idRolNuevo, idUsuario]);
    return result.rows[0] || null;
  }

  static async programarBajaLogicaUsuario({
    idUsuarioObjetivo,
    idActor,
    motivo,
    diasGracia = 7
  }) {
    const query = `
      UPDATE usuario
      SET
        borrado_logico = true,
        estado_cuenta = 'bloqueada',
        fecha_baja_programada = NOW() + ($1 || ' days')::interval,
        motivo_baja = $2,
        eliminado_por = $3
      WHERE id_usuario = $4
        AND COALESCE(borrado_logico, false) = false
      RETURNING id_usuario, fecha_baja_programada
    `;

    const values = [String(diasGracia), motivo || null, idActor, idUsuarioObjetivo];
    const result = await pool.query(query, values);
    return result.rows[0] || null;
  }

  static async restaurarUsuario(idUsuario) {
    const query = `
      UPDATE usuario
      SET
        borrado_logico = false,
        fecha_baja_programada = NULL,
        motivo_baja = NULL,
        eliminado_por = NULL,
        fecha_restauracion = NOW(),
        estado_cuenta = 'activa'
      WHERE id_usuario = $1
        AND COALESCE(borrado_logico, false) = true
      RETURNING id_usuario
    `;

    const result = await pool.query(query, [idUsuario]);
    return result.rows[0] || null;
  }

  static async obtenerUsuariosPendientesBaja() {
    const query = `
      SELECT
        u.id_usuario,
        u.nombre,
        u.apellidos,
        u.nickname,
        u.email,
        u.estado_cuenta,
        u.fecha_baja_programada,
        u.motivo_baja,
        r.nombre_rol
      FROM usuario u
      JOIN rol r ON u.id_rol = r.id_rol
      WHERE COALESCE(u.borrado_logico, false) = true
      ORDER BY u.fecha_baja_programada ASC NULLS LAST
    `;

    const result = await pool.query(query);
    return result.rows;
  }

  static async purgarUsuariosCaducados() {
    const query = `
      DELETE FROM usuario
      WHERE COALESCE(borrado_logico, false) = true
        AND fecha_baja_programada IS NOT NULL
        AND fecha_baja_programada <= NOW()
      RETURNING id_usuario, nickname
    `;

    const result = await pool.query(query);
    return result.rows;
  }
}

module.exports = UsuarioService;