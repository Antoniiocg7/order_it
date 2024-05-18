
import 'package:order_it/services/supabase_api.dart';

class RegisterController {

  register(String email, String password){
    SupabaseApi supabaseApi = SupabaseApi();
    supabaseApi.register(email, password);
  }
}