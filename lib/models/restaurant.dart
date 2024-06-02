import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/models/cart_item.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:order_it/utils/random_id.dart';

class Restaurant extends ChangeNotifier {
  final supabaseApi = SupabaseApi();
  /*
    G E T T E R S
  */
  List<CartItem> get cart => _cart;
  /*
    O P E R A T I O N S
  */
  // USER CART
  final List<CartItem> _cart = [];

  // ADD TO CART
  Future<bool> addToCart(Food food, List<Addon> selectedAddons) async {
    try {
      final cartId = await supabaseApi
          .createCart(); // Crear un carrito en la base de datos
      if (cartId != false) {
        await supabaseApi.addItemToCart(
          RandomIds.generateRandomId().toString(),
          food.id,
          selectedAddons.map((addon) => addon.id).toList(),
        );
      } else {
        return false;
      }

      notifyListeners();
      return true; // Indicar que se agregó correctamente al carrito
    } catch (e) {
      return false; // Si hay un error, devolver false
    }
  }

  // REMOVE FROM CART
  Future<bool> removeFromCart(CartItem cartItem) async {
    try {
      // Eliminar el ítem del carrito en la base de datos
      await supabaseApi.removeFromCart(cartItem.id);

      notifyListeners();
      return true; // Indicar que se eliminó correctamente del carrito
    } catch (e) {
      return false; // Si hay un error, devolver false
    }
  }

  // GET TOTAL PRICE OF CART
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.addons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  // GET TOTAL NUMBER OF ITEMS IN CART
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  // CLEAR CART
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /*
    H E L P E R S
  */

  // GENERATE A RECEIPT
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt");
    receipt.writeln();

    // FORMAT THE DATE TO INCLUDE UP TO SECONDS ONLY
    String formattedData =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    receipt.writeln(formattedData);
    receipt.writeln();
    receipt.writeln("------------");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.addons.isNotEmpty) {
        receipt.writeln(" Add-ons: ${_formatAddons(cartItem.addons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("------------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  // FORMAT DOUBLE VALUE INTO MONEY
  String _formatPrice(double price) {
    return "${price.toStringAsFixed(2)}€";
  }

  // FORMAT LIST OF ADDONS INTO A STRING SUMMARY
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
