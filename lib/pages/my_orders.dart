import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:order_it/models/order.dart'; // Importing the Order class

class MyOrders extends StatelessWidget {
  final List<Order> pedidos = [
    Order(
      id: 1,
      restauranteId: 1,
      clienteId: 1,
      createdAt: DateTime.now(),
      lineasPedido: const Array<Int32>(4, 2, 4, 8),
      addonId: ["1"],
      addons: null,
    ),
    Order(
      id: 1,
      restauranteId: 1,
      clienteId: 1,
      createdAt: DateTime.now(),
      lineasPedido: const Array<Int32>(4, 2, 4, 8),
      addonId: ["1"],
      addons: null,
    ),
    Order(
      id: 1,
      restauranteId: 1,
      clienteId: 1,
      createdAt: DateTime.now(),
      lineasPedido: const Array<Int32>(4, 2, 4, 8),
      addonId: ["1"],
      addons: null,
    ),
    Order(
      id: 1,
      restauranteId: 1,
      clienteId: 1,
      createdAt: DateTime.now(),
      lineasPedido: const Array<Int32>(4, 2, 4, 8),
      addonId: ["1"],
      addons: null,
    ),
    // Add more Order instances here as needed
  ];

  MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Acción de refrescar la lista
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(26.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Todos los pedidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return GestureDetector(
                  onTap: () {
                    // Acción al tocar un pedido
                    print('Pedido tocado: ${pedido.establecimiento}');
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        // Use your own logic to set the image here
                        // Here I'm just showing the establishment ID as an example
                        child: Text(""
                            //pedido.restauranteId.toString()
                            ),
                      ),
                      title: const Text('Alifornia Poke'),
                      subtitle:
                          const Text('Importe · 155,85€ \n03 dic · Pendiente'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Acción de ver el establecimiento
                        },
                        child: const Text('Ver establecim...'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
