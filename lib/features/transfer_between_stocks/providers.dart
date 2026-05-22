import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/hive/hive.dart';
import 'package:celta_inventario/features/transfer_between_stocks/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/transfer_between_stocks/data/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ILocalItemsLotDatasource localItemsLotDatasource(Ref ref) {
  return LocalItemsLotDatasource(
    ref.watch(hiveBoxTransferBetweenStocksProvider),
  );
}

@riverpod
ILocalItemsLotRepository localItemsLotRepository(Ref ref) {
  return LocalItemsLotRepositoryImpl(
    ref.watch(localItemsLotDatasourceProvider),
  );
}
