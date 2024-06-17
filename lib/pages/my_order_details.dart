import 'package:flutter/material.dart';
import 'package:order_it/controllers/order_controller.dart';
import 'package:order_it/models/cart.dart';
import 'package:order_it/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class MyOrderDetails extends StatefulWidget {
  final Cart cart;

  const MyOrderDetails({super.key, required this.cart});

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  final OrderController orderController = OrderController();
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'Resumen de tu pedido',
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                      Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      Text(
                        '${cart.price} €',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
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
                      child: FuturBuild(),
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

  FutureBuilder<List<Map<String, dynamic>>> FuturBuild() {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: foods.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 244, 242, 242),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [

                                          const SizedBox(height: 15,),

                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Plato
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                  child: Image.asset(
                                                    foods[index]['imagepath'],
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                // Nombre y precio
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        foods[index]['name'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            fontSize: 16,
                                                            color: Colors.black),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // Addons
                                          if (foods[index]["addons"] != null)
                                            Container(
                                              decoration: BoxDecoration( color: const Color.fromARGB(255, 244, 241, 241),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        76.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10.0),
                                                child: SizedBox(
                                                  height: 60,
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children:
                                                        (foods[index]
                                                                    ['addons']
                                                                as List)
                                                            .map(
                                                              (addon) =>
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0),
                                                                child:
                                                                    FilterChip(
                                                                  label: Row(
                                                                    children: [
                                                                      Text(
                                                                        addon[
                                                                            'name'],
                                                                        style:
                                                                            TextStyle(color: Colors.black),
                                                                      ),
                                                                      Text(
                                                                          " (${addon['price'].toString()})€",
                                                                          style:
                                                                              TextStyle(color: Colors.black))
                                                                    ],
                                                                  ),
                                                                  onSelected:
                                                                      (value) {},
                                                                  shape:
                                                                      StadiumBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color: Theme.of(context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white
                                                                  /* Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary */
                                                                  ,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black
                                                                    /* Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSecondary */
                                                                    ,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                        
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    );
  }
}
