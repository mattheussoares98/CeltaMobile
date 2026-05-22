import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/stock/stock.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';

part 'stock_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class StockTypeStateController extends _$StockTypeStateController {
  @override
  Future<List<StockTypeEntity>> build(int enterpriseCode) async {
    final repository = ref.watch(soapStockTypeRepositoryProvider);
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final workingUrl = userSession!.enterprise!.workingUrl!;
    final crossIdentity = userSession.user.CrossIdentity_Usuario!;

    return await repository.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );
  }
}
