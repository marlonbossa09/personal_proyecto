import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'package:personal_proyecto/services/varGlobales.dart';

class UsuariosService {
  String URL = VariablesGlobales().getUrlHttp();
  String _BUSCAR_USUARIO = '/estudiantes/';
  String _CREAR_USUARIO = 'registro';
  String _EDITAR_USUARIO = 'update/';
  String _ELIMINAR_USUARIO = 'delete/';

  Future<Map<String, dynamic>> createUser(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$URL$_BUSCAR_USUARIO$_CREAR_USUARIO'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Error: ${response.body}');
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        throw Exception('Ocurrió un error');
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'error': 'Se presentó un problema al crear la empresa.'
      };
    }
  }

  Future<Map<String, dynamic>> editarUsuario(
    Map<String, dynamic> datos, int userid, String token) async {
  try {
    final response = await http.put(
      Uri.parse('$URL$_BUSCAR_USUARIO$_EDITAR_USUARIO$userid'),
      headers: {
      'Authorization': 'Bearer $token',
      "Access-Control-Allow-Origin": "*",
      'Accept': '*/*', 
      'Content-Type': 'application/json; charset=UTF-8'
    },
      body: jsonEncode(datos),
    );

    if (response.statusCode == 200) {
      print('Error: ${response.body}');
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      throw Exception('Ocurrió un error');
    }
  } catch (e) {
    print('Error: $e');
    return {'success': false, 'error': 'Se presentó un problema al crear la empresa.'};
  }
}

  Future<Map> eliminarUsuario(int id, String token) async {
  try {
    final response = await http.delete(
      Uri.parse('$URL$_BUSCAR_USUARIO$_ELIMINAR_USUARIO$id'),
      headers: {
        'Authorization': 'Bearer $token',
        "Access-Control-Allow-Origin": "*",
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 204) {
      return {'success': true, 'data': null}; // No hay contenido para decodificar
    } else {
      throw Exception('Ocurrió un error');
    }
  } catch (e) {
    print('Error: $e');
    return {
      'success': false,
      'error': 'Se presentó un problema al eliminar el usuario.'
    };
  }
}

  Future<List<UsuarioGeneralModel>> verUsuario(String token) async {
    final response = await http.get(
      Uri.parse('$URL$_BUSCAR_USUARIO'),
      headers: {
        'Authorization': 'Bearer $token',
        "Access-Control-Allow-Origin": "*",
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          List<dynamic> jsonList = jsonDecode(response.body);
          List<UsuarioGeneralModel> productos =
              jsonList.map((json) => UsuarioGeneralModel.fromJson(json)).toList();
          return productos;
        } catch (e) {
          print('Error de decodificación JSON: $e');
          throw Exception(
              'Ocurrió un error durante la decodificación del JSON.');
        }
      } else {
        return [];
      }
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw Exception(
          'Ocurrió un error. Código de estado: ${response.statusCode}');
    }
  }
}
