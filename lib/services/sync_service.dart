import 'dart:convert';
import 'package:rutas_jj_app/services/sync_service.dart';

import '../models/models.dart';
import 'database_service.dart';
import 'api_service.dart';
import 'connectivity_service.dart';
import 'sync_service.dart';

class SyncService {
  static Future<void> sincronizarDatos() async {
    if (!await ConnectivityService.hasConnection()) return;

    try {
      // Obtener datos no sincronizados
      final mercanciaNoSync = await DatabaseService.getMercanciaNoSincronizada();

      for (Map<String, dynamic> item in mercanciaNoSync) {
        final request = MercanciaRequest(
          productoId: item['producto_id'],
          cantidad: item['cantidad'],
          tipoRegistro: item['tipo_registro'],
        );

        // Intentar sincronizar con el servidor
        final success = await ApiService.registrarMercancia(request);
        if (success) {
          await DatabaseService.marcarComoSincronizado(item['id']);
        }
      }
    } catch (e) {
      print('Error en sincronización: $e');
    }
  }

  static Future<void> iniciarSincronizacionAutomatica() async {
    // Sincronizar cuando haya conexión
    ConnectivityService.connectionStream.listen((hasConnection) {
      if (hasConnection) {
        sincronizarDatos();
      }
    });
  }
}print('Error en login: $e');
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
      