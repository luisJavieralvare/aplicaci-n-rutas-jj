import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/factura_provider.dart';
import '../models/models.dart';
import 'factura_detalle_screen.dart';

class FacturasScreen extends StatefulWidget {
  const FacturasScreen({super.key});

  @override
  State<FacturasScreen> createState() => _FacturasScreenState();
}

class _FacturasScreenState extends State<FacturasScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las facturas al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FacturaProvider>(context, listen: false).cargarFacturas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Facturas'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Consumer<FacturaProvider>(
        builder: (context, facturaProvider, child) {
          if (facturaProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (facturaProvider.error != null) {
            return Center(child: Text('Error: ${facturaProvider.error}'));
          }

          if (facturaProvider.facturas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tienes facturas generadas.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: facturaProvider.facturas.length,
            itemBuilder: (context, index) {
              final Factura factura = facturaProvider.facturas[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  leading: const Icon(Icons.receipt_outlined, color: Colors.blue, size: 40),
                  title: Text(
                    'Factura #${factura.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(factura.fecha))}',
                  ),
                  trailing: Text(
                    NumberFormat.currency(locale: 'es_CO', symbol: '\$').format(factura.total),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FacturaDetalleScreen(factura: factura),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}