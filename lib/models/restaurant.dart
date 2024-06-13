import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/models/cart_food.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Restaurant extends ChangeNotifier {
  final supabaseApi = SupabaseApi();
  final supabase = Supabase.instance.client;
  /*
    G E T T E R S
  */
  List<CartFood> get cart => _cart;
  /*
    O P E R A T I O N S
  */
  // Carrito del usuario
  final List<CartFood> _cart = [];

  // Método para cargar los detalles del carrito
  Future<void> loadCartDetails() async {
    try {
      List<CartFood> cartFoodList = await supabaseApi.getCartFoodDetails();
      _cart.clear();
      _cart.addAll(cartFoodList);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error al cargar los detalles del carrito: $e");
      }
    }
  }

  // Añadir al carrito
  Future<bool> addToCart(Food food, List<Addon> selectedAddons) async {
    try {

      final cartId = await supabaseApi.createCart(); // Crear un carrito en la base de datos

      if (cartId.isNotEmpty) {

        await supabaseApi.addItemToCart(
          cartId,
          food.id,
          selectedAddons.map((addon) => addon.id).toList(),
        );
      
      }  
      
      if (cartId.isEmpty) {

        final supabase = Supabase.instance.client;
        final user = await supabase.auth.getUser();
        //final userId = user.user?.id.toString();

        final existingCart = await supabase
            .from('cart')
            .select('id')
            .eq('is_finished', false)
            .eq('user_id', user.user!.id);

        final existingCartId = existingCart.first['id'];
        if (existingCart.first.isNotEmpty) {
          final itemIsInCart = await supabase
              .from('cart_item')
              .select('*')
              .eq('food_id', food.id);

          if (itemIsInCart.isNotEmpty) {
            final response = await supabase
                .from('cart_item')
                .update({'quantity': itemIsInCart[0]['quantity'] + 1})
                .eq('id', itemIsInCart[0]['id'])
                .select();
            print(response);

            /* await supabaseApi.updateItemCart(
                itemIsInCart[0]["id"],
                selectedAddons.map((addon) => addon.id).toList(),
                itemIsInCart[0]['quantity'] + 1); */
          } else {
            await supabaseApi.addItemToCart(
              existingCartId.toString(),
              food.id,
              selectedAddons.map((addon) => addon.id).toList(),
            );
          }
        } else {
          return false;
        }
      }

      notifyListeners();
      return true; // Indicar que se agregó correctamente al carrito
    } catch (e) {
      return false; // Si hay un error, devolver false
    }
  }

  // Eliminar del carrito
  Future<bool> removeFromCart(CartFood cartFood) async {
    if (cartFood.quantity == 1) {
      return await supabaseApi.removeFromCart(cartFood.id);
    }

    if (cartFood.quantity > 1) {
      await supabase
          .from("cart_item")
          .update({'quantity': cartFood.quantity - 1})
          .eq('id', cartFood.id)
          .eq('food_id', cartFood.food.id);

      return true;
    }

    return false;
  }

  double getTotalPrice() {
    double total = 0.0;

    for (CartFood cartFood in _cart) {
      double itemTotal = cartFood.food.price;

      for (Addon addon in cartFood.addons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartFood.quantity;
    }

    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartFood cartFood in _cart) {
      totalItemCount += cartFood.quantity;
    }

    return totalItemCount;
  }

  void clearCart() async {
    final SupabaseApi supabase = SupabaseApi();
    final cartId = await supabase.getCart();
    await supabase.clearCart(cartId);

    _cart.clear();

    notifyListeners();
  }

  /*
    H E L P E R S
  */

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Aquí tienes tu recibo");
    receipt.writeln();

    String formattedData =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    receipt.writeln(formattedData);
    receipt.writeln();
    receipt.writeln("------------");

    for (final cartFood in _cart) {
      receipt.writeln(
          "${cartFood.quantity} x ${cartFood.food.name} - ${formatPrice(cartFood.food.price)}");
      if (cartFood.addons.isNotEmpty) {
        receipt.writeln(" Complementos: ${_formatAddons(cartFood.addons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("------------");
    receipt.writeln();
    receipt.writeln("Cantidad total: ${getTotalItemCount()}");
    receipt.writeln("Precio total: ${formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  String formatPrice(double price) {
    return "${price.toStringAsFixed(2)} €";
  }

  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${formatPrice(addon.price)})")
        .join(", ");
  }
}
