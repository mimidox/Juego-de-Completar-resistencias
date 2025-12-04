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
  'black': ColorBandData(color: Colors.black, name: 'Negro', digit: 0, multiplier: 1.0),
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

// Listas de colores permitidos para cada banda - ASEGURAR QUE ORO Y PLATA ESTÉN
final List<String> digitColors = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white'];
final List<String> allDigitColors = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white'];
final List<String> multiplierColors = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white', 'gold', 'silver'];
final List<String> toleranceColors = ['brown', 'red', 'green', 'blue', 'violet', 'grey', 'gold', 'silver'];

// --- MODELO DEL RESULTADO ---
class ResistorValue {
  final double value; // En Ohmios
  final double tolerance; // En porcentaje
  final String formattedValue; // Ej: 1kΩ, 4.7MΩ
  final String formattedTolerance; // Ej: ±5%

  ResistorValue({
    required this.value,
    required this.tolerance,
  })  : formattedValue = _formatValue(value),
        formattedTolerance = '±${tolerance.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}%';

  static String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2).replaceAll(RegExp(r'\.0$'), '').replaceAll(RegExp(r'\.00$'), '')}MΩ';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2).replaceAll(RegExp(r'\.0$'), '').replaceAll(RegExp(r'\.00$'), '')}kΩ';
    } else {
      return '${value.toStringAsFixed(0)}Ω';
    }
  }
}

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

    // 1. Elegir colores para Digito 1 y Digito 2
    String band1Key = digitColors[random.nextInt(digitColors.length)];
    String band2Key = allDigitColors[random.nextInt(allDigitColors.length)];

    // 2. Elegir color para Multiplicador
    String band3Key = multiplierColors[random.nextInt(multiplierColors.length)];

    // 3. Elegir color para Tolerancia
    String band4Key = toleranceColors[random.nextInt(toleranceColors.length)];

    // DEBUG: Verificar los colores seleccionados
    print('Colores correctos: $band1Key, $band2Key, $band3Key, $band4Key');

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
      return '${(targetValue / 1000000).toStringAsFixed(2).replaceAll(RegExp(r'\.0$'), '').replaceAll(RegExp(r'\.00$'), '')}MΩ';
    } else if (targetValue >= 1000) {
      return '${(targetValue / 1000).toStringAsFixed(2).replaceAll(RegExp(r'\.0$'), '').replaceAll(RegExp(r'\.00$'), '')}kΩ';
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

  // Calcula el valor de la resistencia basado en las bandas del usuario
  static ResistorValue calculateResistorValue(List<String> userBands) {
    if (userBands.length != 4) {
      throw ArgumentError('Debe haber exactamente 4 bandas');
    }

    // Verificar si hay bandas sin seleccionar
    if (userBands.contains('none')) {
      throw StateError('Faltan bandas por seleccionar');
    }

    // Obtener los datos de cada banda
    final ColorBandData band1 = colorBands[userBands[0]]!;
    final ColorBandData band2 = colorBands[userBands[1]]!;
    final ColorBandData band3 = colorBands[userBands[2]]!;
    final ColorBandData band4 = colorBands[userBands[3]]!;

    // Verificar que las bandas sean válidas para su posición
    if (band1.digit < 0) {
      throw ArgumentError('La primera banda debe ser un color de dígito');
    }
    if (band2.digit < 0) {
      throw ArgumentError('La segunda banda debe ser un color de dígito');
    }
    if (band3.multiplier <= 0.0) {
      throw ArgumentError('La tercera banda debe ser un color de multiplicador');
    }
    if (band4.tolerance <= 0.0) {
      throw ArgumentError('La cuarta banda debe ser un color de tolerancia');
    }

    // Calcular el valor: (D1 * 10 + D2) * Multiplicador
    final int digit1 = band1.digit;
    final int digit2 = band2.digit;
    final double multiplier = band3.multiplier;
    final double tolerance = band4.tolerance * 100; // Convertir a porcentaje

    final double value = (digit1 * 10 + digit2) * multiplier;

    return ResistorValue(
      value: value,
      tolerance: tolerance,
    );
  }

  // Método auxiliar para obtener los nombres de las bandas
  static String getBandNames(List<String> bands) {
    return bands.map((band) => colorBands[band]?.name ?? 'Desconocido').join(' - ');
  }
}