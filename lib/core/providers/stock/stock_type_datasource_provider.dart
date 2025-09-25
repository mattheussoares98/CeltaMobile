import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/stock/stock.dart';
import '../soap/soap.dart';

part 'stock_type_datasource_provider.g.dart';

@riverpod
ISoapStockTypeDatasource soapStockTypeDatasource(Ref ref) {
  return SoapStockTypeDatasource(ref.watch(soapRequestProvider));
}
