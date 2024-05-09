import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            FadeInDown(
              child: Image.asset(
                'lib/images/Logo.png',
                width: size.width * 1.2,
                height: size.height * 0.5,
              ),
            ),

            const SizedBox(height: 25,),

            // EMAIL TEXTFIELD
            FadeInRight(
              child: MyTextField(
                controller: emailController, 
                hintText: "Email", 
                labelText: "Email",
                obscureText: false,
                icon: Icons.email
              ),
            ),

            const SizedBox(height: 10,),

            //PASSWORD TEXTFIELD
            FadeInLeft(
              child: MyTextField(
                controller: passwordController, 
                hintText: "Password", 
                labelText: "Password",
                obscureText: true,
                icon: Icons.password
              ),
            ),

            const SizedBox(height: 10,),
            
            //SIGN IN BUTTON
            FadeInUp(
              child: MyButton(
                text: "Sign In",
                onTap: () {
                  login();
                },
              ),
            ),

            const SizedBox(height: 25,),

            // NOT A MEMEBER? REGISTER NOW!
            FadeInUp(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text(
                    "Not a member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  
                  const SizedBox(width: 4,),
              
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Registe now!",
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
    );
  }
}