import 'package:json_annotation/json_annotation.dart';
import 'producto.dart';

part 'mercancia.g.dart';

@JsonSerializable()
class Mercancia {
  final int id;
  final Producto producto;
  final int cantidad;
  final String fecha;
  final String tipoRegistro;
  final bool sincronizado;

  Mercancia({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.fecha,
    required this.tipoRegistro,
    this.sincronizado = true,
  });

  factory Mercancia.fromJson(Map<String, dynamic> json) => _$MercanciaFromJson(json);
  Map<String, dynamic> toJson() => _$MercanciaToJson(this);
}
