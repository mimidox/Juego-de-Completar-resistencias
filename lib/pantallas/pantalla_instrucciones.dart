import 'package:flutter/material.dart';

class PantallaInstrucciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INSTRUCCIONES',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 20),
            
            _buildInstruccion('1. Se mostrará una resistencia con 4 bandas de colores.'),
            _buildInstruccion('2. Debes seleccionar el valor correcto entre las opciones.'),
            _buildInstruccion('3. Arrastrar colores de la paleta a las bandas.'),
            _buildInstruccion('4. Debes seleccionar el valor correcto entre las opciones.'),
            
            SizedBox(height: 30),
            
            Text(
              'Tablas de referencia rápida:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 20),
            
            // Tabla de multiplicadores
            _buildTablaMultiplicadores(),
            
            Spacer(),
            
            // Botón VOLVER
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('VOLVER'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruccion(String texto) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(texto),
    );
  }

  Widget _buildTablaMultiplicadores() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Multiplicadores para (1 y kΩ)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildFilaTabla('× 1', 'Negro', '10⁰'),
          _buildFilaTabla('× 10', 'Marrón', '10¹'),
          _buildFilaTabla('× 100', 'Rojo', '10²'),
          _buildFilaTabla('× 1,000 (1k)', 'Naranja', '10³'),
        ],
      ),
    );
  }

  Widget _buildFilaTabla(String valor, String color, String exponente) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(valor)),
          Expanded(child: Text(color)),
          Expanded(child: Text(exponente)),
        ],
      ),
    );
  }
}