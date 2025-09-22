import 'package:json_annotation/json_annotation.dart';
import 'categoria.dart';

part 'producto.g.dart';

@JsonSerializable()
class Producto {
  final int id;
  final String nombre;
  final double precio;
  final int stock;
  final Categoria categoria;
  @JsonKey(name: 'codigoBarras')
  final String? codigoBarras;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.categoria,
    this.codigoBarras,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => _$ProductoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductoToJson(this);
}
