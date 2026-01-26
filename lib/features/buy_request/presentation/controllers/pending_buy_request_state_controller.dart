import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'pending_buy_request_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PendingBuyRequestStateController
    extends _$PendingBuyRequestStateController {
  @override
  FutureOr<PendingBuyRequestEntity> build() async {
    await ref.watch(
      userSessionProvider.future,
    ); //force update the data when do logout
    final repository = ref.read(localPendingBuyRequestRepositoryProvider);
    final localData = await repository.load();

    return localData ?? PendingBuyRequestEntity.empty();
  }

  Future<void> clearState(String? newSavedRequestNumber) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localPendingBuyRequestRepositoryProvider);
      final oldState = state.value!;
      final newState = PendingBuyRequestEntity.empty().copyWith(
        lastSavedRequestNumber:
            newSavedRequestNumber ?? oldState.lastSavedRequestNumber,
        //called by insertBuyRequestStateController when save the new request. This is the
        //reason why update the number here
      );
      await repository.update(newState);

      return newState;
    });
  }

  Future<void> updatePending({
    BuyerEntity? selectedBuyer,
    RequestTypeEntity? selectedRequestType,
    SupplierEntity? selectedSupplier,
    List<EnterpriseEntity>? selectedEnterprises,
    Map<ProductKey, BuyRequestProductItemEntity>? products,
    String? lastSavedRequestNumber,
    bool? annulSelectedEnterprises,
    bool? annulProducts,
    bool? annulSelectedSupplier,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      if ((selectedRequestType != null &&
              selectedRequestType != currentState.selectedRequestType) ||
          (selectedSupplier != null &&
              selectedSupplier != currentState.selectedSupplier)) {
        ref.invalidate(enterprisesStateControllerProvider);
      }

      final newState = state.value!
          .copyWith(
            selectedBuyer: selectedBuyer,
            selectedSupplier: selectedSupplier,
            selectedEnterprises: selectedEnterprises,
            selectedRequestType: selectedRequestType,
            products: products,
            lastSavedRequestNumber: lastSavedRequestNumber,
          )
          .annulValue(
            annulSelectedEnterprises: annulSelectedEnterprises,
            annulProducts: annulProducts,
            annulSelectedSupplier: annulSelectedSupplier,
          );

      final repository = ref.read(localPendingBuyRequestRepositoryProvider);
      await repository.update(newState);

      return newState;
    });
  }
}
