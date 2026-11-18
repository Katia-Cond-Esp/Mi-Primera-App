
class ProductoController {

  String nombreProducto;
  double precioProducto;
  int porcentajeDescuento;

  ProductoController({
    required this.nombreProducto,
    required this.precioProducto,
    required this.porcentajeDescuento,
  });

  // Calcular monto del descuento
  double calcularDescuento() {
    return precioProducto * porcentajeDescuento / 100;
  }

  // Calcular precio final
  double calcularPrecioFinal() {
    return precioProducto - calcularDescuento();
  }
}
