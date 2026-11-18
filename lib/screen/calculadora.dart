import 'package:flutter/material.dart';
import 'package:mi_primera_app/controllers/promedio_controller.dart';

class Screen01 extends StatefulWidget {
  const Screen01({super.key});

  @override
  State<Screen01> createState() => _Screen01State();
}

class _Screen01State extends State<Screen01> {
  //Controladores
  final nombre = TextEditingController();
  final nota1 = TextEditingController();
  final nota2 = TextEditingController();
  final nota3 = TextEditingController();
  
  final objetopromedio = PromedioController();
  
  // Variables de estado para la respuesta visual
  double respuesta = 0;
  String mensajeEstado = '';
  bool esAprobado = false;
  bool mostrarResultado = false;

  void promedio(){
    calcular('promedio');
  }

  void calcular(String operacion){

    //Validar campos vacios 
    if (nombre.text.trim().isEmpty ||
        nota1.text.trim().isEmpty ||
        nota2.text.trim().isEmpty ||
        nota3.text.trim().isEmpty) {
      _mostrarAlerta('Advertencia', 'Por favor, complete todos los campos.');
      return;
    }

    double n1 = double.tryParse(nota1.text) ?? 0;
    double n2 = double.tryParse(nota2.text) ?? 0;
    double n3 = double.tryParse(nota3.text) ?? 0;

    // Validar que las notas estén entre 0 y 20
    if (n1 < 0 || n1 > 20 || n2 < 0 || n2 > 20 || n3 < 0 || n3 > 20) {
      _mostrarAlerta('Error de Rango', 'Las notas deben estar comprendidas entre 0 y 20.');
      return;
    }

    setState(() {
      switch(operacion){
        case 'promedio':
        respuesta = objetopromedio.promedio(n1, n2, n3);
        break;
      }

      // Evaluar condición de aprobación (Mínimo 13)
      if (respuesta >= 13) {
        mensajeEstado = 'APROBADO 🎉';
        esAprobado = true;
      } else {
        mensajeEstado = 'DESAPROBADO ❌';
        esAprobado = false;
      }
      
      mostrarResultado = true;
      
    });
  }

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

  Widget campoTexto(String etiqueta, TextEditingController controller, {bool esNumero = true}) {
    return TextField(
      controller: controller,
      keyboardType: esNumero 
          ? const TextInputType.numberWithOptions(decimal: true) 
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(esNumero ? Icons.school_outlined : Icons.person_outline),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'Calculadora de Promedio',
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
                  color: esAprobado ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      nombre.text.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Muestra el promedio con dos decimales exactos
                    Text(
                      respuesta.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      mensajeEstado,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            if (mostrarResultado) const SizedBox(height: 30),

            const Text(
              'Ingrese los datos',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            campoTexto('Nombre del estudiante', nombre, esNumero: false),

            const SizedBox(height: 15),

            campoTexto('Nota 1 (0 - 20)', nota1),

            const SizedBox(height: 15),

            campoTexto('Nota 2 (0 - 20)', nota2),

            const SizedBox(height: 15),

            campoTexto('Nota 3 (0 - 20)', nota3),

            const SizedBox(height: 30),

            // BOTÓN CALCULAR
            ElevatedButton.icon(
              onPressed: promedio,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular Promedio'),
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

  @override
  void dispose() {
    nombre.dispose();
    nota1.dispose();
    nota2.dispose();
    nota3.dispose();
    super.dispose();
  }
}