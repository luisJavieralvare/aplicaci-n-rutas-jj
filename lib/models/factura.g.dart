// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factura.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Factura _$FacturaFromJson(Map<String, dynamic> json) => Factura(
      id: (json['id'] as num).toInt(),
      fecha: json['fecha'] as String,
      total: (json['total'] as num).toDouble(),
      detalles: (json['detalles'] as List<dynamic>?)
          ?.map((e) => DetalleFactura.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FacturaToJson(Factura instance) => <String, dynamic>{
      'id': instance.id,
      'fecha': instance.fecha,
      'total': instance.total,
      'detalles': instance.detalles,
    };
