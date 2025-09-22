// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalle_factura.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetalleFactura _$DetalleFacturaFromJson(Map<String, dynamic> json) =>
    DetalleFactura(
      id: (json['id'] as num).toInt(),
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
      cantidadVendida: (json['cantidadVendida'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );

Map<String, dynamic> _$DetalleFacturaToJson(DetalleFactura instance) =>
    <String, dynamic>{
      'id': instance.id,
      'producto': instance.producto,
      'cantidadVendida': instance.cantidadVendida,
      'subtotal': instance.subtotal,
    };
