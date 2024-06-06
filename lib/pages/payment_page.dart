import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:order_it/components/my_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;

  // USER WANTS TO PAY
  void userTappedPay() {
    if(formKey.currentState!.validate()){
      // ONLY SHOW DIALOG IF YOUR FORM IS VALID
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Confirm payment"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Card Number: $cardNumber"),
                Text("Expiry Date: $expiryDate"),
                Text("Card Holder name: $cardHolderName"),
                Text("CVV: $cvvCode"),
              ],
            ),
          ),
          actions: [
            // CANCEL BUTTON
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")
            ),

            // ACCEPT BUTTON
            TextButton(
              onPressed: () {
                
                

                /* Navigator.pop(context);
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => const DeliveryProgressPage()
                  )
                ); */
              },
              child: const Text("Yes")
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Checkout"),
      ),
      body: Column(
        children: [

          // CREDIT CARD
          CreditCardWidget(
            cardNumber: cardNumber, 
            expiryDate: expiryDate,
            cardHolderName: cardHolderName, 
            cvvCode: cvvCode, 
            showBackView: isCvvFocused, 
            onCreditCardWidgetChange: (p0) {
              
            },
          ),

          // CREDIT CARD FORM
          CreditCardForm(
            cardNumber: cardNumber, 
            expiryDate: expiryDate, 
            cardHolderName: cardHolderName, 
            cvvCode: cvvCode, 
            onCreditCardModelChange: (data) {
              setState(() {
                cardNumber = data.cardNumber;
                expiryDate = data.expiryDate;
                cardHolderName = data.cardHolderName;
                cvvCode = data.cvvCode;
              });
            }, 
            formKey: formKey
          ),

          const Spacer(),

          MyButton(
            onTap: userTappedPay, 
            text: "Pay now!"
          ),
        ],
      ),
    );
  }
}