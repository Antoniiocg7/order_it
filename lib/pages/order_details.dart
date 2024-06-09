import 'package:flutter/material.dart';
import 'package:order_it/services/supabase_api.dart';

class OrderDetailsPage extends StatelessWidget {
  final int tableNumber;

  const OrderDetailsPage({super.key, required this.tableNumber});

  Future<List<Map<String, dynamic>>> _getOrderDetails() async {
    SupabaseApi supabaseApi = SupabaseApi();
    return await supabaseApi.getOrderDetails(tableNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details for Table $tableNumber'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No orders found for Table $tableNumber'));
          } else {
            List<Map<String, dynamic>> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Order ${orders[index]['id']}'),
                  subtitle: Text('Details: ${orders[index]['details']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
