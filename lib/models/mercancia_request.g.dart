// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mercancia_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MercanciaRequest _$MercanciaRequestFromJson(Map<String, dynamic> json) =>
    MercanciaRequest(
      productoId: (json['productoId'] as num).toInt(),
      cantidad: (json['cantidad'] as num).toInt(),
      tipoRegistro: json['tipoRegistro'] as String,
    );

Map<String, dynamic> _$MercanciaRequestToJson(MercanciaRequest instance) =>
    <String, dynamic>{
      'productoId': instance.productoId,
      'cantidad': instance.cantidad,
      'tipoRegistro': instance.tipoRegistro,
    };
