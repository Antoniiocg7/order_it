class CartItem {
  final String id; // Si hay un ID específico para el ítem del carrito
  final String cartId;
  final String foodId;
  final int quantity;

  CartItem({
    required this.id,
    required this.cartId,
    required this.foodId,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(), // Ajusta según corresponda
      cartId: json['cart_id'].toString(), // Ajusta según corresponda
      foodId: json['food_id'].toString(),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'food_id': foodId,
      'quantity': quantity,
    };
  }
}
