import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
