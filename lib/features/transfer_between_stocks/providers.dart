import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

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
