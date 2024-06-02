/*import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TableQRCodeGenerator extends StatelessWidget {
  final int tableNumber;

  const TableQRCodeGenerator({Key? key, required this.tableNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String qrData = 'table:$tableNumber'; // Identificador único para cada mesa
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code for Table $tableNumber'),
      ),
      body: Center(
        child: QrImage(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}*/
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:base64/base64.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRCodeGeneratorPage(),
    );
  }
}

class QRCodeGeneratorPage extends StatefulWidget {
  @override
  _QRCodeGeneratorPageState createState() => _QRCodeGeneratorPageState();
}

class _QRCodeGeneratorPageState extends State<QRCodeGeneratorPage> {

  final String baseUrl = 'https://gapuibdxbmoqjhibirjm.supabase.co';
  final String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
  final String authorization = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";


  Future<List<Map<String, dynamic>>> getTables() async {
    final url = '$baseUrl/rest/v1/tables?select=*';
    final headers = {
      'Content-Type': 'application/json',
      'apikey': apiKey,
      'Authorization': 'Bearer $authorization'
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load tables');
    }
  }

  Future<void> generateAndSaveQRCode(String data, int tableId) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );
      if (qrValidationResult.status == QrValidationStatus.valid && qrValidationResult.qrCode != null) {
        final qrCode = qrValidationResult.qrCode!;
        final painter = QrPainter.withQr(
          qr: qrCode,
          color: const Color(0xFF000000),
          emptyColor: const Color(0xFFFFFFFF),
          gapless: true,
          embeddedImageStyle: null,
          embeddedImage: null,
        );

        final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
        final buffer = picData!.buffer;
        final qrBase64 = base64Encode(buffer.asUint8List(picData.offsetInBytes, picData.lengthInBytes));

        // Guardar el código QR en la base de datos
        await saveQRCodeToDatabase(tableId, qrBase64);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveQRCodeToDatabase(int tableId, String qrBase64) async {
    final url = '$baseUrl/rest/v1/tables?id=eq.$tableId';
    final headers = {
      'apikey': apiKey,
      'Authorization': 'Bearer $authorization',
      'Content-Type': 'application/json'
    };

    final body = jsonEncode({
      'qr_code': qrBase64,
    });

    final response = await http.patch(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 204) {
      print('QR code for table $tableId saved successfully.');
    } else {
      print('Failed to save QR code for table $tableId: ${response.statusCode} ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final tables = await getTables();
              for (var table in tables) {
                final tableId = table['id'];
                final url = '$baseUrl/rest/v1/tables/$tableId';
                await generateAndSaveQRCode(url, tableId);
                print('QR code for table $tableId generated and saved.');
              }
            } catch (e) {
              print('Error: $e');
            }
          },
          child: Text('Generate QR Codes'),
        ),
      ),
    );
  }
}

