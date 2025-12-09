import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/scanner/scanner.dart';

part 'barcode_scanner_state_controller.g.dart';

@riverpod
class BarcodeScannerStateController extends _$BarcodeScannerStateController {
  @override
  Future<String?> build() async {
    return await ref.read(barcodeScannerRepositoryProvider).scan();
  }
}
