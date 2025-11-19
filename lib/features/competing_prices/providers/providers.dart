import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/soap/soap.dart';
import '../data/datasource/datasource.dart';
import '../domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadResearchsDatasource soapLoadResearchsDatasource(Ref ref) {
  return SoapLoadResearchsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadResearchsRepository soapLoadResearchsRepository(Ref ref) {
  return SoapLoadResearchsRepositoryImpl(
    ref.watch(soapLoadResearchsDatasourceProvider),
  );
}

@riverpod
ISoapInsertUpdateResearchDatasource soapInsertUpdateResearchDatasource(
  Ref ref,
) {
  return SoapInsertUpdateResearchDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInsertUpdateResearchRepository soapInsertUpdateResearchRepository(
  Ref ref,
) {
  return SoapInsertUpdateResearchRepositoryImpl(
    ref.watch(soapInsertUpdateResearchDatasourceProvider),
  );
}

@riverpod
ISoapLoadConcurrentsDatasource soapLoadConcurrentsDatasource(Ref ref) {
  return SoapLoadConcurrentsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadConcurrentsRepository soapLoadConcurrentsRepository(Ref ref) {
  return SoapLoadConcurrentsRepositoryImpl(
    ref.watch(soapLoadConcurrentsDatasourceProvider),
  );
}
