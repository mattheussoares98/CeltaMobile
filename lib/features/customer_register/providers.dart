import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapCustomerDatasource soapCustomerDatasource(Ref ref) {
  return SoapCustomerDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapCustomerRepository soapCustomerRepository(Ref ref) {
  return SoapCustomerRepositoryImpl(ref.watch(soapCustomerDatasourceProvider));
}
