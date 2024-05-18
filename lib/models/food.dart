
// FOOD ITEM
import 'package:order_it/models/addon.dart';

class Food {
  final String name;          // HAMBURGUESA CON QUESA
  final String description;   // UNA HAMBURGUESA CON MUCHO QUESO
  final String imagePath;     // lib/images/cheese_burguer.png
  final double price;         // 4,99€
  final String categoryId;
  List<Addon> availableAddons;

  Food({
    required this.name, 
    required this.description, 
    required this.imagePath, 
    required this.price,
    required this.categoryId,
    required this.availableAddons
  });

}
