import 'package:flutter/material.dart';
import 'screens/pantalla_inicio.dart';
import 'screens/pantalla_juego.dart';
import 'screens/pantalla_instrucciones.dart';

// Punto de entrada de la aplicación Flutter
void main() {
  runApp(const ResistorColorApp());
}

class ResistorColorApp extends StatelessWidget {
  const ResistorColorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resistor Color Builder',
      // Definición del tema de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      // Rutas de navegación para las diferentes pantallas
      routes: {
        '/': (context) => const PantallaInicio(),
        '/game': (context) => const PantallaJuego(),
        '/instructions': (context) => const PantallaInstrucciones(),
      },
    );
  }
}