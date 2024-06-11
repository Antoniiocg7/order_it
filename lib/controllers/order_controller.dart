import 'package:order_it/models/cart.dart';
import 'package:order_it/models/cart_item.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/services/supabase_api.dart';

class OrderController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Cart>> fetchOrders() async {
    try {
      final List<Map<String, dynamic>> cartData = await supabaseApi.getOrders();

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

      print(cartItems[0].foodId);
      
      final List<Map<String, dynamic>> cartFood =
          await supabaseApi.getFood2( cartItems[0].foodId );

      final List<Food> cartFoods =
          cartFood.map((cartFood) => Food.fromJson(cartFood)).toList();


      print(cartFoods[0].name);

      return cartFood;
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }
}
