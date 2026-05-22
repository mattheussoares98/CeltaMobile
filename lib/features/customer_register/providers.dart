import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/customer_register/data/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadCovenantsDatasource soapLoadCovenantsDatasource(Ref ref) {
  return SoapLoadCovenantsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadCovenantsRepository soapLoadCovenantsRepository(Ref ref) {
  return SoapLoadCovenantsRepositoryImpl(
    ref.watch(soapLoadCovenantsDatasourceProvider),
  );
}

@riverpod
ISoapInsertUpdateCustomerDatasource soapInsertUpdateCustomerDatasource(
  Ref ref,
) {
  return SoapInsertUpdateCustomerDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInsertUpdateCustomerRepository soapInsertUpdateCustomerRepository(
  Ref ref,
) {
  return SoapInsertUpdateCustomerRepositoryImpl(
    ref.watch(soapInsertUpdateCustomerDatasourceProvider),
  );
}
