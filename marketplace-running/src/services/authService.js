const bcrypt = require('bcrypt');

class AuthService {
  static async hashearPassword(password) {
    const saltRounds = 10;
    return await bcrypt.hash(password, saltRounds);
  }

  static async comprobarPassword(passwordPlano, passwordHash) {
    return await bcrypt.compare(passwordPlano, passwordHash);
  }
}

module.exports = AuthService;