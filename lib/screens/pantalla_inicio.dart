import 'package:flutter/material.dart';
import '../widgets/resistor_painter.dart';

// Pantalla de inicio de la aplicación
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Ícono de la resistencia (Representación visual simple)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: 150,
                    height: 60,
                    child: CustomPaint(
                      painter: ResistorPainter(bands: ['red', 'green', 'orange', 'gold']),
                    ),
                  ),
                ),                
                const Text(
                  'Resistor Color Builder',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A148C), // Púrpura oscuro
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                
                // Campo para el nombre (como en la captura)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      filled: true,
                      fillColor: Color(0xFFEDE7F6), // Púrpura muy claro
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Botón COMENZAR
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700], // Verde vibrante
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                  ),
                  child: const Text(
                    'COMENZAR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Botón INSTRUCCIONES
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/instructions');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E57C2), // Púrpura medio
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 3,
                  ),
                  child: const Text(
                    'INSTRUCCIONES',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}