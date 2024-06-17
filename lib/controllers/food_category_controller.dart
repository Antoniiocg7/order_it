import 'package:order_it/models/food_category.dart';
import 'package:order_it/services/supabase_api.dart';

class FoodCategoryController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<FoodCategory>> fetchCategories() async {
    try {
      final List<Map<String, dynamic>> categoriesData =
          await supabaseApi.getCategories();
      final List<FoodCategory> categories = categoriesData
          .map((categoryData) => FoodCategory.fromJson(categoryData))
          .toList();
      return categories;
    } catch (error) {
      throw Exception('Error al traer las categorías: $error');
    }
  }
}
