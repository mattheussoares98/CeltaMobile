import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'last_saved_sale_request_state_controller.g.dart';

@riverpod
class LastSavedSaleRequestStateController
    extends _$LastSavedSaleRequestStateController {
  @override
  Future<LastSavedSaleRequestEntity?> build(int enterpriseCode) async {
    return await ref
        .read(localLastSavedSaleRequestRepositoryProvider)
        .load(enterpriseCode);
  }

  Future<void> save(LastSavedSaleRequestEntity value) async {
    await ref
        .read(localLastSavedSaleRequestRepositoryProvider)
        .save(value: value, enterpriseCode: enterpriseCode);
  }
}
