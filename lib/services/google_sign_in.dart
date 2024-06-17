import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleSignInService {
  static Future<AuthResponse> googleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '298816426418-bu2jpqqsa7d314vbtj7a3n20o5dnnete.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '298816426418-0jbhsjfk02jppbpupb7j5p66j9sspqli.apps.googleusercontent.com';

    // Google sign in en Android funciona sin añadir Android
    // Cliente ID registrado en Google Cloud

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No se encontró Access Token';
    }
    if (idToken == null) {
      throw 'No se encontró ID Token';
    }

    final supabase = Supabase.instance.client;

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
