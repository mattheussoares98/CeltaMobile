import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/domain/repositories/request_type/request_type.dart';
import 'package:celta_inventario/core/data/repositories/request_type/request_type.dart';
import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

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
