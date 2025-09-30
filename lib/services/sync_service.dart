import 'package:rutas_jj_app/models/models.dart';
import 'database_service.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

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
}