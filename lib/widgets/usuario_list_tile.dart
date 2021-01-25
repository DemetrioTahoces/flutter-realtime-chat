import 'package:flutter/material.dart';
import 'package:realtime_chat/models/usuario.dart';

class UsuarioListTile extends StatelessWidget {
  final Usuario usuario;

  const UsuarioListTile({
    @required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.name),
      leading: CircleAvatar(
        child: Text(usuario.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
