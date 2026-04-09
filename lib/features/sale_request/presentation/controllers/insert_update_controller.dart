import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import 'controllers.dart';

part 'insert_update_controller.g.dart';

@riverpod
class InsertUpdateController extends _$InsertUpdateController {
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

    if (saleRequestId == 0) {
      //!inserting
      return BSFSaleRequestEntity.empty();
    }

    return await ref.read(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).future,
    );
  }
}
