import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AdminProvider extends ChangeNotifier {
  List<Usuario> _usuariosPendientes = [];
  List<Factura> _reporteSemanal = [];
  bool _isLoading = false;
  String? _error;

  List<Usuario> get usuariosPendientes => _usuariosPendientes;
  List<Factura> get reporteSemanal => _reporteSemanal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarUsuariosPendientes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuariosPendientes = await ApiService.getUsuariosPendientes();
    } catch (e) {
      _error = 'Error cargando usuarios pendientes: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> aprobarUsuario(int id) async {
    try {
      final success = await ApiService.aprobarUsuario(id);
      if (success) {
        _usuariosPendientes.removeWhere((user) => user.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Error aprobando usuario: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> getReporteSemanal(String inicio, String fin) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reporteSemanal = await ApiService.getReporteSemanal(inicio, fin);
    } catch (e) {
      _error = 'Error obteniendo el reporte semanal: $e';
    }

    _isLoading = false;
    notifyListeners();
  }


  void clearError() {
    _error = null;
    notifyListeners();
  }
}