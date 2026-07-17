// lib/features/sale_request/presentation/controllers/insert_update/insert_update_process_cart_controller.dart

import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insert_update_process_cart_controller.g.dart';

@Riverpod(dependencies: [InsertUpdateStateController])
class InsertUpdateProcessCartController
    extends _$InsertUpdateProcessCartController {
  @override
  FutureOr<void> build() {}

  Future<void> processCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final saleRequestState = ref.read(insertUpdateStateControllerProvider);

      final current = saleRequestState.value;
      if (current == null) {
        throw Exception('Estado inválido'.hardcoded);
      }

      if (current.products?.isEmpty ?? true) {
        throw Exception('Insira produtos no pedido'.hardcoded);
      }

      final requestTypeCode = current.requestType?.code;
      if (requestTypeCode == null || requestTypeCode == 0) {
        throw Exception('Informe o modelo de pedido'.hardcoded);
      }

      final customerCode = current.customer?.code ?? 0;
      if (customerCode == 0) {
        throw Exception('Informe o cliente'.hardcoded);
      }

      final saleRequestCode = current.code ?? 0;

      final params = await ref.read(ecRequestParamsProvider().future);
      final args = ref.read(saleRequestArgsProvider);

      final processedValue = await ref
          .read(ecSaleRequestsRepositoryProvider)
          .processCart(
            saleRequest: current,
            enterpriseCode: args.enterpriseCode,
            requestTypeCode: requestTypeCode,
            customerCode: customerCode,
            saleRequestCode: saleRequestCode,
            params: params,
          );

      ref
          .read(insertUpdateStateControllerProvider.notifier)
          .updateProcessedCart(processedValue);
    });
  }
}
