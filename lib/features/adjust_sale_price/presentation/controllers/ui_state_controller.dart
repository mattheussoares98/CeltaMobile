import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/models/models.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';

part 'ui_state_controller.g.dart';

@riverpod
class UIStateController extends _$UIStateController {
  @override
  FutureOr<AdjustPriceUIModel> build(String plu) async {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    if (selectedEnterprise == null) {
      await Future.delayed(const Duration(days: 1));
    }
    final product = await ref.watch(
      selectedProductStateControllerProvider(
        selectedEnterprise!.Code!,
        plu,
      ).future,
    );

    final availableReplications = <ReplicationTypes>{
      ReplicationTypes.packings,
      if (product?.IsFatherOfGrate == true || product?.IsChildOfGrate == true)
        ReplicationTypes.grid,
      if (product?.InClass == true) ReplicationTypes.classess,
      if (selectedEnterprise.EnterpriseParticipateEnterpriseGroup == true)
        ReplicationTypes.operationalGrouping,
    }.toList();

    final selectedReplicatios = <ReplicationTypes>{
      if (product?.AlterationPriceForAllPackings == true)
        ReplicationTypes.packings,
      if (product?.MarkUpdateClassInAdjustSalePriceIndividual == true)
        ReplicationTypes.classess,
      if (availableReplications.contains(ReplicationTypes.operationalGrouping))
        ReplicationTypes.operationalGrouping,
    };

    return AdjustPriceUIModel(
      availableReplications: availableReplications,
      selectedReplications: selectedReplicatios,
    );
  }

  Future<void> updateValues({
    SaleType? selectedSaleType,
    PriceType? selectedPriceType,
    bool? isSelectedClass,
    bool? isSelectedGrid,
    bool? isSelectedOperationalGrouping,
    bool? isSelectedPackings,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    ReplicationTypes? selectedReplication,
    bool? isChangingEndDate,
  }) async {
    Set<ReplicationTypes> newSelectedReplications =
        state.value!.selectedReplications;
    if (selectedReplication != null) {
      newSelectedReplications.contains(selectedReplication)
          ? newSelectedReplications.remove(selectedReplication)
          : newSelectedReplications.add(selectedReplication);
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return state.value!
          .annulValues(annulEndDate: isChangingEndDate)
          .copyWith(
            selectedSaleType: selectedSaleType,
            selectedPriceType: selectedPriceType,
            isSelectedClass: isSelectedClass,
            isSelectedGrid: isSelectedGrid,
            isSelectedOperationalGrouping: isSelectedOperationalGrouping,
            isSelectedPackings: isSelectedPackings,
            selectedStartDate: selectedStartDate,
            selectedEndDate:
                selectedEndDate, // in the UI is treating when try to insert the end date before the start date
            selectedReplications: newSelectedReplications,
          );
    });
  }
}
