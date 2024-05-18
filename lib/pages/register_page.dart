import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_textfield.dart';
import 'package:order_it/controllers/auth/register_controller.dart';

class RegisterPage extends StatelessWidget {

  final void Function() onTap;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final registerController = RegisterController();

  RegisterPage({super.key, required this.onTap});

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
                  height: size.height * 0.4,
                ),
              ),
        
              //const SizedBox(height: 10),
        
              //message, app slogan
              FadeInLeft(
                duration: const Duration( seconds: 1),
                child: Text(
                  "¡Crea tu cuenta ahora!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary
                  ),
                ),
              ),
        
              const SizedBox(height: 25,),
        
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
        
              const SizedBox(height: 20,),
        
              //CONFIRM PASSWORD TEXTFIELD
              FadeInRight(
                duration: const Duration( seconds: 1),
                child: MyTextField(
                  controller: confirmPasswordController, 
                  hintText: "Confirm password", 
                  labelText: "Confirm password",
                  obscureText: true,
                  icon: Icons.password
                ),
              ),
        
              const SizedBox(height: 45,),
              
              //SIGN Up BUTTON
              FadeInUp(
                duration: const Duration( seconds: 1),
                child: MyButton(
                  text: "Registrar",
                  onTap: () {
                    registerController.register(emailController.text, passwordController.text);
                  },
                ),
              ),
        
              const SizedBox(height: 25,),
        
              // ALREADY HAVE AN ACCOUNT? LOGIN HERE
              FadeInUp(
                duration: const Duration( seconds: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text(
                      "¿Ya tienes cuenta?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    ),
                    
                    const SizedBox(width: 4,),
                
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "Inicia sesión",
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