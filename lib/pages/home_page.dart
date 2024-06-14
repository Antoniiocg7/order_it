import 'package:flutter/material.dart';
import 'package:order_it/components/my_drawer.dart';
import 'package:order_it/components/my_food_tile.dart';
import 'package:order_it/components/my_tab_bar.dart';
import 'package:order_it/models/food_category.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/pages/cart_page.dart';
import 'package:order_it/pages/food_page.dart';
import 'package:order_it/controllers/food_category_controller.dart';
import 'package:order_it/controllers/food_controller.dart';
import 'package:order_it/models/food.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  final bool ordersAllowed;

  const HomePage({super.key, required this.ordersAllowed});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final FoodController _foodController = FoodController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para deshabilitar volver atrás
        return false;
      }, 

    child: FutureBuilder<List<FoodCategory>>(
      future: FoodCategoryController().fetchCategories(),
      builder: (context, categorySnapshot) {
        if (categorySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (categorySnapshot.hasError) {
          return Center(child: Text('Error: ${categorySnapshot.error}'));
        } else {
          final categories = categorySnapshot.data ?? [];
          _tabController =
              TabController(length: categories.length, vsync: this);

          return FutureBuilder<List<Food>>(
            future: _foodController.fetchAllFood(),
            builder: (context, foodSnapshot) {
              if (foodSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (foodSnapshot.hasError) {
                return Center(child: Text('Error: ${foodSnapshot.error}'));
              } else {
                final foods = foodSnapshot.data ?? [];
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  drawer: MyDrawer(ordersAllowed: widget.ordersAllowed),
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    leading: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
                    title: const Text('Order It!'),
                    actions: widget.ordersAllowed ? [
                          IconButton(
                            onPressed: () async {
                          final restaurant =
                              Provider.of<Restaurant>(context, listen: false);
                          await restaurant.loadCartDetails();

                          if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartPage(),
                                  ),
                            );
                          }
                            },
                            icon: const Icon(Icons.shopping_cart),
                          ),
                        ] 
                      : [],
                    ),
                  body: Column(
                    children: [
                      MyTabBar(
                          tabController: _tabController,
                          categories: categories),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: categories.map((category) {
                            final categoryMenu = foods
                                .where((food) => food.categoryId == category.id)
                                .toList();
                            return ListView.builder(
                              itemCount: categoryMenu.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final food = categoryMenu[index];
                                return FoodTile(
                                  food: food,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodPage(food: food, ordersAllowed: widget.ordersAllowed),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    ));
  }
}
