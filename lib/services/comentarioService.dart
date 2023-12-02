import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:personal_proyecto/services/varGlobales.dart';

class ComentarioService {
  final String URL = VariablesGlobales().getUrlHttp();
  final String PRODUCTO = '/productos/';
  final String _CREAR_COMENTARIO = '/comentarios';
  final String _EDITAR_PRODUCTO = '/update/';


Future<Map<String, dynamic>> crearComentario(Map<String, dynamic> data, int id, String token) async {
  try {
    final response = await http.post(
      Uri.parse('$URL$PRODUCTO$id$_CREAR_COMENTARIO'),
      headers: {
      'Authorization': 'Bearer $token',
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
    return {'success': false, 'error': 'Se presentó un problema al crear la empresa.'};
  }
}


Future<Map<String, dynamic>> editarProducto(
    Map<String, dynamic> datos, String userid, String token) async {
  try {
    final response = await http.put(
      Uri.parse('$URL$PRODUCTO$_EDITAR_PRODUCTO$userid'),
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

}
