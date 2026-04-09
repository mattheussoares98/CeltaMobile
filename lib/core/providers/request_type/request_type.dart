import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/request_type/request_type.dart';
import '../../domain/repositories/request_type/request_type.dart';
import '../http/http.dart';
import '../soap/soap.dart';

part 'request_type.g.dart';

@riverpod
ISoapLoadRequestTypeDatasource soapLoadRequestTypeDatasource(Ref ref) {
  return SoapLoadRequestTypeDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadRequestTypeRepository soapLoadRequestTypeRepository(Ref ref) {
  return SoapLoadRequestTypeRepositoryImpl(
    ref.watch(soapLoadRequestTypeDatasourceProvider),
  );
}

@riverpod
IEcGetRequestTypesDatasource ecGetRequestTypesDatasource(Ref ref) {
  return EcGetRequestTypesDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcGetRequestTypesRepository ecGetRequestTypesRepository(Ref ref) {
  return EcGetRequestTypesRepositoryImpl(
    ref.watch(ecGetRequestTypesDatasourceProvider),
  );
}
