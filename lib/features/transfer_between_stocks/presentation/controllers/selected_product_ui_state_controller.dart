import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../domain/entities/entities.dart';

part 'selected_product_ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedProductUIStateController
    extends _$SelectedProductUIStateController {
  @override
  SelectedProductUIStateEntity build(int enterpriseCode) {
    ref.watch(validatedUserSessionProvider);
    return SelectedProductUIStateEntity.empty();
  }

  void updateProductIndex(int? index) {
    if (state.productIndex == index || index == null) {
      state = state.annulValues(annulProductIndex: true);
    } else {
      state = state.copyWith(productIndex: index);
    }
  }

  Future<void> updateValues({
    TransferJustificationEntity? justification,
    StockTypeEntity? originStock,
    StockTypeEntity? destinyStock,
    int? pageIndex,
  }) async {
    StockTypeEntity? originStockToChange;
    if (justification != null) {
      //*check if the justification has a fixed stock
      final stocks = await ref.read(
        stockTypeStateControllerProvider(enterpriseCode).future,
      );

      if (justification.CodigoInterno_TipoEstoque != null) {
        originStockToChange = stocks.firstWhere(
          (e) =>
              e.CodigoInterno_TipoEstoque ==
              justification.CodigoInterno_TipoEstoque,
        );
      }
    }

    state = state.copyWith(
      selectedJustification: justification,
      selectedOriginStock: originStockToChange ?? originStock,
      selectedDestinyStock: destinyStock,
      pageIndex: pageIndex,
    );
  }
}
