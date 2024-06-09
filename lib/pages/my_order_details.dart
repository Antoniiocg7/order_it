import 'package:flutter/material.dart';

class MyOrderDetails extends StatefulWidget {
  const MyOrderDetails({super.key});

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Resumen de tu pedido'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Color.fromARGB(255, 211, 210, 208),
                child:  Column(
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                                  ),
                                  Text(
                    '19,89 €',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                                  ),
                    
                    ],
                                  ),
              
              
              SizedBox(height: 8),
              Divider(height: 32, thickness: 2, color: Colors.green, ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '1',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Menú GRANDE Receta',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    '17,90 €',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Elige 1',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Menú Poke - Salmón BBQ Grande 2,00 €',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Elige la base de tu poke',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Arroz sushi 0,00 €',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Elige la bebida para tu menú poke',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Cerveza Levante 0,00 €',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Elige tu postre para tu menú poke',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Cheese cake 1,00 €',
                style: TextStyle(fontSize: 14),
              ),

            ]),

              )
            ],
          ),
        ),
      ),
    );
  }
}
