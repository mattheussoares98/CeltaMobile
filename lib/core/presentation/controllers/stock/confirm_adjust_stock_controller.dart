import 'dart:async';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/providers/user_session/user_session.dart';
import '../../../../exceptions/exceptions.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/stock/stock.dart';

part 'confirm_adjust_stock_controller.g.dart';

@riverpod
class ConfirmAdjustStockController extends _$ConfirmAdjustStockController {
  @override
  FutureOr<void> build() {}

  Future<void> confirm(List<AdjustStockItemEntity> items) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(soapAdjustStockRepositoryProvider);
      final userSession = await ref.watch(userSessionProvider.future);

      if (userSession == null) {
        throw AppException(
          'Sessão inválida. Efetue o login novamente'.hardcoded,
        );
      }
      final baseUrl = userSession.enterprise.baseUrl!;
      final crossIdentity = userSession.user.CrossIdentity_Usuario!;

      await repository.confirm(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        items: items,
      );
    });
  }
}
