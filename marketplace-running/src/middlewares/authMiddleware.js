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
}

module.exports = AuthMiddleware;