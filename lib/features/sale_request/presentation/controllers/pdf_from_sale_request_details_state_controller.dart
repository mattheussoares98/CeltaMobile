import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers.dart';
import 'controllers.dart';

part 'pdf_from_sale_request_details_state_controller.g.dart';

@riverpod
class PdfFromSaleRequestDetailsStateController
    extends _$PdfFromSaleRequestDetailsStateController {
  @override
  FutureOr<Uint8List?> build({
    required int customerCode,
    required int enterpriseCode,
    required int saleRequestCode,
  }) async {
    final saleRequest = await ref.read(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestCode,
      ).future,
    );

    return await ref
        .read(generatePdfRepositoryProvider)
        .bsfGeneration(saleRequest);
  }
}
