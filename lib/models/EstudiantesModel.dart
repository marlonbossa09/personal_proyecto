class Estudiantes {
  final int codigo;
  final String nombre;
  final String apellido;
  final String rol; // Asegúrate de tener este campo si está en tus datos de usuario
  final String email;
  final String clave;
  final String token;

  const Estudiantes({
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.rol, // Asegúrate de tener este campo si está en tus datos de usuario
    required this.email,
    required this.clave,
    required this.token,
  });

  factory Estudiantes.fromJson(Map<String, dynamic> json) {
    return Estudiantes(
      codigo: json['codigo'] ?? 0,
    nombre: json['nombre'] ?? "",
    apellido: json['apellido'] ?? "",
    rol: json['rol'] ?? "",
    email: json['email'] ?? "",
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
  final Estudiantes creador;
  final List<Comentario> comentarios; // Nueva propiedad para almacenar comentarios

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
      creador: Estudiantes.fromJson(json['creador'] ?? {}),
      comentarios: comentarios,
    );
  }
}




class Comentario {
  final int id;
  final String contenido;
  final Estudiantes autor;

  const Comentario({
    required this.id,
    required this.contenido,
    required this.autor,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'] ?? 0,
      contenido: json['contenido'] ?? "",
      autor: Estudiantes.fromJson(json['autor'] ?? {}),
    );
  }
}
