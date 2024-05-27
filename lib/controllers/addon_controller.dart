import 'package:order_it/models/addon.dart';
import 'package:order_it/services/supabase_api.dart';

class AddonController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Addon>> fetchAddons() async {
    try {
      final List<Map<String, dynamic>> addonData =
          await supabaseApi.getAddons();

      final List<Addon> addons = addonData.map((addonData)
      => Addon
      .fromJson(addonData))
      .toList();
      
      return addons;
    
    } catch (error) {
      throw Exception('Failed to fetch addons: $error');
    }
  }
}
