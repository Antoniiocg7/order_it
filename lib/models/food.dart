import 'package:order_it/models/addon.dart';

class Food {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final String categoryId;
  final List<String> addonIds;
  List<Addon>? addons;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.categoryId,
    required this.addonIds,
    this.addons,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      imagePath: json['imagepath'],
      price: json['price'],
      categoryId: json['category_id'].toString(),
      addonIds: [
        json['id_addon_1'].toString(),
        json['id_addon_2'].toString(),
        json['id_addon_3'].toString(),
      ].whereType<String>().toList(),
      addons: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'name': name,
      'description': description,
      'imagepath': imagePath,
      'price': price,
      'category_id': int.parse(categoryId),
      'id_addon_1': addonIds.isNotEmpty ? addonIds[0] : null,
      'id_addon_2': addonIds.length > 1 ? addonIds[1] : null,
      'id_addon_3': addonIds.length > 2 ? addonIds[2] : null,
    };
  }
}
