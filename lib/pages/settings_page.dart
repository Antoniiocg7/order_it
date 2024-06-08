import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:order_it/controllers/order_controller.dart';
import 'package:order_it/pages/my_bilingDetails.dart';
import 'package:order_it/pages/my_orders.dart';
import 'package:order_it/pages/my_profile.dart';
import 'package:order_it/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajustes"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: const Icon(
              Icons.dark_mode_rounded,
              size: 25,
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const CircleAvatar(
            radius: 50,
          ),
          const SizedBox(
            height: 40,
          ),
          MyContainer(
              title: "PEDIDOS",
              icon: const Icon(Icons.coffee),
              route: (context) => const MyOrders()),
          MyContainer(
              title: "MIS DATOS",
              icon: const Icon(Icons.person),
              route: (context) => const MyProfile(
                    title: "Mis datos",
                  )),
          MyContainer(
              title: "METODOS DE PAGO",
              icon: const Icon(Icons.wallet),
              route: (context) => const MyBilingdetails()),
          MyContainer(
              title: "AYUDA",
              icon: const Icon(LineAwesomeIcons.hands_helping_solid),
              route: (context) => const MyOrders()),
          MyContainer(
              title: "PREFERENCIAS",
              icon: const Icon(LineAwesomeIcons.eye_slash),
              route: (context) => const MyOrders()),
          MyContainer(
              title: "ACERCA DE.",
              icon: const Icon(Icons.info_outline),
              route: (context) => const MyBilingdetails()),
        ],
      ),
    );
  }
}

class MyContainer extends StatefulWidget {
  final String title;
  final Icon icon;
  final WidgetBuilder route;

  const MyContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  final OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder:  widget.route,
              ));

      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(76.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SWITCH
              widget.icon,
              const SizedBox(
                width: 25,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
