import 'package:flutter/material.dart';
import 'ckeckout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CheckoutPage(),
    );
  }
}
 


/* import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Charges',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChargesPage(),
    );
  }
}

class ChargesPage extends StatefulWidget {
  @override
  _ChargesPageState createState() => _ChargesPageState();
}

class _ChargesPageState extends State<ChargesPage> {
  final String apiKey =
      'sk_test_51PRMsUDNItGpGPanSipjoAS5aaf0OyH3Yr0MgPNkqMP3CSmxFYyht6ypDU6N9bctRwgOdIxNykZlfu1uY56yRpwn00FK0Esa9f';
  List<dynamic> charges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCharges();
  }

  Future<void> fetchCharges() async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/prices'),
      headers: {
        'Authorization': 'Bearer sk_test_51PRMsUDNItGpGPanSipjoAS5aaf0OyH3Yr0MgPNkqMP3CSmxFYyht6ypDU6N9bctRwgOdIxNykZlfu1uY56yRpwn00FK0Esa9f',
        //'limit': "3"
        //'Stripe-Account': 'acct_1032D82eZvKYlo2C'
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {
        charges = json.decode(response.body)['data'];
        isLoading = false;
      });
    } else {
      print('Request failed with status: ${response.body}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Charges'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: charges.length,
              itemBuilder: (context, index) {
                final charge = charges[index];
                return ListTile(
                  title: Text('Charge ID: ${charge['id']}'),
                  subtitle:
                      Text('Amount: ${charge['amount']} ${charge['currency']}'),
                );
              },
            ),
    );
  }
}
 */