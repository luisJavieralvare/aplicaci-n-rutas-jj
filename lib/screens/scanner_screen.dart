import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';
import '../models/models.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código de Barras'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                _isScanning = !_isScanning;
              });
              if (_isScanning) {
                controller?.resumeCamera();
              } else {
                controller?.pauseCamera();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Apunte la cámara hacia el código de barras',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'El producto se seleccionará automáticamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (_isScanning && scanData.code != null) {
        setState(() {
          _isScanning = false;
        });
        controller.pauseCamera();
        _buscarProducto(scanData.code!);
      }
    });
  }

  Future<void> _buscarProducto(String codigo) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Buscando producto...'),
          ],
        ),
      ),
    );

    try {
      final productosProvider = Provider.of<ProductosProvider>(context, listen: false);
      final producto = await productosProvider.buscarPorCodigoBarras(codigo);

      Navigator.pop(context); // Cerrar dialog de carga

      if (producto != null && context.mounted) {
        // Mostrar producto encontrado y opciones
        _mostrarProductoEncontrado(producto);
      } else if (context.mounted) {
        _mostrarProductoNoEncontrado(codigo);
      }
    } catch (e) {
      Navigator.pop(context); // Cerrar dialog de carga
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
        _reanudarEscaneo();
      }
    }
  }

  void _mostrarProductoEncontrado(Producto producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Producto Encontrado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${producto.nombre}'),
            Text('Precio: \$${producto.precio}'),
            Text('Stock: ${producto.stock}'),
            Text('Categoría: ${producto.categoria.nombre}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reanudarEscaneo();
            },
            child: const Text('Seleccionar'),
          ),
        ],
      ),
    );
  }

  void _mostrarProductoNoEncontrado(String codigo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Producto No Encontrado'),
        content: Text('No se encontró ningún producto con el código: $codigo'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reanudarEscaneo();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _reanudarEscaneo() {
    setState(() {
      _isScanning = true;
    });
    controller?.resumeCamera();
  }