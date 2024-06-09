import 'package:flutter/material.dart';
import 'package:order_it/pages/home_page.dart';
import 'package:order_it/services/supabase_api.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AssignTable extends StatefulWidget {
  final String userId;

  const AssignTable({super.key, required this.userId});

  @override
  State<AssignTable> createState() => _AssignTableState();
}

class _AssignTableState extends State<AssignTable> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  SupabaseApi supabaseApi = SupabaseApi();

  // Método para cuando la aplicación se recompone (funcionalidad de la cámara)
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  // Liberar recursos de la cámara cuando el widget se elimina del árbol de widgets
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Listener para escuchar los datos escaneados
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (result == null && scanData.code != null) {
        setState(() {
          result = scanData;
        });
        await _scanTableQR(scanData.code!);
      }
    });
  }

  Future<void> _scanTableQR(String qrCode) async {
    const String baseUrl = 'https://gapuibdxbmoqjhibirjm.supabase.co';
    const String apiKey =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
    const String authorization =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhcHVpYmR4Ym1vcWpoaWJpcmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MjU1NDIsImV4cCI6MjAyOTQwMTU0Mn0.ytby3w54RxY_DkotV0g_eNiLVAJjc678X97l2kjUz9E";
    bool isOccupied;

    //print('QR Code content: $qrCode');

    // Extraer el número de mesa del contenido del código QR (asumiendo que es una URL)
    Uri uri = Uri.parse(qrCode);
    final String tableNumberQuery = uri.queryParameters['table_number'] ?? '';
    //String tableNumber = tableNumberQuery.replaceAll("eq.", "");
    int tableNumber = int.tryParse(tableNumberQuery.replaceAll("eq.", "")) ?? 0;

    if (tableNumber == 0) {
      //print('No se ha encontrado número de mesa en el QR Code URL.');
      _showDialog('Error',
          'No se ha encontrado número de mesa en el QR Code URL.', () {});
      return;
    }

    isOccupied = await supabaseApi.getIsOccupied(tableNumber);
    //print(isOccupied);

    // Componer la URL para la petición PATCH
    final url = '$baseUrl/rest/v1/tables?table_number=eq.$tableNumber';
    //print('Composed URL: $url');

    // Extract table ID from the QR code data
    //final String tableNumber = qrCode.replaceAll('https://gapuibdxbmoqjhibirjm.supabase.co:/rest/v1/tables?table_number=eq.', '');

    final headers = {
      'apikey': apiKey,
      'Authorization': authorization,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'is_occupied': true,
      'user_id': widget.userId,
    });

    final response =
        await http.patch(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 204) {
      if (isOccupied) {
        //print('La mesa $tableNumber está ocupada, escoja otra por favor.');
        _showDialog('Error',
            'La mesa $tableNumber está ocupada, escoja otra por favor.', () {});
      } else {
        //print('Table $tableNumber assigned successfully.');
        _showDialog('Table Assigned',
            'Table $tableNumber has been successfully assigned to you.', () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(ordersAllowed: true)),
          );
        });
      }
      //await supabaseApi.assignTable(widget.userId, tableNumber);
    } else {
      //print('***************** tableNumber: $tableNumber *****************');
      //print('Error al asignar la mesa $tableNumber: ${response.statusCode} ${response.body}');
      _showDialog('Error', 'Error al asignar la mesa $tableNumber.', () {});
    }
  }

  void _showDialog(String title, String content, VoidCallback onOkPressed) {
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
                  result =
                      null; // Resetea el resultado para poder escanear otro QR
                });
                controller?.resumeCamera(); // Resume camera for scanning
                onOkPressed(); // Ejecutar la acción del showdialog dinámicamente, (errores/éxito)
              },
              child: const Text('OK'),
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
        title: const Text('Elige tu mesa'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: (result != null)
                  ? Text('Escaneado: ${result!.code}')
                  : const Text('Escanea el código QR'),
            ),
          ),
        ],
      ),
    );
  }
  /*
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
  }*/
}
