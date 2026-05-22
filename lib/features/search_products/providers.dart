import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/search_products/data/datasource/datasource.dart';
import 'package:celta_inventario/features/search_products/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/search_products/data/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapSendToPrintDatasource soapSendToPrintDatasource(Ref ref) {
  return SoapSendToPrintDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapSendToPrintRepository soapSendToPrintRepository(Ref ref) {
  return SoapSendToPrintRepositoryImpl(
    ref.watch(soapSendToPrintDatasourceProvider),
  );
}
