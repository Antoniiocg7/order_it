import 'package:flutter/material.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_textfield.dart';
import 'package:order_it/pages/home_page.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;


  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login(){
    /*
      Fill authentication
    */

    //Navigate to Home Page
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => const HomePage() )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
              "Food Delivery App",
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
            
            //SIGN IN BUTTON
            MyButton(
              text: "Iniciar Sesion",
              onTap: () {
                login();
              },
            ),

            const SizedBox(height: 25,),

            // NOT A MEMEBER? REGISTER NOW!
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(
                  "¿Aun no estás registrado? Únete a la familia",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary
                  ),
                ),
                
                const SizedBox(width: 4,),

                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "¡Registrate ya!",
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