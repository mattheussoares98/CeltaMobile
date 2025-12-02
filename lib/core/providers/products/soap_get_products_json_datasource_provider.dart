import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/products/products.dart';
import '../soap/soap.dart';

part 'soap_get_products_json_datasource_provider.g.dart';

@riverpod
ISoapGetProductsJsonDatasource soapGetProductsJsonDatasource(Ref ref) {
  return SoapGetProductsJsonDatasource(ref.watch(soapRequestProvider));
}
