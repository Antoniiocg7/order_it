import 'package:flutter/material.dart';
import 'package:order_it/models/food_category.dart';

class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<FoodCategory> categories;

  const MyTabBar({
    super.key,
    required this.tabController,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: Colors.white,
      tabs: categories.map((category) {
        return Tab(
          text: category.name,
        );
      }).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
