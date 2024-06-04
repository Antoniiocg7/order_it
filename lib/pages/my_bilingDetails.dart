import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:order_it/models/order.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Importing the Order class

class MyBilingdetails extends StatefulWidget {
  const MyBilingdetails({super.key});

  @override
  State<MyBilingdetails> createState() => _MyBilingdetailsState();
}

class _MyBilingdetailsState extends State<MyBilingdetails> {
  final PageController _pageController = PageController();
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
    )
    // Add more Order instances here as needed
  ];

  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos de pago'),
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
      body: _showForm ? _buildForm() : _buildPageView(),
    );
  }

  Widget _buildPageView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
        ),
        SizedBox(
          height: 250,
          width: 350, // Ajusta la altura del contenedor del PageView
          child: PageView.builder(
            controller: _pageController,
            itemCount: pedidos.length + 1, // Añadir uno para el botón
            itemBuilder: (context, index) {
              if (index < pedidos.length) {
                final pedido = pedidos[index];
                return GestureDetector(
                  onTap: () {
                    // Acción al tocar un pedido
                    print('Pedido tocado: ${pedido.establecimiento}');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    width: 280, // Puedes ajustar el ancho aquí
                    height: 180, // Puedes ajustar la altura aquí
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade900,
                          const Color.fromARGB(255, 81, 140, 199)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(
                              0, 3), // Cambia la posición de la sombra
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'VISA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Image.asset(
                                'lib/images/application/visa.png',
                                width: 60,
                                height: 35,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '**** 1234',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                '12/25',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Joaquin Segura',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.all(16.0),
                  width: 280, // Misma anchura que el card
                  height: 180, // Misma altura que el card
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showForm = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Mismos bordes redondeados que el card
                        side: const BorderSide(color: Colors.blueAccent, width: 2), // Borde con grosor 2
                      ),
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.add,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Añadir método de pago',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 16), // Espacio entre el PageView y el indicador
        SmoothPageIndicator(
          controller: _pageController,
          count: pedidos.length + 1, // Número de páginas (pedidos + botón)
          effect: WormEffect(
            dotWidth: 12,
            dotHeight: 12,
            activeDotColor: Colors.blue.shade900,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Añadir método de pago',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de tarjeta',
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fecha de expiración',
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Acción para guardar el método de pago
              print('Guardar método de pago');
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
