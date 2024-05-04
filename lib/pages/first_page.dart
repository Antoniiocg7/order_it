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
          children: [
            //todo: Nombre de usuario
            SizedBox( height: size.height * 0.05),
            const Text('Bienvenido xxx', style: TextStyle( fontSize: 20 ), textAlign: TextAlign.center),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
        
                Container(
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  color: Colors.blue,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CallWaiter())
                      );
                    },
                    icon: const Icon(Icons.person),
                    color: Colors.black,
                  ),
                ),
        
                Container(
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  color: Colors.red,
                  child: IconButton(
                    onPressed: () {
                      
                    },
                    icon: const Icon(Icons.qr_code),
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