import 'package:order_it/controllers/addon_controller.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/models/order.dart';
import 'package:order_it/services/supabase_api.dart';

class OrderController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Order>> fetchOrders() async {
    try {
      final List<Map<String, dynamic>> orderData = await supabaseApi.getFood();
      final List<Order> orders =
          orderData.map((orderData) 
          => Order
          .fromJson(orderData)).
          toList();

      // Obtener los addons
      final List<Addon> addons = await AddonController().fetchAddons();

      // Creamos un mapa para buscarlos mas fácilmente
      final Map<String, Addon> addonMap = {
        for (var addon in addons) addon.id: addon
      };

      // Asignamos los addons a cada comida según su ID
      for (var order in orders) {
        order.addons = order.addonId
            .where((id) => addonMap.containsKey(id))
            .map((id) => addonMap[id]!)
            .toList();
      }

      return orders;
      
    } catch (error) {
      throw Exception('Failed to fetch food: $error');
    }
  }
}
