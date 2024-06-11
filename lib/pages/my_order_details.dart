import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:order_it/models/cart.dart';

class MyOrderDetails extends StatefulWidget {
  final Cart cart;

  const MyOrderDetails({super.key, required this.cart});

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Resumen de tu pedido'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(6.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cart.price,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(
                  indent: 50,
                  endIndent: 50,
                  height: 32,
                  thickness: 2,
                  color: Colors.green,
                ),
                const Card(
                    child: Column(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      'Principal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Menú Poke - Salmón BBQ Grande 2,00 €',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Extras',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Arroz sushi 0,00 €',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    SizedBox(height: 4),
                  ],
                ))
              ])
            ])),
      ),
    );
  }
}
