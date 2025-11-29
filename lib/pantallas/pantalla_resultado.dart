import 'package:flutter/material.dart';
import 'pantalla_inicio.dart';
import 'pantalla_nivel.dart';

class PantallaResultado extends StatelessWidget {
  final bool esCorrecto;
  final Map<String, dynamic> nivel;
  final String nombreJugador;
  final double resistenciaCalculada;
  final double toleranciaCalculada;
  final List<Map<String, dynamic>> niveles;
  final int nivelActual;

  const PantallaResultado({
    required this.esCorrecto,
    required this.nivel,
    required this.nombreJugador,
    required this.resistenciaCalculada,
    required this.toleranciaCalculada,
    required this.niveles,
    required this.nivelActual,
  });

  String _formatearResistencia(double resistencia) {
    if (resistencia >= 1000000) {
      return '${(resistencia / 1000000).toStringAsFixed(1)}MΩ';
    } else if (resistencia >= 1000) {
      return '${(resistencia / 1000).toStringAsFixed(1)}kΩ';
    } else {
      return '${resistencia.toStringAsFixed(0)}Ω';
    }
  }

  void _siguienteNivel(BuildContext context) {
    int siguienteNivelIndex = nivelActual;
    if (siguienteNivelIndex < niveles.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaNivel(
            nivel: niveles[siguienteNivelIndex],
            nombreJugador: nombreJugador,
            coloresMap: {
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
            },
            niveles: niveles,
          ),
        ),
      );
    } else {
      // Todos los niveles completados
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PantallaInicio()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: esCorrecto 
              ? [Colors.green[50]!, Colors.white]
              : [Colors.red[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono animado
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (esCorrecto ? Colors.green : Colors.red).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Icon(
                    esCorrecto ? Icons.check_circle : Icons.error,
                    size: 80,
                    color: esCorrecto ? Colors.green : Colors.red,
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Título
                Text(
                  esCorrecto ? '¡CORRECTO!' : '¡INCORRECTO!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: esCorrecto ? Colors.green : Colors.red,
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Mensaje
                Container(
                  padding: EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      Text(
                        esCorrecto 
                          ? 'Has construido perfectamente\nla resistencia de ${nivel['valorObjetivo']}'
                          : 'La resistencia no es correcta',
                        style: TextStyle(fontSize: 18, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      
                      if (!esCorrecto) ...[
                        SizedBox(height: 15),
                        Divider(),
                        SizedBox(height: 10),
                        Text(
                          'Tu construcción:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_formatearResistencia(resistenciaCalculada)} ±${toleranciaCalculada}%',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Objetivo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nivel['valorObjetivo']}',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(height: 40),
                
                // Botones
                if (esCorrecto && nivelActual < niveles.length) ...[
                  Container(
                    width: double.infinity,
                    height: 60,
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
                      onPressed: () => _siguienteNivel(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_forward, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'SIGUIENTE NIVEL',
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
                  SizedBox(height: 15),
                ],
                
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      if (esCorrecto && nivelActual < niveles.length) {
                        _siguienteNivel(context);
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => PantallaInicio()),
                          (route) => false,
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide.none,
                    ),
                    child: Text(
                      esCorrecto && nivelActual < niveles.length ? 'CONTINUAR' : 'VOLVER AL INICIO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                
                if (!esCorrecto) ...[
                  SizedBox(height: 15),
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'REINTENTAR',
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}