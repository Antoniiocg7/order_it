import 'package:flutter/foundation.dart';
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
        ), // Text
      ), // AppBar
      body: Center(
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
              if (kDebugMode) {
                print("Success");
              }
            }, onCancel: () {
              if (kDebugMode) {
                print("Cancel");
              }
            }, onError: (e) {
              if (kDebugMode) {
                print("Error:$e");
              }
            });

            if (kDebugMode) {
              print(items);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
          ), // BeveledRectangleBorder
          child: const Text("Checkout"),
        ), // TextButton // Center
      ), // Scaffold
    );
  }
}
