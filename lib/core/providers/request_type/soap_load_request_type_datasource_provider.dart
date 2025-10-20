import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/request_type/request_type.dart';
import '../soap/soap.dart';

part 'soap_load_request_type_datasource_provider.g.dart';

@riverpod
ISoapLoadRequestTypeDatasource soapLoadRequestTypeDatasource(Ref ref) {
  return SoapLoadRequestTypeDatasource(ref.watch(soapRequestProvider));
}
