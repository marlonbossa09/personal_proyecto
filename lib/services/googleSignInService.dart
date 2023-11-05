import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
    clientId: '4526463154-8n3pp5u7nitpidjth9gbegoavu21dbdq.apps.googleusercontent.com', // Reemplaza con tu propio Client ID
  );

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final googleKey = await account!.authentication;
      print(account);
      print(googleKey.idToken);
      return account;
    } catch (e) {
      print('Error en Google SignIn');
      print(e);
      return null;
    }
  }
}
