import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String token;
  final String type;
  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final String estado;

  LoginResponse({
    required this.token,
    required this.type,
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.estado,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
    _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}