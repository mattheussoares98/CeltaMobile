import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';

part 'selected_ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedUIStateController extends _$SelectedUIStateController {
  @override
  SelectedUIStateEntity build(int enterpriseCode) {
    return SelectedUIStateEntity.empty();
  }

  void updateValues({
    TransferJustificationEntity? justification,
    StockTypeEntity? originStock,
    StockTypeEntity? destinyStock,
    int? productIndex,
  }) {
    final annulProductIndex =
        productIndex == state.productIndex || productIndex == null;
    state = state
        .annulValues(annulProductIndex: annulProductIndex)
        .copyWith(
          selectedJustification: justification,
          selectedOriginStock: originStock,
          selectedDestinyStock: destinyStock,
          productIndex: annulProductIndex ? null : productIndex,
        );
  }
}
