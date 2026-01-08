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

  Future<bool> insert({
    required double quantity,
    required String ean,
    required String observations,
    required int? internalCode,
  }) async {
    bool succeeds = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      await ref
          .read(soapInsertProductNotFoundDatasourceProvider)
          .insert(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            productNotFound: ProductNotFoundModel(
              internalCode: internalCode,
              quantity: quantity,
              ean: ean,
              observations: observations,
            ),
            receiptCode: receiptCode,
          );
      ref.invalidate(productsNotFoundStateControllerProvider(receiptCode));
      succeeds = true;
    });
    return succeeds;
  }
}
