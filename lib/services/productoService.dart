import 'package:http/http.dart' as http;
import 'package:personal_proyecto/models/ProductosModel.dart';
import 'dart:convert';

import 'package:personal_proyecto/services/varGlobales.dart';

class ProductoService {
  final String URL = VariablesGlobales().getUrlHttp();
  final String _OBTENER_PRODUCTO = '/productos';


 Future<List<ProductosModel>> verProductos(String token) async {
  final response = await http.get(
    Uri.parse('$URL$_OBTENER_PRODUCTO'),
    headers: {
      'Authorization': 'Bearer $token',
      "Access-Control-Allow-Origin": "*",
      'Accept': 'application/json', // Ajustar el tipo de contenido aceptado
    },
  );

  if (response.statusCode == 200) {
    // Verificar si la respuesta no está vacía
    if (response.body.isNotEmpty) {
      // Intentar decodificar el JSON
      try {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<ProductosModel> productos = jsonList.map((json) => ProductosModel.fromJson(json)).toList();
        return productos;
      } catch (e) {
        // Manejar errores de decodificación JSON
        print('Error de decodificación JSON: $e');
        throw Exception('Ocurrió un error durante la decodificación del JSON.');
      }
    } else {
      // La respuesta está vacía, devolver una lista vacía
      return [];
    }
  } else if (response.statusCode == 403) {
    // En el caso de un código de estado 403, devolvemos una lista vacía.
    return [];
  } else {
    // En otros casos, lanzar una excepción
    throw Exception('Ocurrió un error. Código de estado: ${response.statusCode}');
  }
}




}
