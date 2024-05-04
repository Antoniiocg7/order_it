import 'package:flutter/material.dart';
import 'package:order_it/pages/home_page.dart';

class CallWaiter extends StatelessWidget {
  const CallWaiter({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order It!', style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.green,
        //todo: action: logout
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.3, // 30% de la altura de la pantalla
              child: const Center(
                child: Text(
                  'Nuestro camarero le atenderá enseguida, gracias por su paciencia',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_tree,
                    size: size.width * 0.3, // Ajustar tamaño del icono según necesites
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage())
                      );
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}