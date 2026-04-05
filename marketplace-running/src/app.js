const express = require("express");
const path = require("path");
const session = require("express-session");
require("dotenv").config();

const indexRoutes = require("./routes/index");
const resenyaUsuarioRoutes = require("./routes/resenyaUsuarioRoutes");
const resenyaProductoRoutes = require("./routes/resenyaProductoRoutes");

const app = express();

// Configuración del motor de vistas EJS.
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

// Middleware para leer datos de formularios.
app.use(express.urlencoded({ extended: true }));

// Middleware para leer JSON.
app.use(express.json());

// Archivos estáticos: CSS, JS del cliente e imágenes.
app.use(express.static(path.join(__dirname, "public")));

// Configuración básica de sesión.
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
  }),
);

app.use((req, res, next) => {
  res.locals.usuarioSesion = req.session.usuario || null;
  next();
});

// Rutas principales.
app.use("/", indexRoutes);
app.use("/", resenyaUsuarioRoutes);
app.use("/", resenyaProductoRoutes);

// Puerto del servidor.
const PORT = process.env.PORT || 3000;

// Arrancamos el servidor.
app.listen(PORT, () => {
  console.log(`Servidor ejecutándose en http://localhost:${PORT}`);
});