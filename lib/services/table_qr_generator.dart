import 'package:flutter/material.dart';
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
}
