const { Pool } = require("pg");
require("dotenv").config();

// Creamos un pool de conexiones a PostgreSQL.
// Esto permite reutilizar conexiones y trabajar mejor que abriendo una nueva cada vez.
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

// Exportamos el pool para poder usarlo en otras partes del proyecto.
module.exports = pool;
