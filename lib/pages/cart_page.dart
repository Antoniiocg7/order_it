import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_cart_tile.dart';
import 'package:order_it/models/cart_food.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/pages/payment_page.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    SupabaseApi().getUserCartDetails();
    SupabaseApi().getCartFood();
    SupabaseApi().getCartFoodAddons();
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        // Carrito
        final userCart = restaurant.cart;
        if (kDebugMode) {
          print(userCart.length);
        }

        return Scaffold(
            appBar: AppBar(
              title: const Text("Carrito"),
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                // Vaciar carrito
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: userCart.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                  "¿Estás seguro de que quieres vaciar el carrito?"),
                              actions: [
                                TextButton(
                                    child: const Text("No"),
                                    onPressed: () => Navigator.pop(context)),
                                TextButton(
                                  child: const Text("Sí"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    restaurant.clearCart();
                                  },
                                )
                              ],
                            ),
                          );
                        },
                )
              ],
            ),
            body: Column(children: [
              Expanded(
                child: Column(
                  children: [
                    (userCart.isEmpty)
                        ? const Expanded(
                            child: Center(child: Text("Carrito vacío")))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: userCart.length,
                              itemBuilder: (context, index) {
                                final cartFood = userCart[index];
                                return MyCartTile(
                                  cartFood: cartFood,
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
              
              
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 211, 211).withOpacity(0.5), // Fondo grisáceo transparente
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BotonPagar(userCart: userCart),

                  
                        
                        Column(
                          children: [
                            Text(
                              '${restaurant.getTotalPrice()} €',
                              
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Text(
                              'TOTAL IMP. INCL*',
                              
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BotonPagar extends StatelessWidget {
  const BotonPagar({
    super.key,
    required this.userCart,
  });

  final List<CartFood> userCart;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color.fromARGB(255, 22, 180, 88),
        ),
      ),
      onPressed: userCart.isEmpty
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentPage(),
                ),
              ),
      child: SizedBox(
        width: 80,
        height: 45,
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'PAGAR',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}