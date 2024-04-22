
// FOOD ITEM
class Food {
  final String name;          // HAMBURGUESA CON QUESA
  final String description;   // UNA HAMBURGUESA CON MUCHO QUESO
  final String imagePath;     // lib/images/cheese_burguer.png
  final double price;         // 4,99€
  final FoodCategory category;
  List<Addon> availableAddons;

  Food({
    required this.name, 
    required this.description, 
    required this.imagePath, 
    required this.price,
    required this.category,
    required this.availableAddons
  });

}

// FOOD CATEGORIES

enum FoodCategory {
  burguers,
  salads,
  sides,
  desserts,
  drinks
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