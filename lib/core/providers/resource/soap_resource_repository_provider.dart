import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/resource/resource.dart';
import 'resource.dart';

part 'soap_resource_repository_provider.g.dart';

@riverpod
ISoapResourceRepository soapResourceRepository(Ref ref) {
  return SoapResourceRepositoryImpl(ref.watch(soapResourceDatasourceProvider));
}
