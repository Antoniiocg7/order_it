import 'package:flutter/material.dart';
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

  void _navigateToTableDetail(
      BuildContext context, Map<String, dynamic> table) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TableDetailPage(table: table, supabaseApi: _supabaseApi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tablesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tables available'));
          } else {
            List<Map<String, dynamic>> tables = snapshot.data!;
            tables
                .sort((a, b) => a['table_number'].compareTo(b['table_number']));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  bool isOccupied = tables[index]['is_occupied'];
                  return GestureDetector(
                    onTap: () => _navigateToTableDetail(context, tables[index]),
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      color: isOccupied ? Colors.red : Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Mesa ${tables[index]['table_number']}',
                              style: const TextStyle(color: Colors.white),
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

  const TableDetailPage(
      {super.key, required this.table, required this.supabaseApi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Mesa ${table['table_number']}'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Detalles de Mesa: ${table['table_number']}'),
            const SizedBox(height: 20),
            if (table['is_occupied'])
              ElevatedButton(
                  onPressed: () async {
                    bool liberada = await supabaseApi.releaseTable(
                        table['user_id'], table['table_number']);
                    if (liberada) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Mesa Liberada'),
                              content: Text(
                                  'La mesa ${table['table_number']} ha sido liberada correctamente.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Cerrar el diálogo
                                    Navigator.pop(
                                        context); // Volver a la página anterior
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
                              content: Text(
                                  'Hubo un error al liberar la mesa ${table['table_number']}'),
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
                  child: Text('Liberar Mesa ${table['table_number']}'))
          ],
        ),
      ),
    );
  }
}
