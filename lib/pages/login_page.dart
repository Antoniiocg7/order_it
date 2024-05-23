import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:order_it/components/login_with_button.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_textfield.dart';
import 'package:order_it/controllers/auth/login_controller.dart';
import 'package:order_it/pages/home_page.dart';
import 'package:order_it/services/google_sign_in.dart';
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
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                  'lib/images/application/Logo.png',
                  width: size.width * 1.2,
                  height: size.height * 0.35,
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
                    obscureText: false),
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
                height: 20,
              ),

              //SIGN IN BUTTON
              FadeInUp(
                duration: const Duration(seconds: 1),
                child: MyButton(
                  text: "Iniciar Sesión",
                  linearGradient: LinearGradient(
                      colors: [Colors.green.shade900, Colors.green]),
                  onTap: () {
                    loginController.login(
                      context,
                      emailController.text,
                      passwordController.text,
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 15,
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
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginWithButton(
                    onTap: () {
                    GoogleSignInService.googleSignIn();
                    },
                    
                    icon: "assets/icons/google_icon.png",
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  LoginWithButton(
                    onTap: () {},
                    text: "Continuar con Facebook",
                    icon: "assets/icons/facebook_icon.png",
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  LoginWithButton(
                    onTap: () {},
                    text: "   Continuar con Apple",
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
