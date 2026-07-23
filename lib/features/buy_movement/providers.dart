import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/buy_movement/data/datasource/datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcBuyMovementDatasource ecBuyMovementDatasource(Ref ref) {
  return EcBuyMovementDatasource(ref.watch(httpClientProvider));
}
