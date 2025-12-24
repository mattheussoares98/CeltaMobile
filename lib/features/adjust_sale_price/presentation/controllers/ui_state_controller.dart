import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';

part 'ui_state_controller.g.dart';

@riverpod
class UIStateController extends _$UIStateController {
  //TODO test this controller and finish the tests
  @override
  FutureOr<AdjustPriceUIModel> build(ProductEntity? product) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    final availableReplications = <ReplicationTypes>{
      ReplicationTypes.packings,
      if (product?.IsFatherOfGrate == true || product?.IsChildOfGrate == true)
        ReplicationTypes.grid,
      if (product?.InClass == true) ReplicationTypes.classess,
      if (selectedEnterprise?.EnterpriseParticipateEnterpriseGroup == true)
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
      return state.value!.copyWith(
        selectedSaleType: selectedSaleType,
        selectedPriceType: selectedPriceType,
        isSelectedClass: isSelectedClass,
        isSelectedGrid: isSelectedGrid,
        isSelectedOperationalGrouping: isSelectedOperationalGrouping,
        isSelectedPackings: isSelectedPackings,
        selectedStartDate: selectedStartDate,
        selectedEndDate: selectedEndDate,
        selectedReplications: newSelectedReplications,
      );
    });
  }
}
