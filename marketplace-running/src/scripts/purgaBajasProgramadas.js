// Script para purgar productos y usuarios caducados de forma automática (ejecutar con cron).
require('dotenv').config();
const pool = require('../config/db');
const UsuarioService = require('../services/usuarioService');
const ProductoService = require('../services/productoService');
const AuditoriaService = require('../services/auditoriaService');

async function purgar() {
  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    const productos = await ProductoService.purgarProductosCaducados();
    const usuarios = await UsuarioService.purgarUsuariosCaducados();

    for (const producto of productos) {
      await AuditoriaService.registrar({
        idActor: null,
        accion: 'PURGA_DEFINITIVA_PRODUCTO',
        entidad: 'producto',
        idObjetivoProducto: producto.id_prod,
        detalle: `Producto purgado automáticamente: ${producto.titulo}`
      });
    }

    for (const usuario of usuarios) {
      await AuditoriaService.registrar({
        idActor: null,
        accion: 'PURGA_DEFINITIVA_USUARIO',
        entidad: 'usuario',
        idObjetivoUsuario: usuario.id_usuario,
        detalle: `Usuario purgado automáticamente: ${usuario.nickname}`
      });
    }

    await client.query('COMMIT');

    console.log(`Productos purgados: ${productos.length}`);
    console.log(`Usuarios purgados: ${usuarios.length}`);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error durante la purga:', error);
  } finally {
    client.release();
    process.exit(0);
  }
}

purgar();