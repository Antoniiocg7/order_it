import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/components/my_cart_tile.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/pages/payment_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        // CART
        final userCart = restaurant.cart;


        // SCAFFOLD UI
        return Scaffold(
          appBar: AppBar(
            title: const Text("Cart"),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // CLEAR CART BUTTON
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (context) => AlertDialog(
                      title: const Text("Are you sure you want to clear the cart?"),
                      actions: [
                        // CANCEL BUTTON
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context)
                        ),

                        // ACCEPT BUTTON
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            Navigator.pop(context);
                            restaurant.clearCart();
                          } 
                        )
                      ],
                    )
                  );
                }
              )
            ],
          ),
          body: Column(

            // LIST OF CART
            children: [
              Expanded(
                child: Column(
                  children: [
                    (userCart.isEmpty) 
                    ? const Expanded(child: Center(child: Text("Cart is empty..."))) 
                    : Expanded(
                      child: ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                
                          // GET INDIVIDUAL CART ITEM
                          final cartItem = userCart[index];
                
                          // RETURN CART TILE UI
                          return MyCartTile(
                            cartItem: cartItem,
                          );
                        }
                      )
                    )
                  ],
                ),
              ),

              // BUTTON TO PAY
              MyButton(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentPage())), 
                text: "Go to checkout"
              ),

              const SizedBox( height: 25 )
            ],
          ),
        );
      },
    );
  }
}