import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order_it/pages/call_waiter.dart';
import 'package:order_it/pages/home_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                '¡Usted elije como ser atendido!',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Contenedor llamar camarero
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CallWaiter(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Lottie.network(
                            height: 275,
                            width: 275,
                            "https://lottie.host/41971476-4e70-415a-84be-f27724801f80/Pr23iBZ13J.json",
                          ),
                          const Text(
                            'Llamar a un camarero',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  // Contenedor Pedir Online
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Lottie.network(
                            height: 275,
                            width: 275,
                            "https://lottie.host/21421179-7764-42b8-8c26-afe8e5c115a9/mr4rrQa9mX.json",
                          ),
                          const Text(
                            'Pedir Online',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
