import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class UiStateController extends _$UiStateController {
  @override
  FutureOr<UiStateModel> build(int enterpriseCode) async {
    await ref.watch(
      userSessionProvider.future,
    ); //force update the data when do logout
    final suppliers = await ref
        .read(supplierStateControllerProvider(enterpriseCode).future)
        .then((value) {
          return [...?value];
        });

    final pendingAsync = await ref.read(
      pendingBuyRequestStateControllerProvider(enterpriseCode).future,
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

  void updateSelectedCartProductIndex(int? index) {
    if (state.value != null && state.value!.selectedCartProductIndex == index) {
      state = AsyncData(
        state.value!.annulValues(annulSelectedCartProductIndex: true),
      );
    } else {
      state = AsyncData(
        state.value!
            .annulValues(annulSelectedCartProductIndex: index == null)
            .copyWith(selectedCartProductIndex: index),
      );
    }
  }
}
