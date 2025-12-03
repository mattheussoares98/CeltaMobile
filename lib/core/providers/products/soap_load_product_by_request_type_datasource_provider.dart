import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/products/products.dart';
import '../soap/soap.dart';

part 'soap_load_product_by_request_type_datasource_provider.g.dart';

@riverpod
ISoapLoadProductByRequestTypeDatasource soapLoadProductByRequestTypeDatasource(
  Ref ref,
) {
  return SoapLoadProductByRequestTypeDatasource(ref.watch(soapRequestProvider));
}
