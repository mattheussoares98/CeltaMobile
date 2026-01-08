import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'insert_transfer_request_controller.g.dart';

@Riverpod(keepAlive: true)
class InsertTransferRequestController
    extends _$InsertTransferRequestController {
  @override
  FutureOr<void> build(DraftKey draftKey) {}

  Future<void> insert() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final products = await ref.read(
        cartProductsStateControllerProvider(draftKey).future,
      );

      final response = await ref
          .read(soapInsertTransferRequestRepositoryProvider)
          .save(
            urlInUse: validatedUser!.enterprise!.urlInUse!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            enterpriseOriginCode: draftKey.enterpriseOrigin,
            enterpriseDestinyCode: draftKey.enterpriseDestinyCode,
            requestTypeCode: draftKey.requestTypeCode,
            products: products,
          );

      await ref
          .read(lastSavedNumberStateControllerProvider.notifier)
          .save(response);
      await ref
          .read(cartProductsStateControllerProvider(draftKey).notifier)
          .clearLot();
    });
  }
}
