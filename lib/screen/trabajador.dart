
import 'package:flutter/material.dart';
import 'package:mi_primera_app/controllers/trabajador_controller.dart';

class PantallaTrabajador extends StatefulWidget {
  const PantallaTrabajador({super.key});

  @override
  State<PantallaTrabajador> createState() => _PantallaTrabajadorState();
}

class _PantallaTrabajadorState extends State<PantallaTrabajador> {

  // Controladores
  final nombre = TextEditingController();
  final horas = TextEditingController();
  final pago = TextEditingController();

  // Objeto controlador
  final objetotrabajador = CalculadoraTrabajadorController(
    nombreTrabajador: '',
    horasTrabajadas: 0,
    pagaPorHora: 0,
  );

  // Variables para mostrar resultados
  String nombreMostrado = '';
  double sueldoTotal = 0;
  bool mostrarResultado = false;

  // Método para calcular
  void calcularSueldo() {

    FocusScope.of(context).unfocus();

    // Validar campos vacíos
    if (nombre.text.trim().isEmpty ||
        horas.text.trim().isEmpty ||
        pago.text.trim().isEmpty) {
      _mostrarAlerta(
        'Advertencia',
        'Por favor, complete todos los campos.',
      );
      return;
    }

    double? h = double.tryParse(horas.text);
    double? p = double.tryParse(pago.text);

    // Validar números
    if (h == null || p == null) {
      _mostrarAlerta(
        'Error',
        'Ingrese valores numéricos válidos.',
      );
      return;
    }

    // Validar valores negativos
    if (h < 0 || p < 0) {
      _mostrarAlerta(
        'Error de Rango',
        'Las horas y el pago no pueden ser negativos.',
      );
      return;
    }

    // Crear objeto controlador
    final calculadora = CalculadoraTrabajadorController(
      nombreTrabajador: nombre.text.trim(),
      horasTrabajadas: h,
      pagaPorHora: p,
    );

    setState(() {
      nombreMostrado = calculadora.nombreTrabajador;
      sueldoTotal = calculadora.calcularSueldo();
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: esNumero
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(
          esNumero ? Icons.work_outline : Icons.person_outline,
        ),
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
    nombre.dispose();
    horas.dispose();
    pago.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      // APPBAR
      appBar: AppBar(
        title: const Text(
          'Calculadora de Sueldo',
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
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      nombreMostrado.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'SUELDO TOTAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'S/ ${sueldoTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            if (mostrarResultado)
              const SizedBox(height: 30),

            // TITULO
            const Text(
              'Ingrese los datos del trabajador',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // CAMPO NOMBRE
            campoTexto(
              'Nombre del trabajador',
              nombre,
              esNumero: false,
            ),

            const SizedBox(height: 15),

            // CAMPO HORAS
            campoTexto(
              'Horas trabajadas',
              horas,
            ),

            const SizedBox(height: 15),

            // CAMPO PAGO
            campoTexto(
              'Pago por hora (S/.)',
              pago,
            ),

            const SizedBox(height: 30),

            // BOTON CALCULAR
            ElevatedButton.icon(
              onPressed: calcularSueldo,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular Sueldo'),
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
