import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:order_it/components/my_button.dart';
import 'package:order_it/pages/delivery_progress_page.dart';
import 'package:order_it/services/supabase_api.dart';

class PaymentPage3 extends StatefulWidget {
  const PaymentPage3({super.key});

  @override
  State<PaymentPage3> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage3> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;

  void userTappedPay() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      // Si el formulario es válido
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirmar pago"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Número de tarjeta: $cardNumber"),
                Text("Validez: $expiryDate"),
                Text("Titular: $cardHolderName"),
                Text("CVV: $cvvCode"),
              ],
            ),
          ),
          actions: [
            // Cancelar
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar")),

            TextButton(
              onPressed: () async {
                final SupabaseApi supabase = SupabaseApi();
                try {
                  // Asegurarse de que la actualización del estado del carrito se complete antes de continuar
                  await supabase.updateCartState();
                } catch (e) {
                  // Manejar el error si la actualización falla
                  if (kDebugMode) {
                    print("Error al actualizar el estado del carrito: $e");
                  }
                  return; // Salir si hay un error
                }

                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeliveryProgressPage(),
                    ),
                  );
                }
              },
              child: const Text("Sí"),
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
        title: const Text("Confirmar pago"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tarjeta
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                onCreditCardWidgetChange: (p0) {},
              ),
              const SizedBox(height: 20),
              // Formulario
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
                formKey: formKey,
              ),
              const SizedBox(height: 20),
              MyButton(onTap: userTappedPay, text: "Pagar"),
            ],
          ),
        ),
      ),
    );
  }
}
