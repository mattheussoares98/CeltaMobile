import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../data/model/model.dart';
import '../../domain/entity/entity.dart';
import '../../providers.dart';

part 'products_not_found_state_controller.g.dart';

@riverpod
class ProductsNotFoundStateController
    extends _$ProductsNotFoundStateController {
  @override
  FutureOr<List<ProductNotFoundEntity>> build(int receiptCode) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);
    return await ref
        .read(soapLoadProductsNotFoundRepositoryProvider)
        .load(
          baseUrl: validatedUser!.enterprise!.baseUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          receiptCode: receiptCode,
        );
  }

  Future<void> insert({
    required int? internalCode,
    required double quantity,
    required String ean,
    required String? observations,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      await ref
          .read(soapInsertProductNotFoundDatasourceProvider)
          .insert(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            productNotFound: ProductNotFoundModel(
              internalCode: internalCode,
              quantity: quantity,
              ean: ean,
              observations: observations,
            ),
            receiptCode: receiptCode,
          );

      ref.invalidateSelf();
      return [];
    });
  }
}
