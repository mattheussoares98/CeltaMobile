import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/supplier/supplier.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../models/models.dart';
import 'controllers.dart';

part 'ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class UiStateController extends _$UiStateController {
  @override
  FutureOr<UiStateModel> build() async {
    await ref.watch(
      userSessionProvider.future,
    ); //force update the data when do logout
    final suppliers = await ref
        .read(
          supplierStateControllerProvider(SearchSupplierType.buyRequest).future,
        )
        .then((value) {
          return [...?value];
        });

    final pendingAsync = await ref.read(
      pendingBuyRequestStateControllerProvider.future,
    );

    if (pendingAsync.selectedSupplier != null &&
        suppliers.any((e) => e.Code == pendingAsync.selectedSupplier?.Code) !=
            true) {
      suppliers.add(pendingAsync.selectedSupplier!);
    }

    return UiStateModel(
      currentPageIndex: 0,
      selectedProductIndex: null,
      selectedCartProductIndex: null,
      suppliers: suppliers,
    );
  }

  void updatePageIndex(int index) {
    state = AsyncData(state.value!.copyWith(currentPageIndex: index));
  }

  void updateSelectedProductIndex(int? index) {
    if (state.value != null && state.value!.selectedProductIndex == index) {
      state = AsyncData(
        state.value!.annulValues(annulSelectedProductIndex: true),
      );
    } else {
      state = AsyncData(
        state.value!
            .annulValues(annulSelectedProductIndex: index == null)
            .copyWith(selectedProductIndex: index),
      );
    }
  }
}
