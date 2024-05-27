import 'package:flutter/material.dart';
import 'package:order_it/auth/login_or_register.dart';
import 'package:order_it/components/my_drawer_tile.dart';
import 'package:order_it/pages/login_page.dart';
import 'package:order_it/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // APP LOGO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Image.asset(
              'lib/images/application/Logo.png',
              width: size.width * 0.8,
              height: size.height * 0.3,
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          //HOME LIST TILE
          MyDrawerTile(
            text: "INICIO",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          //SETTINGS LIST TILE
          MyDrawerTile(
            text: "AJUSTES",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),

          // Tirar logout abajo del todo
          const Spacer(),

          //LOGGING OUT LIST TILE
          MyDrawerTile(
            text: "CERRAR SESION",
            icon: Icons.logout,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
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