import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/stock/stock.dart';
import 'stock.dart';

part 'soap_stock_type_repository_provider.g.dart';

@riverpod
ISoapStockTypeRepository soapStockTypeRepository(Ref ref) {
  return SoapStockTypeRepositoryImpl(
    ref.watch(soapStockTypeDatasourceProvider),
  );
}
