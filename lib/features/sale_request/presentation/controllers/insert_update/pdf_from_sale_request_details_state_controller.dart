import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers.dart';
import 'insert_update.dart';

part 'pdf_from_sale_request_details_state_controller.g.dart';

@riverpod
class PdfFromSaleRequestDetailsStateController
    extends _$PdfFromSaleRequestDetailsStateController {
  @override
  FutureOr<Uint8List?> build() async {
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

    final saleRequest = await ref.watch(
      saleRequestDetailsStateControllerProvider(
        ref.read(saleRequestArgsProvider),
      ).future,
    );

    return await ref
        .read(generatePdfRepositoryProvider)
        .bsfGeneration(saleRequest);
  }
}
