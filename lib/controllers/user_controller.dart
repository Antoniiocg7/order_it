import 'package:order_it/models/usuario.dart';
import 'package:order_it/services/supabase_api.dart';

class UserController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<User> getUser([String? email]) async {
    try {
      final List<Map<String, dynamic>> userData =
          await supabaseApi.getUser();

      if (userData.isEmpty) {
        throw Exception('No user found with this email');
      }

      final User user = User.fromJson(userData[0]);

      return user;
    } catch (error) {
      throw Exception('Failed to fetch user: $error');
    }
  }
}
