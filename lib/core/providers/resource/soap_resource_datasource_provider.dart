import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/resource/resource.dart';
import '../soap/soap.dart';

part 'soap_resource_datasource_provider.g.dart';

@riverpod
ISoapResourceDatasource soapResourceDatasource(Ref ref) {
  return SoapResourceDatasource(ref.watch(soapRequestProvider));
}
