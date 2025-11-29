import 'package:flutter/material.dart';
import 'resistor_data.dart';
import '../widgets/resistor_painter.dart';
import '../widgets/color_pallette.dart';

// Pantalla principal del juego donde el usuario construye la resistencia
class PantallaJuego extends StatefulWidget {
  const PantallaJuego({super.key});

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  late ResistorChallenge challenge;
  List<String> userBands = ['none', 'none', 'none', 'none']; // Bandas seleccionadas por el usuario
  int currentBandIndex = 0; // Banda que se está intentando arrastrar/asignar
  String? feedbackMessage;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _startNewChallenge();
  }

  // Inicia o reinicia el desafío de la resistencia
  void _startNewChallenge() {
    setState(() {
      challenge = ResistorChallenge.generateRandom();
      userBands = ['none', 'none', 'none', 'none'];
      currentBandIndex = 0;
      feedbackMessage = null;
      isCorrect = false;
    });
  }

  // Maneja el color soltado en una banda
  void _handleBandDrop(String colorKey, int bandIndex) {
    if (bandIndex == currentBandIndex) {
      setState(() {
        userBands[bandIndex] = colorKey;
        // Avanza a la siguiente banda automáticamente
        if (currentBandIndex < 3) {
          currentBandIndex++;
        }
        feedbackMessage = null;
      });
    }
  }

  // Verifica la respuesta del usuario
  void _checkAnswer() {
    if (userBands.contains('none')) {
      setState(() {
        feedbackMessage = '¡Faltan bandas por colocar!';
      });
      return;
    }

    // Comprobar si las bandas del usuario coinciden con las correctas
    if (userBands.toString() == challenge.correctBands.toString()) {
      setState(() {
        isCorrect = true;
        feedbackMessage = '¡Correcto!';
      });
      _showResultDialog(
        '¡CORRECTO!',
        'Has construido perfectamente la resistencia de ${challenge.formattedChallenge}.',
        Colors.green,
      );
    } else {
      setState(() {
        isCorrect = false;
        feedbackMessage = 'Incorrecto. Revisa el orden o los valores.';
      });
      _showResultDialog(
        'INCORRECTO',
        'El valor de la resistencia que construiste es incorrecto. Sigue intentando.',
        Colors.red,
      );
    }
  }

  // Muestra un diálogo con el resultado y opción para siguiente nivel
  void _showResultDialog(String title, String content, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('SIGUIENTE NIVEL'),
              onPressed: () {
                Navigator.of(context).pop();
                _startNewChallenge();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determinar la instrucción basada en la banda actual
    String instructionText;
    if (currentBandIndex == 0) {
      instructionText = '1.er Dígito';
    } else if (currentBandIndex == 1) {
      instructionText = '2.º Dígito';
    } else if (currentBandIndex == 2) {
      instructionText = 'Multiplicador';
    } else if (currentBandIndex == 3) {
      instructionText = 'Tolerancia';
    } else {
      instructionText = 'Resistencia Lista';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Armar Resistencia', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E57C2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Objetivo del Nivel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Resistencia Objetivo:',
                      style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                    ),
                    Text(
                      challenge.formattedChallenge,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF4A148C)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Área de la Resistencia Interactiva
              ResistorInteractive(
                bands: userBands,
                onBandDrop: _handleBandDrop,
                activeBandIndex: currentBandIndex,
              ),

              const SizedBox(height: 20),

              // Indicador de la banda actual
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Banda Actual: $instructionText',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple.shade700),
                ),
              ),
              
              // Mensaje de feedback
              if (feedbackMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    feedbackMessage!,
                    style: TextStyle(
                      color: isCorrect ? Colors.green[700] : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Botón REVISAR
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
                child: const Text(
                  'REVISAR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              
              const SizedBox(height: 30),

              // Paleta de Colores
              ColorPalette(
                onColorTap: (colorKey) {
                  // Permite al usuario seleccionar rápidamente el color
                  if (currentBandIndex < 4) {
                    _handleBandDrop(colorKey, currentBandIndex);
                  }
                },
                currentBandIndex: currentBandIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget interactivo para la resistencia (zonas de arrastre)
class ResistorInteractive extends StatelessWidget {
  final List<String> bands;
  final Function(String colorKey, int bandIndex) onBandDrop;
  final int activeBandIndex;

  const ResistorInteractive({
    super.key,
    required this.bands,
    required this.onBandDrop,
    required this.activeBandIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: CustomPaint(
        painter: ResistorPainter(bands: bands),
        child: Row(
          children: List.generate(4, (index) {
            // Zonas de arrastre para cada banda
            return Expanded(
              flex: index == 3 ? 2 : 1, // La banda de tolerancia es más ancha visualmente
              child: DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  // Pequeño indicador visual de la banda activa
                  return Container(
                    decoration: BoxDecoration(
                      border: index == activeBandIndex && bands[index] == 'none'
                          ? Border.all(color: Colors.purple.shade700, width: 3)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
                onWillAcceptWithDetails: (data) => index == activeBandIndex, // Solo acepta en la banda activa
                onAcceptWithDetails: (data) {
                  onBandDrop(data.data, index);
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}