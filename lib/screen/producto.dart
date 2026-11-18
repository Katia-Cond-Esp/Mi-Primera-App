
import 'package:flutter/material.dart';
import 'package:mi_primera_app/controllers/producto_controller.dart';

class PantallaProducto extends StatefulWidget {
  const PantallaProducto({super.key});

  @override
  State<PantallaProducto> createState() => _PantallaProductoState();
}

class _PantallaProductoState extends State<PantallaProducto> {

  // Controladores
  final nombre = TextEditingController();
  final precio = TextEditingController();
  final descuento = TextEditingController();

  // Variables para mostrar resultados
  String nombreMostrado = '';
  double montoDescuento = 0;
  double precioFinal = 0;
  bool mostrarResultado = false;

  // Método para calcular
  void calcularProducto() {

    FocusScope.of(context).unfocus();

    // Validar campos vacíos
    if (nombre.text.trim().isEmpty ||
        precio.text.trim().isEmpty ||
        descuento.text.trim().isEmpty) {
      _mostrarAlerta(
        'Advertencia',
        'Por favor, complete todos los campos.',
      );
      return;
    }

    double? p = double.tryParse(precio.text);
    int? d = int.tryParse(descuento.text);

    // Validar números
    if (p == null || d == null) {
      _mostrarAlerta(
        'Error',
        'Ingrese valores numéricos válidos.',
      );
      return;
    }

    // Validar rangos
    if (p < 0 || d < 0 || d > 100) {
      _mostrarAlerta(
        'Error de Rango',
        'El precio no puede ser negativo y el descuento debe estar entre 0 y 100%.',
      );
      return;
    }

    // Crear objeto controlador
    final producto = ProductoController(
      nombreProducto: nombre.text.trim(),
      precioProducto: p,
      porcentajeDescuento: d,
    );

    setState(() {
      nombreMostrado = producto.nombreProducto;
      montoDescuento = producto.calcularDescuento();
      precioFinal = producto.calcularPrecioFinal();
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
          esNumero
              ? Icons.attach_money
              : Icons.shopping_bag_outlined,
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
    precio.dispose();
    descuento.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      // APPBAR
      appBar: AppBar(
        title: const Text(
          'Calculadora de Descuentos',
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
                      'DESCUENTO APLICADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '- S/ ${montoDescuento.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'PRECIO FINAL',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'S/ ${precioFinal.toStringAsFixed(2)}',
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
              'Ingrese los datos del producto',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // CAMPO NOMBRE
            campoTexto(
              'Nombre del producto',
              nombre,
              esNumero: false,
            ),

            const SizedBox(height: 15),

            // CAMPO PRECIO
            campoTexto(
              'Precio original (S/.)',
              precio,
            ),

            const SizedBox(height: 15),

            // CAMPO DESCUENTO
            TextField(
              controller: descuento,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Porcentaje de descuento (0 - 100)',
                prefixIcon: const Icon(Icons.local_offer_outlined),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // BOTON CALCULAR
            ElevatedButton.icon(
              onPressed: calcularProducto,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular Descuento'),
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
