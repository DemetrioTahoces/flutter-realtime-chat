// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.online,
    this.name,
    this.email,
    this.uuid,
  });

  bool online;
  String name;
  String email;
  String uuid;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        name: json["name"],
        email: json["email"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "name": name,
        "email": email,
        "uuid": uuid,
      };
}
