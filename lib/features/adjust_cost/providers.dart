import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/http/http.dart';
import 'data/datasource/datasource.dart';

part 'providers.g.dart';

@riverpod
IEcAdjustCostDatasource adjustCostDatasource(Ref ref) {
  return EcAdjustCostDatasource(ref.watch(httpClientProvider));
}
