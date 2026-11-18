
import 'package:flutter/material.dart';
import 'package:mi_primera_app/controllers/combustible_controller.dart';

class PantallaCombustible extends StatefulWidget {
  const PantallaCombustible({super.key});

  @override
  State<PantallaCombustible> createState() => _PantallaCombustibleState();
}

class _PantallaCombustibleState extends State<PantallaCombustible> {

  // Controladores
  final marca = TextEditingController();
  final distancia = TextEditingController();
  final combustible = TextEditingController();

  // Variables para mostrar resultados
  String marcaMostrada = '';
  double rendimiento = 0;
  String evaluacion = '';
  bool mostrarResultado = false;

  // Método para calcular
  void calcularCombustible() {

    FocusScope.of(context).unfocus();

    // Validar campos vacíos
    if (marca.text.trim().isEmpty ||
        distancia.text.trim().isEmpty ||
        combustible.text.trim().isEmpty) {
      _mostrarAlerta(
        'Advertencia',
        'Por favor, complete todos los campos.',
      );
      return;
    }

    double? d = double.tryParse(distancia.text);
    double? c = double.tryParse(combustible.text);

    // Validar números
    if (d == null || c == null) {
      _mostrarAlerta(
        'Error',
        'Ingrese valores numéricos válidos.',
      );
      return;
    }

    // Validar rangos
    if (d < 0 || c <= 0) {
      _mostrarAlerta(
        'Error de Rango',
        'La distancia no puede ser negativa y el combustible debe ser mayor que cero.',
      );
      return;
    }

    // Crear objeto controlador
    final vehiculo = CombustibleController(
      marcaVehiculo: marca.text.trim(),
      distanciaRecorrida: d,
      cantidadCombustible: c,
    );

    setState(() {
      marcaMostrada = vehiculo.marcaVehiculo;
      rendimiento = vehiculo.calcularRendimiento();
      evaluacion = vehiculo.evaluarRendimiento();
      mostrarResultado = true;
    });
  }

  // Método para mostrar alertas
  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Método para crear campos de texto
  Widget campoTexto(
    String etiqueta,
    TextEditingController controller, {
    bool esNumero = true,
    IconData icono = Icons.directions_car,
  }) {
    return TextField(
      controller: controller,
      keyboardType: esNumero
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    marca.dispose();
    distancia.dispose();
    combustible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Color según el rendimiento
    Color colorEvaluacion =
        rendimiento >= 15
            ? const Color(0xFF2E7D32)
            : const Color(0xFFEF6C00);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      // APPBAR
      appBar: AppBar(
        title: const Text(
          'Calculadora de Combustible',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3157C8),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // TARJETA DE RESULTADO
            if (mostrarResultado)
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: colorEvaluacion,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    Text(
                      marcaMostrada.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'RENDIMIENTO DEL VEHÍCULO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${rendimiento.toStringAsFixed(2)} km/gal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        evaluacion,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (mostrarResultado)
              const SizedBox(height: 30),

            // TITULO
            const Text(
              'Ingrese los datos del vehículo',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // CAMPO MARCA
            campoTexto(
              'Marca del vehículo',
              marca,
              esNumero: false,
              icono: Icons.directions_car_outlined,
            ),

            const SizedBox(height: 15),

            // CAMPO DISTANCIA
            campoTexto(
              'Distancia recorrida (km)',
              distancia,
              icono: Icons.map_outlined,
            ),

            const SizedBox(height: 15),

            // CAMPO COMBUSTIBLE
            campoTexto(
              'Combustible consumido (galones/litros)',
              combustible,
              icono: Icons.local_gas_station_outlined,
            ),

            const SizedBox(height: 30),

            // BOTON CALCULAR
            ElevatedButton.icon(
              onPressed: calcularCombustible,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular Rendimiento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3157C8),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
