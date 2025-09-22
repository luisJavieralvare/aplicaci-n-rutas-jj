import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _userRole;
  String? _userName;
  int? _userId;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _userRole;
  String? get userName => _userName;
  int? get userId => _userId;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token != null) {
      _isAuthenticated = true;
      _userRole = prefs.getString('userRole');
      _userName = prefs.getString('userName');
      _userId = prefs.getInt('userId');
      notifyListeners();
    }
  }

  Future<bool> login(String correo, String contrasena) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulación de login - aquí conectarías con tu API
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular respuesta exitosa
      _isAuthenticated = true;
      _userRole = 'ADMIN'; // o 'TRABAJADOR'
      _userName = 'Usuario Test';
      _userId = 1;
      
      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'fake_token');
      await prefs.setString('userRole', _userRole!);
      await prefs.setString('userName', _userName!);
      await prefs.setInt('userId', _userId!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String nombre, String correo, String contrasena, String telefono) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulación de registro
      await Future.delayed(const Duration(seconds: 2));
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _isAuthenticated = false;
    _userRole = null;
    _userName = null;
    _userId = null;
    notifyListeners();
  }
}
