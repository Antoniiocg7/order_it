import 'package:flutter/material.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {

  final void Function() onTap;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Image.asset(
              'lib/images/Logo.png',
              width: size.width * 1.2,
              height: size.height * 0.5,
            ),

            const SizedBox(height: 25,),

            //message, app slogan
            Text(
              "¡Crea tu cuenta ahora!",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),

            const SizedBox(height: 25,),

            // EMAIL TEXTFIELD
            MyTextField(
              controller: emailController, 
              hintText: "Email", 
              labelText: "Email",
              obscureText: false,
              icon: const Icon(Icons.email),
            ),

            const SizedBox(height: 10,),

            //PASSWORD TEXTFIELD
            MyTextField(
              controller: passwordController, 
              hintText: "Password",
              labelText: "Password",
              obscureText: true,
              icon: const Icon(Icons.password)
            ),

            const SizedBox(height: 10,),

            //CONFIRM PASSWORD TEXTFIELD
            MyTextField(
              controller: confirmPasswordController, 
              hintText: "Confirm password", 
              labelText: "Confirm password",
              obscureText: true,
              icon: const Icon(Icons.password),
            ),

            const SizedBox(height: 10,),
            
            //SIGN Up BUTTON
            MyButton(
              text: "Sign Up",
              onTap: () {

              },
            ),

            const SizedBox(height: 25,),

            // ALREADY HAVE AN ACCOUNT? LOGIN HERE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary
                  ),
                ),
                
                const SizedBox(width: 4,),

                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login Now!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )

              ],
            )

          ],
          
        ),
      ),
    );
  }
}