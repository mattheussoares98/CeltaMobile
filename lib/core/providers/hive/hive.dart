import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/infraestructure/infrastructure.dart';

part 'hive.g.dart';

@Riverpod(keepAlive: true)
Box hiveBoxAppSettings(Ref ref) {
  return Hive.box(DatabaseConstants.appSettings.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxBuyRequest(Ref ref) {
  return Hive.box(DatabaseConstants.buyRequest.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxSaleRequest(Ref ref) {
  return Hive.box(DatabaseConstants.saleRequest.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxTransferBetweenStocks(Ref ref) {
  return Hive.box(DatabaseConstants.transferBetweenStocks.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxTransferRequest(Ref ref) {
  return Hive.box(DatabaseConstants.transferRequest.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxUserSession(Ref ref) {
  return Hive.box(DatabaseConstants.userSession.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxFavoriteModules(Ref ref) {
  return Hive.box(DatabaseConstants.favoriteModules.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxLastSelectedEnterpriseCode(Ref ref) {
  return Hive.box(DatabaseConstants.lastSelectedEnterpriseCode.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxAppUsage(Ref ref) {
  return Hive.box(DatabaseConstants.appUsage.name);
}

@riverpod
List<Box> boxesToClearOnLogout(Ref ref) {
  return [
    ref.watch(hiveBoxAppSettingsProvider),
    ref.watch(hiveBoxBuyRequestProvider),
    ref.watch(hiveBoxSaleRequestProvider),
    ref.watch(hiveBoxTransferBetweenStocksProvider),
    ref.watch(hiveBoxTransferRequestProvider),
    ref.watch(hiveBoxLastSelectedEnterpriseCodeProvider),
  ];
}
