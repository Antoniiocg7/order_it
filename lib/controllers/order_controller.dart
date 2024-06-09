import 'package:order_it/models/cart.dart';
import 'package:order_it/services/supabase_api.dart';

class OrderController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Cart>> fetchOrders() async {
    try {
      final List<Map<String, dynamic>> orderData =
          await supabaseApi.getOrders();

      final List<Cart> orders =
          orderData.map((orderData) => Cart.fromJson(orderData)).toList();

      return orders;
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }
}
