import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/request_type/request_type.dart';
import 'request_type.dart';

part 'soap_load_request_type_repository_provider.g.dart';

@riverpod
ISoapLoadRequestTypeRepository soapLoadRequestTypeRepository(Ref ref) {
  return SoapLoadRequestTypeRepositoryImpl(
    ref.watch(soapLoadRequestTypeDatasourceProvider),
  );
}
