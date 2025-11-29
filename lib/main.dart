import 'package:flutter/material.dart';
import 'pantallas/pantalla_inicio.dart';

void main() {
  runApp(ResistorColorBuilderApp());
}

class ResistorColorBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resistor Color Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaInicio(),
      debugShowCheckedModeBanner: false,
    );
  }
}