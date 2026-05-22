import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/customer/customer.dart';
import 'package:celta_inventario/core/data/repositories/customer/customer.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';
import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

part 'customer.g.dart';

@riverpod
ISoapCustomerDatasource soapCustomerDatasource(Ref ref) {
  return SoapCustomerDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapCustomerRepository soapCustomerRepository(Ref ref) {
  return SoapCustomerRepositoryImpl(ref.watch(soapCustomerDatasourceProvider));
}

@riverpod
IEcCustomersDatasource ecCustomersDatasource(Ref ref) {
  return EcCustomersDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcCustomersRepository ecCustomersRepository(Ref ref) {
  return EcCustomersRepositoryImpl(ref.watch(ecCustomersDatasourceProvider));
}
