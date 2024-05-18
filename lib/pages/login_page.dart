import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_textfield.dart';
import 'package:order_it/controllers/auth/login_controller.dart';

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

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //logo
              FadeInDown(
                duration: const Duration( seconds: 2),
                child: Image.asset(
                  'lib/images/application/Logo.png',
                  width: size.width * 1.2,
                  height: size.height * 0.5,
                ),
              ),
        
              const SizedBox(height: 0),
        
              // EMAIL TEXTFIELD
              FadeInRight(
                duration: const Duration( seconds: 1),
                child: MyTextField(
                  controller: emailController, 
                  hintText: "Email", 
                  labelText: "Email",
                  obscureText: false,
                  icon: Icons.email
                ),
              ),
        
              const SizedBox(height: 20,),
        
              //PASSWORD TEXTFIELD
              FadeInLeft(
                duration: const Duration( seconds: 1),
                child: MyTextField(
                  controller: passwordController, 
                  hintText: "Password", 
                  labelText: "Password",
                  obscureText: true,
                  icon: Icons.password
                ),
              ),
        
              const SizedBox(height: 50,),
              
              //SIGN IN BUTTON
              FadeInUp(
                duration: const Duration( seconds: 1),
                child: MyButton(
                  text: "Iniciar Sesión",
                  onTap: () {
                    loginController.login(context, emailController.text, passwordController.text);
                  },
                ),
              ),
        
              const SizedBox(height: 25,),
        
              // NOT A MEMEBER? REGISTER NOW!
              FadeInUp(
                duration: const Duration( seconds: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text(
                      "¿No eres miembro?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    ),
                    
                    const SizedBox(width: 4),
                
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Regístrate",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold
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