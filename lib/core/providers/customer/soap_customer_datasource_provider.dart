import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/customer/customer.dart';
import '../soap/soap.dart';

part 'soap_customer_datasource_provider.g.dart';

@riverpod
ISoapCustomerDatasource soapCustomerDatasource(Ref ref) {
  return SoapCustomerDatasource(ref.watch(soapRequestProvider));
}
