import 'package:flutter/material.dart';
import '../screens/resistor_data.dart';

// Widget para dibujar la forma de la resistencia (Cuerpo y bandas)
class ResistorPainter extends CustomPainter {
  final List<String> bands;

  ResistorPainter({required this.bands});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    const double bodyHeight = 30.0;
    const double bodyRadius = bodyHeight / 2;

    // Colores base y de las bandas
    final Paint bodyPaint = Paint()..color = const Color(0xFFF5E5C6); // Color Beige/Tostado
    final Paint leadPaint = Paint()..color = Colors.grey.shade500;
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final double centerY = height / 2;

    // 1. Dibujar Alambres (Leads)
    const double leadWidth = 2.0;
    canvas.drawLine(Offset(0, centerY), Offset(width / 2 - bodyRadius, centerY), leadPaint..strokeWidth = leadWidth);
    canvas.drawLine(Offset(width / 2 + bodyRadius, centerY), Offset(width, centerY), leadPaint..strokeWidth = leadWidth);

    // 2. Dibujar Cuerpo de la Resistencia
    final bodyRect = Rect.fromCenter(center: Offset(width / 2, centerY), width: 2 * bodyRadius, height: bodyHeight);
    final bodyPath = Path()
      ..addRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(bodyRadius)));
    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, borderPaint);


    // 3. Dibujar las 4 bandas de color
    const double bandWidth = 8.0;
    final double startX = width / 2 - bodyRadius;
    
    // Posiciones relativas de las bandas desde la izquierda del cuerpo
    const List<double> bandOffsets = [
      0.08, // Banda 1 (Dígito 1)
      0.28, // Banda 2 (Dígito 2)
      0.48, // Banda 3 (Multiplicador)
      0.75, // Banda 4 (Tolerancia - separada)
    ];

    for (int i = 0; i < bands.length; i++) {
      final String colorKey = bands[i];
      // Si el color es 'none', no lo dibujamos
      if (colorKey == 'none') continue;

      final Color color = colorBands[colorKey]!.color;
      final double offset = bandOffsets[i] * (2 * bodyRadius);
      final bandX = startX + offset;

      final bandRect = Rect.fromLTWH(
        bandX,
        centerY - bodyHeight / 2,
        bandWidth,
        bodyHeight,
      );

      final bandPaint = Paint()..color = color;
      canvas.drawRect(bandRect, bandPaint);

      // Dibujar borde para la banda
      canvas.drawRect(bandRect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ResistorPainter oldDelegate) {
    return bands.toString() != oldDelegate.bands.toString();
  }
}