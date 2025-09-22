import 'package:flutter/material.dart';

class MercanciaProvider extends ChangeNotifier {
  List<dynamic> _mercanciaLlevada = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get mercanciaLlevada => _mercanciaLlevada;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> registrarMercancia(dynamic request, dynamic producto) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulación de registro
      await Future.delayed(const Duration(seconds: 1));
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error registrando mercancía: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> cargarMercanciaLlevadaHoy() async {
    try {
      // Datos simulados
      _mercanciaLlevada = [
        {
          'id': 1,
          'producto': {
            'id': 1,
            'nombre': 'Coca Cola 350ml',
            'precio': 2500.0,
          },
          'cantidad': 10,
          'fecha': DateTime.now().toIso8601String(),
          'tipoRegistro': 'LLEVADA'
        }
      ];
      notifyListeners();
    } catch (e) {
      _error = 'Error cargando mercancía: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
