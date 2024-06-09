import 'package:flutter/foundation.dart';
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
  // USER CART
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
        print("Error loading cart details: $e");
      }
    }
  }

  // ADD TO CART
  Future<bool> addToCart(Food food, List<Addon> selectedAddons) async {
    try {
      final cartId = await supabaseApi
          .createCart(); // Crear un carrito en la base de datos

      if (cartId != "") {
        await supabaseApi.addItemToCart(
          cartId,
          food.id,
          selectedAddons.map((addon) => addon.id).toList(),
        );
      } else {
        final existingCart =
            await supabase.from('cart').select('id').eq('is_finished', false);
        final existingCartId = existingCart.first['id'];
        if (existingCart.first.isNotEmpty) {
          await supabaseApi.addItemToCart(
            existingCartId.toString(),
            food.id,
            selectedAddons.map((addon) => addon.id).toList(),
          );
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

  // REMOVE FROM CART
  Future<bool> removeFromCart(CartFood cartFood) async {
    try {
      // Eliminar el ítem del carrito en la base de datos
      await supabaseApi.removeFromCart(cartFood.id);

      notifyListeners();
      return true; // Indicar que se eliminó correctamente del carrito
    } catch (e) {
      return false; // Si hay un error, devolver false
    }
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


  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /*
    H E L P E R S
  */


  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt");
    receipt.writeln();


    String formattedData =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    receipt.writeln(formattedData);
    receipt.writeln();
    receipt.writeln("------------");

    for (final cartFood in _cart) {
      receipt.writeln(
          "${cartFood.quantity} x ${cartFood.food.name} - ${_formatPrice(cartFood.food.price)}");
      if (cartFood.addons.isNotEmpty) {
        receipt.writeln(" Add-ons: ${_formatAddons(cartFood.addons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("------------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");

    return receipt.toString();
  }


  String _formatPrice(double price) {
    return "${price.toStringAsFixed(2)}€";
  }


  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
