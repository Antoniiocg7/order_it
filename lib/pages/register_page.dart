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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.lock_open_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25,),

            //message, app slogan
            Text(
              "Let´s create an account for you!",
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
              obscureText: false
            ),

            const SizedBox(height: 10,),

            //PASSWORD TEXTFIELD
            MyTextField(
              controller: passwordController, 
              hintText: "Password", 
              obscureText: true
            ),

            const SizedBox(height: 10,),

            //CONFIRM PASSWORD TEXTFIELD
            MyTextField(
              controller: confirmPasswordController, 
              hintText: "Confirm password", 
              obscureText: true
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