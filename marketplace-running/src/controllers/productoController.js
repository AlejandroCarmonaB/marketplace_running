const ProductoService = require('../services/productoService');
const ResenyaProductoService = require('../services/resenyaProductoService');

class ProductoController {
  static async mostrarProductos(req, res) {
    try {
      const termino = req.query.q || '';
      const idCategoria = req.query.categoria || '';
      const precioMax = req.query.precioMax || '';

      const categorias = await ProductoService.obtenerCategorias();

      const productos = await ProductoService.filtrarProductos({
        termino,
        idCategoria,
        precioMax
      });

      res.render('products', {
        productos,
        termino,
        categorias,
        filtros: {
          idCategoria,
          precioMax
        }
      });
    } catch (error) {
      console.error('Error al obtener los productos:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async mostrarDetalleProducto(req, res) {
    try {
      const idProducto = parseInt(req.params.id);

      if (isNaN(idProducto) || idProducto <= 0) {
        return res.status(400).send('ID de producto no válido');
      }

      const producto = await ProductoService.obtenerProductoPorId(idProducto);

      if (!producto) {
        return res.status(404).send('Producto no encontrado');
      }

      const imagenes = await ProductoService.obtenerImagenesProducto(idProducto);
      const resenyas = await ResenyaProductoService.obtenerResenyasDeProducto(idProducto);
      const resumen = await ResenyaProductoService.obtenerResumenValoracionesProducto(idProducto);

      let resenyaUsuario = null;
      if (req.session.usuario) {
        resenyaUsuario = await ResenyaProductoService.obtenerResenyaProductoUsuario(
          req.session.usuario.id_usuario,
          idProducto
        );
      }

      const mensajeExito = req.session.mensajeExito || null;
      const mensajeError = req.session.mensajeError || null;
      delete req.session.mensajeExito;
      delete req.session.mensajeError;

      res.render('product_detail', {
        producto,
        imagenes,
        resenyas,
        resumen,
        resenyaUsuario,
        mensajeExito,
        mensajeError
      });
    } catch (error) {
      console.error('Error al obtener el detalle del producto:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async mostrarFormularioPublicar(req, res) {
    try {
      const categorias = await ProductoService.obtenerCategorias();

      res.render('product_form', {
        categorias,
        error: null,
        exito: null,
        datos: {},
        modoEdicion: false,
        idProducto: null
      });
    } catch (error) {
      console.error('Error al mostrar el formulario de publicación:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async publicarProducto(req, res) {
    const categorias = await ProductoService.obtenerCategorias();

    try {
      const idVendedor = req.session.usuario.id_usuario;

      const titulo = req.body.titulo?.trim();
      const descripcion = req.body.descripcion?.trim();
      const estadoFisico = req.body.estado_fisico?.trim();
      const idCategoria = parseInt(req.body.id_categoria);
      const precio = parseFloat(req.body.precio);

      if (!titulo || !descripcion || !estadoFisico || !req.body.id_categoria || !req.body.precio) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'Todos los campos son obligatorios.',
          exito: null,
          datos: req.body,
          modoEdicion: false,
          idProducto: null
        });
      }

      if (isNaN(idCategoria) || idCategoria <= 0) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'La categoría seleccionada no es válida.',
          exito: null,
          datos: req.body,
          modoEdicion: false,
          idProducto: null
        });
      }

      if (isNaN(precio) || precio < 0) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'El precio no es válido.',
          exito: null,
          datos: req.body,
          modoEdicion: false,
          idProducto: null
        });
      }

      const estadosValidos = [
        'como nuevo',
        'excelente estado',
        'muy poco uso',
        'buen estado',
        'uso moderado'
      ];

      if (!estadosValidos.includes(estadoFisico)) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'El estado físico seleccionado no es válido.',
          exito: null,
          datos: req.body,
          modoEdicion: false,
          idProducto: null
        });
      }

      const productoCreado = await ProductoService.crearProducto({
        idVendedor,
        idCategoria,
        titulo,
        descripcion,
        precio,
        stock: 1,
        estadoFisico
      });

      if (req.files && req.files.length > 0) {
        const rutas = req.files.map(file => `uploads/productos/${file.filename}`);
        await ProductoService.insertarImagenes(productoCreado.id_prod, rutas);
      }

      req.session.mensajeExito = 'Producto publicado correctamente.';
      return res.redirect('/mis-productos');
    } catch (error) {
      console.error('Error al publicar producto:', error);

      return res.status(500).render('product_form', {
        categorias,
        error: error.message || 'Error interno del servidor.',
        exito: null,
        datos: req.body || {},
        modoEdicion: false,
        idProducto: null
      });
    }
  }

  static async mostrarMisProductos(req, res) {
    try {
      const idVendedor = req.session.usuario.id_usuario;
      const productos = await ProductoService.obtenerProductosPorVendedor(idVendedor);

      const mensajeExito = req.session.mensajeExito || null;
      delete req.session.mensajeExito;

      res.render('my_products', { productos, mensajeExito });
    } catch (error) {
      console.error('Error al obtener los productos del vendedor:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async mostrarFormularioEditar(req, res) {
    try {
      const idProducto = parseInt(req.params.id);
      const idVendedor = req.session.usuario.id_usuario;

      if (isNaN(idProducto) || idProducto <= 0) {
        return res.status(400).send('ID de producto no válido');
      }

      const categorias = await ProductoService.obtenerCategorias();
      const producto = await ProductoService.obtenerProductoPorIdYVendedor(idProducto, idVendedor);

      if (!producto) {
        return res.status(404).send('Producto no encontrado o no te pertenece');
      }

      res.render('product_form', {
        categorias,
        error: null,
        exito: null,
        datos: producto,
        modoEdicion: true,
        idProducto
      });
    } catch (error) {
      console.error('Error al mostrar el formulario de edición:', error);
      res.status(500).send('Error interno del servidor');
    }
  }

  static async editarProducto(req, res) {
    const categorias = await ProductoService.obtenerCategorias();

    try {
      const idProducto = parseInt(req.params.id);
      const idVendedor = req.session.usuario.id_usuario;

      const titulo = req.body.titulo?.trim();
      const descripcion = req.body.descripcion?.trim();
      const estadoFisico = req.body.estado_fisico?.trim();
      const idCategoria = parseInt(req.body.id_categoria);
      const precio = parseFloat(req.body.precio);

      if (!titulo || !descripcion || !estadoFisico || !req.body.id_categoria || !req.body.precio) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'Todos los campos son obligatorios.',
          exito: null,
          datos: { ...req.body, id_prod: idProducto },
          modoEdicion: true,
          idProducto
        });
      }

      if (isNaN(idCategoria) || idCategoria <= 0) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'La categoría seleccionada no es válida.',
          exito: null,
          datos: { ...req.body, id_prod: idProducto },
          modoEdicion: true,
          idProducto
        });
      }

      if (isNaN(precio) || precio < 0) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'El precio no es válido.',
          exito: null,
          datos: { ...req.body, id_prod: idProducto },
          modoEdicion: true,
          idProducto
        });
      }

      const estadosValidos = [
        'como nuevo',
        'excelente estado',
        'muy poco uso',
        'buen estado',
        'uso moderado'
      ];

      if (!estadosValidos.includes(estadoFisico)) {
        return res.status(400).render('product_form', {
          categorias,
          error: 'El estado físico seleccionado no es válido.',
          exito: null,
          datos: { ...req.body, id_prod: idProducto },
          modoEdicion: true,
          idProducto
        });
      }

      const actualizado = await ProductoService.actualizarProducto({
        idProducto,
        idVendedor,
        idCategoria,
        titulo,
        descripcion,
        precio,
        estadoFisico
      });

      if (!actualizado) {
        return res.status(404).send('Producto no encontrado o no te pertenece');
      }

      if (req.files && req.files.length > 0) {
        const rutas = req.files.map(file => `uploads/productos/${file.filename}`);
        await ProductoService.insertarImagenes(idProducto, rutas);
      }

      req.session.mensajeExito = 'Producto actualizado correctamente.';
      return res.redirect('/mis-productos');
    } catch (error) {
      console.error('Error al editar producto:', error);

      return res.status(500).render('product_form', {
        categorias,
        error: error.message || 'Error interno del servidor.',
        exito: null,
        datos: { ...req.body, id_prod: req.params.id },
        modoEdicion: true,
        idProducto: req.params.id
      });
    }
  }

  static async eliminarProducto(req, res) {
    try {
      const idProducto = parseInt(req.params.id);
      const idVendedor = req.session.usuario.id_usuario;

      if (isNaN(idProducto) || idProducto <= 0) {
        return res.status(400).send('ID de producto no válido');
      }

      const eliminado = await ProductoService.desactivarProducto(idProducto, idVendedor);

      if (!eliminado) {
        return res.status(404).send('Producto no encontrado o no te pertenece');
      }

      req.session.mensajeExito = 'Producto desactivado correctamente.';
      return res.redirect('/mis-productos');
    } catch (error) {
      console.error('Error al eliminar producto:', error);
      return res.status(500).send('Error interno del servidor');
    }
  }
}

module.exports = ProductoController;