import 'package:order_it/services/supabase_api.dart';
import 'package:order_it/models/tables.dart';

class TablesController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Tables>> fetchTables() async {
    try {
      // Obtenemos los datos de Food en formato JSON
      final List<Map<String, dynamic>> tablesData =
          await supabaseApi.getTables();

          print(tablesData);

      // Convertimos el JSON en objetos Food
      final List<Tables> tables =
          tablesData.map((data) => Tables.fromJson(data)).toList();

      print(tablesData);

      return tables;
    } catch (error) {
      throw Exception('Failed to fetch food: $error');
    }
  }
}
