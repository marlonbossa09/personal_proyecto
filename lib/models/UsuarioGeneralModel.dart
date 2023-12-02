class UsuarioGeneralModel {
  final int codigo;
  final String nombre;
  final String apellido;
  final String rol; 
  final String email;
  final String celular;
  final String clave;
  final String token;

  const UsuarioGeneralModel({
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.rol, 
    required this.email,
    required this.celular,
    required this.clave,
    required this.token,
  });

  factory UsuarioGeneralModel.fromJson(Map<String, dynamic> json) {
    return UsuarioGeneralModel(
      codigo: json['codigo'] ?? 0,
    nombre: json['nombre'] ?? "",
    apellido: json['apellido'] ?? "",
    rol: json['rol'] ?? "",
    email: json['email'] ?? "",
    celular: json['celular'] ?? "",
    clave: json['clave'] ?? "",
      token: json['token'] ?? "",
    );
  }
}

class ProductoConUsuarioModel {
  final int id;
  final String nombre;
  final String descripcion;
  final String cantidad;
  final String precio;
  final UsuarioGeneralModel creador;
  final List<Comentario> comentarios;

  const ProductoConUsuarioModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precio,
    required this.creador,
    required this.comentarios,
  });

  factory ProductoConUsuarioModel.fromJson(Map<String, dynamic> json, List<Comentario> comentarios) {
    return ProductoConUsuarioModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? "",
      descripcion: json['descripcion'] ?? "",
      cantidad: json['cantidad'] ?? "",
      precio: json['precio'] ?? "",
      creador: UsuarioGeneralModel.fromJson(json['creador'] ?? {}),
      comentarios: comentarios,
    );
  }
}




class Comentario {
  final int id;
  final String contenido;
  final UsuarioGeneralModel autor;

  const Comentario({
    required this.id,
    required this.contenido,
    required this.autor,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'] ?? 0,
      contenido: json['contenido'] ?? "",
      autor: UsuarioGeneralModel.fromJson(json['autor'] ?? {}),
    );
  }
}
