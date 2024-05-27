import 'dart:convert';
import 'dart:ffi';
import 'package:order_it/models/addon.dart';

class Order {
  final int id;
  final int restauranteId;
  final int clienteId;
  final DateTime createdAt;
  final Array lineasPedido;
  final List<String> addonId;
  List<Addon>? addons;

  Order({
    required this.id,
    required this.restauranteId,
    required this.clienteId,
    required this.createdAt,
    required this.lineasPedido,
    required this.addonId,
    this.addons,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restauranteId: json['restauranteId'],
      clienteId: json['clienteId'],
      createdAt: json['createdAt'],
      lineasPedido: json['lineasPedido'],
      addonId: [
        json['id_addon_1'].toString(),
        json['id_addon_2'].toString(),
        json['id_addon_3'].toString(),
      ].whereType<String>().toList(),
      addons: null,
    );
  }
  
  get http => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restauranteId': restauranteId,
      'clienteId': clienteId,
      'createdAt': createdAt,
      'lineasPedido': lineasPedido,
      'id_addon_1': addonId.isNotEmpty ? addonId[0] : null,
      'id_addon_2': addonId.length > 1 ? addonId[1] : null,
      'id_addon_3': addonId.length > 2 ? addonId[2] : null,
    };
  }

  
}
