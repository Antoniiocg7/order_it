import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_it/controllers/user_controller.dart';
import 'package:order_it/models/usuario.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyBilingdetails extends StatefulWidget {
  const MyBilingdetails({super.key});

  @override
  State<MyBilingdetails> createState() => _MyBilingdetailsState();
}

class _MyBilingdetailsState extends State<MyBilingdetails> {
  final UserController userController = UserController();
  late Future<User> user;

  final PageController _pageController = PageController();

  final bool _showForm = false;

  @override
  void initState() {
    super.initState();
    user = userController.getUser('segurajoaquinm@gmail.com');

    // Obtener datos del usuario al inicializar el estado
  }

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
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Acción de refrescar la lista
            },
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _showForm ? _buildForm() : _buildPageView(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPageView(User user) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
        ),
        SizedBox(
          height: 250,
          width: 350,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 1, // Solo un elemento para los datos del usuario
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Acción al tocar los datos del usuario
                },
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  width: 280,
                  height: 180,
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
                        offset: const Offset(0, 3),
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
                            Text(
                              user.creditCard[0]["tipo"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.creditCard[0]
                                  ["numero"], // ${user.cardLast4Digits},
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              user.creditCard[0]
                                  ["vencimiento"], //user.cardExpiration,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              user.creditCard[0]
                                  ["titular"], //user.cardHolderName,
                              style: const TextStyle(
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
            },
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: 1,
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
              if (kDebugMode) {
                print('Guardar método de pago');
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
