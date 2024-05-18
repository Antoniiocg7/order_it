import 'package:flutter/material.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {

  final Food food;
  final Map<Addon, bool> selectedAddons = {};

  FoodPage({
    super.key, 
    required this.food
  }){
    // INITIALIZE SELECTED ADDONS TO BE FALSE
    for (Addon addon in food.availableAddons ){
      selectedAddons[addon] = false;
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {

  // METHOD TO ADD TO CART
  void addToCart( Food food, Map<Addon, bool> selectedAddons ){

    // CLOSE THE CURRENT FOOD PAGE TO GO BACK MENU
    Navigator.pop(context);

    // FORMAT THE SELECTED ADDONS
    List<Addon> currentlySelectedAddons = [];
    for ( Addon addon in widget.food.availableAddons ){
      if( widget.selectedAddons[addon] == true ){
        currentlySelectedAddons.add(addon);
      }
    } 

    // ADD TO CART
    context.read<Restaurant>().addToCart(food, currentlySelectedAddons);
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        //SCAFFOLD UI
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              
              children: [
                // FOOD IMAGE
                Image.asset(widget.food.imagePath,),
            
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FOOD NAME
                      Text(
                        widget.food.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
            
                      // FOOD PRICE
                      Text(
                        "${widget.food.price}€",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary
                        ),
                      ),
            
                      const SizedBox( height: 10 ),
                  
                      // FOOD DESCRIPTION
                      Text(
                        widget.food.description,
                      ),
            
                      const SizedBox( height: 10 ),
            
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
            
                      const SizedBox( height: 10 ),
            
                      Text(
                        "Add-ons",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
            
                      const SizedBox( height: 10 ),
                  
                      // ADDONS
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary
                          ),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.food.availableAddons.length,
                          itemBuilder: (context, index) {
                                    
                            // GET INDIVIDUAL ADDON
                            Addon addon = widget.food.availableAddons[index];
                                    
                            // RETURN CHECK BOX UI
                            return CheckboxListTile(
                              title: Text(addon.name),
                              subtitle: Text(
                                "${addon.price}€", 
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                              value: widget.selectedAddons[addon], 
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.selectedAddons[addon] = value!;
                                });
                              }
                            );
                          },
                        ),
                      ),
                      
                    ],
                  ),
                ),
            
                // BUTTON -> ADD TO CART
                MyButton(
                  text: "Add to cart", 
                  onTap: () => addToCart(widget.food, widget.selectedAddons),
                ),

                const SizedBox( height: 25 )
                
              ],
            ),
          ),
        ),

        // BACK BUTTON
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only( left: 25 ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        )
      ],
    );
  }
}