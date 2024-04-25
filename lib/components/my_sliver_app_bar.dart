import 'package:flutter/material.dart';
import 'package:order_it/pages/cart_page.dart';

class MySliverAppBar extends StatelessWidget {

  final Widget child;
  final Widget title;

  const MySliverAppBar({
    super.key, 
    required this.child, 
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      collapsedHeight: 120,
      floating: false,
      pinned: false,
      actions: [
        // CART BUTTON
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: (){
            // GO TO CART PAGE
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartPage()
              )
            );
          }, 
        )
      ],
      backgroundColor: Theme.of(context).colorScheme.background,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Sunset Dinner"),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: child,
        ),  
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only( left: 0, right: 0, top: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}