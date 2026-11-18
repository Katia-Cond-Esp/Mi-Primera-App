import 'package:flutter/material.dart';
import 'package:mi_primera_app/screen/calculadora.dart';
import 'package:mi_primera_app/screen/combustible.dart';
import 'package:mi_primera_app/screen/producto.dart';
import 'package:mi_primera_app/screen/trabajador.dart';

void main() {
  //El runApp nos permite ejecutar nuestro programa
  runApp(
    const MaterialApp(
      //El home nos permite definir la pantalla que se va a mostrar al iniciar el programa
      home: PantallaCombustible(),
    ),
  );
}
