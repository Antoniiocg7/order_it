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
        title: Text('Detalles del pedido de la mesa $tableNumber'),
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
                child: Text('No hay pedidos en la mesa $tableNumber'));
          } else {
            List<Map<String, dynamic>> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Pedido ${orders[index]['id']}'),
                  subtitle: Text('Detalles: ${orders[index]['details']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
