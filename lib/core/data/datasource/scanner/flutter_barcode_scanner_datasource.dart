import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // Required for PlatformException
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

import 'scanner.dart';

class FlutterBarcodeScannerDatasource implements IBarcodeScannerDatasource {
  @override
  Future<String?> scan() async {
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );

      // The library returns '-1' if the user cancels
      if (barcodeScanRes == '-1') {
        return null;
      }

      return barcodeScanRes;
    } on PlatformException catch (e) {
      // Logic for specific platform errors (e.g., permission denied)
      debugPrint('Platform Error: ${e.message}');
      return null;
    } catch (e) {
      // Generic catch to prevent the crash
      debugPrint('Unexpected Error: $e');
      return null;
    }
  }
}
