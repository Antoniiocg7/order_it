
// FOOD ITEM
import 'package:flutter/foundation.dart';

class Food {
  final String name;          
  final String description;
  final String imagePath;     
  final double price;      
  final Enum category;
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

enum FoodCategory {
  burguers,
  sides,
  salads,
  drinks,
  desserts
}

// FOOD ADDONS
class Addon {

  String name;
  double price;

  Addon({
    required this.name,
    required this.price
  });

}