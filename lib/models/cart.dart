class Cart {
  final String id;
  final String userId;
  final String price;
  final bool isFinished;
  //final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    required this.price,
    required this.isFinished,
    //this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      price: json['price'].toString(),
      isFinished: json['is_finished'] as bool,
      /* items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(), */
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'user_id': userId,
      'price': price,
      'is_finished': isFinished,
      //'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
