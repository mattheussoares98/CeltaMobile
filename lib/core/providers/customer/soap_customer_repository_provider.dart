import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/customer/customer.dart';
import 'customer.dart';

part 'soap_customer_repository_provider.g.dart';

@riverpod
ISoapCustomerRepository soapCustomerRepository(Ref ref) {
  return SoapCustomerRepositoryImpl(ref.watch(soapCustomerDatasourceProvider));
}
