import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/models/usuarios_response.dart';
import 'package:realtime_chat/services/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      String token = await AuthService.getToken();

      final resp = await http.get(
        '${Environment.url}${Environment.api}${Environment.usuarios}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.users;
    } catch (e) {
      return [];
    }
  }
}
