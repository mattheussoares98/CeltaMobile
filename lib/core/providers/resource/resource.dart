import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/resource/resource.dart';
import 'package:celta_inventario/core/domain/repositories/resource/resource.dart';
import 'package:celta_inventario/core/data/repositories/resource/resource.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

part 'resource.g.dart';

@riverpod
ISoapResourceDatasource soapResourceDatasource(Ref ref) {
  return SoapResourceDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapResourceRepository soapResourceRepository(Ref ref) {
  return SoapResourceRepositoryImpl(ref.watch(soapResourceDatasourceProvider));
}
