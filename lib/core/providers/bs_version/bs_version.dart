import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/bs_version/bs_version.dart';
import '../soap/soap.dart';

part 'bs_version.g.dart';

@riverpod
ISoapBsVersionDatasource soapBsVersionDatasource(Ref ref) {
  return SoapBsVersionDatasource(ref.watch(soapRequestProvider));
}
