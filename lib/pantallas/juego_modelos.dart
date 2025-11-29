import 'package:flutter/material.dart';

// Estructura de datos para niveles usando Queue
import 'dart:collection';

class Nivel {
  final int numero;
  final String titulo;
  final String valorObjetivo;
  final String descripcion;
  final Color color;
  final int puntosRequeridos;
  final List<Color> coloresCorrectos;

  Nivel({
    required this.numero,
    required this.titulo,
    required this.valorObjetivo,
    required this.descripcion,
    required this.color,
    required this.puntosRequeridos,
    required this.coloresCorrectos,
  });
}

class Jugador {
  String nombre;
  int puntuacion;
  int nivelActual;
  int racha;

  Jugador({
    required this.nombre,
    this.puntuacion = 0,
    this.nivelActual = 1,
    this.racha = 0,
  });
}

// Gestor de niveles usando Queue
class GestorNiveles {
  final Queue<Nivel> _niveles = Queue();
  
  GestorNiveles() {
    _inicializarNiveles();
  }
  
  void _inicializarNiveles() {
    _niveles.addAll([
      Nivel(
        numero: 1,
        titulo: "PRINCIPIANTE",
        valorObjetivo: "1kΩ ±5%",
        descripcion: "Valores básicos - Aprende los fundamentos",
        color: Colors.green,
        puntosRequeridos: 0,
        coloresCorrectos: [Colors.brown, Colors.black, Colors.red, Color(0xFFFFD700)],
      ),
      Nivel(
        numero: 2,
        titulo: "INTERMEDIO", 
        valorObjetivo: "4.7kΩ ±10%",
        descripcion: "Valores con punto decimal - Mayor precisión",
        color: Colors.orange,
        puntosRequeridos: 30,
        coloresCorrectos: [Colors.yellow, Colors.purple, Colors.red, Color(0xFFC0C0C0)],
      ),
      Nivel(
        numero: 3,
        titulo: "AVANZADO",
        valorObjetivo: "47kΩ ±1%",
        descripcion: "Valores complejos - Tolerancias estrictas",
        color: Colors.red,
        puntosRequeridos: 60,
        coloresCorrectos: [Colors.yellow, Colors.purple, Colors.orange, Colors.brown],
      ),
    ]);
  }
  
  Queue<Nivel> get niveles => _niveles;
  int get totalNiveles => _niveles.length;
  
  Nivel? obtenerNivel(int numero) {
    return _niveles.firstWhere((nivel) => nivel.numero == numero);
  }
  
  bool estaDesbloqueado(Nivel nivel, int puntuacionJugador) {
    return puntuacionJugador >= nivel.puntosRequeridos;
  }
  
  Nivel? obtenerSiguienteNivel(Nivel nivelActual) {
    final listaNiveles = _niveles.toList();
    final indexActual = listaNiveles.indexWhere((n) => n.numero == nivelActual.numero);
    
    if (indexActual < listaNiveles.length - 1) {
      return listaNiveles[indexActual + 1];
    }
    return null;
  }
}