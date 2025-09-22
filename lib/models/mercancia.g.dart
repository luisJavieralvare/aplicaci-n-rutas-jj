// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mercancia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mercancia _$MercanciaFromJson(Map<String, dynamic> json) => Mercancia(
      id: (json['id'] as num).toInt(),
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
      cantidad: (json['cantidad'] as num).toInt(),
      fecha: json['fecha'] as String,
      tipoRegistro: json['tipoRegistro'] as String,
      sincronizado: json['sincronizado'] as bool? ?? true,
    );

Map<String, dynamic> _$MercanciaToJson(Mercancia instance) => <String, dynamic>{
      'id': instance.id,
      'producto': instance.producto,
      'cantidad': instance.cantidad,
      'fecha': instance.fecha,
      'tipoRegistro': instance.tipoRegistro,
      'sincronizado': instance.sincronizado,
    };
