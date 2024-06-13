import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_cart_tile.dart';
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
            title: const Text("Cart"),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // Vaciar carrito
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
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
          body: Column(
            children: [
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

              MyButton(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage(),
                  ),
                ),
                text: "Pagar",
              ),

              const SizedBox(height: 25)
            ],
          ),
        );
      },
    );
  }
}
