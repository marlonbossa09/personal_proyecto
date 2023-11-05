class User {
  final String nombre;
  final String apellido;
  final String rol; // Asegúrate de tener este campo si está en tus datos de usuario
  final String email;
  final String token;

  const User({
    required this.nombre,
    required this.apellido,
    required this.rol, // Asegúrate de tener este campo si está en tus datos de usuario
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nombre: json['nombre'] ?? "",
      apellido: json['apellido'] ?? "",
      rol: json['rol'] ?? "", // Asegúrate de tener este campo si está en tus datos de usuario
      email: json['email'] ?? "",
      token: json['token'] ?? "",
    );
  }
}
