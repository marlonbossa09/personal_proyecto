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

  Future<UsuarioGeneralModel> iniciarSesion(String email, String clave) async {
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
      return UsuarioGeneralModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ocurrió un error durante el inicio de sesión.');
    }
  }

  Future<UsuarioGeneralModel> usuarioActual(String token) async {
  final response = await http.get(
    Uri.parse('$URL$USUARIOACTUAL'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200 || response.statusCode == 403) {
    dynamic respuesta = jsonDecode(response.body);
    if (respuesta is List) {
      if (respuesta.isNotEmpty) {
        Map<String, dynamic> userMap = Map<String, dynamic>.from(respuesta[0]);
        userMap.addAll({"token": token});
        return UsuarioGeneralModel.fromJson(userMap);
      } else {
        throw Exception('No se encontró ningún usuario con el ID proporcionado.');
      }
    } else if (respuesta is Map) {
      Map<String, dynamic> stringMap = Map<String, dynamic>.from(respuesta);
      stringMap.addAll({"token": token});
      return UsuarioGeneralModel.fromJson(stringMap);
    } else {
      throw Exception('El formato de respuesta no es válido.');
    }
  } else {
    throw Exception('Ocurrió un error');
  }
}


}
