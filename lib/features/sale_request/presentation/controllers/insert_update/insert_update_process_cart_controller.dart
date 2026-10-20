import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
// lib/features/sale_request/presentation/controllers/insert_update/insert_update_process_cart_controller.dart

import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
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
        throw AppException.localized(CoreFailure.invalidState);
      }

      if (current.products?.isEmpty ?? true) {
        throw AppException.localized(CoreFailure.addProductsToTheOrder2);
      }

      final requestTypeCode = current.requestType?.code;
      if (requestTypeCode == null || requestTypeCode == 0) {
        throw AppException.localized(CoreFailure.enterTheOrderTemplate);
      }

      final customerCode = current.customer?.code ?? 0;
      if (customerCode == 0) {
        throw AppException.localized(CoreFailure.enterTheCustomer);
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
