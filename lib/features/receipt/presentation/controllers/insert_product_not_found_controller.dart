import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../data/model/model.dart';
import '../../domain/entity/entity.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'insert_product_not_found_controller.g.dart';

@riverpod
class InsertProductNotFoundController
    extends _$InsertProductNotFoundController {
  @override
  Future<void> build({
    required int receiptCode,
    required ProductNotFoundEntity product,
  }) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);
    await ref
        .read(soapInsertProductNotFoundDatasourceProvider)
        .insert(
          baseUrl: validatedUser!.enterprise!.baseUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          productNotFound: ProductNotFoundModel(
            internalCode: product.internalCode,
            quantity: product.quantity,
            ean: product.ean,
            observations: product.observations,
          ),
          receiptCode: receiptCode,
        );
    ref.invalidate(productsNotFoundStateControllerProvider(receiptCode));
  }
}
