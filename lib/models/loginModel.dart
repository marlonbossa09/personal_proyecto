class LoginModel {
  final String email;
  final String clave;

  LoginModel({required this.email, required this.clave});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'clave': clave,
    };
  }
}
