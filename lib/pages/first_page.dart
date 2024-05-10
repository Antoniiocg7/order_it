import 'package:flutter/material.dart';
import 'package:order_it/pages/call_waiter.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order It!', style: TextStyle(fontSize: 20, color: Colors.white) ),
        backgroundColor: Colors.green,
        //todo: action: logout
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //todo: Nombre de usuario
            SizedBox( height: size.height * 0.05),
            const Text(
              'Bienvenido xxx',
              style: TextStyle( fontSize: 20, color: Colors.white ),
              textAlign: TextAlign.center
            ),
            
            SizedBox( height: size.height * 0.1),

            const Text('¡Usted elije como ser atendido!', style: TextStyle( fontSize: 20, color: Colors.white), textAlign: TextAlign.center),

            SizedBox( height: size.height * 0.1),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Primer contenedor y texto
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      height: size.height * 0.3,
                      color: Colors.blue,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CallWaiter()),
                          );
                        },
                        icon: Image.asset(
                          'lib/images/application/camarero.png',
                          width: 200,
                          height: size.height * 0.5,
                        ),
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Llamar a un camarero',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // Segundo contenedor y texto
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      height: size.height * 0.3,
                      color: Colors.red,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'lib/images/application/QR.png',
                          width: 200,
                          height: size.height * 0.5,
                        ),
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pedir Online',
                      style: TextStyle(fontSize: 17, color: Colors.white),
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