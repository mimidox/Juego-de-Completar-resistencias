import 'package:flutter/material.dart';
import 'pantalla_ayuda.dart';
import 'pantalla_resultado.dart';

class PantallaNivel extends StatefulWidget {
  final Map<String, dynamic> nivel;
  final String nombreJugador;
  final Map<String, Color> coloresMap;
  final List<Map<String, dynamic>> niveles;

  const PantallaNivel({
    required this.nivel,
    required this.nombreJugador,
    required this.coloresMap,
    required this.niveles,
  });

  @override
  _PantallaNivelState createState() => _PantallaNivelState();
}

class _PantallaNivelState extends State<PantallaNivel> {
  List<Color?> _bandas = [null, null, null, null];
  List<String> _nombresColores = ['Negro', 'Marrón', 'Rojo', 'Naranja', 'Amarillo', 'Verde', 'Azul', 'Violeta', 'Gris', 'Blanco', 'Oro', 'Plata'];
  
  // Mapa de multiplicadores
  final Map<String, double> _multiplicadores = {
    'Negro': 1,
    'Marrón': 10,
    'Rojo': 100,
    'Naranja': 1000,
    'Amarillo': 10000,
    'Verde': 100000,
    'Azul': 1000000,
    'Violeta': 10000000,
    'Gris': 100000000,
    'Blanco': 1000000000,
    'Oro': 0.1,
    'Plata': 0.01,
  };

  // Mapa de tolerancias
  final Map<String, double> _tolerancias = {
    'Marrón': 1.0,
    'Rojo': 2.0,
    'Verde': 0.5,
    'Azul': 0.25,
    'Violeta': 0.1,
    'Gris': 0.05,
    'Oro': 5.0,
    'Plata': 10.0,
  };

  // Mapa de valores de dígitos
  final Map<String, int> _valoresDigitos = {
    'Negro': 0,
    'Marrón': 1,
    'Rojo': 2,
    'Naranja': 3,
    'Amarillo': 4,
    'Verde': 5,
    'Azul': 6,
    'Violeta': 7,
    'Gris': 8,
    'Blanco': 9,
  };

  List<String> _nombresBandas = ['', '', '', ''];

  String _obtenerNombreColor(Color color) {
    return widget.coloresMap.entries.firstWhere((entry) => entry.value == color).key;
  }

  double _calcularResistencia() {
    if (_bandas[0] == null || _bandas[1] == null || _bandas[2] == null) return 0;

    String nombreColor1 = _obtenerNombreColor(_bandas[0]!);
    String nombreColor2 = _obtenerNombreColor(_bandas[1]!);
    String nombreColor3 = _obtenerNombreColor(_bandas[2]!);

    int digito1 = _valoresDigitos[nombreColor1] ?? 0;
    int digito2 = _valoresDigitos[nombreColor2] ?? 0;
    double multiplicador = _multiplicadores[nombreColor3] ?? 1;

    return (digito1 * 10 + digito2) * multiplicador;
  }

  double _obtenerTolerancia() {
    if (_bandas[3] == null) return 20.0; // Sin banda = 20%
    String nombreColor4 = _obtenerNombreColor(_bandas[3]!);
    return _tolerancias[nombreColor4] ?? 20.0;
  }

  bool _verificarRespuesta() {
    double resistenciaCalculada = _calcularResistencia();
    double toleranciaCalculada = _obtenerTolerancia();

    int resistenciaObjetivo = widget.nivel['resistenciaReal'];
    double toleranciaObjetivo = widget.nivel['toleranciaReal'];

    // Verificar si la resistencia y tolerancia coinciden
    bool resistenciaCorrecta = resistenciaCalculada == resistenciaObjetivo.toDouble();
    bool toleranciaCorrecta = toleranciaCalculada == toleranciaObjetivo;

    return resistenciaCorrecta && toleranciaCorrecta;
  }

  void _verificarYAvanzar() {
    if (_bandas.any((color) => color == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completa todas las bandas primero')),
      );
      return;
    }

    bool esCorrecto = _verificarRespuesta();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaResultado(
          esCorrecto: esCorrecto,
          nivel: widget.nivel,
          nombreJugador: widget.nombreJugador,
          resistenciaCalculada: _calcularResistencia(),
          toleranciaCalculada: _obtenerTolerancia(),
          niveles: widget.niveles,
          nivelActual: widget.nivel['numero'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.nivel['titulo']),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PantallaAyuda()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador de progreso
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      widget.nombreJugador,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 5),
                    Text('Nivel ${widget.nivel['numero']}'),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              Text(
                'Selecciona el color correcto y arrástralo a la primera banda para comenzar a crear el valor de la resistencia:',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              
              SizedBox(height: 25),
              
              // Valor objetivo destacado
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: Text(
                    widget.nivel['valorObjetivo'],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // Resistencia con bandas
              _buildResistencia(),
              
              SizedBox(height: 30),
              
              // Paleta de colores
              Text(
                'Paleta de colores:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              _buildPaletaColores(),
              
              Spacer(),
              
              // Botones
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PantallaAyuda()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(color: Colors.blue, width: 2),
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'HINT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _verificarYAvanzar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'REVISAR',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResistencia() {
    return Center(
      child: Container(
        width: 250,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return DragTarget<Color>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 25,
                  height: 70,
                  decoration: BoxDecoration(
                    color: _bandas[index] ?? Colors.grey[300],
                    border: Border.all(
                      color: candidateData.isNotEmpty ? Colors.blue : Colors.grey[400]!,
                      width: candidateData.isNotEmpty ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: candidateData.isNotEmpty 
                      ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 10)]
                      : [],
                  ),
                );
              },
              onAccept: (color) {
                setState(() {
                  _bandas[index] = color;
                  _nombresBandas[index] = _obtenerNombreColor(color);
                });
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPaletaColores() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _nombresColores.map((nombreColor) {
          Color color = widget.coloresMap[nombreColor]!;
          return Draggable<Color>(
            data: color,
            feedback: Material(
              elevation: 5,
              shape: CircleBorder(),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
            childWhenDragging: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
            ),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}