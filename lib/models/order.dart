import 'dart:ffi';

class Order {
  final int id;
  final String userId;
  final String createdAt;
  final Float? price;
  final bool isFinished;


  Order({
    required this.id,
    required this.userId,
    required this.isFinished,
    required this.createdAt,
    this.price
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        userId: json['user_id'],
        isFinished: json['is_finished'],
        createdAt: json['created_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_finished': isFinished,
      'created_at': createdAt,
    };
  }
}
