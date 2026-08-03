import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pdf_from_sale_request_details_state_controller.g.dart';

@riverpod
class PdfFromSaleRequestDetailsStateController
    extends _$PdfFromSaleRequestDetailsStateController {
  @override
  FutureOr<Uint8List?> build(SaleRequestArgs args) async {
    ref.cache();

    final saleRequest = await ref.watch(
      saleRequestDetailsStateControllerProvider(args).future,
    );

    return await ref
        .read(generatePdfRepositoryProvider)
        .bsfGeneration(saleRequest);
  }
}
