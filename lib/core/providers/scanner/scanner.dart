import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/scanner/scanner.dart';
import '../../domain/repositories/scanner/scanner.dart';

part 'scanner.g.dart';

@riverpod
IBarcodeScannerDatasource barcodeScannerDatasource(Ref ref) {
  return FlutterBarcodeScannerDatasource();
}

@riverpod
IBarcodeScannerRepository barcodeScannerRepository(Ref ref) {
  return BarcodeScannerRepositoryImpl(
    ref.watch(barcodeScannerDatasourceProvider),
  );
}
