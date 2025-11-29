import 'package:flutter/material.dart';
import 'dart:math';

// --- CONFIGURACIÓN DE COLORES Y DATOS ---

// Definición del modelo para cada banda de color
class ColorBandData {
  final Color color;
  final String name;
  final int digit;
  final double multiplier;
  final double tolerance;

  const ColorBandData({
    required this.color,
    required this.name,
    this.digit = -1, // -1 indica que no es un dígito
    this.multiplier = 0.0,
    this.tolerance = 0.0,
  });
}

// Mapa de colores con sus propiedades
const Map<String, ColorBandData> colorBands = {
  'black': ColorBandData(color: Colors.black, name: 'Negro', digit: 0, multiplier: 1.0, tolerance: 0.0),
  'brown': ColorBandData(color: Color(0xFF8B4513), name: 'Marrón', digit: 1, multiplier: 10.0, tolerance: 0.01),
  'red': ColorBandData(color: Colors.red, name: 'Rojo', digit: 2, multiplier: 100.0, tolerance: 0.02),
  'orange': ColorBandData(color: Colors.orange, name: 'Naranja', digit: 3, multiplier: 1000.0),
  'yellow': ColorBandData(color: Colors.yellow, name: 'Amarillo', digit: 4, multiplier: 10000.0),
  'green': ColorBandData(color: Colors.green, name: 'Verde', digit: 5, multiplier: 100000.0, tolerance: 0.005),
  'blue': ColorBandData(color: Colors.blue, name: 'Azul', digit: 6, multiplier: 1000000.0, tolerance: 0.0025),
  'violet': ColorBandData(color: Color(0xFF8A2BE2), name: 'Violeta', digit: 7, multiplier: 10000000.0, tolerance: 0.001),
  'grey': ColorBandData(color: Color(0xFF808080), name: 'Gris', digit: 8, multiplier: 100000000.0, tolerance: 0.0005),
  'white': ColorBandData(color: Colors.white, name: 'Blanco', digit: 9, multiplier: 1000000000.0),
  'gold': ColorBandData(color: Color(0xFFFFD700), name: 'Oro', multiplier: 0.1, tolerance: 0.05),
  'silver': ColorBandData(color: Color(0xFFC0C0C0), name: 'Plata', multiplier: 0.01, tolerance: 0.10),
  'none': ColorBandData(color: Colors.transparent, name: 'Sin Banda', tolerance: 0.20),
};

// Listas de colores permitidos para cada banda
final List<String> digitColors = colorBands.keys.where((k) => colorBands[k]!.digit >= 0 && k != 'black').toList(); // No negro para primera banda
final List<String> allDigitColors = colorBands.keys.where((k) => colorBands[k]!.digit >= 0).toList(); // Todos para segunda banda
final List<String> multiplierColors = colorBands.keys.where((k) => colorBands[k]!.multiplier > 0.0).toList();
final List<String> toleranceColors = colorBands.keys.where((k) => colorBands[k]!.tolerance > 0.0).toList();


// --- MODELO DEL JUEGO / DESAFÍO ---

class ResistorChallenge {
  final double targetValue; // En Ohmios
  final double targetTolerance; // En porcentaje
  final List<String> correctBands; // ['color1', 'color2', 'color3', 'color4']

  ResistorChallenge({
    required this.targetValue,
    required this.targetTolerance,
    required this.correctBands,
  });

  // Método estático para generar un nuevo desafío aleatorio
  static ResistorChallenge generateRandom() {
    final Random random = Random();

    // 1. Elegir colores para Digito 1 y Digito 2 (no negro en D1)
    String band1Key = digitColors[random.nextInt(digitColors.length)];
    String band2Key = allDigitColors[random.nextInt(allDigitColors.length)];

    // 2. Elegir color para Multiplicador
    String band3Key = multiplierColors[random.nextInt(multiplierColors.length)];

    // 3. Elegir color para Tolerancia
    String band4Key = toleranceColors[random.nextInt(toleranceColors.length)];

    // Obtener valores
    final int digit1 = colorBands[band1Key]!.digit;
    final int digit2 = colorBands[band2Key]!.digit;
    final double multiplier = colorBands[band3Key]!.multiplier;
    final double tolerance = colorBands[band4Key]!.tolerance;

    // Calcular el valor objetivo: (D1 * 10 + D2) * Multiplicador
    final double value = (digit1 * 10 + digit2) * multiplier;
    final double tolerancePercent = tolerance * 100;

    return ResistorChallenge(
      targetValue: value,
      targetTolerance: tolerancePercent,
      correctBands: [band1Key, band2Key, band3Key, band4Key],
    );
  }

  // Convierte el valor en una cadena legible (ej: 1000 -> 1kΩ)
  String get formattedTargetValue {
    if (targetValue >= 1000000) {
      return '${(targetValue / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}MΩ';
    } else if (targetValue >= 1000) {
      return '${(targetValue / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}kΩ';
    } else {
      return '${targetValue.toStringAsFixed(0)}Ω';
    }
  }

  // Convierte la tolerancia a una cadena legible (ej: 5.0 -> ±5%)
  String get formattedTargetTolerance {
    return '±${targetTolerance.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}%';
  }

  // Formato completo para mostrar al usuario
  String get formattedChallenge => '$formattedTargetValue $formattedTargetTolerance';
}