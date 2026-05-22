import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';

part 'last_saved_sale_request_state_controller.g.dart';

@riverpod
class LastSavedSaleRequestStateController
    extends _$LastSavedSaleRequestStateController {
  @override
  FutureOr<LastSavedSaleRequestEntity?> build(int enterpriseCode) async {
    return await ref
        .read(localLastSavedSaleRequestRepositoryProvider)
        .load(enterpriseCode);
  }

  Future<void> save(LastSavedSaleRequestEntity value) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(localLastSavedSaleRequestRepositoryProvider)
          .save(value: value, enterpriseCode: enterpriseCode);

      return value;
    });
  }
}
