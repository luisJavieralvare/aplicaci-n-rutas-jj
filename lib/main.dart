import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/auth_provider.dart';
import 'providers/productos_provider.dart';
import 'providers/mercancia_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/factura_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/registro_mercancia_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/facturas_screen.dart';
import 'screens/usuarios_pendientes_screen.dart';
import 'screens/inventario_screen.dart';
import 'screens/reportes_screen.dart';
import 'services/connectivity_service.dart';
import 'services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // En un proyecto real, aquí usarías un sistema de logging
  }

  // Inicializar servicios de conectividad y sincronización
  await ConnectivityService.init();
  await SyncService.iniciarSincronizacionAutomatica();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductosProvider()),
        ChangeNotifierProvider(create: (_) => MercanciaProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => FacturaProvider()),
      ],
      child: MaterialApp(
        title: 'Rutas J-J',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/trabajador/registro-mercancia': (context) => const RegistroMercanciaScreen(),
          '/trabajador/scanner': (context) => const BarcodeScannerScreen(),
          '/trabajador/facturas': (context) => const FacturasScreen(),
          '/admin/usuarios-pendientes': (context) => const UsuariosPendientesScreen(),
          '/admin/inventario': (context) => const InventarioScreen(),
          '/admin/reportes': (context) => const ReportesScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}