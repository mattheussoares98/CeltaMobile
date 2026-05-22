import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/stock/stock.dart';
import 'package:celta_inventario/core/domain/repositories/stock/stock.dart';
import 'package:celta_inventario/core/data/repositories/stock/stock.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

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
