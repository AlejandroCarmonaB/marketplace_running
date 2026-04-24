const { Pool } = require("pg");
require("dotenv").config();

// Creamos un pool de conexiones a PostgreSQL.
// Esto permite reutilizar conexiones y trabajar mejor que abriendo una nueva cada vez.

/*
Esta parte del código se ha editado para usar DATABASE_URL, que es una forma común de configurar la conexión a la base de datos en entornos como Heroku o Neon. Si estás usando un entorno local, 
puedes seguir usando las variables individuales como DB_HOST, DB_PORT, etc.

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});
*/

//Esta parte es para cuando se despliegue en un entorno que requiere SSL, como Neon. Si estás trabajando localmente sin SSL, puedes usar la configuración anterior.
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

// Exportamos el pool para poder usarlo en otras partes del proyecto.
module.exports = pool;
