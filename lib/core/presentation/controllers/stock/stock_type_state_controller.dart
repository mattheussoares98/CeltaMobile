import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../providers/stock/stock.dart';
import '../user_session/user_session.dart';

part 'stock_type_state_controller.g.dart';

@riverpod
class StockTypeStateController extends _$StockTypeStateController {
  @override
  Future<List<StockTypeEntity>> build(int enterpriseCode) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    final repository = ref.watch(soapStockTypeRepositoryProvider);
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final baseUrl = userSession!.enterprise.baseUrl!;
    final crossIdentity = userSession.user.CrossIdentity_Usuario!;

    return await repository.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );
  }
}
