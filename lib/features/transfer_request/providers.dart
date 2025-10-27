import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadDestinyEnterprisesDatasource soapLoadDestinyEnterprisesDatasource(
  Ref ref,
) {
  return SoapLoadDestinyEnterprisesDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadDestinyEnterprisesRepository soapLoadDestinyEnterprisesRepository(
  Ref ref,
) {
  return SoapLoadDestinyEnterprisesRepositoryImpl(
    ref.watch(soapLoadDestinyEnterprisesDatasourceProvider),
  );
}

@riverpod
ISoapLoadProductByRequestTypeDatasource soapLoadProductByRequestTypeDatasource(
  Ref ref,
) {
  return SoapLoadProductByRequestTypeDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadProductByRequestTypeRepository soapLoadProductByRequestTypeRepository(
  Ref ref,
) {
  return SoapLoadProductByRequestTypeRepositoryImpl(
    ref.watch(soapLoadProductByRequestTypeDatasourceProvider),
  );
}

@riverpod
ILocalTransferRequestDatasource localTransferRequestDatasource(Ref ref) {
  return LocalTransferRequestDatasource(
    ref.watch(hiveBoxTransferRequestProvider),
  );
}

@riverpod
ILocalTransferRequestRepository localTransferRequestRepository(Ref ref) {
  return LocalTransferRequestRepositoryImpl(
    ref.watch(localTransferRequestDatasourceProvider),
  );
}
