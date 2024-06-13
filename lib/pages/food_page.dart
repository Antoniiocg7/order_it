import 'package:flutter/material.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/models/addon.dart';
import 'package:order_it/models/food.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  
  final Food food;
  final bool ordersAllowed;
  final Map<Addon, bool> selectedAddons = {};

  FoodPage({super.key, required this.food, required this.ordersAllowed}) {
    // Inicializamos los complementos seleccionados a false
    for (Addon addon in food.addons ?? []) {
      selectedAddons[addon] = false;
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  // Método para añadir al carrito
  void addToCart(Food food, Map<Addon, bool> selectedAddons) async {
    // Cerramos la anterior página para volver al menú
    if (!mounted) return;

    List<Addon> currentlySelectedAddons = [];
    for (Addon addon in widget.food.addons ?? []) {
      if (widget.selectedAddons[addon] == true) {
        currentlySelectedAddons.add(addon);
      }
    }

    



    // Añadir al carrito
    bool success = await context.read<Restaurant>().addToCart(food, currentlySelectedAddons);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Imagen
                Image.asset(widget.food.imagePath),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre
                      Text(
                        widget.food.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      // Precio
                      Text(
                        "${widget.food.price}€",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Descripción
                      Text(widget.food.description),
                      const SizedBox(height: 10),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Complementos",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Complementos
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.food.addons?.length ?? 0,
                          itemBuilder: (context, index) {
                            // Recoger el complemento individualmente
                            Addon addon = widget.food.addons![index];

                            if (widget.ordersAllowed) {
                              // Checkbox del complemento
                              return CheckboxListTile(
                                title: Text(addon.name),
                                subtitle: Text(
                                  "${addon.price}€",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                value: widget.selectedAddons[addon],
                                onChanged: (bool? value) {
                                  setState(() {
                                    widget.selectedAddons[addon] = value!;
                                  });
                                },
                              );
                            } else {
                              // Lista de complementos
                              return ListTile(
                                title: Text(addon.name),
                                subtitle: Text(
                                  "${addon.price}€",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón -> Añadir al carrito (Solo si ordersAllowed es true)
                if (widget.ordersAllowed)
                  MyButton(
                    text: "Añadir al carrito",
                    onTap: () => addToCart(widget.food, widget.selectedAddons),
                  ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        // Botón back
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
