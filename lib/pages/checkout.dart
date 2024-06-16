import 'package:flutter/material.dart';
import 'stripe_services.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stripe Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300, // Set your desired maximum width
            maxHeight: 50, // Set your desired maximum height
          ),
          child: TextButton(
            onPressed: () async {
              var items = [
                {
                  "productPrice": 4,
                  "productName": 'Apple',
                  "qty": 5,
                },
                {
                  "productPrice": 4,
                  "productName": 'Pineapple',
                  "qty": 5,
                }
              ];

              await StripeService.stripePaymentCheckout(
                  items, 500, context, mounted, onSuccess: () {
                print("Success");
              }, onCancel: () {
                print("Cancel");
              }, onError: (e) {
                print("Error:" + e.toString());
              });

              print(items);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1)),
              ),
            ),
            child: const Text("Checkout"),
          ),
        ),
      ),
    );
  }
}
