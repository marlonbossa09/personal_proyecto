import 'package:http/http.dart' as http;
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'dart:convert';

import 'package:personal_proyecto/services/varGlobales.dart';

class ProductoService {
  final String URL = VariablesGlobales().getUrlHttp();
  final String _OBTENER_PRODUCTO = '/productos';
  final String _PRODUCTO_DE_USUARIO = '/mis-productos';
  final String _OBTENER_PRODUCTO_ID = '/productos/';
  final String _CREAR_PRODUCTO = '/productos/agregar';
  final String _EDITAR_PRODUCTO = '/update/';
  final String _ELIMINAR_PRODUCTO = '/delete/';

 Future<List<ProductoConUsuarioModel>> verProductos(String token) async {
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
        List<ProductoConUsuarioModel> productos = jsonList.map((json) => ProductoConUsuarioModel.fromJson(json, [])).toList();
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

Future<List<ProductoConUsuarioModel>> verProductosUsuario(String token) async {
  final response = await http.get(
    Uri.parse('$URL$_OBTENER_PRODUCTO$_PRODUCTO_DE_USUARIO'),
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
        List<ProductoConUsuarioModel> productos = jsonList.map((json) => ProductoConUsuarioModel.fromJson(json, [])).toList();
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


Future<ProductoConUsuarioModel> verProductoId(int id, String token) async {
  try {
    final response = await http.get(
      Uri.parse('$URL$_OBTENER_PRODUCTO_ID$id'),
      headers: {
        'Authorization': 'Bearer $token',
        "Access-Control-Allow-Origin": "*",
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseBody = jsonDecode(response.body);
      print(responseBody);

      if (responseBody != null) {
        final productoJson = responseBody['producto'];
        
        final creadorData = productoJson['creador'];
        UsuarioGeneralModel creador = UsuarioGeneralModel.fromJson(creadorData);

        List<dynamic> comentariosJson = productoJson['comentarios'] ?? [];
        List<Comentario> comentarios = comentariosJson.map((comment) => Comentario.fromJson(comment)).toList();

        ProductoConUsuarioModel producto = ProductoConUsuarioModel.fromJson(productoJson, comentarios);

        return producto;
      } else {
        return ProductoConUsuarioModel(
          id: id,
          nombre: '',
          descripcion: '',
          cantidad: '',
          precio: '',
          creador: UsuarioGeneralModel(token: '', clave: '', email: '', celular: '', rol: '', apellido: '', nombre: '', codigo: 0),
          comentarios: [],
        );
      }
    } else {
      throw Exception('Ocurrió un error. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return ProductoConUsuarioModel(
      id: id,
      nombre: '',
      descripcion: '',
      cantidad: '',
      precio: '',
      creador: UsuarioGeneralModel(token: '', clave: '', email: '', celular: '', rol: '', apellido: '', nombre: '', codigo: 0),
      comentarios: [],
    );
  }
}



  Future<Map> eliminarProducto(int id, String token) async {
  try {
    final response = await http.delete(
      Uri.parse('$URL$_OBTENER_PRODUCTO$_ELIMINAR_PRODUCTO$id'),
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


Future<Map<String, dynamic>> editarProducto(
    Map<String, dynamic> datos, String userid, String token) async {
  try {
    final response = await http.put(
      Uri.parse('$URL$_OBTENER_PRODUCTO$_EDITAR_PRODUCTO$userid'),
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
