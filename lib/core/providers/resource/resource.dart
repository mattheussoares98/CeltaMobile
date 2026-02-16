import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/resource/resource.dart';
import '../../domain/repositories/resource/resource.dart';
import '../soap/soap.dart';

part 'resource.g.dart';

@riverpod
ISoapResourceDatasource soapResourceDatasource(Ref ref) {
  return SoapResourceDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapResourceRepository soapResourceRepository(Ref ref) {
  return SoapResourceRepositoryImpl(ref.watch(soapResourceDatasourceProvider));
}
