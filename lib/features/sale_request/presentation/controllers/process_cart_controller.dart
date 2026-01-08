import 'dart:async';

import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'process_cart_controller.g.dart';

@riverpod
class ProcessCartController extends _$ProcessCartController {
  @override
  FutureOr<void> build() {}

  Future<void> process({required int requestTypeCode}) async {
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

      final processedCart = await ref
          .read(soapProcessCartRepositoryProvider)
          .process(
            crossId: validateduser!.user.CrossIdentity_Usuario!,
            workingUrl: validateduser.enterprise!.workingUrl!,
            enterpriseCode: selectedEnterprise!.Code!,
            requestTypeCode: requestTypeCode,
            customerCode: pending.customer!.Code!,
            covenantCode: pending.covenant?.covenant?.Code,
            products: pending.cart.values
                .map((e) => e.copyWith(DiscountValue: 0))
                .toList(),
          );

      await ref
          .read(pendingSaleRequestStateControllerProvider.notifier)
          .updateProductsFromProcessedCart(processedCart);
    });
  }
}
