import 'package:flutter/material.dart';
import 'package:order_it/models/food.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Food food;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector(
      {super.key,
        required this.quantity,
        required this.food,
        required this.onIncrement,
        required this.onDecrement
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular( 50 ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Botón decrementar
          GestureDetector(
            onTap: onDecrement,
            child: Icon(
              Icons.remove,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Contador de cantidad
          Padding(
          
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SizedBox(
              
              width: 30,
              child: Center(
              
                child: Text(quantity.toString()),
              ),
            ),
          ),

          // Botón incrementar
          GestureDetector(
            onTap: 
            onIncrement,
            child: Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
