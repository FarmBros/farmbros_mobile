import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  Future<Map<String, dynamic>> loginRequest(
      String email, String password) async {
    try {
      final signInRequest = await http
          .post(Uri.parse('https://example.com/login'), body: <String, String>{
        'email': email,
        'password': password,
      });

      return jsonDecode(signInRequest.body);
    } catch (e) {
      return <String, dynamic>{'error': e.toString()};
    }
  }
}
