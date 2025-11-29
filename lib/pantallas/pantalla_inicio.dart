import 'package:flutter/material.dart';
import 'pantalla_nivel.dart';
import 'pantalla_instrucciones.dart';

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final TextEditingController _nombreController = TextEditingController();
  String _nombreJugador = '';
  bool _nombreRegistrado = false;

  final List<Map<String, dynamic>> _niveles = [
    {
      'numero': 1,
      'titulo': 'Nivel 1',
      'valorObjetivo': '1kΩ ±5%',
      'resistenciaReal': 1000,
      'toleranciaReal': 5.0,
      'coloresCorrectos': ['Marrón', 'Negro', 'Rojo', 'Oro'],
      'puntosRequeridos': 0,
    },
    {
      'numero': 2,
      'titulo': 'Nivel 2',
      'valorObjetivo': '4.7kΩ ±10%',
      'resistenciaReal': 4700,
      'toleranciaReal': 10.0,
      'coloresCorrectos': ['Amarillo', 'Violeta', 'Rojo', 'Plata'],
      'puntosRequeridos': 30,
    },
    {
      'numero': 3,
      'titulo': 'Nivel 3',
      'valorObjetivo': '47kΩ ±1%',
      'resistenciaReal': 47000,
      'toleranciaReal': 1.0,
      'coloresCorrectos': ['Amarillo', 'Violeta', 'Naranja', 'Marrón'],
      'puntosRequeridos': 60,
    },
  ];

  final Map<String, Color> _coloresMap = {
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

  void _registrarNombre() {
    if (_nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Ingresa tu nombre para comenzar!')),
      );
      return;
    }

    setState(() {
      _nombreRegistrado = true;
      _nombreJugador = _nombreController.text.trim();
    });
  }

  void _editarNombre() {
    setState(() {
      _nombreRegistrado = false;
      _nombreController.text = _nombreJugador;
    });
  }

  void _iniciarJuego() {
    if (!_nombreRegistrado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Primero registra tu nombre!')),
      );
      return;
    }

    // Iniciar siempre desde el nivel 1
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaNivel(
          nivel: _niveles[0],
          nombreJugador: _nombreJugador,
          coloresMap: _coloresMap,
          niveles: _niveles,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título con icono
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.electrical_services, size: 40, color: Colors.blue[800]),
                  SizedBox(width: 10),
                  Text(
                    'Resistor Color\nBuilder',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Registro de nombre
              if (!_nombreRegistrado) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                
                SizedBox(height: 25),
                
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _registrarNombre,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'COMENZAR JUEGO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Nombre registrado
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[50]!, Colors.lightBlue[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 30),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Bienvenido!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                            Text(
                              _nombreJugador,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: _editarNombre,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 40),
                
                // Botón para iniciar juego
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _iniciarJuego,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'INICIAR NIVEL 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '1kΩ ±5%',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              SizedBox(height: 30),
              
              // Botón INSTRUCCIONES
              Container(
                width: double.infinity,
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
                      MaterialPageRoute(builder: (context) => PantallaInstrucciones()),
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
                      Icon(Icons.help_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'INSTRUCCIONES',
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
            ],
          ),
        ),
      ),
    );
  }
}