const AnaliticaService = require('../services/analiticaService');
const ProductoService = require('../services/productoService');

class AnaliticaController {
  static async mostrarDashboard(req, res) {
    try {
      const vista = req.query.vista || 'general';
      const usuarioBusqueda = req.query.usuario || '';
      const anio = req.query.anio || '';
      const categoria = req.query.categoria || '';

      const [aniosDisponibles, categorias, usuariosSelect] = await Promise.all([
        AnaliticaService.obtenerAniosDisponibles(),
        ProductoService.obtenerCategorias(),
        AnaliticaService.obtenerUsuariosParaAnalitica()
      ]);

      if (vista === 'usuario') {
        let usuario = null;
        let resenas = null;
        let compras = [];
        let ventas = [];

        if (usuarioBusqueda) {
          usuario = await AnaliticaService.obtenerResumenUsuario({
            usuario: usuarioBusqueda,
            anio,
            categoria
          });

          if (usuario) {
            [resenas, compras, ventas] = await Promise.all([
              AnaliticaService.obtenerResenasUsuario(usuario.id_usuario),
              AnaliticaService.obtenerUltimasCompras(usuario.id_usuario, {
                anio,
                categoria
              }),
              AnaliticaService.obtenerUltimasVentas(usuario.id_usuario, {
                anio,
                categoria
              })
            ]);
          }
        }

        return res.render('analitica', {
          vista,
          usuarioBusqueda,
          usuario,
          resenas,
          compras,
          ventas,
          usuariosSelect,
          aniosDisponibles: aniosDisponibles.map(a => a.anio),
          categorias,
          filtros: { anio, categoria }
        });
      }

      const [
        resumenGeneral,
        resumenProductos,
        ventasRetenidas,
        resumenValoraciones,
        ventasMes,
        ventasCategoria,
        estados,
        topVendedores,
        topCompradores
      ] = await Promise.all([
        AnaliticaService.obtenerResumenGeneral({ anio, categoria }),
        AnaliticaService.obtenerTotalProductosVendidos({ anio, categoria }),
        AnaliticaService.obtenerVentasRetenidas({ anio, categoria }),
        AnaliticaService.obtenerResumenValoraciones({ anio, categoria }),
        AnaliticaService.obtenerVentasPorMes({ anio, categoria }),
        AnaliticaService.obtenerVentasPorCategoria({ anio, categoria }),
        AnaliticaService.obtenerEstadoProductos({ categoria }),
        AnaliticaService.obtenerTopVendedores({ anio, categoria }),
        AnaliticaService.obtenerTopCompradores({ anio, categoria })
      ]);

      const resumen = {
        totalPedidosCompletados: Number(resumenGeneral.total_pedidos_completados || 0),
        ingresosTotales: Number(resumenGeneral.ingresos_totales || 0),
        totalProductosVendidos: Number(resumenProductos.total_productos_vendidos || 0),
        ventasRetenidas: Number(ventasRetenidas.total_retenidas || 0),
        importeRetenido: Number(ventasRetenidas.importe_retenido || 0),
        mediaValoraciones: Number(resumenValoraciones.media_valoraciones || 0),
        totalResenyas: Number(resumenValoraciones.total_resenyas || 0)
      };

      res.render('analitica', {
        vista,
        resumen,
        ventasMes,
        ventasCategoria,
        estados,
        topVendedores,
        topCompradores,
        usuariosSelect,
        aniosDisponibles: aniosDisponibles.map(a => a.anio),
        categorias,
        filtros: { anio, categoria }
      });
    } catch (error) {
      console.error('Error al cargar la analítica:', error);
      res.status(500).send('Error al cargar la analítica');
    }
  }
}

module.exports = AnaliticaController;