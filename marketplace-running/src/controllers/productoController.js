const ProductoService = require("../services/productoService");

class ProductoController {
  static async mostrarProductos(req, res) {
    try {
      const productos = await ProductoService.obtenerProductosActivos();
      res.render("products", { productos });
    } catch (error) {
      console.error("Error al obtener los productos:", error);
      res.status(500).send("Error interno del servidor");
    }
  }

  static async mostrarDetalleProducto(req, res) {
    try {
      const idProducto = parseInt(req.params.id);

      if (isNaN(idProducto) || idProducto <= 0) {
        return res.status(400).send("ID de producto no válido");
      }
      
      const producto = await ProductoService.obtenerProductoPorId(idProducto);

      if (!producto) {
        return res.status(404).send("Producto no encontrado");
      }

      res.render("product_detail", { producto });
    } catch (error) {
      console.error("Error al obtener el detalle del producto:", error);
      res.status(500).send("Error interno del servidor");
    }
  }
}

module.exports = ProductoController;
