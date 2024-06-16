import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_it/controllers/order_controller.dart';
import 'package:order_it/models/cart.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Waiter extends StatefulWidget {
  const Waiter({super.key});

  @override
  State<Waiter> createState() => _WaiterState();
}

class _WaiterState extends State<Waiter> {
  final SupabaseApi _supabaseApi = SupabaseApi();
  List<Map<String, dynamic>> tables = [];
  late RealtimeChannel _channel;

  @override
  void initState() {
    super.initState();
    _fetchTables();
    _setupSubscription();
  }

  // Método para obtener las mesas desde la API de Supabase
  Future<void> _fetchTables() async {
    List<Map<String, dynamic>> fetchedTables = await _supabaseApi.getTables();
    fetchedTables
        .sort((a, b) => a['table_number'].compareTo(b['table_number']));
    setState(() {
      tables = fetchedTables;
    });
  }

  // Configura la suscripción para recibir actualizaciones en tiempo real sobre las mesas
  void _setupSubscription() {
    _channel = Supabase.instance.client
        .channel('public:tables')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          callback: (payload) {
            _fetchTables();
          },
          schema: 'public',
          table: 'tables',
        )
        .subscribe();
  }

  // Navega a la página de detalles de la mesa
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
        backgroundColor: Colors.green,
        title: const Text('Mesas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: tables.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                        boxShadow: const [
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
            ),
    );
  }

  @override
  void dispose() {
    _channel.unsubscribe();
    super.dispose();
  }
}

class TableDetailPage extends StatefulWidget {
  final Map<String, dynamic> table;
  final SupabaseApi supabaseApi;

  const TableDetailPage(
      {super.key, required this.table, required this.supabaseApi});

  @override
  TableDetailPageState createState() => TableDetailPageState();
}

class TableDetailPageState extends State<TableDetailPage> {
  bool _isHovering = false;
  bool _isAssigned = false;
  String uuid = '';
  String? nombre;
  bool? isWaiterAssigned;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // Inicializa la página verificando el estado de asignación de la mesa y obteniendo datos del camarero
  Future<void> _initialize() async {
    await _checkMesaAsignada();
    await _getWaiter();
    await _getName();
    await _getWaiterAssigned();
  }

  // Verifica si la mesa está asignada a un camarero
  Future<void> _checkMesaAsignada() async {
    bool assigned =
        await widget.supabaseApi.getWaiter(widget.table['table_number']);
    setState(() {
      _isAssigned = assigned;
    });
  }

  // Obtiene el UUID del camarero actual
  Future<void> _getWaiter() async {
    final activeUser = await widget.supabaseApi.getUser();
    setState(() {
      uuid = activeUser[0]['id'];
    });
  }

  // Obtiene el nombre del camarero
  Future<void> _getName() async {
    final waiterName = await widget.supabaseApi.getName(uuid);
    setState(() {
      nombre = waiterName;
    });
  }

  // Verifica si la mesa está asignada al camarero actual
  Future<void> _getWaiterAssigned() async {
    final waiterAssigned = await widget.supabaseApi
        .getCamareroAsignado(uuid, widget.table['table_number']);
    setState(() {
      isWaiterAssigned = waiterAssigned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles de Mesa ${widget.table['table_number']}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        actions: [
          if (widget.table['is_occupied'])
            MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: TextButton(
                onPressed: () async {
                  bool liberada = await widget.supabaseApi.releaseTable(
                      widget.table['user_id'], widget.table['table_number']);
                  if (liberada) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Mesa Liberada'),
                            content: Text(
                                'La mesa ${widget.table['table_number']} ha sido liberada correctamente.'),
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
                                'Hubo un error al liberar la mesa ${widget.table['table_number']}'),
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _isHovering
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: const Text(
                    'Liberar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _isAssigned
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nombre != null ? 'Asignada a $nombre' : 'Cargando...',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      isWaiterAssigned == true
                          ? ElevatedButton(
                              onPressed: () async {
                                bool success = await widget.supabaseApi
                                    .releaseWaiterTable(
                                        uuid, widget.table['table_number']);
                                if (success) {
                                  setState(() {
                                    _isAssigned = false;
                                    nombre = null;
                                    isWaiterAssigned = false;
                                  });
                                } else {
                                  if (kDebugMode) {
                                    print('Error al desvincular la mesa');
                                  }
                                }
                              },
                              child: const Text('Desvincular'))
                          : Container()
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person_add),
                        onPressed: () async {
                          bool success = await widget.supabaseApi
                              .assignTableWaiter(
                                  uuid, widget.table['table_number']);
                          if (success) {
                            final waiterName =
                                await widget.supabaseApi.getName(uuid);
                            setState(() {
                              _isAssigned = true;
                              isWaiterAssigned = true;
                              nombre = waiterName;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Asignar mesa',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            OrdersList(userTable: widget.table['user_id']),
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

  Map<int, bool> cardColors = {};

  @override
  void initState() {
    super.initState();
    futureOrders = orderController.fetchOrders(widget.userTable);
    futureItems = futureOrders.then((orders) {
      return orderController.fetchCartFood2(orders);
    });
    _loadCardColors();
  }

  Future<void> _loadCardColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Cargar el estado de las tarjetas
      cardColors = (prefs.getStringList('cardColors') ?? []).asMap().map((index, value) {
        return MapEntry(index, value == 'true');
      });
    });
  }

  Future<void> _saveCardColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cardColorsList = cardColors.values.map((value) => value.toString()).toList();
    prefs.setStringList('cardColors', cardColorsList);
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
            final Map<String, int> cantidad = {};

            // Calcula la cantidad de cada tipo de comida en los pedidos
            for (var food in carts) {
              if (cantidad.containsKey(food.name)) {
                cantidad[food.name] = cantidad[food.name]! + 1;
              } else {
                cantidad[food.name] = 1;
              }
            }
            return ListView.builder(
              itemCount: carts.length,
              itemBuilder: (context, index) {
                final cart = carts[index];
                final int cantidadInt = cantidad[cart.name] ?? 0;
                bool? isServed = cardColors[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isServed == null || !isServed) {
                        cardColors[index] = true; // Verde
                      } else {
                        cardColors[index] = false; // Rojo
                      }
                      _saveCardColors();
                    });
                  },
                  child: Card(
                    color: isServed == null
                        ? Colors.red
                        : (isServed ? Colors.green : Colors.red),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.food_bank),
                      ),
                      title: Text(cart.name),
                      subtitle: Text('Cantidad: $cantidadInt'),
                      trailing: Text(
                        '${cart.price} €',
                        style: const TextStyle(fontSize: 16),
                      ),
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
