import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import 'controllers.dart';

part 'insert_update_state_controller.g.dart';

@riverpod
class InsertUpdateStateController extends _$InsertUpdateStateController {
  @override
  FutureOr<BSFSaleRequestEntity> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestId,
  }) async {
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

    final paymentOptionsFuture = ref.read(
      paymentOptionsStateControllerProvider(enterpriseCode).future,
    );

    if (saleRequestId == 0) {
      //!inserting
      await paymentOptionsFuture;
      return BSFSaleRequestEntity.empty();
    }

    final saleRequestDetailsFuture = ref.read(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).future,
    );

    final results = await Future.wait([
      paymentOptionsFuture,
      saleRequestDetailsFuture,
    ]);

    return results[1] as BSFSaleRequestEntity;
  }
}
