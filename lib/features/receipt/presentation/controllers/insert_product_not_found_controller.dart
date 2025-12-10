import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../data/model/model.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'insert_product_not_found_controller.g.dart';

@riverpod
class InsertProductNotFoundController
    extends _$InsertProductNotFoundController {
  @override
  FutureOr<void> build(int receiptCode) async {}

  Future<void> insert({
    required double quantity,
    required String ean,
    required String observations,
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
              internalCode: null,
              quantity: quantity,
              ean: ean,
              observations: observations,
            ),
            receiptCode: receiptCode,
          );
      ref.invalidate(productsNotFoundStateControllerProvider(receiptCode));
    });
  }
}
