import 'package:json_annotation/json_annotation.dart';

part 'mercancia_request.g.dart';

@JsonSerializable()
class MercanciaRequest {
  final int productoId;
  final int cantidad;
  final String tipoRegistro;

  MercanciaRequest({
    required this.productoId,
    required this.cantidad,
    required this.tipoRegistro,
  });

  factory MercanciaRequest.fromJson(Map<String, dynamic> json) => 
    _$MercanciaRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MercanciaRequestToJson(this);
}