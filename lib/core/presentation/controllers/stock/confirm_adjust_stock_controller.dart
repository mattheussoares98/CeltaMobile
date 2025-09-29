import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../../../providers/stock/stock.dart';
import '../user_session/user_session.dart';

part 'confirm_adjust_stock_controller.g.dart';

@riverpod
class ConfirmAdjustStockController extends _$ConfirmAdjustStockController {
  @override
  FutureOr<void> build() {}

  Future<void> confirm(List<AdjustStockItemEntity> items) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 3));
      throw Exception('error');
      final repository = ref.read(soapAdjustStockRepositoryProvider);
      final userSession = await ref.read(validatedUserSessionProvider.future);

      final baseUrl = userSession!.enterprise!.baseUrl!;
      final crossIdentity = userSession.user.CrossIdentity_Usuario!;

      await repository.confirm(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        items: items,
      );
    });
  }
}
