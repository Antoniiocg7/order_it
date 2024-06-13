import 'package:flutter/material.dart';
import 'package:order_it/controllers/order_controller.dart';
import 'package:order_it/models/cart.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/services/supabase_api.dart';

class Waiter extends StatefulWidget {
  const Waiter({super.key});

  @override
  State<Waiter> createState() => _WaiterState();
}

class _WaiterState extends State<Waiter> {
  late Future<List<Map<String, dynamic>>> _tablesFuture;
  final SupabaseApi _supabaseApi = SupabaseApi();

  @override
  void initState() {
    super.initState();
    _tablesFuture = _supabaseApi.getTables();
  }

  void _navigateToTableDetail(BuildContext context, Map<String, dynamic> table) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TableDetailPage(table: table, supabaseApi: _supabaseApi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Mesas', style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold)),
        
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tablesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay mesas disponibles'));
          } else {
            List<Map<String, dynamic>> tables = snapshot.data!;
            tables.sort((a, b) => a['table_number'].compareTo(b['table_number']));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  bool isOccupied = tables[index]['is_occupied'];
                  return GestureDetector(
                    onTap: () => _navigateToTableDetail(context, tables[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isOccupied ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isOccupied ? Icons.person : Icons.event_seat,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mesa ${tables[index]['table_number']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class TableDetailPage extends StatelessWidget {
  final Map<String, dynamic> table;
  final SupabaseApi supabaseApi;

  const TableDetailPage({super.key, required this.table, required this.supabaseApi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Mesa ${table['table_number']}'),
        actions: [
          if (table['is_occupied'])
            TextButton(
              onPressed: () async {
                bool liberada = await supabaseApi.releaseTable(table['user_id'], table['table_number']);
                if (liberada) {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Mesa Liberada'),
                          content: Text('La mesa ${table['table_number']} ha sido liberada correctamente.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Cerrar el diálogo
                                Navigator.pop(context); // Volver a la página anterior
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error al liberar mesa'),
                          content: Text('Hubo un error al liberar la mesa ${table['table_number']}'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Waiter(),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: const Text(
                'Liberar',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Pedidos de la mesa ${table['table_number']}:'),
            const SizedBox(height: 20),
            OrdersList(userTable: table['user_id']),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatefulWidget {
  final String? userTable;

  const OrdersList({super.key, required this.userTable});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final OrderController orderController = OrderController();
  late Future<List<Cart>> futureOrders;
  late Future<List<Food>> futureItems;

  @override
  void initState() {
    super.initState();
    futureOrders = orderController.fetchOrders(widget.userTable);
    futureItems = futureOrders.then((orders) {
      return orderController.fetchCartFood2(orders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Food>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay pedidos disponibles.'));
          } else {
            final carts = snapshot.data!;
            return ListView.builder(
              itemCount: carts.length,
              itemBuilder: (context, index) {
                final cart = carts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.food_bank),
                    ),
                    title: const Text('Restaurante'),
                    subtitle: const Text('Fecha:'),
                    trailing: Text(
                      '${cart.name} €',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
