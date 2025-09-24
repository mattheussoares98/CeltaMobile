import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/scanner/scanner.dart';
import 'scanner.dart';

part 'barcode_scanner_repository_provider.g.dart';

@riverpod
IBarcodeScannerRepository barcodeScannerRepository(Ref ref) {
  return BarcodeScannerRepositoryImpl(
    ref.watch(barcodeScannerDatasourceProvider),
  );
}
