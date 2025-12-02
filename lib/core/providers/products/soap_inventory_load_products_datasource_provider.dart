import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/products/products.dart';
import '../soap/soap.dart';

part 'soap_inventory_load_products_datasource_provider.g.dart';

@riverpod
ISoapInventoryLoadProductsDatasource soapInventoryLoadProductsDatasource(
  Ref ref,
) {
  return SoapInventoryLoadProductsDatasource(ref.watch(soapRequestProvider));
}
