import 'package:order_it/controllers/addon_controller.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/services/supabase_api.dart';

class FoodController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Food>> fetchFood() async {
    try {
      final List<Map<String, dynamic>> foodData = await supabaseApi.getFood();
      final List<Food> foods =
          foodData.map((foodData) => Food.fromJson(foodData)).toList();

      // Obtener los addons
      final List<Addon> addons = await AddonController().fetchAddons();

      // Creamos un mapa para buscarlos mas fácilmente
      final Map<String, Addon> addonMap = {
        for (var addon in addons) addon.id: addon
      };

      // Asignamos los addons a cada comida según su ID
      for (var food in foods) {
        food.addons = food.addonIds
            .where((id) => addonMap.containsKey(id))
            .map((id) => addonMap[id]!)
            .toList();
      }
      return foods;
    } catch (error) {
      throw Exception('Failed to fetch food: $error');
    }
  }
}
