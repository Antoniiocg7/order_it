import 'package:order_it/models/cart.dart';
import 'package:order_it/models/cart_item.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/services/supabase_api.dart';

class OrderController {
  final SupabaseApi supabaseApi = SupabaseApi();

  // Los pedidos del usuario
  Future<List<Cart>> fetchOrders([String? userId]) async {
    try {
      final List<Map<String, dynamic>> cartData =
          await supabaseApi.getOrders(userId);

      final List<Cart> carts =
          cartData.map((cartData) => Cart.fromJson(cartData)).toList();

      return carts;
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartFood(String cartId) async {
    try {
      final List<Map<String, dynamic>> cartItem =
          await supabaseApi.getCartItems2(cartId);

      final List<CartItem> cartItems =
          cartItem.map((cartItem) => CartItem.fromJson(cartItem)).toList();

      List<Map<String, dynamic>> cartFood = [];

      for (var element in cartItems) {
        // Obtener la lista de alimentos de la API
        var foodList = await supabaseApi.getFood2(element.foodId);

        // Agregar la cantidad a cada alimento en la lista
        for (var food in foodList) {
          food['quantity'] = element.quantity;
        }

        // Agregar la lista de alimentos con cantidades a cartFood
        cartFood.addAll(foodList);
      }

      return cartFood;
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }

  // Los artículos del pedido
  Future<List<Food>> fetchCartFood2(List<Cart> carts) async {
    try {
      final List<Food> allFoods = [];

      for (Cart cart in carts) {
        final List<Map<String, dynamic>> cartItemData =
            await supabaseApi.getCartItems3(cart.id);

        final List<CartItem> cartItems =
            cartItemData.map((item) => CartItem.fromJson(item)).toList();

        // Sacar el nombre del plato en base al ID del artículo
        for (CartItem cartItem in cartItems) {
          final List<Map<String, dynamic>> cartFoodData =
              await supabaseApi.getFood2(cartItem.foodId);

          final List<Food> cartFoods =
              cartFoodData.map((food) => Food.fromJson(food)).toList();

          allFoods.addAll(cartFoods);
        }
      }

      return allFoods;
    } catch (error) {
      throw Exception('Failed to fetch cart items: $error');
    }
  }
}
