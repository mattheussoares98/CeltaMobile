import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../domain/entity/entity.dart';
import '../../../providers.dart';

part 'receipts_state_controller.g.dart';

@riverpod
class ReceiptsStateController extends _$ReceiptsStateController {
  @override
  FutureOr<List<ReceiptEntity>> build(int enterpriseCode) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadReceiptsRepositoryProvider)
        .loadReceipts(
          baseUrl: validatedUser!.enterprise!.baseUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
        );
  }
}
