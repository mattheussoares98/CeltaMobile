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
