import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:order_it/utils/random_id.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {
  final supabase = Supabase.instance.client;
  final String baseUrl = 'https://gapuibdxbmoqjhibirjm.supabase.co';
  final String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
  final String authorization =
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";

  Map<String, String> _createHeaders() {
    return {
      'Content-Type': 'application/json',
      'apikey': apiKey,
      'Authorization': authorization,
    };
  }

  Map<String, String> _createHeadersInsert() {
    return {
      'Content-Type': 'application/json',
      'apikey': apiKey,
      'Authorization': authorization,
      "Prefer": "return=minimal"
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

    return response.statusCode == 200;
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

  Future<int?> getUserRole(String email) async {
    final url =
        '$baseUrl/rest/v1/users?select=rol&email=eq.${Uri.encodeComponent(email)}';
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

  Future<List<Map<String, dynamic>>> getFoodAddons() async {
    final url = '$baseUrl/rest/v1/food_addon?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load food_addons');
    }
  }

  Future<String> createCart() async {
    final url = '$baseUrl/rest/v1/cart';
    final headers = _createHeadersInsert();

    // Convert DateTime.now() to ISO 8601 string
    final now = DateTime.now().toUtc().toIso8601String();
    final cartId = RandomIds.generateRandomId().toString();
    final supabase = Supabase.instance.client;
    final UserResponse userResponse = await supabase.auth.getUser();
    final supabaseApi = SupabaseApi();
    final checkCart = await supabaseApi.checkCart();
    if (checkCart.isEmpty || checkCart.first['is_finished'] == true) {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          "id": cartId,
          "user_id": userResponse.user!.id,
          "is_finished": false,
          "created_at": now,
        }),
      );

      if (response.statusCode == 201) {
        return cartId;
      } else {
        return '';
      }
    } else {
      return "";
    }
  }

  Future<void> addItemToCart(
    String cartId,
    String foodId,
    List<String> addonIds,
  ) async {
    final url = '$baseUrl/rest/v1/cart_item';
    final url2 = '$baseUrl/rest/v1/cart_item_addon';
    final url3 = '$baseUrl/rest/v1/cart_item?cart_id=eq.$cartId&select=id';
    final headers = _createHeadersInsert();
    final cartItemId = RandomIds.generateRandomId().toString();
    // CREACIÓN DE LOS CART_ITEMS ASIGNADOS AL CART
    await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(
        {
          "id": cartItemId,
          "cart_id": int.parse(cartId),
          "food_id": int.parse(foodId),
          "quantity": "1"
        },
      ),
    );

    try {
      // OBTENEMOS EL ID DEL CART_ITEM AL QUE QUEREMOS ASIGNAR EL ADDONS
      final cartItemResponse = await http.get(
        Uri.parse(url3),
        headers: headers,
      );

      final List<dynamic> cartItemData = jsonDecode(cartItemResponse.body);
      if (cartItemData.isNotEmpty) {
        final cartItem = cartItemData[0];
        final cartItemId = cartItem['id'];
        try {
          for (var addonId in addonIds) {
            final response = await http.post(
              Uri.parse(url2),
              headers: headers,
              body: jsonEncode(
                {
                  'cart_item_id': cartItemId,
                  'addon_id': int.parse(addonId),
                },
              ),
            );

            if (response.statusCode != 201) {
              throw Exception("Error en la petición de agregar addons al item");
            }
          }
        } catch (e) {
          throw Exception("Error al agregar addons al item del carrito");
        }
      }
    } catch (e) {
      throw Exception("Error al insertar el item al carrito");
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(String cartId) async {
    final String url = '$baseUrl/rest/v1/cart_item?cart_id=$cartId';
    final headers = _createHeaders();

    try {
      final http.Response response =
          await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['error'] == null) {
          return List<Map<String, dynamic>>.from(responseData['data'] as List);
        } else {
          throw Exception(responseData['error']['message']);
        }
      } else {
        throw Exception(
          'Error al cargar los items del carrito, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al cargar los items del carrito: $e');
    }
  }

  Future<void> clearCart(String cartId) async {
    final String url = '$baseUrl/rest/v1/cart_item?cart_id=$cartId';
    final headers = _createHeaders();

    try {
      final http.Response response =
          await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          throw Exception(responseData['error']['message']);
        }
      } else {
        throw Exception(
          'Error al limpiar el carrito, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al limpiar el carrito: $e');
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    final String url = '$baseUrl/rest/v1/cart_item/$cartItemId';
    final headers = _createHeaders();

    try {
      final http.Response response =
          await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          throw Exception(responseData['error']['message']);
        }
      } else {
        throw Exception(
          'Error al eliminar el item del carrito, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al eliminar el item del carrito: $e');
    }
  }

  Future<List<Map<String, dynamic>>> checkCart() async {
    final activeUser = await supabase.auth.getUser();

    try {
      final List<Map<String, dynamic>> responseData = await supabase
          .from('cart')
          .select('is_finished')
          .eq(
            'user_id',
            activeUser.user!.id,
          )
          .eq(
            'is_finished',
            false,
          );

      return responseData;
    } catch (e) {
      throw Exception('Error al encontrar el carrito asociado al usuario: $e');
    }
  }

  Future<void> updateCartState() async {
    final supabase = Supabase.instance.client;
    final user = await supabase.auth.getUser();
    final userId = user.user?.id;

    if (userId == null) {
      print(userId);
      return;
    }

    //const bool verd = true;

    // Replace with your actual API key and authorization token
    const String apiKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E';
    const String authorization =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E'; // Ensure this is a valid JWT

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'apikey': apiKey,
      'Authorization': authorization, // Assuming you need Bearer token
    };

    var url =
        'https://gapuibdxbmoqjhibirjm.supabase.co/rest/v1/cart?user_id=eq.$userId&is_finished=eq.false';

    final body = {
      "is_finished": true,
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Cart state updated successfully');
      } else {
        print('Failed to update cart state: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
