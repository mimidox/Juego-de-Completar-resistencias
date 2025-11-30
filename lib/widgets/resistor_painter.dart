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
    
    // Aumentar el tamaño del cuerpo de la resistencia
    final double bodyHeight = 50.0;
    final double bodyWidth = width * 0.7; // Usar 70% del ancho disponible
    final double bodyRadius = bodyHeight / 2;

    // Colores base y de las bandas
    final Paint bodyPaint = Paint()..color = const Color(0xFFF5E5C6); // Color Beige/Tostado
    final Paint leadPaint = Paint() 
      ..color = Colors.grey.shade600
      ..strokeWidth = 3.0;
    
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double centerY = height / 2;
    final double bodyStartX = (width - bodyWidth) / 2;

    // 1. Dibujar Alambres (Leads) - más gruesos
    final double leadLength = bodyStartX;
    canvas.drawLine(
      Offset(0, centerY), 
      Offset(leadLength, centerY), 
      leadPaint
    );
    canvas.drawLine(
      Offset(width - leadLength, centerY), 
      Offset(width, centerY), 
      leadPaint
    );

    // 2. Dibujar Cuerpo de la Resistencia - más grande
    final bodyRect = Rect.fromLTWH(
      bodyStartX, 
      centerY - bodyHeight / 2, 
      bodyWidth, 
      bodyHeight
    );
    
    final bodyPath = Path()
      ..addRRect(RRect.fromRectAndRadius(bodyRect, Radius.circular(bodyRadius)));
    
    // Sombra suave para dar profundidad
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawPath(bodyPath, shadowPaint);
    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, borderPaint);

    // 3. Dibujar las 4 bandas de color - más anchas y mejor espaciadas
    final double bandWidth = 12.0;
    final double bandSpacing = bodyWidth * 0.15;
    
    // Posiciones relativas de las bandas (mejor distribuidas)
    final List<double> bandOffsets = [
      bodyWidth * 0.15, // Banda 1 (Dígito 1)
      bodyWidth * 0.35, // Banda 2 (Dígito 2)
      bodyWidth * 0.55, // Banda 3 (Multiplicador)
      bodyWidth * 0.80, // Banda 4 (Tolerancia - más separada)
    ];

    for (int i = 0; i < bands.length; i++) {
      final String colorKey = bands[i];
      // Si el color es 'none', no lo dibujamos
      if (colorKey == 'none') continue;

      final Color color = colorBands[colorKey]!.color;
      final double bandX = bodyStartX + bandOffsets[i] - bandWidth / 2;

      // Dibujar banda principal
      final bandRect = Rect.fromLTWH(
        bandX,
        centerY - bodyHeight / 2,
        bandWidth,
        bodyHeight,
      );

      final bandPaint = Paint()..color = color;
      canvas.drawRect(bandRect, bandPaint);

      // Borde más definido para la banda
      final bandBorderPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      
      canvas.drawRect(bandRect, bandBorderPaint);

      // Efecto de brillo/sombra para dar profundidad a las bandas
      if (color != Colors.black && color != const Color(0xFF8B4513)) {
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 1.0;
        
        canvas.drawLine(
          Offset(bandX, centerY - bodyHeight / 2 + 1),
          Offset(bandX + bandWidth, centerY - bodyHeight / 2 + 1),
          highlightPaint,
        );
      }
    }

    // 4. Agregar detalles decorativos (líneas en los extremos del cuerpo)
    final detailPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Línea decorativa izquierda
    canvas.drawLine(
      Offset(bodyStartX + 5, centerY - bodyHeight / 3),
      Offset(bodyStartX + 5, centerY + bodyHeight / 3),
      detailPaint,
    );

    // Línea decorativa derecha
    canvas.drawLine(
      Offset(bodyStartX + bodyWidth - 5, centerY - bodyHeight / 3),
      Offset(bodyStartX + bodyWidth - 5, centerY + bodyHeight / 3),
      detailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ResistorPainter oldDelegate) {
    return bands.toString() != oldDelegate.bands.toString();
  }
}