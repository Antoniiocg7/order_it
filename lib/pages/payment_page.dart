import 'package:flutter/material.dart';
import 'package:order_it/models/cart_food.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/pages/delivery_progress_page.dart';
import 'package:order_it/pages/home_page.dart';
import 'package:order_it/pages/stripe_services.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final List<CartFood> userCart;
  static const double iva = 0.10;

  const PaymentPage({super.key, required this.userCart});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final List<CartFood> userCart = restaurant.getUserCart;
        final subtotal = (restaurant.getTotalPrice());
        final totalStr = restaurant.formatPrice(subtotal * 1.10);
        final totalDouble = subtotal * 1.10;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirma tu pago'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(ordersAllowed: true),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.cancel_rounded,
                  size: 25,
                ),
              )
            ],
            titleSpacing: 5.2,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Tu carrito',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: userCart.map((cartFood) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        cartFood.food.imagePath,
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      cartFood.food.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${restaurant.formatPrice(cartFood.food.price * cartFood.quantity)} (${cartFood.quantity} uds.) ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (cartFood.addons.isNotEmpty)
                                SizedBox(
                                  height: 50,
                                  child: cartFood.addons.isEmpty
                                      ? null
                                      : ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: cartFood.addons
                                              .map(
                                                (addon) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: FilterChip(
                                                    label: Row(
                                                      children: [
                                                        Text(addon.name,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            " (${addon.price.toString()}) €",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary))
                                                      ],
                                                    ),
                                                    onSelected: (value) {},
                                                    shape: StadiumBorder(
                                                      side: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    labelStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${restaurant.formatPrice(subtotal)} ',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 16),
                  const Divider(height: 2),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        restaurant.formatPrice(subtotal),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 225),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Mostrar la pantalla de carga
                          showLoadingDialog(context);

                          // Iniciar el proceso de pago con Stripe
                          await StripeService.stripePaymentCheckout(
                            userCart,
                            totalStr,
                            context,
                            mounted,
                            onSuccess: () async {
                              final SupabaseApi supabaseApi = SupabaseApi();

                              // Guardar el carrito en Supabase
                              await supabaseApi.createCart(
                                  restaurant.getUserCart, totalDouble);

                              // Cerrar la pantalla de carga
                              Navigator.pop(context);

                              // Verificar si el contexto está montado antes de navegar
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DeliveryProgressPage(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 14, 80, 44),
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text('Finalizar compra'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Procesando..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
