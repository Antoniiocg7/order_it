import 'package:flutter/material.dart';
import 'package:order_it/components/my_receipt.dart';

class DeliveryProgressPage extends StatelessWidget {
  const DeliveryProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para deshabilitar volver atrás
        return false;
      },
    
    child: const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            MyReceipt(),
          ],
        ),
      ),
    ));
  }

  // CUSTOM BUTTON NAVBAR - MESSAGE / CALL DELIVERY DRIVER
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          // PROFILE PICK OF DRIVER
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          ),

          const SizedBox(width: 10),

          // DRIVER DETAILS
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Antonio Cañizares",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              Text(
                "Driver",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ],
          ),

          const Spacer(),

          Row(
            children: [
              // MESSAGE BUTTON
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ),

              const SizedBox(width: 10),

              // CALL BUTTON
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.call,
                      color: Colors.green,
                    )),
              ),

              
            ],
          )
        ],
      ),
    );
  }
}
