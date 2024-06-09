import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:order_it/models/user.dart';
import 'package:order_it/pages/first_page.dart';
import 'package:order_it/pages/waiter.dart';
import 'package:order_it/services/snackbar_helper.dart';
import 'package:order_it/pages/home_page.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {
  login(BuildContext context, String email, String password) async {
    Usuario usuario = Usuario(email: email, password: password);

    final usuarioBox = Hive.box<Usuario>("userBox");

    usuarioBox.add(usuario);

    SupabaseApi supabaseApi = SupabaseApi();

    final supabase = Supabase.instance.client;
    supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // TODO: PENDIENTE DE IMPLEMENTAR LOGICA MAL LOGIN ????
    int? rol = await supabaseApi.getUserRole(email);
    String? userId = await supabaseApi.getUserUUID(email);

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
          if (userId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                //builder: (context) =>  AssignTable(userId: userId ?? ''),
                //builder: (context) => AssignTable(userId: userId),
                builder: (context) => FirstPage(userId: userId),
              ),
            );
          }
        }
      } else {
        SnackbarHelper.showSnackbar(
          context,
          'Inicio de sesión incorrecto, compruebe las credenciales',
          backgroundColor: Colors.red,
        );
      if (rol == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else if (rol == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FirstPage(),
          ),
        );
      }
    }
  }

  bool loginWithoutConnection(
      BuildContext context, String email, String password) {
    final usuarioBox = Hive.box<Usuario>("userBox");

    if (email == usuarioBox.getAt(0)!.email) {
      if (password == usuarioBox.getAt(0)!.password) {
        return true;
      }
      return false;
    }
    return false;
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