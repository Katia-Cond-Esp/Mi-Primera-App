
class CalculadoraTrabajadorController {

  String nombreTrabajador;
  double horasTrabajadas;
  double pagaPorHora;

  CalculadoraTrabajadorController({
    required this.nombreTrabajador,
    required this.horasTrabajadas,
    required this.pagaPorHora,
  });

  double calcularSueldo() {
    return horasTrabajadas * pagaPorHora;
  }
}
