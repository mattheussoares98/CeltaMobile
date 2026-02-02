import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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
    final theme = Theme.of(context);

    final productsAreEmpty = ref.watch(
      lotStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s.value?.isEmpty ?? true),
    );

    if (productsAreEmpty) {
      return Center(
        child: Text(
          'Lote vazio'.hardcoded,
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.red),
        ),
      );
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
              //TODO fix when tap the button after close the keyboard
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p4,
                0,
                Sizes.p4,
                Sizes.p4,
              ),
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
