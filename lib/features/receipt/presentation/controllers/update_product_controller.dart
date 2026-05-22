import 'dart:async';

import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/receipt/providers.dart';

part 'update_product_controller.g.dart';

@riverpod
class UpdateProductController extends _$UpdateProductController {
  @override
  FutureOr<void> build(SearchProductKey searchProductKey) {}

  Future<void> updateValues({
    required int grDocCode,
    required int productIndex,
    required bool isSubtract,
    required double quantity,
    required DateTime? newValidityDate,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      final product = await ref.read(
        searchProductsStateControllerProvider(
          searchProductKey,
        ).selectAsync((s) => s.elementAt(productIndex)),
      );

      final quantityToSendInRequest = isSubtract == true
          ? 0 - quantity
          : quantity;
      final oldQuantity = product.Quantidade_ProcRecebDocProEmb ?? 0;
      final newQuantity = oldQuantity + quantityToSendInRequest;

      if (newQuantity < 0) {
        throw AppException(
          'A nova quantidade não pode ser menor que zero'.hardcoded,
        );
      }

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.countReceiptProduct);

      await ref
          .read(soapUpdateProductDatasourceProvider)
          .update(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            grDocCode: grDocCode,
            productCode: product.ProductCode!,
            productPackingCode: product.ProductPackingCode!,
            newQuantity: quantityToSendInRequest,
            newValidityDate: newValidityDate,
          );

      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .updateProduct(
            product
                .annuValues(
                  annulDataValidade_ProcRecebDocProEmb: newValidityDate == null,
                )
                .copyWith(
                  Quantidade_ProcRecebDocProEmb: newQuantity,
                  DataValidade_ProcRecebDocProEmb: newValidityDate,
                ),
          );
    });
  }
}
