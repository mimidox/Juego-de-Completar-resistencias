import 'package:flutter/material.dart';
import 'package:resistencia_juego/screens/pantalla_instrucciones.dart';
import 'resistor_data.dart';
import 'pantalla_pista.dart';
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

  // Restablece la resistencia actual (mismo nivel)
  void _resetCurrentChallenge() {
    setState(() {
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

  // Maneja la selección directa de color desde la paleta
  void _handleColorTap(String colorKey) {
    if (currentBandIndex < 4) {
      setState(() {
        userBands[currentBandIndex] = colorKey;
        if (currentBandIndex < 3) {
          currentBandIndex++;
        }
        feedbackMessage = null;
      });
    }
  }

  // Obtiene el valor formateado de las bandas del usuario
  String _getUserResistorValue() {
    try {
      // Convertir las bandas del usuario a valor de resistencia
      final userResistor = ResistorChallenge.calculateResistorValue(userBands);
      return userResistor.formattedValue;
    } catch (e) {
      return 'Valor inválido';
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
        showComparison: false,
      );
    } else {
      setState(() {
        isCorrect = false;
        feedbackMessage = 'Incorrecto. Revisa el orden o los valores.';
      });
      _showResultDialog(
        'INCORRECTO',
        'El valor de la resistencia que construiste no coincide con el objetivo.',
        Colors.red,
        showComparison: true,
      );
    }
  }

  // Muestra un diálogo con el resultado y opción para siguiente nivel
  void _showResultDialog(String title, String content, Color color, {bool showComparison = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content),
              if (showComparison) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tu resultado:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _getUserResistorValue(),
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Objetivo:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            challenge.formattedChallenge,
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tus bandas:',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  _getBandNames(userBands),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bandas correctas:',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  _getBandNames(challenge.correctBands),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Revisa las bandas y vuelve a intentarlo antes de continuar.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            if (showComparison)
              TextButton(
                child: const Text('REINTENTAR'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Permite al usuario corregir las bandas sin reiniciar el nivel
                },
              ),
            TextButton(
              child: Text(showComparison ? 'SIGUIENTE NIVEL' : 'CONTINUAR'),
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

  // Obtiene los nombres de las bandas para mostrar
  String _getBandNames(List<String> bands) {
    return bands.map((band) {
      if (band == 'none') return 'Ninguna';
      return colorBands[band]?.name ?? band;
    }).join(' - ');
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
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PantallaInstrucciones()),
              );
            },
          ),
        ],
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

              // Botones HINT y REVISAR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PantallaPista()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 234, 40),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('HINT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                    
                  ),
                  const SizedBox(width: 20),
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
                ],
              ),

              // Botón RESTABLECER - debajo de los botones HINT y REVISAR
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  
                  onPressed: _resetCurrentChallenge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15,),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'RESTABLECER',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              // Paleta de Colores
              ColorPalette(
                onColorTap: _handleColorTap,
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
      child: Stack(
        children: [
          // Fondo con la resistencia pintada
          CustomPaint(
            painter: ResistorPainter(bands: bands),
            size: Size.infinite,
          ),
          // Zonas de arrastre superpuestas
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                flex: index == 3 ? 2 : 1,
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        border: index == activeBandIndex && bands[index] == 'none'
                            ? Border.all(color: Colors.purple.shade700, width: 3)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                        color: candidateData.isNotEmpty 
                            ? Colors.purple.withOpacity(0.3)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: bands[index] != 'none'
                            ? null
                            : Icon(
                                Icons.add_circle_outline,
                                color: index == activeBandIndex 
                                    ? Colors.purple.shade700 
                                    : Colors.grey,
                                size: 24,
                              ),
                      ),
                    );
                  },
                  onWillAccept: (data) => index == activeBandIndex,
                  onAccept: (data) {
                    onBandDrop(data, index);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}