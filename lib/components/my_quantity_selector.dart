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
        borderRadius: BorderRadius.circular( 25 ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Botón decrementar
          GestureDetector(
            onTap: onDecrement,
            child: Icon(
              quantity == 1? Icons.delete : Icons.remove,
              size: 20,
              color: quantity == 1? Colors.red.shade400: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Contador de cantidad
          Padding(
          
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              
              height: 20,
              width: 25,
              child: Center(
              
                child: Text(quantity.toString()),
              ),
            ),
          ),

          // Botón incrementar
          GestureDetector(
            onTap: onIncrement,
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
