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
    return SelectedProductUIStateEntity.empty();
  }

  Future<void> updateValues({
    TransferJustificationEntity? justification,
    StockTypeEntity? originStock,
    StockTypeEntity? destinyStock,
    int? productIndex,
    int? pageIndex,
  }) async {
    final annulProductIndex =
        productIndex == state.productIndex || productIndex == null;

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

    state = state
        .annulValues(annulProductIndex: annulProductIndex)
        .copyWith(
          selectedJustification: justification,
          selectedOriginStock: originStockToChange ?? originStock,
          selectedDestinyStock: destinyStock,
          pageIndex: pageIndex,
          productIndex: annulProductIndex ? null : productIndex,
        );
  }
}
