import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../providers.dart';

part 'send_to_print_controller.g.dart';

@riverpod
class SendToPrintController extends _$SendToPrintController {
  @override
  Future<void> build() async {}

  Future<void> send({
    required String productPackingCode,
    required bool newValue,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      await ref
          .read(soapSendToPrintRepositoryProvider)
          .send(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            enterpriseCode: selectedEnterprise!.Code!,
            productPackingCode: productPackingCode,
            newValue: newValue,
          );
    });
  }
}
