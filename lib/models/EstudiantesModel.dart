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
