import 'package:flutter/material.dart';
import 'package:order_it/components/my_cart_tile.dart';
import 'package:order_it/models/cart_food.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/pages/payment_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = _sortCartByInsertionOrder(restaurant.cart);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Carrito"),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
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
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text("Sí"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  restaurant.clearCart();
                                },
                              ),
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
                child: userCart.isEmpty
                    ? const Center(child: Text("Carrito vacío"))
                    : ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          final cartFood = userCart[index];
                          return MyCartTile(cartFood: cartFood);
                        },
                      ),
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 211, 211)
                      .withOpacity(0.5),
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
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [
                        BotonPagar(userCart: userCart),
                        Column(
                          children: [
                            Text(
                              restaurant.formatPrice(
                                  restaurant.getTotalPrice()),
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

  List<CartFood> _sortCartByInsertionOrder(List<CartFood> cart) {
    cart.sort((a, b) => a.food.id.compareTo(b.food.id));
    return cart;
  }
}

class BotonPagar extends StatelessWidget {
  const BotonPagar({
    Key? key,
    required this.userCart,
  }) : super(key: key);

  final List<CartFood> userCart;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 19, 160, 78),
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
