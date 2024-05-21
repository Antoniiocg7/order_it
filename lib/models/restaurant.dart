import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/models/cart_item.dart';
import 'package:order_it/models/food.dart';

class Restaurant extends ChangeNotifier {
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

  // GET TOTAL PRICE OF CART
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
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
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln(" Add-ons: ${_formatAddons(cartItem.selectedAddons)}");
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
