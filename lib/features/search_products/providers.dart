import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';
import 'data/repositories/repositories.dart';

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
