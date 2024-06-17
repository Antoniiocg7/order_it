import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              FadeInDown(
                duration: const Duration(seconds: 3),
                child: Image.asset(
                  'assets/icons/Logo.png',
                  width: 500,
                  height: 300,
                ),
              ),

              const SizedBox(height: 0),

              // Email
              FadeInRight(
                duration: const Duration(seconds: 2),
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

              // Contraseña
              FadeInLeft(
                duration: const Duration(seconds: 2),
                child: MyTextField(
                    controller: passwordController,
                    hintText: "Contraseña",
                    labelText: "Contraseña",
                    obscureText: true),
              ),

              const SizedBox(
                height: 30,
              ),

              // Inicio de sesión
              FadeInUp(
                duration: const Duration(seconds: 2),
                child: MyButton(
                  text: "Iniciar Sesión",
                  linearGradient: LinearGradient(
                      colors: [Colors.green.shade900, Colors.green]),
                  onTap: () async {
                    // Esconder el teclado
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
                                  builder: (context) => const FirstPage(),
                                ),
                              )
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

              FadeInUp(
                duration: const Duration(seconds: 2),
                child: const Text(
                  "O iniciar sesión con:",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              Column(
                children: [
                  FadeInUp(
                    duration: const Duration(seconds: 2),
                    child: LoginWithButton(
                      onTap: () async {
                        GoogleSignInService.googleSignIn();
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FirstPage(),
                            ),
                          );
                        }
                      },
                      text: "Continuar con Google     ",
                      icon: "assets/icons/google_icon.png",
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              // Ir a registro
              FadeInUp(
                duration: const Duration(seconds: 2),
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
