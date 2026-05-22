import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/customer_register/providers.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';

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

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.insertUpdateCustomer);

      return await ref
          .read(soapInsertUpdateCustomerRepositoryProvider)
          .insertOrUpdateCustomer(
            customer: customer!,
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          );
    });
  }
}
