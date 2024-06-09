import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleSignInService {
  static Future<AuthResponse> googleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '581750972976-dm2uqljbks5cbij1hb861r311o2ctcdj.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = '581750972976-q01j9q71b265n0am7fated10rjdag5t1.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final supabase = Supabase.instance.client;

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}