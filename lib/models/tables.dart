class Tables {
  final String id;
  final bool? isOccupated; // Permitir nulos
  final String? userId;       // Permitir nulos
  final int tableNumber;

  Tables({
    required this.id,
    this.isOccupated,
    this.userId,
    required this.tableNumber,
  });

  factory Tables.fromJson(Map<String, dynamic> json) {
    return Tables(
      id: json['id'].toString(),
      isOccupated: json['is_occupied'],
      userId: json['user_id'],
      tableNumber: json['table_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'isOccupated': isOccupated,
      'userId': userId,
      'tableNumber': tableNumber,
    };
  }
}
