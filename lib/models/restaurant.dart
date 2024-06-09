import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      print("******************************");
      print("CARTATAA***");
      print(_cart[0].food);
      print(_cart[0].addons);
      print(_cart[0].quantity);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading cart details: $e");
      }
    }
  }

  // ADD TO CART
  void addToCart(Food food, List<Addon> selectedAddons) {
    // See if there is a cart item already with the same food and selected addons
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      // CHECK IF THE FOOD ITEMS ARE THE SAME
      bool isSameFood = item.food == food;

      //CHECK IF THE LIST OF SELECTED ADDONS ARE THE SAME
      bool isSameAddons =
          const ListEquality().equals(item.selectedAddons, selectedAddons);

      return isSameFood && isSameAddons;
    });

    // IF ITEM ALREADY EXISTS, INCREASE IT´S QUANTITY
    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      // OTHERWISE, ADD A NEW CART ITEM TO THE CART
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
  }

  // REMOVE FROM CART
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
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
