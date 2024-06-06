class Order {
  final int id;
  final int restauranteId;
  final String clienteId;
  final String createdAt;

  Order({
    required this.id,
    required this.restauranteId,
    required this.clienteId,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restauranteId: json['restaurant_id'],
      clienteId: json['client_id'],
      createdAt: json['created_at']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurante_id': restauranteId,
      'cliente_id': clienteId,
      'created_at': createdAt,
    };
  }
}
