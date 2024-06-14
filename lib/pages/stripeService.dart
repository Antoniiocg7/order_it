import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static String secretKey =
      "sk_test_51PRMsUDNItGpGPanSipjoAS5aaf0OyH3Yr0MgPNkqMP3CSmxFYyht6ypDU6N9bctRwgOdIxNykZlfu1uY56yRpwn00FK0Esa9f";
  static String publishableKey =
      "pk_test_51PRMsUDNItGpGPanTb1ysM18Z2iMUyjZ2SH3j08759KsOr7USkADaLLoziMQ2IL0FswP66v5BMQGfB8W24dSFn29001ag2hXNB";

  static Future<dynamic> createCheckoutSession(
    List<dynamic> productItems,
    totalAmount,
  ) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");

    String lineItems = "";
    int index = 0;

    productItems.forEach(
      (val) {
        var productPrice = (val["productPrice"] * 100).round().toString();
        lineItems +=
            "&line_items[$index][price_data][product_data][name]=${val['productName']}";
        lineItems +=
            "&line_items[$index][price_data][unit_amount]=$productPrice";
        lineItems +=
            "&line_items[$index][price_data][currency]=EUR";
        lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";
        index++;
      },
    );

    final response = await http.post(url,
        body:
            'success-url=https://checkout.stripe.dev/success&mode=payment$lineItems',
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form'
        });

    return json.decode(response.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
    productItems,
    subTotal,
    context,
    mounted, {
    onSuccess,
    onCancel,
    onError,
  }) async {
    
    final String sessionId = await createCheckoutSession(
      productItems,
      subTotal,
    );

    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey: publishableKey,
      successUrl: "https://checkout.stripe.dev/success",
      canceledUrl: "https://checkout.stripe.dev/cancel",
    );

    if (mounted) {
      final text = result.when(
        redirected: () => 'Redirected Successfuly',
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );

      return text;
    }
  }
}
