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

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
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

    // Draggable permite arrastrar el widget
    return Draggable<String>(
      data: colorKey,
      feedback: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isBlack ? Border.all(color: Colors.white, width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
            )
          ],
        ),
      ),
      childWhenDragging: Container(), // No mostrar nada en la paleta mientras se arrastra
      // InkWell permite hacer tap rápido para seleccionar el color
      child: InkWell(
        onTap: () => onTap(colorKey),
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: name,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isBlack ? Colors.white54 : Colors.black12,
                  width: 1),
            ),
          ),
        ),
      ),
    );
  }
}