import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadInventoryDatasource soapLoadInventoryDatasource(Ref ref) {
  return SoapLoadInventoryDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadInventoryRepository soapLoadInventoryRepository(Ref ref) {
  return SoapLoadInventoryRepositoryImpl(
    ref.watch(soapLoadInventoryDatasourceProvider),
  );
}

@riverpod
ISoapInventoryProductsDatasource soapInventoryProductsDatasource(Ref ref) {
  return SoapInventoryProductsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInventoryProductsRepository soapInventoryProductsRepository(Ref ref) {
  return SoapInventoryProductsRepositoryImpl(
    ref.watch(soapInventoryProductsDatasourceProvider),
  );
}
