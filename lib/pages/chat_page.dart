import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/models/messages_response.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
import 'package:realtime_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [
    // ChatMessage(texto: 'Hola Mundo', uid: '123'),
    // ChatMessage(texto: 'Hola No Mundo', uid: '1234'),
    // ChatMessage(
    //     texto:
    //         'f3n1890uhr807432hnf0134ungf9ui341ng9i34n908gn341098nf3089th8319jht08934j0983j10945',
    //     uid: '123'),
    // ChatMessage(
    //     texto:
    //         'jf89431hf93842hjrf98324jnt908324jnt980342jn890tj3425809tj32098j53024jg340ng3',
    //     uid: '1234'),
  ];
  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('personal-message', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uuid);
  }

  void _escucharMensaje(dynamic data) {
    String from = data['from'];

    if (from == chatService.usuarioPara.uuid) {
      ChatMessage message = ChatMessage(
        texto: data['message'],
        uuid: from,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 400),
        ),
      );

      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usuarioPara.name.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              usuarioPara.name,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemBuilder: (_, i) => _messages[i],
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              height: 50,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _estaEscribiendo ? (_) => _handleSubmit() : null,
                onChanged: (texto) {
                  setState(() {
                    _estaEscribiendo = texto.trim().length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            // Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed:
                          _estaEscribiendo ? () => _handleSubmit() : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed:
                              _estaEscribiendo ? () => _handleSubmit() : null,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    final String texto = _textController.text.trim();

    if (texto.length == 0) return;

    setState(() {
      final newMessage = ChatMessage(
        uuid: this.authService.usuario.uuid,
        texto: texto,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 400),
        ),
      );
      _messages.insert(0, newMessage);
      newMessage.animationController.forward();
      _estaEscribiendo = false;
    });

    this.socketService.emit('personal-message', {
      'from': this.authService.usuario.uuid,
      'to': this.chatService.usuarioPara.uuid,
      'message': texto,
    });

    _textController.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('personal-message');

    super.dispose();
  }

  void _cargarHistorial(String uuid) async {
    List<Message> chat = await this.chatService.getChat(uuid);

    final history = chat.map((message) => ChatMessage(
          texto: message.message,
          uuid: message.from,
          animationController: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 0),
          )..forward(),
        ));

    setState(() {
      this._messages.insertAll(0, history);
    });
  }
}
