import 'package:flutter/material.dart';
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
            onPressed: (){
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
          const Icon(
            Icons.settings,
            size: 100,
            color: Colors.green),
          const SizedBox(
            height: 40,
          ),
          MyContainer(
              title: "PEDIDOS",
              icon: const Icon(Icons.coffee),
              routeBuilder: (context) =>  MyOrders()),
          MyContainer(
              title: "MIS DATOS",
              icon: const Icon(Icons.person),
              routeBuilder: (context) => const MyProfile(title: 'Settings',)),
          MyContainer(
              title: "METODOS DE PAGO",
              icon: const Icon(Icons.wallet),
              routeBuilder: (context) =>  MyBilingdetails()),
          MyContainer(
              title: "ACERCA DE.",
              icon: const Icon(Icons.info_outline),
              routeBuilder: (context) =>  MyBilingdetails()),
        ],
      ),
    );
  }
}

class MyContainer extends StatefulWidget {
  final String title;
  final Icon icon;
  final WidgetBuilder routeBuilder;

  const MyContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.routeBuilder,
  });

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: widget.routeBuilder));
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(76.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //SWITCH
              widget.icon,
              const SizedBox(
                width: 15,
              ),
              Text(
                widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
