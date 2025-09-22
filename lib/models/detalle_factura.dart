import 'package:json_annotation/json_annotation.dart';
import 'producto.dart';

part 'detalle_factura.g.dart';

@JsonSerializable()
class DetalleFactura {
  final int id;
  final Producto producto;
  final int cantidadVendida;
  final double subtotal;

  DetalleFactura({
    required this.id,
    required this.producto,
    required this.cantidadVendida,
    required this.subtotal,
  });

  factory DetalleFactura.fromJson(Map<String, dynamic> json) => 
    _$DetalleFacturaFromJson(json);
  Map<String, dynamic> toJson() => _$DetalleFacturaToJson(this);
}