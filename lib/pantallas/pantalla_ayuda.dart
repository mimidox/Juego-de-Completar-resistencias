import 'package:flutter/material.dart';

class PantallaAyuda extends StatelessWidget {
  // Mapa de colores para mostrar visualmente
  final Map<String, Color> coloresMap = {
    'Negro': Colors.black,
    'Marrón': Colors.brown,
    'Rojo': Colors.red,
    'Naranja': Colors.orange,
    'Amarillo': Colors.yellow,
    'Verde': Colors.green,
    'Azul': Colors.blue,
    'Violeta': Colors.purple,
    'Gris': Colors.grey,
    'Blanco': Colors.white,
    'Oro': Color(0xFFFFD700),
    'Plata': Color(0xFFC0C0C0),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            
            // Título HINT centrado
            Center(
              child: Text(
                'HINT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Información de bandas
            _buildInfoBanda('1.ª banda:', '1.er dígito'),
            _buildInfoBanda('2.ª banda:', '2.º dígito'),
            _buildInfoBanda('3.ª banda:', 'Multiplicador'),
            _buildInfoBanda('4.ª banda:', '% de tolerancia'),
            
            SizedBox(height: 20),
            
            // Línea divisoria
            Divider(color: Colors.grey, height: 1),
            
            SizedBox(height: 20),
            
            // Tolerancias con colores visuales
            _buildToleranciaConColor('20%', 'No band', Colors.grey[300]!),
            _buildToleranciaConColor('10%', 'Plata', coloresMap['Plata']!),
            _buildToleranciaConColor('5%', 'Oro', coloresMap['Oro']!),
            
            SizedBox(height: 20),
            
            // Ejemplos de colores para dígitos
            Text(
              'Colores para dígitos:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            
            // Fila de colores de ejemplo
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCirculoColor('Negro', coloresMap['Negro']!),
                  _buildCirculoColor('Marrón', coloresMap['Marrón']!),
                  _buildCirculoColor('Rojo', coloresMap['Rojo']!),
                  _buildCirculoColor('Naranja', coloresMap['Naranja']!),
                  _buildCirculoColor('Amarillo', coloresMap['Amarillo']!),
                  _buildCirculoColor('Verde', coloresMap['Verde']!),
                ],
              ),
            ),
            
            Spacer(),
            
            // Botón VOLVER centrado
            Center(
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'VOLVER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanda(String numero, String descripcion) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(
              numero,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            descripcion,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildToleranciaConColor(String porcentaje, String colorNombre, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(
              porcentaje,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(width: 20),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
          SizedBox(width: 10),
          Text(
            colorNombre,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCirculoColor(String nombre, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
          SizedBox(height: 5),
          Text(
            nombre,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}