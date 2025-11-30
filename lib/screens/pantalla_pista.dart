import 'package:flutter/material.dart';

// Pantalla de ayuda que muestra la leyenda de las bandas y la tabla de colores.
// Estructura de la tabla de valores (similar a la captura)
const List<List<String>> colorValues = [
  ['0', 'Negro'],
  ['1', 'Marrón'],
  ['2', 'Rojo'],
  ['3', 'Naranja'],
  ['4', 'Amarillo'],
  ['5', 'Verde'],
  ['6', 'Azul'],
  ['7', 'Violeta'],
  ['8', 'Gris'],
  ['9', 'Blanco'],
];

class PantallaPista extends StatelessWidget {
  const PantallaPista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PISTA', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E57C2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Leyenda de las Bandas
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('1.ª banda: 1.er dígito', style: TextStyle(fontSize: 16)),
                  Text('2.ª banda: 2.º dígito', style: TextStyle(fontSize: 16)),
                  Text('3.ª banda: Multiplicador', style: TextStyle(fontSize: 16)),
                  Text('4.ª banda: % de tolerancia', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Tabla de Colores
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'CÓDIGO DE COLORES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Dígitos (0-9) - Usando GridView en lugar de Wrap
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3.0, // Ajusta este valor según necesites
                    ),
                    itemCount: colorValues.length,
                    itemBuilder: (context, index) {
                      final value = colorValues[index];
                      return _buildColorEntry(
                        digit: value[0],
                        colorName: value[1],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Tolerancias especiales
                  _buildSpecialTolerances(),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Botón VOLVER
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E57C2),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('VOLVER', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorEntry({
    required String digit,
    required String colorName,
  }) {
    Color color;
    switch (colorName) {
      case 'Negro': color = Colors.black; break;
      case 'Marrón': color = const Color(0xFF8B4513); break;
      case 'Rojo': color = Colors.red; break;
      case 'Naranja': color = Colors.orange; break;
      case 'Amarillo': color = Colors.yellow; break;
      case 'Verde': color = Colors.green; break;
      case 'Azul': color = Colors.blue; break;
      case 'Violeta': color = Colors.purple; break;
      case 'Gris': color = Colors.grey; break;
      case 'Blanco': color = Colors.white; break;
      default: color = Colors.transparent;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: colorName == 'Negro' || colorName == 'Blanco' 
                  ? Border.all(color: Colors.white30) 
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  digit,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  colorName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSpecialTolerances() {
    return Column(
      children: [
        _buildToleranceEntry('Sin Banda', '±20%', Colors.transparent),
        _buildToleranceEntry('Plata', '±10%', const Color(0xFFC0C0C0)),
        _buildToleranceEntry('Oro', '±5%', const Color(0xFFFFD700)),
      ],
    );
  }

  Widget _buildToleranceEntry(String colorName, String tolerance, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: color == Colors.transparent 
                  ? Border.all(color: Colors.white70) 
                  : Border.all(color: Colors.black12),
            ),
            child: color == Colors.transparent 
                ? const Center(
                    child: Text(
                      'N/A',
                      style: TextStyle(fontSize: 8, color: Colors.white70),
                    ),
                  ) 
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              colorName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Text(
            tolerance,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}