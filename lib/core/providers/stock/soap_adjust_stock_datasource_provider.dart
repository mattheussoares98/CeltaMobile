import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/stock/stock.dart';
import '../soap/soap.dart';

part 'soap_adjust_stock_datasource_provider.g.dart';

@riverpod
ISoapAdjustStockDatasource soapAdjustStockDatasource(Ref ref) {
  return SoapAdjustStockDatasource(ref.watch(soapRequestProvider));
}
