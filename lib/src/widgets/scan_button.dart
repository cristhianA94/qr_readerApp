import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:provider/provider.dart';
import 'package:qr_reader/src/providers/scan_list_provider.dart';

import 'package:qr_reader/src/utils/utils.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        elevation: 5,
        child: Icon(Icons.filter_center_focus),
        onPressed: () async {
          String barcodeScanRes = 'unknown';

          try {
            // TODO QR Reader
            barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                '#3D8BEF', 'Cancelar', true, ScanMode.QR);
            // String barcodeScanRes = 'https://www.linkedin.com/in/cristhian-apolo-cevallos/';
            barcodeScanRes = 'geo:25.761532437749285, -80.19085136196087';
          } on PlatformException {
            barcodeScanRes = 'Fallo en la obtención del codigo.';
          }

          // Si el usuario cancelo el Scan
          if (barcodeScanRes == '-1') return;

          final scanListProvider =
              Provider.of<ScanListProvider>(context, listen: false);

          if (barcodeScanRes == '-1') {
            final nuevoScan = await scanListProvider.nuevoScan(barcodeScanRes);
            launchURL(context, nuevoScan);
          }
        },
      ),
    );
  }
}
