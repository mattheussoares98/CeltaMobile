import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/inventory/data/datasource/datasource.dart';
import 'package:celta_inventario/features/inventory/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/inventory/data/repositories/repositories.dart';

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
ISoapInventoryEntryQuantityDatasource soapInventoryEntryQuantityDatasource(
  Ref ref,
) {
  return SoapInventoryEntryQuantityDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInventoryEntryQuantityRepository soapInventoryEntryQuantityRepository(
  Ref ref,
) {
  return SoapInventoryEntryQuantityRepositoryImpl(
    ref.watch(soapInventoryEntryQuantityDatasourceProvider),
  );
}

@riverpod
ISoapInventoryAnnulDatasource soapInventoryAnnulDatasource(Ref ref) {
  return SoapInventoryAnnulDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInventoryAnnulRepository soapInventoryAnnulRepository(Ref ref) {
  return SoapInventoryAnnulRepositoryImpl(
    ref.watch(soapInventoryAnnulDatasourceProvider),
  );
}
