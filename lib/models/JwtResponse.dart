class JwtResponse {
  final String token;

  JwtResponse({required this.token});

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      token: json['token'],
    );
  }
}
