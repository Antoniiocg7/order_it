import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:order_it/models/cart_food.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/pages/delivery_progress_page.dart';
import 'package:order_it/pages/home_page.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final List<CartFood> userCart;
  static const double iva = 0.10;

  const PaymentPage({super.key, required this.userCart});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final List<CartFood> userCart = restaurant.getUserCart;
        final subtotal = (restaurant.getTotalPrice());

        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirma tu pago'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(ordersAllowed: true),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.cancel_rounded,
                  size: 25,
                ),
              )
            ],
            titleSpacing: 5.2,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Tu carrito',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: userCart.map((cartFood) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      cartFood.food.imagePath,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    cartFood.food.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${restaurant.formatPrice(cartFood.food.price * cartFood.quantity)} (${cartFood.quantity} uds.) ',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${restaurant.formatPrice(subtotal)} ',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Impuestos',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '10 %',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 2),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        restaurant.formatPrice(subtotal * 1.10),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 225),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          _showAddPaymentMethodModal(restaurant);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 14, 80, 44),
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text('Finalizar compra'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddPaymentMethodModal(Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentForm(restaurant: restaurant),
            ],
          ),
        );
      },
    );
  }
}

class PaymentForm extends StatefulWidget {
  final Restaurant restaurant;

  const PaymentForm({super.key, required this.restaurant});

  @override
  PaymentFormState createState() => PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;
  bool isLoading = false;

  Future<void> userTappedPay() async {
    setState(() {
      isLoading = true;
    });

    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      final total = widget.restaurant.getTotalPrice() * 1.10;

      final SupabaseApi supabaseApi = SupabaseApi();
      await supabaseApi.createCart(widget.restaurant.getUserCart, total);

      if (context.mounted) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const DeliveryProgressPage(),
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
            ),
            const SizedBox(height: 10),
            CreditCardForm(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              formKey: formKey,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },
            ),
            const SizedBox(height: 33),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: userTappedPay,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 14, 80, 44),
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Pagar ${widget.restaurant.formatPrice(widget.restaurant.getTotalPrice() * 1.10)}',
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
