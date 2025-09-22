// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Producto _$ProductoFromJson(Map<String, dynamic> json) => Producto(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      precio: (json['precio'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      categoria: Categoria.fromJson(json['categoria'] as Map<String, dynamic>),
      codigoBarras: json['codigoBarras'] as String?,
    );

Map<String, dynamic> _$ProductoToJson(Producto instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'precio': instance.precio,
      'stock': instance.stock,
      'categoria': instance.categoria,
      'codigoBarras': instance.codigoBarras,
    };
