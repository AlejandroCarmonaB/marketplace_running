const ProductoService = require('../services/productoService');

class CarritoController {
  static async agregarAlCarrito(req, res) {
    try {
      const idProducto = parseInt(req.params.id);

      if (isNaN(idProducto) || idProducto <= 0) {
        return res.status(400).send('ID de producto no válido');
      }

      if (!req.session.carrito) {
        req.session.carrito = [];
      }

      const producto = await ProductoService.obtenerProductoPorId(idProducto);

      if (!producto) {
        return res.status(404).send('Producto no encontrado');
      }

      if (producto.id_vendedor === req.session.usuario.id_usuario) {
        return res.redirect(`/producto/${idProducto}`);
      }

      const yaEnCarrito = req.session.carrito.some(
        p => p.id_prod === idProducto
      );

      if (yaEnCarrito) {
        return res.redirect('/carrito');
      }

      req.session.carrito.push(producto);

      return res.redirect('/carrito');
    } catch (error) {
      console.error('Error al añadir al carrito:', error);
      return res.status(500).send('Error interno del servidor');
    }
  }

  static verCarrito(req, res) {
    try {
      const carrito = req.session.carrito || [];

      const total = carrito.reduce((acumulado, producto) => {
        return acumulado + Number(producto.precio);
      }, 0);

      const mensajeError = req.session.mensajeError || null;
      delete req.session.mensajeError;

      res.render('carrito', {
        carrito,
        total,
        mensajeError
      });
    } catch (error) {
      console.error('Error al mostrar el carrito:', error);
      return res.status(500).send('Error interno del servidor');
    }
  }

  static eliminarDelCarrito(req, res) {
    const idProducto = parseInt(req.params.id);

    req.session.carrito = (req.session.carrito || []).filter(
      p => p.id_prod !== idProducto
    );

    return res.redirect('/carrito');
  }

  static async comprar(req, res) {
    try {
      const carrito = req.session.carrito || [];

      if (carrito.length === 0) {
        return res.redirect('/carrito');
      }

      const idComprador = req.session.usuario.id_usuario;

      await ProductoService.procesarCompra({
        idComprador,
        carrito
      });

      req.session.carrito = [];
      req.session.mensajeExito = 'Compra realizada correctamente. Tu pedido está pendiente de verificación.';

      return res.redirect('/mis-pedidos');
    } catch (error) {
      console.error('Error en la compra:', error);
      req.session.mensajeError = error.message || 'Error al procesar la compra.';
      return res.redirect('/carrito');
    }
  }
}

module.exports = CarritoController;