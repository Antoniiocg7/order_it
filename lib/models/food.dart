
// FOOD ITEM
import 'package:flutter/foundation.dart';

class Food {
  final String name;          
  final String description;
  final String imagePath;     
  final double price;      
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



// FOOD ADDONS
class Addon {

  String name;
  double price;

  Addon({
    required this.name,
    required this.price
  });

}