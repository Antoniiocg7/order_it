import 'package:flutter/material.dart';
import 'package:order_it/components/my_drawer.dart';
import 'package:order_it/components/my_food_tile.dart';
import 'package:order_it/components/my_tab_bar.dart';
import 'package:order_it/models/food_category.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/pages/cart_page.dart';
import 'package:order_it/pages/food_page.dart';
import 'package:order_it/controllers/food_category_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

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
    return FutureBuilder<List<FoodCategory>>(
      future: FoodCategoryController().fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final categories = snapshot.data ?? [];
          _tabController =
              TabController(length: categories.length, vsync: this);
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            drawer: const MyDrawer(),
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
              title: const Text('Order It'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ));
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ],
            ),
            body: Column(
              children: [
                MyTabBar(tabController: _tabController, categories: categories),
                Expanded(
                  child: Consumer<Restaurant>(
                    builder: (context, restaurant, child) => TabBarView(
                      controller: _tabController,
                      children: categories.map((category) {
                        final categoryMenu = restaurant.getMenuForCategory(
                          category.id.toString(),
                        );
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
                                    builder: (context) => FoodPage(food: food),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
