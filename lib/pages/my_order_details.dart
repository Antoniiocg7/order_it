import 'package:flutter/material.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '1',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Menú GRANDE Receta',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      '17,90 €',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige 1',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Menú Poke - Salmón BBQ Grande 2,00 €',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige la base de tu poke',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Arroz sushi 0,00 €',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige la bebida para tu menú poke',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cerveza Levante 0,00 €',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige tu postre para tu menú poke',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cheese cake 1,00 €',
                  style: TextStyle(fontSize: 14),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
