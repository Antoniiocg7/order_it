import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {
  final String baseUrl = 'https://gapuibdxbmoqjhibirjm.supabase.co';
  final String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
  final String authorization = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
  final SupabaseClient client;

  SupabaseApi() : client = Supabase.instance.client;

  Map<String, String> _createHeaders() {
    return {
      'Content-Type': 'application/json',
      'apikey': apiKey,
      'Authorization': authorization,
    };
  }

  Future<bool> login(String email, String password) async {
    final url = '$baseUrl/auth/v1/token?grant_type=password';
    final headers = _createHeaders();

    final body = json.encode({
      'email': email,
      'password': password,
    });

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    final url = '$baseUrl/auth/v1/signup';
    final headers = _createHeaders();

    final body = json.encode({
      'email': email,
      'password': password,
    });

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getUserUUI(String email) async {
    final url = '$baseUrl/rest/v1/users?select=id&email=eq.${Uri.encodeComponent(email)}';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      print('RESPUESTA: $jsonResponse');
      if (jsonResponse.isNotEmpty && jsonResponse[0]['id'] != null) {
        return jsonResponse[0]['id'];
      } else {
        return null;
      }
    } else {
      print('Error al obtener el UUID del usuario: ${response.statusCode}');
      return null;
    }
  }


  /*Future<String?> getUserUUID(String email) async {
    final url = '$baseUrl/rest/v1/users?select=user_id&email=eq.${Uri.encodeComponent(email)}';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.isNotEmpty && jsonResponse[0]['user_id'] != null) {
        return jsonResponse[0]['user_id'];
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener el UUID del usuario');
    }
  }*/

  Future<int?> getUserRole(String email) async {
    final url = '$baseUrl/rest/v1/users?select=rol&email=eq.${Uri.encodeComponent(email)}';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.isNotEmpty && jsonResponse[0]['rol'] != null) {
        return jsonResponse[0]['rol'];
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener el rol del usuario');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final url = '$baseUrl/rest/v1/category?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Map<String, dynamic>>> getAddons() async {
    final url = '$baseUrl/rest/v1/addon?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Map<String, dynamic>>> getFood() async {
    final url = '$baseUrl/rest/v1/food?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load categories');
    }
  }


  Future<List<Map<String, dynamic>>> getOrderDetails(int tableNumber) async {
    final url = '$baseUrl/rest/v1/orders?select=*&table_number=eq.$tableNumber';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load order details');
    }
  }

  Future<List<Map<String, dynamic>>> getTables() async {
    final url = '$baseUrl/rest/v1/tables?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load tables');
    }
  }

  Future<void> assignTable(String userId, int tableNumber) async {
    final url = '$baseUrl/rest/v1/tables?id=$tableNumber';
    
    final headers = {
      'apikey': apiKey,
      'Authorization': authorization,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'user_id': userId,
      'table_number': tableNumber,
      'is_occupied': true
    });

    final response = await http.patch(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Table $tableNumber assigned successfully.');
    } else {
      print('Failed to assign table $tableNumber: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> releaseTable(int tableNumber) async {
    final url = '$baseUrl/rest/v1/rpc/release_table';
    
    final headers = {
      'apikey': apiKey,
      'Authorization': authorization,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'table_number': tableNumber,
      'is_occupied': false,
      'user_id': null,
    });

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Table $tableNumber released successfully.');
    } else {
      print('Failed to release table $tableNumber: ${response.statusCode} ${response.body}');
    }
  }
}
  // Importante sacar tableNumber
  /*
  Future<void> assignTable(String userId, int tableNumber) async {
    final response = await client
        .from('tables')
        .update({'is_occupied': true, 'user_id': userId})
        .eq('table_number', tableNumber);

    if (response.error != null) {
      print('Error al hacer la reserva de mesa: ${response.statusCode}');
      return null;
    }
  }

  Future<void> releaseTable(int tableNumber) async {
    final response = await client
        .from('tables')
        .update({'is_occupied': false, 'user_id': null})
        .eq('table_number', tableNumber);

    if (response.error != null) {
      throw response.error!;
    }
  }
  */

