import 'package:flutter/material.dart';
import 'package:order_it/controllers/order_controller.dart';
import 'package:order_it/models/cart.dart';
import 'package:order_it/services/supabase_api.dart';

class MyOrderDetails extends StatefulWidget {
  final Cart cart;

  const MyOrderDetails({super.key, required this.cart});

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  final OrderController orderController = OrderController();
  final SupabaseApi supabaseApi = SupabaseApi();
  late Future<List<Map<String, dynamic>>> futureCartFood;

  @override
  void initState() {
    super.initState();
    futureCartFood = orderController.fetchCartFood(widget.cart.id);
  }

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        '${cart.price} €',
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
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height *
                          0.5, // Added height constraint
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: futureCartFood,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No hay pedidos disponibles.'));
                          } else {
                            final foods = snapshot.data!;
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Principal',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: foods.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${foods[index]["name"]} x ${foods[index]["quantity"]} - ${foods[index]["price"] * foods[index]["quantity"]} € \n${foods[index]["price"]}  €',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
