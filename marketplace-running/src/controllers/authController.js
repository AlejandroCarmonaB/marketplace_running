const UsuarioService = require('../services/usuarioService');
const AuthService = require('../services/authService');

class AuthController {
  static mostrarFormularioLogin(req, res) {
    const mensajeExito = req.session.mensajeExito || null;
    req.session.mensajeExito = null;

    res.render('login', {
      error: null,
      mensajeExito,
      datos: {}
    });
  }

  static async iniciarSesion(req, res) {
    try {
      const email = req.body.email?.trim().toLowerCase();
      const password = req.body.password;

      if (!email || !password) {
        return res.status(400).render('login', {
          error: 'Debes introducir el correo y la contraseña.',
          mensajeExito: null,
          datos: { email }
        });
      }

      const usuario = await UsuarioService.obtenerUsuarioPorEmail(email);

      if (!usuario) {
        return res.status(401).render('login', {
          error: 'Credenciales incorrectas.',
          mensajeExito: null,
          datos: { email }
        });
      }

      const passwordCorrecta = await AuthService.comprobarPassword(
        password,
        usuario.password
      );

      if (!passwordCorrecta) {
        return res.status(401).render('login', {
          error: 'Credenciales incorrectas.',
          mensajeExito: null,
          datos: { email }
        });
      }

      req.session.usuario = {
        id_usuario: usuario.id_usuario,
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
        mensajeExito: null,
        datos: {
          email: req.body.email?.trim().toLowerCase() || ''
        }
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