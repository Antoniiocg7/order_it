import 'package:flutter/material.dart';
import 'package:order_it/components/my_current_location.dart';
import 'package:order_it/components/my_description_box.dart';
import 'package:order_it/components/my_drawer.dart';
import 'package:order_it/components/my_sliver_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(
            title: const Text("Title"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),

                //MY CURRENT LOCATION
                const MyCurrentLocation(),

                //DESCRIPTION BOX
                const MyDescriptionBox()

              ],
            )
          )
        ], 
        body: Container(color: Colors.teal,)
      ),
    );
  }
}