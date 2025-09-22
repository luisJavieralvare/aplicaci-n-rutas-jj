import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  static Stream<bool> get connectionStream => _connectionController.stream;

  static Future<void> init() async {
    // Verificar conexión inicial
    final result = await _connectivity.checkConnectivity();
    _connectionController.add(result != ConnectivityResult.none);

    // Escuchar cambios de conectividad
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionController.add(result != ConnectivityResult.none);
    });
  }

  static Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static void dispose() {
    _connectionController.close();
  }
}