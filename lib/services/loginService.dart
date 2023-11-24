import 'package:http/http.dart' as http;
import 'package:personal_proyecto/models/JwtResponse.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';
import 'package:personal_proyecto/models/loginModel.dart';
import 'dart:convert';

import 'package:personal_proyecto/services/varGlobales.dart';

class LoginService {
  final String URL = VariablesGlobales().getUrlHttp();
  final String LOGIN = '/estudiantes/login';
  final String USUARIOACTUAL = '/estudiantes/actual';
  final String RENEWTOKEN = '/refresh';

  Future<JwtResponse> iniciarSesion(String email, String clave) async {
    final response = await http.post(
      Uri.parse('$URL$LOGIN'),
      headers: <String, String>{
         "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'
      },
      body: jsonEncode(LoginModel(email: email, clave: clave).toJson()),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return JwtResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ocurrió un error durante el inicio de sesión.');
    }
  }

  Future<Estudiantes> usuarioActual(String token) async {
  final response = await http.get(
    Uri.parse('$URL$USUARIOACTUAL'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200 || response.statusCode == 403) {
    return Estudiantes.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Ocurrió un error.');
  }
}


}
