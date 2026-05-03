import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/stock/stock.dart';
import '../../domain/repositories/stock/stock.dart';
import '../../data/repositories/stock/stock.dart';
import '../soap/soap.dart';

part 'stock.g.dart';

@riverpod
ISoapAdjustStockDatasource soapAdjustStockDatasource(Ref ref) {
  return SoapAdjustStockDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapAdjustStockRepository soapAdjustStockRepository(Ref ref) {
  return SoapAdjustStockRepositoryImpl(
    ref.watch(soapAdjustStockDatasourceProvider),
  );
}

@riverpod
ISoapStockTypeDatasource soapStockTypeDatasource(Ref ref) {
  return SoapStockTypeDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapStockTypeRepository soapStockTypeRepository(Ref ref) {
  return SoapStockTypeRepositoryImpl(
    ref.watch(soapStockTypeDatasourceProvider),
  );
}
