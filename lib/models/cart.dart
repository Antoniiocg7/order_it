import 'package:order_it/models/cart_item.dart';

class Cart {
  final String id;
  final String userId;
  final String price;
  final bool isFinished;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    required this.price,
    required this.isFinished,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      price: json['price'].toString(),
      isFinished: json['isFinished'] as bool,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'userId': userId,
      'price': price,
      'isFinished': isFinished,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
