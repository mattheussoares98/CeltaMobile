import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/bs_version/bs_version.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

part 'bs_version.g.dart';

@riverpod
ISoapBsVersionDatasource soapBsVersionDatasource(Ref ref) {
  return SoapBsVersionDatasource(ref.watch(soapRequestProvider));
}
