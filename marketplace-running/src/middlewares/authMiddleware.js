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

  static soloUsuario(req, res, next) {
    if (!req.session.usuario || req.session.usuario.nombre_rol !== 'usuario') {
      return res.status(403).send('Acceso denegado');
    }

    next();
  }

  static soloAdmin(req, res, next) {
    if (!req.session.usuario || req.session.usuario.nombre_rol !== 'administrador') {
      return res.status(403).send('Acceso denegado');
    }

    next();
  }

  static soloSuperAdmin(req, res, next) {
    if (!req.session.usuario || req.session.usuario.nombre_rol !== 'superadministrador') {
      return res.status(403).send('Acceso denegado');
    }

    next();
  }

  static soloAdminOSuperAdmin(req, res, next) {
    if (!req.session.usuario) {
      return res.status(403).send('Acceso denegado');
    }

    const rol = req.session.usuario.nombre_rol;

    if (rol !== 'administrador' && rol !== 'superadministrador') {
      return res.status(403).send('Acceso denegado');
    }

    next();
  }

  static soloAdminOVerificador(req, res, next) {
    if (!req.session.usuario) {
      return res.status(403).send('Acceso denegado');
    }

    const rol = req.session.usuario.nombre_rol;

    if (
      rol !== 'administrador' &&
      rol !== 'verificador' &&
      rol !== 'superadministrador'
    ) {
      return res.status(403).send('Acceso denegado');
    }

    next();
  }

  static soloAdminOAnalista(req, res, next) {
    if (!req.session.usuario) {
      return res.status(403).send('Acceso denegado');
    }

    const rol = req.session.usuario.nombre_rol;

    if (
      rol !== 'administrador' &&
      rol !== 'analista' &&
      rol !== 'superadministrador'
    ) {
      return res.status(403).send('Acceso denegado');
    }

    next();
  }
}

module.exports = AuthMiddleware;