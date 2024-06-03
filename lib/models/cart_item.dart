import 'package:order_it/models/addon.dart';
import 'package:order_it/models/food.dart';

class CartItem {
  final String id; // Si hay un ID específico para el ítem del carrito
  final Food food;
  final List<Addon> addons;
  int quantity;

  CartItem({
    required this.id,
    required this.food,
    required this.addons,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(), // Ajusta según corresponda
      food: Food.fromJson(json['food']), // Ajusta según corresponda
      addons: (json['addons'] as List<dynamic>)
          .map((addonJson) => Addon.fromJson(addonJson))
          .toList(),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'addons': addons.map((addon) => addon.toJson()).toList(),
      'quantity': quantity,
    };
  }
}
