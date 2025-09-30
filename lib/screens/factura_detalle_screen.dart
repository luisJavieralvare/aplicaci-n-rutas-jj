import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class FacturaDetalleScreen extends StatelessWidget {
  final Factura factura;

  const FacturaDetalleScreen({super.key, required this.factura});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle Factura #${factura.id}'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildDetalles(currencyFormatter),
          const Divider(thickness: 1.5, height: 40),
          _buildTotal(currencyFormatter),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(factura.fecha))}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Factura ID: ${factura.id}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalles(NumberFormat currencyFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Productos Vendidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (factura.detalles == null || factura.detalles!.isEmpty)
          const Center(child: Text('No hay detalles para esta factura.'))
        else
          ...factura.detalles!.map((detalle) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined, color: Colors.blue),
              title: Text(detalle.producto.nombre),
              subtitle: Text('Cantidad: ${detalle.cantidadVendida} x ${currencyFormatter.format(detalle.producto.precio)}'),
              trailing: Text(currencyFormatter.format(detalle.subtotal), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )),
      ],
    );
  }

  Widget _buildTotal(NumberFormat currencyFormatter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 20),
          Text(
            currencyFormatter.format(factura.total),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }
}