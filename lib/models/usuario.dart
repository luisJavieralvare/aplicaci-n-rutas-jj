import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@JsonSerializable()
class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final String estado;
  final String rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.estado,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}