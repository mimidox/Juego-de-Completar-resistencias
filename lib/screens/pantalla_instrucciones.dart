import 'package:flutter/material.dart';

// Pantalla con las tablas de referencia y reglas de juego
class PantallaInstrucciones extends StatelessWidget {
  const PantallaInstrucciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INSTRUCCIONES', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E57C2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInstructionText(
                '1. El objetivo es colocar los colores correctos en la resistencia para igualar el Valor Objetivo (Ohmios y Tolerancia).'),
            _buildInstructionText(
                '2. La Resistencia es de 4 bandas: Dígito 1, Dígito 2, Multiplicador y Tolerancia.'),
            _buildInstructionText(
                '3. Debes colocar las bandas en orden (de izquierda a derecha) arrastrando el color de la paleta.'),
            _buildInstructionText(
                '4. Una vez colocadas las 4 bandas, presiona "REVISAR".'),
            const SizedBox(height: 30),
            
            const Text(
              'Tablas de Referencia (4 Bandas):',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 15),
            
            _buildTable('1. Dígitos (Banda 1 y 2)', [
              ['Color', 'Dígito'],
              ['Negro', '0'],
              ['Marrón', '1'],
              ['Rojo', '2'],
              ['Naranja', '3'],
              ['Amarillo', '4'],
              ['Verde', '5'],
              ['Azul', '6'],
              ['Violeta', '7'],
              ['Gris', '8'],
              ['Blanco', '9'],
            ]),
            const SizedBox(height: 20),
            
            _buildTable('2. Multiplicadores (Banda 3)', [
              ['Color', 'Multiplicador'],
              ['Negro', 'x1'],
              ['Marrón', 'x10'],
              ['Rojo', 'x100'],
              ['Naranja', 'x1k'],
              ['Amarillo', 'x10k'],
              ['Verde', 'x100k'],
              ['Azul', 'x1M'],
              ['Violeta', 'x10M'],
              ['Gris', 'x100M'],
              ['Blanco', 'x1G'],
              ['Oro', 'x0.1'],
              ['Plata', 'x0.01'],
            ]),
            const SizedBox(height: 20),
            
            _buildTable('3. Tolerancia (Banda 4)', [
              ['Color', 'Tolerancia'],
              ['Marrón', '±1%'],
              ['Rojo', '±2%'],
              ['Verde', '±0.5%'],
              ['Azul', '±0.25%'],
              ['Violeta', '±0.1%'],
              ['Gris', '±0.05%'],
              ['Oro', '±5%'],
              ['Plata', '±10%'],
            ]),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('VOLVER', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildTable(String title, List<List<String>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
            },
            border: TableBorder.all(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            children: data.map((row) {
              final isHeader = data.indexOf(row) == 0;
              return TableRow(
                decoration: isHeader ? BoxDecoration(color: Colors.deepPurple.shade100) : null,
                children: row.map((cell) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        cell,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                          color: isHeader ? Colors.deepPurple.shade900 : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}