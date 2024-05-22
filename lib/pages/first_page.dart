import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order_it/pages/call_waiter.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Order It!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        //todo: action: logout
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //todo: Nombre de usuario
            SizedBox(height: size.height * 0.05),
            const Text(
              'Bienvenido xxx',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: size.height * 0.1),

            const Text(
              '¡Usted elije como ser atendido!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: size.height * 0.1),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Primer contenedor y texto
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CallWaiter()),
                        );
                      },
                      icon: Lottie.network(
                        "https://lottie.host/41971476-4e70-415a-84be-f27724801f80/Pr23iBZ13J.json",
                        height: 150,
                        width: 150,
                      ),
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Llamar a un camarero',
                      style: TextStyle(fontSize: 17, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // Segundo contenedor y texto
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Lottie.network(
                        "https://lottie.host/21421179-7764-42b8-8c26-afe8e5c115a9/mr4rrQa9mX.json",
                        height: 150,
                        width: 150,
                      ),
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pedir Online',
                      style: TextStyle(fontSize: 17, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
