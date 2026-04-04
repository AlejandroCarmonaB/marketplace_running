//Comprobamos si el usuario está autenticado antes de permitirle acceder a ciertas rutas, y redirigimos a la página de inicio si ya está autenticado.
class AuthMiddleware {
  static asegurarAutenticacion(req, res, next) {
    if (!req.session.usuario) {
      return res.redirect('/login');
    }

    next();
  }

  static redirigirSiAutenticado(req, res, next) {
    if (req.session.usuario) {
      return res.redirect('/');
    }

    next();
  }

  static soloAdmin(req, res, next) {
    if (!req.session.usuario || req.session.usuario.nombre_rol !== 'administrador') {
      return res.status(403).send('Acceso denegado');
    }

    next();
  }
}

module.exports = AuthMiddleware;