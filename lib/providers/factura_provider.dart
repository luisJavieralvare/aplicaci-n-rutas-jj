import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class FacturaProvider extends ChangeNotifier {
  List<Factura> _facturas = [];
  bool _isLoading = false;
  String? _error;

  List<Factura> get facturas => _facturas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarFacturas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _facturas = await ApiService.getMisFacturas();
    } catch (e) {
      _error = 'Error al cargar las facturas: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}