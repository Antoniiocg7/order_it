import 'package:order_it/models/order.dart';
import 'package:order_it/services/supabase_api.dart';

class OrderController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Order>> fetchOrders() async {
    try {
      final List<Map<String, dynamic>> orderData =
          await supabaseApi.getOrders();

      final List<Order> orders =
          orderData.map((orderData) => Order.fromJson(orderData)).toList();

      return orders;
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }
}
