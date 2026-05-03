import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/soap/soap.dart';
import '../data/datasource/datasource.dart';
import '../domain/repository/repository.dart';
import '../data/repository/repository.dart';

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
ISoapConcurrentsDatasource soapConcurrentsDatasource(Ref ref) {
  return SoapConcurrentsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapConcurrentsRepository soapConcurrentsRepository(Ref ref) {
  return SoapConcurrentsRepositoryImpl(
    ref.watch(soapConcurrentsDatasourceProvider),
  );
}

@riverpod
ISoapInsertUpdatePricesDatasource soapInsertUpdatePricesDatasource(Ref ref) {
  return SoapInsertUpdatePricesDatasource(ref.watch(soapRequestProvider));
}
