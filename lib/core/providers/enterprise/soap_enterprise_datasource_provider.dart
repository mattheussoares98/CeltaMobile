import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/enterprise/enterprise.dart';
import '../soap/soap.dart';

part 'soap_enterprise_datasource_provider.g.dart';

@riverpod
ISoapEnterpriseDatasource soapEnterpriseDatasource(Ref ref) {
  final soapAdapter = ref.watch(soapRequestProvider);
  return SoapEnterpriseDatasource(soapAdapter: soapAdapter);
}
