import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/request_type/request_type.dart';
import '../models/models.dart';

part 'ui_state_controller.g.dart';

@riverpod
class UiStateController extends _$UiStateController {
  @override
  FutureOr<UiModel> build(int requestTypeCode) async {
    final requests = await ref.read(
      requestTypeStateControllerProvider(Modules.transferRequest).future,
    );

    final allowChangePrice =
        requests
            ?.firstWhereOrNull((e) => e.Code == requestTypeCode)
            ?.AllowAlterCostOrSalePrice ==
        true;

    return UiModel(
      selectedInsertProductIndex: null,
      selectedCartProductIndex: null,
      requestTypeAllowChangePrice: allowChangePrice,
    );
  }

  void updatePageIndex(int pageIndex) {
    state = AsyncValue.data(state.value!.copyWith(pageIndex: pageIndex));
  }

  void updateSelectedInsertProductIndex(int? index) {
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedInsertProductIndex: index,
        annulSelectedInsertProductIndex:
            index == null || state.value?.selectedInsertProductIndex == index,
      ),
    );
  }

  void updateSelectedCartProductIndex(int? index) {
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedCartProductIndex: index,
        annulSelectedCartProductIndex:
            index == null || state.value?.selectedCartProductIndex == index,
      ),
    );
  }
}
