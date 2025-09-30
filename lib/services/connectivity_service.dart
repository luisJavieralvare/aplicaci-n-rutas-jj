import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  static Stream<bool> get connectionStream => _connectionController.stream;

  static Future<void> init() async {
    // Verificar conexión inicial
    final result = await _connectivity.checkConnectivity();
    _connectionController.add(!result.contains(ConnectivityResult.none));

    // Escuchar cambios de conectividad
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _connectionController.add(!result.contains(ConnectivityResult.none));
    });
  }

  static Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  static void dispose() {
    _connectionController.close();
  }
}