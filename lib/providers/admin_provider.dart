import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<dynamic> _usuariosPendientes = [];
  List<dynamic> _reporteSemanal = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get usuariosPendientes => _usuariosPendientes;
  List<dynamic> get reporteSemanal => _reporteSemanal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarUsuariosPendientes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulación de carga
      await Future.delayed(const Duration(seconds: 1));
      
      _usuariosPendientes = [
        {
          'id': 2,
          'nombre': 'Juan Pérez',
          'correo': 'juan@example.com',
          'estado': 'PENDIENTE',
          'rol': 'TRABAJADOR'
        }
      ];
    } catch (e) {
      _error = 'Error cargando usuarios pendientes: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> aprobarUsuario(int id) async {
    try {
      // Simulación de aprobación
      await Future.delayed(const Duration(seconds: 1));
      
      // Remover de la lista
      _usuariosPendientes.removeWhere((user) => user['id'] == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error aprobando usuario: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}