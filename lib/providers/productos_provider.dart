import 'package:flutter/material.dart';

class ProductosProvider extends ChangeNotifier {
  List<dynamic> _productos = []; // Temporalmente dynamic
  List<dynamic> _categorias = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get productos => _productos;
  List<dynamic> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulación de carga
      await Future.delayed(const Duration(seconds: 1));
      
      // Datos simulados
      _productos = [
        {
          'id': 1,
          'nombre': 'Coca Cola 350ml',
          'precio': 2500.0,
          'stock': 100,
          'categoria': {'id': 1, 'nombre': 'Bebidas'},
          'codigoBarras': '7702001234567'
        },
        {
          'id': 2,
          'nombre': 'Papas Margarita',
          'precio': 3000.0,
          'stock': 50,
          'categoria': {'id': 2, 'nombre': 'Snacks'},
          'codigoBarras': '7702002234567'
        }
      ];
    } catch (e) {
      _error = 'Error cargando productos: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarCategorias() async {
    try {
      _categorias = [
        {'id': 1, 'nombre': 'Bebidas'},
        {'id': 2, 'nombre': 'Snacks'},
        {'id': 3, 'nombre': 'Dulces'}
      ];
      notifyListeners();
    } catch (e) {
      _error = 'Error cargando categorías: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}