import 'package:http/http.dart' as http;
import 'package:personal_proyecto/models/ProductosModel.dart';
import 'dart:convert';

import 'package:personal_proyecto/services/varGlobales.dart';

class ProductoService {
  final String URL = VariablesGlobales().getUrlHttp();
  final String _OBTENER_PRODUCTO = '/productos';
  final String _CREAR_PRODUCTO = '/productos/agregar';
  final String _EDITAR_EMPRESA = '';

 Future<List<ProductosModel>> verProductos(String token) async {
  final response = await http.get(
    Uri.parse('$URL$_OBTENER_PRODUCTO'),
    headers: {
      'Authorization': 'Bearer $token',
      "Access-Control-Allow-Origin": "*",
      'Accept': 'application/json', 
    },
  );

  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      // Intentar decodificar el JSON
      try {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<ProductosModel> productos = jsonList.map((json) => ProductosModel.fromJson(json)).toList();
        return productos;
      } catch (e) {
        print('Error de decodificación JSON: $e');
        throw Exception('Ocurrió un error durante la decodificación del JSON.');
      }
    } else {
      return [];
    }
  } else if (response.statusCode == 403) {
    return [];
  } else {
    throw Exception('Ocurrió un error. Código de estado: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> crearProducto(Map<String, dynamic> data, String token) async {
  try {
    final response = await http.post(
      Uri.parse('$URL$_CREAR_PRODUCTO'),
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


Future<Map<String, dynamic>> editarEmpresa(
    Map<String, dynamic> datos, String userid, String token) async {
  try {
    final response = await http.put(
      Uri.parse('$URL$_EDITAR_EMPRESA$userid'),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(datos),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'detail': responseData['content']};
      } else {
        return {'detail': responseData['detail'][0]['msg']};
      }
    } else {
      throw Exception('Ocurrió un error');
    }
  } catch (e) {
    return {'detail': 'Se presentó un problema al crear la empresa.'};
  }
}




}
