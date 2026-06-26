import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/lot/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LotPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const LotPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LotPageState();
}

class _LotPageState extends ConsumerState<LotPage> {
  final lotQuantityController = TextEditingController();
  final lotQuantityFocusNode = FocusNode();

  @override
  void dispose() {
    lotQuantityController.dispose();
    lotQuantityFocusNode.dispose();
    super.dispose();
  }

  void confirmRequest(bool isRequest) async {
    final items = await ref.read(
      lotStateControllerProvider(widget.enterpriseCode).future,
    );

    ref
        .read(confirmAdjustStockControllerProvider.notifier)
        .confirm(
          items
              .map(
                (e) => AdjustStockItemEntity(
                  EnterpriseCode: e.product.EnterpriseCode!,
                  ProductCode: e.product.ProductCode!,
                  ProductPackingCode: e.product.ProductPackingCode!,
                  JustificationCode:
                      e.selectedJustification.CodigoInterno_JustMov,
                  StockTypeCode:
                      e.selectedOriginStock.CodigoInterno_TipoEstoque!,
                  StockTypeRecipientCode:
                      e.selectedDestinyStock.CodigoInterno_TipoEstoque,
                  IsPendingAdjust: isRequest,
                  Quantity: e.quantity,
                ),
              )
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final productsAreEmpty = ref.watch(
      lotStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s.value?.isEmpty ?? true),
    );

    if (productsAreEmpty) {
      return Center(child: DefaultText.error('Lote vazio'.hardcoded));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              LotItems(
                quantityController: lotQuantityController,
                enterpriseCode: widget.enterpriseCode,
                quantityFocusNode: lotQuantityFocusNode,
              ),
              Consumer(
                builder: (_, ref, _) {
                  final keyboardIsOpen = ref.watch(
                    keyboardVisibilityStateControllerProvider,
                  );
                  if (!keyboardIsOpen) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  return AnimatedBuilder(
                    animation: lotQuantityFocusNode,
                    builder: (_, _) {
                      return SliverToBoxAdapter(
                        child: ConfirmAndRequestButtons(
                          enterpriseCode: widget.enterpriseCode,
                          confirmRequest: confirmRequest,
                        ),
                      );
                    },
                  );
                },
              ),
              gapSliverH48,
            ],
          ),
        ),
        Consumer(
          builder: (_, ref, _) {
            final keyboardIsOpen = ref.watch(
              keyboardVisibilityStateControllerProvider,
            );

            if (keyboardIsOpen) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
              child: ConfirmAndRequestButtons(
                enterpriseCode: widget.enterpriseCode,
                confirmRequest: confirmRequest,
              ),
            );
          },
        ),
      ],
    );
  }
}
