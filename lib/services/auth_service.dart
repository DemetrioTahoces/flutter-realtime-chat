import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/usuario.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool value) {
    this._autenticando = value;
    notifyListeners();
  }

  // Getters del token estaticos
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {
      'email': email,
      'password': password,
    };

    final url = '${Environment.url}${Environment.api}${Environment.login}';

    return _login(url, data);
  }

  Future<String> register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {
      'name': nombre,
      'email': email,
      'password': password,
    };

    final url =
        '${Environment.url}${Environment.api}${Environment.login}${Environment.newUser}';

    return _register(url, data);
  }

  Future<bool> _login(String url, Map<String, dynamic> data) async {
    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.body;

      this._guardarToken(loginResponse.token);

      return true;
    }

    return false;
  }

  Future<String> _register(String url, Map<String, dynamic> data) async {
    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.body;

      this._guardarToken(loginResponse.token);

      return 'true';
    }

    final body = jsonDecode(resp.body);
    return body['message'];
  }

  Future<bool> _renew(String url, String token) async {
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.body;

      this._guardarToken(loginResponse.token);

      return true;
    }

    return false;
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final url =
        '${Environment.url}${Environment.api}${Environment.login}${Environment.renew}';

    return this._renew(url, token);
  }

  Future<void> _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    return await _storage.delete(key: 'token');
  }
}
