
import 'package:flutter/material.dart';
import 'package:order_it/models/food.dart';

class Restaurant extends ChangeNotifier{

  final List<Food> _menu = [

    // BURGUERS
    Food(
      name: "Classic Cheeseburguer", 
      description: "Una jugosa ternera madurada con extra de queso", 
      imagePath: "lib/images/dishes/classic_burguer.jpeg", 
      price: 0.99, 
      category: FoodCategory.burguers, 
      availableAddons: [
        Addon(name: "Extra queso", price: 0.99),
        Addon(name: "Bacon", price: 1.99),
        Addon(name: "Extra carne", price: 2.99),
      ]
    ),
    Food(
      name: "Vegan Burguer", 
      description: "Una suculenta hamburguesa vegana", 
      imagePath: "lib/images/dishes/vegan_burguer.jpg", // Rellena la ruta de la imagen aquí
      price: 8.99, 
      category: FoodCategory.burguers, 
      availableAddons: [
        Addon(name: "Huevo frito", price: 1.49),
        Addon(name: "Aguacate", price: 1.99),
        Addon(name: "Chiles jalapeños", price: 0.99),
      ]
    ),
    Food(
      name: "Yakisoba", 
      description: "Jugosos fideos con pollo de primera calidad", 
      imagePath: "lib/images/dishes/fideos_pollo.png", // Rellena la ruta de la imagen aquí
      price: 10.99, 
      category: FoodCategory.burguers, 
      availableAddons: [
        Addon(name: "Tomillo", price: 1.49),
        Addon(name: "Rúcula", price: 0.99),
        Addon(name: "Salsa de trufa", price: 2.99),
      ]
    ),
    Food(
      name: "BBQ Ranch Burger", 
      description: "Una deliciosa hamburguesa con salsa BBQ, queso cheddar y aderezo ranchero", 
      imagePath: "lib/images/dishes/bbq_burguer.jpeg", // Rellena la ruta de la imagen aquí
      price: 9.99, 
      category: FoodCategory.burguers, 
      availableAddons: [
        Addon(name: "Cebolla rostizada", price: 1.49),
        Addon(name: "Pimiento jalapeño", price: 0.99),
        Addon(name: "Lechuga y tomate frescos", price: 0.79),
      ]
    ),
    Food(
      name: "Salmon Fresco", 
      description: "Un salmon noruego fresco, de altísima calidad", 
      imagePath: "lib/images/dishes/salmon.png", // Rellena la ruta de la imagen aquí
      price: 9.49, 
      category: FoodCategory.burguers, 
      availableAddons: [
        Addon(name: "Tomate en rodajas", price: 0.79),
        Addon(name: "Cebolla roja encurtida", price: 1.29),
        Addon(name: "Hojas de espinaca fresca", price: 0.99),
      ]
    ),


    // SALADS
    Food(
      name: "Caesar Salad", 
      description: "Fresca lechuga romana con aderezo Caesar y crutones", 
      imagePath: "lib/images/salads/caesar_salad.jpeg", // Rellena la ruta de la imagen aquí
      price: 6.99, 
      category: FoodCategory.salads, 
      availableAddons: [
        Addon(name: "Pollo a la parrilla", price: 2.99),
        Addon(name: "Langostinos", price: 4.99),
        Addon(name: "Aguacate", price: 1.99),
      ]
    ),
    Food(
      name: "Caprese Salad", 
      description: "Ensalada fresca con tomates, mozzarella de búfala y albahaca", 
      imagePath: "lib/images/salads/normal_salad.jpeg", // Rellena la ruta de la imagen aquí
      price: 9.49, 
      category: FoodCategory.salads, 
      availableAddons: [
        Addon(name: "Vinagre balsámico", price: 0.99),
        Addon(name: "Aceite de oliva virgen", price: 0.79),
        Addon(name: "Pesto", price: 1.29),
      ]
    ),
    Food(
      name: "Cobb Salad", 
      description: "Ensalada clásica con pollo a la parrilla, aguacate, bacon y huevo duro", 
      imagePath: "lib/images/salads/ensalada1.png", // Rellena la ruta de la imagen aquí
      price: 11.49, 
      category: FoodCategory.salads, 
      availableAddons: [
        Addon(name: "Queso azul desmenuzado", price: 1.99),
        Addon(name: "Tomates cherry", price: 0.79),
        Addon(name: "Aceitunas negras", price: 0.99),
      ]
    ),
    Food(
      name: "Asian Sesame Salad", 
      description: "Ensalada fresca con pollo a la parrilla, fideos de arroz crujientes y aderezo de sésamo", 
      imagePath: "lib/images/salads/ensalada2.png", // Rellena la ruta de la imagen aquí
      price: 10.49, 
      category: FoodCategory.salads, 
      availableAddons: [
        Addon(name: "Zanahorias ralladas", price: 0.99),
        Addon(name: "Cacahuetes tostados", price: 1.29),
        Addon(name: "Cilantro fresco", price: 0.79),
      ]
    ),
    Food(
      name: "Quinoa Salad", 
      description: "Ensalada nutritiva de quinoa con vegetales frescos y vinagreta de limón", 
      imagePath: "lib/images/salads/ensalada3.jpeg", // Rellena la ruta de la imagen aquí
      price: 8.99, 
      category: FoodCategory.salads, 
      availableAddons: [
        Addon(name: "Aguacate en cubitos", price: 1.49),
        Addon(name: "Pimientos asados", price: 0.99),
        Addon(name: "Semillas de girasol tostadas", price: 0.79),
      ]
    ),


    // SIDES
    Food(
      name: "Alitas de pollo", 
      description: "Alitas de pollo rebozadas al estilo Kentucky", 
      imagePath: "lib/images/sides/chicken_wings.png", // Rellena la ruta de la imagen aquí
      price: 2.49, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Queso fundido", price: 1.49),
        Addon(name: "Salsa BBQ", price: 0.99),
        Addon(name: "Cebolla caramelizada", price: 1.99),
      ]
    ),
    Food(
      name: "Nachos Rancheros", 
      description: "Nachos mexicanos acompañados de salsa ranchera y pico de gallo", 
      imagePath: "lib/images/sides/nachos.png", // Rellena la ruta de la imagen aquí
      price: 5.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Salsa picante", price: 0.99),
        Addon(name: "Ranch dressing", price: 0.79),
        Addon(name: "Salsa de ajo", price: 1.29),
      ]
    ),
    Food(
      name: "Aros de cebolla", 
      description: "Crujientes aros de cebolla fritos y sazonados", 
      imagePath: "lib/images/sides/onion_rings.jpg", // Rellena la ruta de la imagen aquí
      price: 4.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Salsa de arándanos", price: 1.49),
        Addon(name: "Salsa de cilantro y lima", price: 0.99),
        Addon(name: "Queso cheddar derretido", price: 1.79),
      ]
    ),
    Food(
      name: "Pan de ajo", 
      description: "Pan tostado con mantequilla de ajo y perejil", 
      imagePath: "lib/images/sides/pan_ajo.png", // Rellena la ruta de la imagen aquí
      price: 3.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Queso parmesano rallado", price: 1.49),
        Addon(name: "Tomates secos", price: 1.29),
        Addon(name: "Champiñones salteados", price: 1.79),
      ]
    ),
    Food(
      name: "Verduras a la plancha", 
      description: "Verduras frescas a la plancha con aceite de oliva virgen extra y sal", 
      imagePath: "lib/images/sides/verduras.png", // Rellena la ruta de la imagen aquí
      price: 4.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Salsa de yogur y eneldo", price: 0.99),
        Addon(name: "Salsa de tomate picante", price: 0.79),
        Addon(name: "Mayonesa de ajo", price: 1.29),
      ]
    ),


    // DRINKS
    Food(
      name: "Coca Cola", 
      description: "Refrescante Coca-Cola servida bien fría", 
      imagePath: "lib/images/drinks/cocacola.png", // Rellena la ruta de la imagen aquí
      price: 1.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Hielo extra", price: 0.49),
        Addon(name: "Limón", price: 0.29),
        Addon(name: "Cereza", price: 0.59),
      ]
    ),
    Food(
      name: "Agua", 
      description: "Agua de mineralizazión débil", 
      imagePath: "lib/images/drinks/agua.jpg", // Rellena la ruta de la imagen aquí
      price: 2.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Hierbabuena", price: 0.50),
        Addon(name: "Melocotón", price: 0.75),
        Addon(name: "Fresa", price: 0.99),
      ]
    ),
    Food(
      name: "Cerveza", 
      description: "Refrescante cerveza alemana", 
      imagePath: "lib/images/drinks/beer.png", // Rellena la ruta de la imagen aquí
      price: 8.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Hierbabuena fresca", price: 1.49),
        Addon(name: "Azúcar moreno", price: 0.99),
        Addon(name: "Soda de limón", price: 0.79),
      ]
    ),
    Food(
      name: "Zumo", 
      description: "Zumo de naranja natural", 
      imagePath: "lib/images/drinks/zumo.png", // Rellena la ruta de la imagen aquí
      price: 4.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Cardamomo molido", price: 0.99),
        Addon(name: "Sirope de rosa", price: 1.49),
        Addon(name: "Nuez moscada", price: 0.79),
      ]
    ),
    Food(
      name: "Vino Tinto", 
      description: "Vino tinto reserva", 
      imagePath: "lib/images/drinks/wine.png", // Rellena la ruta de la imagen aquí
      price: 5.49, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Sirope de agave", price: 0.99),
        Addon(name: "Leche de almendras", price: 1.29),
        Addon(name: "Ron blanco (opcional)", price: 2.99),
      ]
    ),


    // DESSERTS

    Food(
      name: "Tarta de chocolate", 
      description: "Deliciosa tarta de chocolate caliente con helado de vainilla", 
      imagePath: "lib/images/desserts/chocolate_cake.jpeg", // Rellena la ruta de la imagen aquí
      price: 4.99, 
      category: FoodCategory.desserts, 
      availableAddons: [
        Addon(name: "Nueces", price: 0.99),
        Addon(name: "Caramelo", price: 1.49),
        Addon(name: "Crema batida", price: 0.79),
      ]
    ),
    Food(
      name: "Cheesecake", 
      description: "Delicioso pastel de queso con salsa de frutos rojos", 
      imagePath: "lib/images/desserts/cheese_cake.jpeg", // Rellena la ruta de la imagen aquí
      price: 7.99, 
      category: FoodCategory.desserts, 
      availableAddons: [
        Addon(name: "Frambuesas frescas", price: 1.49),
        Addon(name: "Mango en rodajas", price: 1.99),
        Addon(name: "Chocolate rallado", price: 0.99),
      ]
    ),
    Food(
      name: "MilkShake", 
      description: "Batido de leche vainilla y plátano", 
      imagePath: "lib/images/desserts/milkshakes.jpeg", // Rellena la ruta de la imagen aquí
      price: 6.99, 
      category: FoodCategory.desserts, 
      availableAddons: [
        Addon(name: "Helado de vainilla", price: 1.99),
        Addon(name: "Canela en polvo", price: 0.49),
        Addon(name: "Nuez moscada", price: 0.79),
      ]
    ),
    Food(
      name: "Tarta 3 leches", 
      description: "Tarta de leche casera con una base de galletas y crema batida", 
      imagePath: "lib/images/desserts/milk_cake.png", // Rellena la ruta de la imagen aquí
      price: 7.49, 
      category: FoodCategory.desserts, 
      availableAddons: [
        Addon(name: "Merengue tostado", price: 1.99),
        Addon(name: "Ralladura de lima", price: 0.79),
        Addon(name: "Hojas de menta fresca", price: 0.49),
      ]
    ),
    Food(
      name: "Tortitas con chocolate", 
      description: "Tortitas esponjosas con sirope de chocolate", 
      imagePath: "lib/images/desserts/tortitas.png", // Rellena la ruta de la imagen aquí
      price: 7.99, 
      category: FoodCategory.desserts, 
      availableAddons: [
        Addon(name: "Fresas frescas", price: 1.49),
        Addon(name: "Virutas de chocolate", price: 0.99),
        Addon(name: "Granillo de almendra", price: 0.79),
      ]
    ),

  ];

  /*
    G E T T E R S
  */
  List<Food> get menu => _menu;

  /*
    O P E R A T I O N S
  */
  // ADD TO CART

  // REMOVE FROM CART

  // GET TOTAL PRICE OF CART

  // GET TOTAL NUMBER OF ITEMS IN CART

  // CLEAR CART

  /*
    H E L P E R S
  */

  // GENERATE A RECEIPT

  // FORMAT DOUBLE VALUE INTO MONEY

  // FORMAT LIST OF ADDONS INTO A STRING SUMMARY



}