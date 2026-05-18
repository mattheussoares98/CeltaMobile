import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/customer/customer.dart';
import '../../data/repositories/customer/customer.dart';
import '../../domain/repositories/customer/customer.dart';
import '../http/http.dart';
import '../soap/soap.dart';

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
