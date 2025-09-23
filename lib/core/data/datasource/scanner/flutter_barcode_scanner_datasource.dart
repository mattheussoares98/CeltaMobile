import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

import 'scanner.dart';

class FlutterBarcodeScannerDatasource implements IBarcodeScannerDatasource {
  @override
  Future<String?> scan() async {
    final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancelar',
      true,
      ScanMode.BARCODE,
    );

    if (barcodeScanRes == '-1') {
      return null;
    }

    return barcodeScanRes;
  }
}
