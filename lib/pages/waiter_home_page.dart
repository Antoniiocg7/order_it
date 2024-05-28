import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:order_it/controllers/tables_controller.dart';
import 'package:order_it/pages/cart_page.dart';
import 'package:order_it/models/tables.dart';

class WaiterHomePage extends StatefulWidget {
  const WaiterHomePage({super.key});

  @override
  State<WaiterHomePage> createState() => _WaiterHomePageState();
}

class _WaiterHomePageState extends State<WaiterHomePage> {
  final TablesController _tablesController = TablesController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tables>>(
      future: _tablesController.fetchTables(),
      builder: (context, tableSnapshot) {
        if (tableSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (tableSnapshot.hasError) {
          return Center(child: Text('Error: ${tableSnapshot.error}'));
        } else {
          final tables = tableSnapshot.data ?? [];
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              title: const Text('Order It'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tables.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      return ListTile(
                        title: Text('Table ${table.tableNumber}'),
                        onTap: () {
                          // Navegar a la página de detalles de la mesa
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
