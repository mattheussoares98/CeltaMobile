import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infraestructure/infrastructure.dart';

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
Box hiveBoxTransferBetweenStocks(Ref ref) {
  return Hive.box(DatabaseConstants.transferBetweenStocks.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxTransferRequestLastSavedNumber(Ref ref) {
  return Hive.box(DatabaseConstants.transferRequestLastSavedNumber.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxTransferRequest(Ref ref) {
  return Hive.box(DatabaseConstants.transferRequest.name);
}

@Riverpod(keepAlive: true)
Box hiveBoxUserSession(Ref ref) {
  return Hive.box(DatabaseConstants.userSession.name);
}
