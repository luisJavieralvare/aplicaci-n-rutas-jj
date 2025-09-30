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
      print('Error en login: $e');
    }
    return null;
  }

  static Future<bool> register(String nombre, String correo, String contrasena, String telefono) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'nombre': nombre,
          'correo': correo,
          'contrasena': contrasena,
          'telefono': telefono,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Productos endpoints
  static Future<List<Producto>> getProductos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Producto.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error obteniendo productos: $e');
    }
    return [];
  }

  static Future<Producto?> getProductoPorCodigoBarras(String codigo) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/codigo-barras/$codigo'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Producto.fromJson(data);
      }
    } catch (e) {
      print('Error obteniendo producto por código: $e');
    }
    return null;
  }

  static Future<List<Categoria>> getCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/categorias'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Categoria.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error obteniendo categorías: $e');
    }
    return [];
  }

  // Mercancía endpoints
  static Future<bool> registrarMercancia(MercanciaRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mercancia'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error registrando mercancía: $e');
      return false;
    }
  }

  static Future<List<Mercancia>> getMercanciaLlevadaHoy() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mercancia/llevada-hoy'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Mercancia.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error obteniendo mercancía llevada: $e');
    }
    return [];
  }

  // Facturas endpoints
  static Future<Factura?> generarFacturaDiaria(String fecha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/facturas/generar?fecha=$fecha'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Factura.fromJson(data);
      }
    } catch (e) {
      print('Error generando factura: $e');
    }
    return null;
  }

  static Future<List<Factura>> getMisFacturas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/facturas/mis-facturas'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Factura.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error obteniendo facturas: $e');
    }
    return [];
  }

  // Admin endpoints
  static Future<List<Usuario>> getUsuariosPendientes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/usuarios/pendientes'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Usuario.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error obteniendo usuarios pendientes: $e');
    }
    return [];
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