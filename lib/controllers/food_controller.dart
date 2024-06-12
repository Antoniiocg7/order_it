import 'package:order_it/controllers/addon_controller.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/services/supabase_api.dart';

class FoodController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Food>> fetchAllFood() async {
    try {
      // Obtenemos los datos de Food en formato JSON
      final List<Map<String, dynamic>> foodData = await supabaseApi.getFood();

      // Convertimos el JSON en objetos Food
      final List<Food> foods =
          foodData.map((data) => Food.fromJson(data)).toList();

      // Obtenemos el JSON con las relaciones entre Food y Addon
      final List<Map<String, dynamic>> foodAddonData =
          await supabaseApi.getFoodAddons();

      // Obtenemos los datos de Addon en formato JSON
      final List<Addon> addons = await AddonController().fetchAddons();

      // Creamos un mapa para facilitar la búsqueda
      final Map<String, Addon> addonMap = {
        for (var addon in addons) addon.id: addon
      };

      // Asignamos cada Addon a su Food
      for (var food in foods) {
        // Obtenemos los Addons para el elemento Food actual
        var addonIds = foodAddonData
            .where((fa) => fa['food_id'].toString() == food.id)
            .map((fa) => fa['addon_id'].toString())
            .toList();

        // Le asignamos los Addon al elemento Food
        food.addons = addonIds.map((id) => addonMap[id]!).toList();
      }

      return foods;
    } catch (error) {
      throw Exception('Failed to fetch food: $error');
    }
  }

  Future<List<Food>> fetchFoodByCart() async {
    try {
      // Obtenemos los datos de Food en formato JSON
      final List<Map<String, dynamic>> foodData = await supabaseApi.getFood();

      // Convertimos el JSON en objetos Food
      final List<Food> foods =
          foodData.map((data) => Food.fromJson(data)).toList();

      // Obtenemos el JSON con las relaciones entre Food y Addon
      final List<Map<String, dynamic>> foodAddonData =
          await supabaseApi.getFoodAddons();

      // Obtenemos los datos de Addon en formato JSON
      final List<Addon> addons = await AddonController().fetchAddons();

      // Creamos un mapa para facilitar la búsqueda
      final Map<String, Addon> addonMap = {
        for (var addon in addons) addon.id: addon
      };

      // Asignamos cada Addon a su Food
      for (var food in foods) {
        // Obtenemos los Addons para el elemento Food actual
        var addonIds = foodAddonData
            .where((fa) => fa['food_id'].toString() == food.id)
            .map((fa) => fa['addon_id'].toString())
            .toList();

        // Le asignamos los Addon al elemento Food
        food.addons = addonIds.map((id) => addonMap[id]!).toList();
      }

      return foods;
    } catch (error) {
      throw Exception('Failed to fetch food: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartFood(String cartId) async {
    try {
      final List<Map<String, dynamic>> cartFood =
          await supabaseApi.getCartItems2(cartId);

      return cartFood;
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }
}
