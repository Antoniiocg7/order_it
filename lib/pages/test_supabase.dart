
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTest extends StatelessWidget {
  SupabaseTest({super.key});

  final _future = Supabase.instance.client
      .from('categoria')
      .select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final categorias = snapshot.data!;
          return ListView.builder(
            itemCount: categorias.length,
            itemBuilder: ((context, index) {
              final categoria = categorias[index];
              return ListTile(
                title: Text(categoria['nombre']),
              );
            }),
          );
        },
      ),
    );
  }

}