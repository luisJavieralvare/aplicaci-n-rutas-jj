import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../models/models.dart';

class UsuariosPendientesScreen extends StatefulWidget {
  const UsuariosPendientesScreen({super.key});

  @override
  State<UsuariosPendientesScreen> createState() => _UsuariosPendientesScreenState();
}

class _UsuariosPendientesScreenState extends State<UsuariosPendientesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).cargarUsuariosPendientes();
    });
  }

  Future<void> _aprobarUsuario(int id) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final success = await adminProvider.aprobarUsuario(id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Usuario aprobado exitosamente' : 'Error al aprobar el usuario'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Pendientes'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          if (adminProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adminProvider.error != null) {
            return Center(child: Text('Error: ${adminProvider.error}'));
          }

          if (adminProvider.usuariosPendientes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_disabled_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay usuarios pendientes.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: adminProvider.usuariosPendientes.length,
            itemBuilder: (context, index) {
              final Usuario usuario = adminProvider.usuariosPendientes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(Icons.person_outline, color: Colors.orange),
                  ),
                  title: Text(usuario.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(usuario.correo),
                  trailing: ElevatedButton(
                    onPressed: () => _aprobarUsuario(usuario.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Aprobar'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}