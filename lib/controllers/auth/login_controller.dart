import 'package:flutter/material.dart';
import 'package:order_it/pages/assign_table.dart';
import 'package:order_it/pages/first_page.dart';
import 'package:order_it/pages/waiter.dart';
import 'package:order_it/services/snackbar_helper.dart';
import 'package:order_it/services/supabase_api.dart';

class LoginController {
  login(BuildContext context, String email, String password) async {
    SupabaseApi supabaseApi = SupabaseApi();

    bool success = await supabaseApi.login(email, password);
    int? rol = await supabaseApi.getUserRole(email);
    String? userId = await supabaseApi.getUserUUI(email);

    if (context.mounted) {
      if (success) {
        if (rol == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Waiter(),
            ),
          );
        } else if (rol == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  AssignTable(userId: userId ?? ''),
            ),
          );
        }
      } else {
        SnackbarHelper.showSnackbar(
          context,
          'Inicio de sesión incorrecto, compruebe las credenciales',
          backgroundColor: Colors.red,
        );
      }
    }
  }
}

/*
class LoginController {

  login(BuildContext context, String email, String password) async {
    SupabaseApi supabaseApi = SupabaseApi();
    
    bool success = await supabaseApi.login(email, password);
    if(context.mounted){
      if(success){
        int? rol = await supabaseApi.getUserRole(email);
        print(rol);
        if (rol == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (rol == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstPage()));
        }
        
      }else{
        SnackbarHelper.showSnackbar(context, 'Inicio de sesión incorrecto, compruebe las credenciales', backgroundColor: Colors.red);
      }
    }
  }
}
*/