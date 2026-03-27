import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../exceptions/exceptions.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'pdf_from_last_saved_sale_request_controller.g.dart';

@riverpod
class PdfFromLastSavedSaleRequestController
    extends _$PdfFromLastSavedSaleRequestController {
  @override
  FutureOr<Uint8List?> build() async {
    final selectedEnterprise = ref.read(
      selectedEnterpriseStateControllerProvider,
    );

    final lastSaved = await ref.read(
      lastSavedSaleRequestStateControllerProvider(
        selectedEnterprise!.Code!,
      ).future,
    );

    if (lastSaved == null) {
      throw AppException(
        'Não foi encontrado pedido salvo para a empresa selecionada para conseguir gerar o PDF'
            .hardcoded,
      );
    }

    return await ref
        .read(generatePdfRepositoryProvider)
        .soapGeneration(lastSaved);
  }
}
