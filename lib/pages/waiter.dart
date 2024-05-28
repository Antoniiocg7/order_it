import 'package:flutter/material.dart';
import 'package:order_it/services/supabase_api.dart';

class Waiter extends StatefulWidget {
  const Waiter({Key? key}) : super(key: key);

  @override
  _WaiterState createState() => _WaiterState();
}

class _WaiterState extends State<Waiter> {
  late Future<List<Map<String, dynamic>>> _tablesFuture;
  final SupabaseApi _supabaseApi = SupabaseApi();

  @override
  void initState() {
    super.initState();
    _tablesFuture = _supabaseApi.getTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiter'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tablesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tables available'));
          } else {
            List<Map<String, dynamic>> tables = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                bool isOccupied = tables[index]['is_occupied'];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  color: isOccupied ? Colors.red : Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Table ${tables[index]['table_number']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        /*QrImage(
                          data: 'table:${tables[index]['table_number']}',
                          version: QrVersions.auto,
                          size: 50.0,
                        ),*/
                      ],
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
