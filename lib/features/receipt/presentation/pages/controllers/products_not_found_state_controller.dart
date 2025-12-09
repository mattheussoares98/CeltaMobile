import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../domain/entity/entity.dart';
import '../../../providers.dart';

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
}
