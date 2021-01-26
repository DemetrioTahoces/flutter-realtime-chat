import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/models/usuario.dart';
import 'package:realtime_chat/pages/chat_page.dart';
import 'package:realtime_chat/services/chat_service.dart';

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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChatPage(),
            transitionDuration: Duration(milliseconds: 500),
          ),
        );
      },
    );
  }
}
