import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'update_sale_request_controller.g.dart';

@riverpod
class UpdateSaleRequestController extends _$UpdateSaleRequestController {
  @override
  FutureOr<void> build(int saleRequestCode, int enterpriseCode) {}

  Future<bool> updateSaleRequest(BSFSaleRequestEntity saleRequest) async {
    state = const AsyncValue.loading();
    bool updated = false;
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      updated = await ref
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

    return updated;
  }
}
