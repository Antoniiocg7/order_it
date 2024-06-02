import 'package:flutter/material.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class AssignTable extends StatefulWidget {

  final String userId;

  const AssignTable({
    super.key,
    required this.userId
  });

  @override
  _AssignTableState createState() => _AssignTableState();
}

class _AssignTableState extends State<AssignTable> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  SupabaseApi supabaseApi = SupabaseApi();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (result == null && scanData.code != null) {
        setState(() {
          result = scanData;
        });
        await _ScanTableQR(scanData.code!);
      }
    });
  }

  Future<void> _ScanTableQR(String qrCode) async {

    const String baseUrl = 'https://gapuibdxbmoqjhibirjm.supabase.co';
    const String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
    const String authorization = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
    

    // Imprimir el contenido del código QR para ver cómo está estructurado
    print('QR Code content: $qrCode');


    // Extraer el número de mesa del contenido del código QR (asumiendo que es una URL)
    Uri uri = Uri.parse(qrCode);
    final String tableNumberQuery = uri.queryParameters['table_number'] ?? '';
    String tableNumber = tableNumberQuery.replaceAll("eq.", "");

    if (tableNumber.isEmpty) {
      print('No se ha encontrado número de mesa en el QR Code URL.');
      _showDialog('Error', 'No se ha encontrado número de mesa en el QR Code URL.');
      return;
    }

    // Componer la URL para la petición PATCH
    final url = '$baseUrl/rest/v1/tables?table_number=eq.$tableNumber';
    print('Composed URL: $url');


    // Extract table ID from the QR code data
    //final String tableNumber = qrCode.replaceAll('https://gapuibdxbmoqjhibirjm.supabase.co:/rest/v1/tables?table_number=eq.', '');

    final headers = {
      'apikey': apiKey,
      'Authorization': authorization,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'is_occupied': true,
      //'user_id': 'example_user_id', // Replace with actual user ID
    });

    final response = await http.patch(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 204) {
      print('Table $tableNumber assigned successfully.');
      _showDialog('Table Assigned', 'Table $tableNumber has been successfully assigned to you.');
      
    } else {
      print('***************** tableNumber: $tableNumber *****************');
      print('Failed to assign table $tableNumber: ${response.statusCode} ${response.body}');
      _showDialog('Error', 'Failed to assign table $tableNumber.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  result = null; // Reset result to allow scanning another QR code
                });
                controller?.resumeCamera(); // Resume camera for scanning
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Table'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Scanned: ${result!.code}')
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }
}
