const bcrypt = require('bcrypt');

class AuthService {
  static async hashearPassword(password) {
    const saltRounds = 10;
    return await bcrypt.hash(password, saltRounds);
  }
}

module.exports = AuthService;