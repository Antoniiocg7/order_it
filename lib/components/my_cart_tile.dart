import 'package:flutter/material.dart';
import 'package:order_it/components/my_quantity_selector.dart';
import 'package:order_it/models/cart_item.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOOD IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      cartItem.food.imagePath,
                      width: 100,
                      height: 100,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // NAME AND PRICE
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            cartItem.food.name,
                          ),
                        ],
                      ),
                      // NAME

                      const SizedBox(
                        height: 30,
                      ),
                      // INCREMENT OR DECREMENT QUANTITY
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          // PRICE
                          Text(
                            "${cartItem.food.price}€",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),

                          const SizedBox(
                            width: 90,
                          ),
                          QuantitySelector(
                            quantity: cartItem.quantity,
                            food: cartItem.food,
                            onIncrement: () {
                              restaurant.addToCart(
                                  cartItem.food, cartItem.selectedAddons);
                            },
                            onDecrement: () {
                              restaurant.removeFromCart(cartItem);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ADDONS
            SizedBox(
              height: cartItem.selectedAddons.isEmpty ? 0 : 60,
              child: ListView(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                scrollDirection: Axis.horizontal,
                children: cartItem.selectedAddons
                    .map(
                      (addon) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Row(
                            children: [
                              // ADDON NAME
                              Text(addon.name),

                              // ADDON PRICE
                              Text(" (${addon.price.toString()})€")
                            ],
                          ),
                          onSelected: (value) {},
                          shape: StadiumBorder(
                              side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          labelStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
