import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/stock/stock.dart';
import 'stock.dart';

part 'soap_adjust_stock_repository_provider.g.dart';

@riverpod
ISoapAdjustStockRepository soapAdjustStockRepository(Ref ref) {
  return SoapAdjustStockRepositoryImpl(
    ref.watch(soapAdjustStockDatasourceProvider),
  );
}
