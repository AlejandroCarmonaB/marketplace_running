const UsuarioService = require('../services/usuarioService');
const AuthService = require('../services/authService');

class AuthController {
  static mostrarFormularioLogin(req, res) {
    res.render('login', {
      error: null,
      datos: {}
    });
  }

  static async iniciarSesion(req, res) {
    try {
      const email = req.body.email?.trim().toLowerCase();
      const password = req.body.password;

      if (!email || !password) {
        return res.status(400).render('login', {
          error: 'Debes introducir correo y contraseña.',
          datos: { email }
        });
      }

      const usuario = await UsuarioService.obtenerUsuarioPorEmail(email);

      if (!usuario) {
        return res.status(400).render('login', {
          error: 'Credenciales incorrectas.',
          datos: { email }
        });
      }

      if (usuario.estado_cuenta !== 'activa') {
        return res.status(403).render('login', {
          error: 'Tu cuenta no está activa.',
          datos: { email }
        });
      }

      const passwordCorrecta = await AuthService.comprobarPassword(
        password,
        usuario.password
      );

      if (!passwordCorrecta) {
        return res.status(400).render('login', {
          error: 'Credenciales incorrectas.',
          datos: { email }
        });
      }

      req.session.usuario = {
        id_usuario: usuario.id_usuario,
        id_rol: usuario.id_rol,
        nombre: usuario.nombre,
        apellidos: usuario.apellidos,
        nickname: usuario.nickname,
        email: usuario.email,
        nombre_rol: usuario.nombre_rol
      };

      return res.redirect('/');
    } catch (error) {
      console.error('Error al iniciar sesión:', error);

      return res.status(500).render('login', {
        error: 'Error interno del servidor.',
        datos: {}
      });
    }
  }

  static cerrarSesion(req, res) {
    req.session.destroy((error) => {
      if (error) {
        console.error('Error al cerrar sesión:', error);
        return res.redirect('/');
      }

      res.clearCookie('connect.sid');
      return res.redirect('/login');
    });
  }
}

module.exports = AuthController;