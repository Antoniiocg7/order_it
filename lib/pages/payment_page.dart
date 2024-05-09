
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/pages/delivery_progress_page.dart';

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
          title: const Text("Realizar Pago"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Numero tarjeta: $cardNumber"),
                Text("Mes/Año: $expiryDate"),
                Text("Titular Tarjeta: $cardHolderName"),
                Text("CVV: $cvvCode"),
              ],
            ),
          ),
          actions: [
            // CANCEL BUTTON
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")
            ),

            // ACCEPT BUTTON
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => const DeliveryProgressPage()
                  )
                );
              },
              child: const Text("Si")
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
            text: "¡Paga y disfruta de tu comida!"
          ),
        ],
      ),
    );
  }
}