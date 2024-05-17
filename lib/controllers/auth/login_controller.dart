import 'package:flutter/material.dart';
import 'package:order_it/pages/first_page.dart';
import 'package:order_it/services/snackbar_helper.dart';
import 'package:order_it/services/supabase_api.dart';

class LoginController {

  login(BuildContext context, String email, String password) async {
    SupabaseApi supabaseApi = SupabaseApi();
    
    bool success = await supabaseApi.login(email, password);
    if(context.mounted){
      if(success){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstPage()));
      }else{
        SnackbarHelper.showSnackbar(context, 'Inicio de sesión incorrecto, compruebe las credenciales', backgroundColor: Colors.red);
      }
    }
  }
}