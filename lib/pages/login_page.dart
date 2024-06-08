// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:order_it/components/login_with_button.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_textfield.dart';
import 'package:order_it/controllers/auth/login_controller.dart';
import 'package:order_it/pages/first_page.dart';
import 'package:order_it/services/google_sign_in.dart';
import 'package:order_it/services/snackbar_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginController = LoginController();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FirstPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //logo
              FadeInDown(
                duration: const Duration(seconds: 2),
                child: Image.asset(
                  'assets/icons/Logo.png',
                  width: 500,
                  height: 300,
                ),
              ),

              const SizedBox(height: 0),

              // EMAIL TEXTFIELD
              FadeInRight(
                duration: const Duration(seconds: 1),
                child: MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  labelText: "Email",
                  obscureText: false,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //PASSWORD TEXTFIELD
              FadeInLeft(
                duration: const Duration(seconds: 1),
                child: MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    labelText: "Password",
                    obscureText: true),
              ),

              const SizedBox(
                height: 30,
              ),

              //SIGN IN BUTTON
              FadeInUp(
                duration: const Duration(seconds: 1),
                child: MyButton(
                  text: "Iniciar Sesión",
                  linearGradient: LinearGradient(
                      colors: [Colors.green.shade900, Colors.green]),
                  onTap: () async {
                    // ESCONDEMOS EL TECLADO
                    FocusManager.instance.primaryFocus?.unfocus();

                    bool hasConnection =
                        await InternetConnectionChecker().hasConnection;
                    if (hasConnection) {
                      // Esto quiere decir que si el contexto existe.
                      // La informacion de la aplicación.
                      if (context.mounted) {
                        loginController.login(
                          context,
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    } else {
                      if (context.mounted) {
                        bool inicioSesion =
                            loginController.loginWithoutConnection(context,
                                emailController.text, passwordController.text);

                        inicioSesion
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FirstPage()))
                            : SnackbarHelper.showSnackbar(
                                context, "Inicio de sesión no válido.");
                      }
                    }
                  },
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              const Text(
                "O iniciar sesión con:",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              Column(
                children: [
                  LoginWithButton(
                    onTap: () async {
                      GoogleSignInService.googleSignIn();
                      if (await GoogleSignIn.standard().isSignedIn()) {
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FirstPage(),
                            ),
                          );
                        }
                      }
                    },
                    text: "Continuar con Google     ",
                    icon: "assets/icons/google_icon.png",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LoginWithButton(
                    onTap: () {},
                    text: "Continuar con Facebook",
                    icon: "assets/icons/facebook_icon.png",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LoginWithButton(
                    onTap: () {},
                    text: "Continuar con Apple       ",
                    icon: "assets/icons/apple_icon.png",
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              // NOT A MEMEBER? REGISTER NOW!
              FadeInUp(
                duration: const Duration(seconds: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿No eres miembro?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Regístrate",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:order_it/pages/first_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _setupAuthListener();
    
  }

  final supabase = Supabase.instance.client;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FirstPage(),
          ),
        );
      }
    });
  }

  Future<AuthResponse> _googleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = '581750972976-dm2uqljbks5cbij1hb861r311o2ctcdj.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

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

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _googleSignIn,
          child: const Text('Google login'),
        ),
      ),
    );
  }
}*/
