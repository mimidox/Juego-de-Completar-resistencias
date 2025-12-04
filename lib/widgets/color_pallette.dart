import 'package:flutter/material.dart';
import '../screens/resistor_data.dart';

// Paleta de colores para seleccionar las bandas
class ColorPalette extends StatelessWidget {
  final Function(String colorKey) onColorTap;
  final int currentBandIndex;

  const ColorPalette({
    super.key,
    required this.onColorTap,
    required this.currentBandIndex,
  });

  // Colores a mostrar en la paleta según la banda actual
  List<String> get colorsToShow {
    if (currentBandIndex == 0) return digitColors;
    if (currentBandIndex == 1) return allDigitColors;
    if (currentBandIndex == 2) return multiplierColors;
    if (currentBandIndex == 3) return toleranceColors;

    // Si ya terminó, muestra todos los relevantes
    return colorBands.keys.where((k) => k != 'none').toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = colorsToShow;

    // DEBUG: Verificar qué colores se están mostrando
    print('Colores mostrados para banda $currentBandIndex: $colors');

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // MÁS COLUMNAS para colores más pequeños
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // Más columnas = colores más pequeños
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final colorKey = colors[index];
          final colorData = colorBands[colorKey]!;

          return ColorChip(
            colorKey: colorKey,
            color: colorData.color,
            name: colorData.name,
            onTap: onColorTap,
          );
        },
      ),
    );
  }
}

// Chip individual de color (Draggable)
class ColorChip extends StatelessWidget {
  final String colorKey;
  final Color color;
  final String name;
  final Function(String colorKey) onTap;

  const ColorChip({
    super.key,
    required this.colorKey,
    required this.color,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBlack = color == Colors.black;
    final bool isWhite = color == Colors.white;
    final bool isGold = colorKey == 'gold';
    final bool isSilver = colorKey == 'silver';
    final bool isLightColor = isWhite || isGold || isSilver;

    // TAMAÑO MÁS PEQUEÑO
    return Draggable<String>(
      data: colorKey,
      feedback: Container(
        width: 40, // Más pequeño
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: isBlack || isLightColor 
              ? Border.all(color: Colors.black, width: 2) 
              : Border.all(color: Colors.black38, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: _getColorContent(),
      ),
      childWhenDragging: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey),
        ),
      ),
      child: InkWell(
        onTap: () => onTap(colorKey),
        borderRadius: BorderRadius.circular(6),
        child: Tooltip(
          message: name,
          waitDuration: const Duration(milliseconds: 500),
          child: Container(
            width: 40, // Más pequeño
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isBlack || isLightColor 
                    ? Colors.black 
                    : Colors.black38,
                width: 1.5,
              ),
            ),
            child: _getColorContent(),
          ),
        ),
      ),
    );
  }

  Widget _getColorContent() {
    if (colorKey == 'black') {
      return Center(
        child: Text(
          'N',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12, // Más pequeño
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (colorKey == 'gold') {
      return Center(
        child: Text(
          'ORO',
          style: TextStyle(
            color: Colors.black,
            fontSize: 8, // Más pequeño
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else if (colorKey == 'silver') {
      return Center(
        child: Text(
          'PLATA',
          style: TextStyle(
            color: Colors.black,
            fontSize: 7, // Más pequeño
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else if (color == Colors.white) {
      return Center(
        child: Text(
          'BCO',
          style: TextStyle(
            color: Colors.black,
            fontSize: 8, // Más pequeño
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox();
  }
}