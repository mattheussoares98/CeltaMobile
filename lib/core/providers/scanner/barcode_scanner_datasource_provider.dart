import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/scanner/scanner.dart';

part 'barcode_scanner_datasource_provider.g.dart';

@riverpod
IBarcodeScannerDatasource barcodeScannerDatasource(Ref ref) {
  return FlutterBarcodeScannerDatasource();
}
