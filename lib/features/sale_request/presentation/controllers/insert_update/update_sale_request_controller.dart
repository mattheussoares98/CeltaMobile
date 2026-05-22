import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';

part 'update_sale_request_controller.g.dart';

@riverpod
class UpdateSaleRequestController extends _$UpdateSaleRequestController {
  @override
  FutureOr<void> build(int saleRequestCode, int enterpriseCode) {}

  Future<void> updateSaleRequest(BSFSaleRequestEntity saleRequest) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      await ref
          .read(ecSaleRequestsRepositoryProvider)
          .update(
            saleRequest: saleRequest,
            enterpriseCode: enterpriseCode,
            params: EcRequestParams(
              workingUrl: validatedUser!.enterprise!.workingUrl!,
              user: validatedUser.user.name!,
              accessKey: validatedUser.user.AccessKey!,
            ),
          );
    });
  }
}
