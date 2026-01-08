import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'insert_update_customer_controller.g.dart';

@riverpod
class InsertUpdateCustomerController extends _$InsertUpdateCustomerController {
  @override
  FutureOr<void> build() {}

  Future<void> insertUpdate() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final customer = await ref.read(customerStateControllerProvider.future);
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      return await ref
          .read(soapInsertUpdateCustomerRepositoryProvider)
          .insertOrUpdateCustomer(
            customer: customer!,
            urlInUse: validatedUser!.enterprise!.urlInUse!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          );
    });
  }
}
