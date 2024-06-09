import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order_it/pages/home_page.dart';

class CallWaiter extends StatelessWidget {
  
  const CallWaiter({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Center(
                child: Text(
                  'Nuestro camarero le atenderá enseguida, gracias por su paciencia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ),
            LottieBuilder.network(
              "https://lottie.host/e68cfcf9-06a6-41b6-a07b-2af798939f28/W6MR3uvtV7.json",
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(ordersAllowed: false),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Ver la carta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
