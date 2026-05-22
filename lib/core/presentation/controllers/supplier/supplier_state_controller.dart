import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/supplier/supplier.dart';

part 'supplier_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SupplierStateController extends _$SupplierStateController {
  @override
  FutureOr<List<SupplierEntity>?> build(
    SearchSupplierType searchType,
    int enterpriseCode,
  ) async {
    final selectedSupplier = await ref.read(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).selectAsync((s) => s.selectedSupplier),
    );
    return [?selectedSupplier];
  }

  Future<void> load(String searchValue) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      return await ref
          .read(soapLoadSupplierRepositoryProvider)
          .load(
            workingUrl: userSession!.enterprise!.workingUrl!,
            crossIdentity: userSession.user.CrossIdentity_Usuario!,
            searchType: searchType,
            searchValue: searchValue,
          );
    });
  }
}
