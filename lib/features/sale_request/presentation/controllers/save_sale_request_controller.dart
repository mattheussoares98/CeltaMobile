import 'dart:async';

import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'save_sale_request_controller.g.dart';

@riverpod
class SaveSaleRequestController extends _$SaveSaleRequestController {
  @override
  FutureOr<void> build() {}

  Future<void> save({
    required int requestTypeCode,
    required String observations,
    required String instructions,
    required int enterpriseCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validateduser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final pending = await ref.read(
        pendingSaleRequestStateControllerProvider(enterpriseCode).future,
      );

      if (pending.customer == null) {
        throw AppException('Selecione o cliente!'.hardcoded);
      }

      final saleRequestNumber = await ref
          .read(soapSaveSaleRequestRepositoryProvider)
          .save(
            workingUrl: validateduser!.enterprise!.workingUrl!,
            crossIdentity: validateduser.user.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
            saleRequest: pending.copyWith(
              observations: observations,
              instructions: instructions,
            ),
          );

      await ref
          .read(
            lastSavedSaleRequestStateControllerProvider(
              enterpriseCode,
            ).notifier,
          )
          .save(
            LastSavedSaleRequestEntity(
              pendingSaleRequestEntity: pending.copyWith(
                observations: observations,
                instructions: instructions,
              ),
              saleRequestNumber: saleRequestNumber!,
            ),
          );

      await ref
          .read(localPendingSaleRequestRepositoryProvider)
          .clear(enterpriseCode);
      ref.invalidate(localPendingSaleRequestRepositoryProvider);
    });
  }
}
