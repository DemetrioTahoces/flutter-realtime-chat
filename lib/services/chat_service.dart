import 'package:flutter/material.dart';
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/messages_response.dart';
import 'package:realtime_chat/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/services/auth_service.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Message>> getChat(String userID) async {
    String token = await AuthService.getToken();

    final resp = await http.get(
      '${Environment.url}${Environment.api}${Environment.mensajes}/$userID',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    final mensajesResp = messagesResponseFromJson(resp.body);

    return mensajesResp.messages;
  }
}
