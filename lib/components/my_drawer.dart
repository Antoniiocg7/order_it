import 'package:flutter/material.dart';
import 'package:order_it/auth/login_or_register.dart';
import 'package:order_it/components/my_drawer_tile.dart';
import 'package:order_it/pages/cart_page.dart';
import 'package:order_it/pages/help_page.dart';
import 'package:order_it/pages/my_orders.dart';
import 'package:order_it/pages/my_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyDrawer extends StatelessWidget {
  
  final bool ordersAllowed;

  const MyDrawer({super.key, required this.ordersAllowed });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Menú desplegable
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Image.asset(
              'assets/icons/Logo.png',
              width: size.width * 0.8,
              height: size.height * 0.3,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          MyDrawerTile(
            text: "INICIO",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          if(ordersAllowed)
            MyDrawerTile(
              text: "CARRRITO",
              icon: Icons.shopping_cart_rounded,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
            ),

          MyDrawerTile(
            text: "PEDIDOS",
            icon: Icons.food_bank,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyOrders(),
                ),
              );
            },
          ),

          MyDrawerTile(
            text: "MIS DATOS",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProfile(title: "Hola",),
                ),
              );
            },
          ),

          MyDrawerTile(
            text: "AYUDA",
            icon: Icons.help_center,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpPage(),
                ),
              );
            },
          ),


          MyDrawerTile(
            text: "ACERCA DE.",
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyOrders(),
                ),
              );
            },
          ),


          // Tirar logout abajo del todo
          const Spacer(),

          MyDrawerTile(
            text: "CERRAR SESION",
            icon: Icons.logout,
            onTap: () async {
              final supabase = Supabase.instance;
              supabase.client.auth.signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegister(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
