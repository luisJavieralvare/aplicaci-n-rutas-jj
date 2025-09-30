import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../models/models.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 7));
  DateTime _fechaFin = DateTime.now();

  Future<void> _seleccionarFecha(BuildContext context, bool esFechaInicio) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: esFechaInicio ? _fechaInicio : _fechaFin,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        if (esFechaInicio) {
          _fechaInicio = fechaSeleccionada;
        } else {
          _fechaFin = fechaSeleccionada;
        }
      });
    }
  }

  void _generarReporte() {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final inicio = DateFormat('yyyy-MM-dd').format(_fechaInicio);
    final fin = DateFormat('yyyy-MM-dd').format(_fechaFin);
    adminProvider.getReporteSemanal(inicio, fin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes de Ventas'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSelectorFechas(),
          const Divider(),
          Expanded(child: _buildListaReporte()),
        ],
      ),
    );
  }

  Widget _buildSelectorFechas() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBotonFecha('Desde:', _fechaInicio, () => _seleccionarFecha(context, true)),
              _buildBotonFecha('Hasta:', _fechaFin, () => _seleccionarFecha(context, false)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _generarReporte,
            icon: const Icon(Icons.search),
            label: const Text('Generar Reporte'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBotonFecha(String label, DateTime fecha, VoidCallback onPressed) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onPressed,
          child: Text(DateFormat('dd/MM/yyyy').format(fecha)),
        ),
      ],
    );
  }

  Widget _buildListaReporte() {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (adminProvider.reporteSemanal.isEmpty) {
          return const Center(child: Text('No hay datos para el rango de fechas seleccionado.'));
        }

        final facturas = adminProvider.reporteSemanal;
        final totalVentas = facturas.fold<double>(0, (sum, item) => sum + item.total);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Ventas: ${NumberFormat.currency(locale: 'es_CO', symbol: '\$').format(totalVentas)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: facturas.length,
                itemBuilder: (context, index) {
                  final Factura factura = facturas[index];
                  return ListTile(
                    title: Text('Factura #${factura.id} - Fecha: ${factura.fecha}'),
                    trailing: Text(NumberFormat.currency(locale: 'es_CO', symbol: '\$').format(factura.total)),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}