const UsuarioService = require('../services/usuarioService');
const AuthService = require('../services/authService');

class UsuarioController {
  static mostrarFormularioRegistro(req, res) {
    res.render('register', {
      error: null,
      exito: null,
      datos: {}
    });
  }

  static async registrarUsuario(req, res) {
    try {
      const nombre = req.body.nombre?.trim();
      const apellidos = req.body.apellidos?.trim();
      const nickname = req.body.nickname?.trim();
      const email = req.body.email?.trim().toLowerCase();
      const password = req.body.password;

      if (!nombre || !apellidos || !nickname || !email || !password) {
        return res.status(400).render('register', {
          error: 'Todos los campos son obligatorios.',
          exito: null,
          datos: { nombre, apellidos, nickname, email }
        });
      }

      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        return res.status(400).render('register', {
          error: 'El formato del correo electrónico no es válido.',
          exito: null,
          datos: { nombre, apellidos, nickname, email }
        });
      }

      if (password.length < 6) {
        return res.status(400).render('register', {
          error: 'La contraseña debe tener al menos 6 caracteres.',
          exito: null,
          datos: { nombre, apellidos, nickname, email }
        });
      }

      const idRol = await UsuarioService.obtenerIdRol('usuario');

      if (!idRol) {
        return res.status(500).render('register', {
          error: 'No se ha encontrado el rol base de usuario.',
          exito: null,
          datos: { nombre, apellidos, nickname, email }
        });
      }

      const yaExiste = await UsuarioService.existeEmailONickname(email, nickname);

      if (yaExiste) {
        return res.status(400).render('register', {
          error: 'Ya existe un usuario con ese correo o nickname.',
          exito: null,
          datos: { nombre, apellidos, nickname, email }
        });
      }

      const passwordHash = await AuthService.hashearPassword(password);

      await UsuarioService.crearUsuario({
        idRol,
        nombre,
        apellidos,
        nickname,
        email,
        passwordHash
      });

      req.session.mensajeExito = 'Usuario registrado correctamente. Ya puedes iniciar sesión.';

      return res.redirect('/login');
    } catch (error) {
      console.error('Error al registrar usuario:', error);

      return res.status(500).render('register', {
        error: 'Error interno del servidor.',
        exito: null,
        datos: {}
      });
    }
  }
}

module.exports = UsuarioController;