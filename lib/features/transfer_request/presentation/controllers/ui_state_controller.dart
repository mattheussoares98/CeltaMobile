import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/transfer_request/presentation/models/models.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state_controller.g.dart';

@riverpod
class UiStateController extends _$UiStateController {
  @override
  FutureOr<UiModel> build(int requestTypeCode, int enterpriseCode) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });
    final requests = await ref.read(
      requestTypeStateControllerProvider(
        Modules.transferRequest,
        enterpriseCode,
      ).future,
    );

    final allowChangePrice =
        requests
            ?.firstWhereOrNull((e) => e.code == requestTypeCode)
            ?.allowAlterCostOrSalePrice ==
        true;

    return UiModel(
      selectedInsertProductIndex: null,
      selectedCartProductIndex: null,
      requestTypeAllowChangePrice: allowChangePrice,
    );
  }

  void updatePageIndex(int pageIndex) {
    if (state is AsyncLoading || state.value == null) {
      return;
    }
    state = AsyncValue.data(state.value!.copyWith(pageIndex: pageIndex));
  }

  void updateSelectedInsertProductIndex(int? index) {
    if (state.value == null) {
      return;
    }

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
