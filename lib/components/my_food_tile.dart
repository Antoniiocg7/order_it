import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:order_it/models/food.dart';

class FoodTile extends StatelessWidget {

  final Food food;
  final void Function()? onTap;

  const FoodTile({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
            
                // TEXT FOOD DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.name),
                      Text(
                        "${food.price}€", 
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                      Text(
                        food.description, 
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                      )
                    ],
                  )
                ),

                const SizedBox( width: 15 ),
            
                // FOOD IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    food.imagePath,
                    height: 130,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          ),
        ),

        // DIVIDER LINE
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
          endIndent: 25,
          indent: 25,
        )
      ],
    );
  }
}