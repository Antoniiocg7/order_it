import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:order_it/models/addon.dart';
import 'package:order_it/models/cart_food.dart';
import 'package:order_it/models/cart_item.dart';
import 'package:order_it/models/food.dart';
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

  Future<List<Map<String, dynamic>>> getUser(String email) async {
    final url = '$baseUrl/rest/v1/users?email=eq.${Uri.encodeComponent(email)}';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      throw Exception('No se pueden cargar los pedidos');
    }

    final List<dynamic> jsonResponse = json.decode(response.body);

    print(jsonResponse);

    return jsonResponse.cast<Map<String, dynamic>>();
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
        final cartItem = cartItemData.last;
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
    try {
      final response =
          await supabase.from('cart_item').select('*').eq('cart_id', cartId);

      return response;
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

  Future<String> getCart() async {
    try {
      final activeUser = await supabase.auth.getUser();

      final cartId = await supabase
          .from('cart')
          .select('id')
          .eq('is_finished', false)
          .eq('user_id', activeUser.user!.id);
      return cartId.first['id'].toString();
    } catch (e) {
      throw Exception('Error al encontrar el carrito asociado al usuario: $e');
    }
  }

  // Future<List<Map<String, dynamic>>> showCartItems(String cartId) async {
  //   final response = await supabase
  //       .from('cart_item')
  //       .select('*, food (*)') // Join con la tabla food
  //       .eq('cart_id', cartId);

  //   return List<Map<String, dynamic>>.from(response);
  // }

  Future<List<CartItem>> getUserCartDetails() async {
    final cart = await getCart();

    final cartItemsJson = await getCartItems(cart);
    List<CartItem> cartItems =
        cartItemsJson.map<CartItem>((item) => CartItem.fromJson(item)).toList();

    return cartItems;
  }

  Future<List<String>> getFoodIdsFromCart() async {
    // Obtener los detalles del carrito
    final cartItems = await getUserCartDetails();

    // Extraer los food_id de cada CartItem
    List<String> foodIds = cartItems.map((item) => item.foodId).toList();

    return foodIds;
  }

  Future<void> getCartFood() async {
    // Obtener los food_ids
    final foodIds = await getFoodIdsFromCart();

    // Realizar otra petición con los food_ids
    for (String foodId in foodIds) {
      await getFoodFromId(foodId);
    }
  }

  Future<Food> getFoodFromId(String foodId) async {
    final response =
        await supabase.from('food').select('*').eq('id', foodId).single();
    return Food.fromJson(response);
  }

  Future<List<String>> getFoodAddonsIdsFromCart() async {
    // Obtener los detalles del carrito
    final cartItems = await getUserCartDetails();

    // Extraer los food_id de cada CartItem
    List<String> foodAddonsIds = cartItems.map((item) => item.id).toList();

    return foodAddonsIds;
  }

  Future<void> getCartFoodAddons() async {
    // Obtener los ids cart_item
    final cartItemIds = await getFoodAddonsIdsFromCart();

    // Realizar otra petición con los ids cart_item para obtener los addons
    for (String cartItemId in cartItemIds) {
      await getFoodAddonsFromCart(cartItemId);
    }
  }

  Future<List<Addon>> getFoodAddonsFromCart(
    String cartItemId,
  ) async {
    final response =
        await supabase.from('cart_item_addon').select('addon_id').eq(
              'cart_item_id',
              cartItemId,
            );

    // Extraer los addon_id de la respuesta
    List<int> addonIds =
        response.map<int>((item) => item['addon_id'] as int).toList();

    if (addonIds.isEmpty) {
      if (kDebugMode) {
        print('No addons found for this cart item.');
      }
      return [];
    }

    // Construir un array de condiciones para los IDs
    final conditions = addonIds.map((id) => 'id.eq.$id').join(',');

    // Obtener los detalles de los addons usando los addon_id
    final addonDetailsResponse =
        await supabase.from('addon').select('*').or(conditions);

    List<Addon> addonList = addonDetailsResponse
        .map<Addon>((json) => Addon.fromJson(json))
        .toList();

    return addonList;

    // Convertir la respuesta en una lista de objetos Addon
    // List<Addon> addonList = addonDetailsResponse
    //     .map<Addon>((json) => Addon.fromJson(json))
    //     .toList();

    // print(addonList);
    // return addonList;
  }

  Future<List<CartFood>> getCartFoodDetails() async {
    // Obtener los detalles del carrito
    final cartItems = await getUserCartDetails();

    // Lista para almacenar los objetos CartFood
    List<CartFood> cartFoodList = [];

    // Iterar sobre cada CartItem para obtener los detalles necesarios
    for (CartItem cartItem in cartItems) {
      // Obtener el foodId del CartItem
      String foodId = cartItem.foodId;

      // Obtener los detalles del food
      Food food = await getFoodFromId(foodId);

      // Obtener los addons para el cartItem
      List<Addon> addons = await getFoodAddonsFromCart(cartItem.id);

      // Crear un objeto CartFood y agregarlo a la lista
      CartFood cartFood = CartFood(
        id: cartItem.id,
        food: food,
        addons: addons,
        quantity: cartItem.quantity,
      );

      cartFoodList.add(cartFood);
    }

    return cartFoodList;
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

  Future<List<Map<String, dynamic>>> getOrders() async {

    final supabase = Supabase.instance.client;
    final user = await supabase.auth.getUser();
    final userId = user.user?.id;

    final url =
        '$baseUrl/rest/v1/cart?select*&is_finished=eq.true&user_id=eq.$userId';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);


    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load food_addons');
    }
  }
}
