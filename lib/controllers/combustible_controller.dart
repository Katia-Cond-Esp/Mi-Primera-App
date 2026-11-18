
class CombustibleController {

  // Atributos
  String marcaVehiculo;
  double distanciaRecorrida;
  double cantidadCombustible;

  // Constructor
  CombustibleController({
    required this.marcaVehiculo,
    required this.distanciaRecorrida,
    required this.cantidadCombustible,
  });

  // Método para calcular el rendimiento
  double calcularRendimiento() {
    return distanciaRecorrida / cantidadCombustible;
  }

  // Método para evaluar el rendimiento
  String evaluarRendimiento() {
    double rendimiento = calcularRendimiento();

    if (rendimiento >= 15) {
      return 'BUEN RENDIMIENTO 🎉';
    } else {
      return 'BAJO RENDIMIENTO ⚠️';
    }
  }
}
