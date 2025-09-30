import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ProductosProvider extends ChangeNotifier {
  List<Producto> _productos = [];
  List<Categoria> _categorias = [];
  bool _isLoading = false;
  String? _error;

  List<Producto> get productos => _productos;
  List<Categoria> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _productos = await ApiService.getProductos();
    } catch (e) {
      _error = 'Error cargando productos: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarCategorias() async {
    try {
      _categorias = await ApiService.getCategorias();
      notifyListeners();
    } catch (e) {
      _error = 'Error cargando categorías: $e';
      notifyListeners();
    }
  }
  
  Future<Producto?> buscarPorCodigoBarras(String codigo) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final producto = await ApiService.getProductoPorCodigoBarras(codigo);
      _isLoading = false;
      notifyListeners();
      return producto;
    } catch (e) {
      _error = 'Error buscando producto por código de barras: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}