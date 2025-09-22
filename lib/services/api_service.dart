import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Para emulador Android
  // Para dispositivo físico usar: 'http://192.168.1.XXX:8080/api'
  
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Auth endpoints
  static Future<LoginResponse?> login(String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'correo': correo,
          'contrasena': contrasena,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(data);
        
        // Guardar token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.token);
        await prefs.setInt('userId', loginResponse.id);
        await prefs.setString('userRole', loginResponse.rol);
        await prefs.setString('userName', loginResponse.nombre);
        
        return loginResponse;
      }
    } catch (e) {
      print('Error obteniendo usuarios pendientes: $e');
    }
    return null;
  }

  static Future<bool> aprobarUsuario(int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/usuarios/$id/aprobar'),
        headers: await _getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error aprobando usuario: $e');
      return false;
    }
  }

  // Reportes endpoints
  static Future<List<Factura>> getReporteSemanal(String inicio, String fin) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/facturas/reportes/semana?inicio=$inicio&fin=$fin'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Factura.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error obteniendo reporte semanal: $e');
    }
    return [];
  }
}