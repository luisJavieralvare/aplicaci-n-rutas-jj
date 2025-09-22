import 'package:json_annotation/json_annotation.dart';
import 'detalle_factura.dart';

part 'factura.g.dart';

@JsonSerializable()
class Factura {
  final int id;
  final String fecha;
  final double total;
  final List<DetalleFactura>? detalles;

  Factura({
    required this.id,
    required this.fecha,
    required this.total,
    this.detalles,
  });

  factory Factura.fromJson(Map<String, dynamic> json) => _$FacturaFromJson(json);
  Map<String, dynamic> toJson() => _$FacturaToJson(this);
}