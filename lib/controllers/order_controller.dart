import 'package:order_it/models/cart.dart';
import 'package:order_it/services/supabase_api.dart';

class OrderController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Cart>> fetchOrders() async {
    try {
      final List<Map<String, dynamic>> cartData =
          await supabaseApi.getOrders();

      final List<Cart> carts =
          cartData.map((cartData) => Cart.fromJson(cartData)).toList();

      return carts;
    
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }
}
