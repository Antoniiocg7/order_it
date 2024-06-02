import 'package:order_it/models/cart_item.dart';

class Cart {
  final String id;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
