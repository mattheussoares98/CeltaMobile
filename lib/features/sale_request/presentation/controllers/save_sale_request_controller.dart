import 'dart:async';

import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'save_sale_request_controller.g.dart';

@riverpod
class SaveSaleRequestController extends _$SaveSaleRequestController {
  @override
  FutureOr<void> build() {}

  Future<void> save({required int requestTypeCode}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validateduser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final pending = await ref.read(
        pendingSaleRequestStateControllerProvider.future,
      );
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      if (pending.customer == null) {
        throw AppException('Selecione o cliente!'.hardcoded);
      }

      final saleRequestNumber = await ref
          .read(soapSaveSaleRequestRepositoryProvider)
          .save(
            baseUrl: validateduser!.enterprise!.baseUrl!,
            crossIdentity: validateduser.user.CrossIdentity_Usuario!,
            enterpriseCode: selectedEnterprise!.Code!,
            requestTypeCode: requestTypeCode,
            saleRequest: pending,
          );

      await ref
          .read(
            lastSavedSaleRequestStateControllerProvider(
              selectedEnterprise.Code!,
            ).notifier,
          )
          .save(
            LastSavedSaleRequestEntity(
              pendingSaleRequestEntity: pending,
              saleRequestNumber: saleRequestNumber!,
            ),
          );

      await ref.read(localPendingSaleRequestRepositoryProvider).clear();
      ref.invalidate(localPendingSaleRequestRepositoryProvider);
    });
  }
}
