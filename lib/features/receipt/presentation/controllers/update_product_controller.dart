import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';

part 'update_product_controller.g.dart';

@riverpod
class UpdateProductController extends _$UpdateProductController {
  @override
  FutureOr<void> build(SearchProductKey searchProductKey) {}

  Future<void> updateValues({
    required int grDocCode,
    required int productPackingCode,
    required bool isSubtract,
    required double quantity,
    required DateTime? newValidityDate,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      final product = await _getCorrespondentProduct(productPackingCode);

      final oldQuantity = product.Quantidade_ProcRecebDocProEmb ?? 0;
      final newQuantity = isSubtract == true
          ? oldQuantity - quantity
          : quantity;

      await ref
          .read(soapUpdateProductDatasourceProvider)
          .update(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            grDocCode: grDocCode,
            productCode: product.ProductCode!,
            productPackingCode: productPackingCode,
            newQuantity: newQuantity,
            newValidityDate: newValidityDate,
          );

      _updateProduct(product: product, quantity: newQuantity);
    });
  }

  void _updateProduct({
    required ProductEntity product,
    double? quantity,
    DateTime? validatyDate,
  }) {
    ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .updateProduct(
          product.copyWith(
            DataValidade_ProcRecebDocProEmb: validatyDate,
            Quantidade_ProcRecebDocProEmb: quantity,
          ),
        );
  }

  Future<ProductEntity> _getCorrespondentProduct(int productPackingCode) async {
    final products = await ref.read(
      searchProductsStateControllerProvider(searchProductKey).future,
    );
    return products.firstWhere(
      (e) => e.ProductPackingCode == productPackingCode,
    );
  }
}
