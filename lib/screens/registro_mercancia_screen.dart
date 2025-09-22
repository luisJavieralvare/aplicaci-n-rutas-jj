import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';
import '../providers/mercancia_provider.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistroMercanciaScreen extends StatefulWidget {
  const RegistroMercanciaScreen({Key? key}) : super(key: key);

  @override
  State<RegistroMercanciaScreen> createState() => _RegistroMercanciaScreenState();
}

class _RegistroMercanciaScreenState extends State<RegistroMercanciaScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _cantidadController = TextEditingController();
  Producto? _productoSeleccionado;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Cargar datos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductosProvider>(context, listen: false).cargarProductos();
      Provider.of<MercanciaProvider>(context, listen: false).cargarMercanciaLlevadaHoy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Mercancía'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Registrar Llevada', icon: Icon(Icons.add_box)),
            Tab(text: 'Registrar Devuelta', icon: Icon(Icons.remove_circle)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.pushNamed(context, '/trabajador/scanner'),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRegistroLlevada(),
          _buildRegistroDevuelta(),
        ],
      ),
    );
  }

  Widget _buildRegistroLlevada() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nuevo Registro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<ProductosProvider>(
                    builder: (context, productosProvider, child) {
                      if (productosProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return DropdownButtonFormField<Producto>(
                        value: _productoSeleccionado,
                        hint: const Text('Seleccionar Producto'),
                        decoration: InputDecoration(
                          labelText: 'Producto',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: productosProvider.productos
                            .map((producto) => DropdownMenuItem<Producto>(
                                  value: producto,
                                  child: Text('${producto.nombre} - Stock: ${producto.stock}'),
                                ))
                            .toList(),
                        onChanged: (producto) {
                          setState(() {
                            _productoSeleccionado = producto;
                          });
                        },
                        validator: (value) {
                          if (value == null) return 'Seleccione un producto';
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Ingrese la cantidad';
                      final cantidad = int.tryParse(value!);
                      if (cantidad == null || cantidad <= 0) {
                        return 'Ingrese una cantidad válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Consumer<MercanciaProvider>(
                    builder: (context, mercanciaProvider, child) {
                      return SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: mercanciaProvider.isLoading
                              ? null
                              : () => _registrarMercancia('LLEVADA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: mercanciaProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Text(
                                  'Registrar Llevada',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistroDevuelta() {
    return Consumer<MercanciaProvider>(
      builder: (context, mercanciaProvider, child) {
        if (mercanciaProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final mercanciaLlevada = mercanciaProvider.mercanciaLlevada;

        if (mercanciaLlevada.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No hay productos llevados hoy',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mercanciaLlevada.length,
          itemBuilder: (context, index) {
            final mercancia = mercanciaLlevada[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.inventory, color: Colors.white),
                ),
                title: Text(mercancia.producto.nombre),
                subtitle: Text('Llevado: ${mercancia.cantidad}'),
                trailing: ElevatedButton(
                  onPressed: () => _mostrarDialogoDevuelta(mercancia),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Devolver'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarDialogoDevuelta(Mercancia mercancia) {
    final cantidadController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Devolver ${mercancia.producto.nombre}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cantidad llevada: ${mercancia.cantidad}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad a devolver',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final cantidad = int.tryParse(cantidadController.text);
              if (cantidad != null && cantidad > 0 && cantidad <= mercancia.cantidad) {
                Navigator.pop(context);
                _registrarDevuelta(mercancia.producto, cantidad);
              }
            },
            child: const Text('Devolver'),
          ),
        ],
      ),
    );
  }

  Future<void> _registrarMercancia(String tipo) async {
    if (_productoSeleccionado == null || _cantidadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cantidad = int.tryParse(_cantidadController.text);
    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese una cantidad válida'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = MercanciaRequest(
      productoId: _productoSeleccionado!.id,
      cantidad: cantidad,
      tipoRegistro: tipo,
    );

    final success = await Provider.of<MercanciaProvider>(context, listen: false)
        .registrarMercancia(request, _productoSeleccionado!);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$tipo registrada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      _cantidadController.clear();
      setState(() {
        _productoSeleccionado = null;
      });
      // Recargar productos para actualizar stock
      Provider.of<ProductosProvider>(context, listen: false).cargarProductos();
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registrando $tipo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _registrarDevuelta(Producto producto, int cantidad) async {
    final request = MercanciaRequest(
      productoId: producto.id,
      cantidad: cantidad,
      tipoRegistro: 'DEVUELTA',
    );

    final success = await Provider.of<MercanciaProvider>(context, listen: false)
        .registrarMercancia(request, producto);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devolución registrada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      // Recargar mercancía llevada
      Provider.of<MercanciaProvider>(context, listen: false).cargarMercanciaLlevadaHoy();
      // Recargar productos para actualizar stock
      Provider.of<ProductosProvider>(context, listen: false).cargarProductos();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }
}
