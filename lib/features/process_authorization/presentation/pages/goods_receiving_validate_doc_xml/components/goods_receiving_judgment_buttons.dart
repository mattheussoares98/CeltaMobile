import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoodsReceivingJudgmentButtons extends ConsumerWidget {
  final int processCode;
  final bool areJudgedItems;

  const GoodsReceivingJudgmentButtons({
    super.key,
    required this.processCode,
    required this.areJudgedItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerProvider = markStatusJudgmentControllerProvider(
      areJudgedItems,
      processCode,
    );
    final uiControllerProvider = gRValidateDocXmlUiControllerProvider(
      processCode,
    );
    final hasSelectedProducts = ref.watch(
      uiControllerProvider.select(
        (state) => areJudgedItems
            ? state.selectedProductsWithJudgmentIds.isNotEmpty
            : state.selectedProductsWithoutJudgmentIds.isNotEmpty,
      ),
    );
    final isLoading = ref.watch(
      controllerProvider.select((state) => state.isLoading),
    );

    void judge(BsfGoodsReceivingProductJudgmentStatus judgmentStatus) {
      final content = switch (judgmentStatus) {
        BsfGoodsReceivingProductJudgmentStatus.devolveAll =>
          "Deseja devolver todas as quantidades dos produtos selecionados?"
              .hardcoded,
        BsfGoodsReceivingProductJudgmentStatus.devolveExcess =>
          "Deseja devolver somente a quantidade excedente dos produtos selecionados?"
              .hardcoded,
        BsfGoodsReceivingProductJudgmentStatus.accept =>
          "Deseja aceitar as divergências dos produtos selecionados?".hardcoded,
        BsfGoodsReceivingProductJudgmentStatus.withoutJudge =>
          "Deseja anular os julgamentos dos produtos selecionados?".hardcoded,
      };
      showAlertDialog(
        context: context,
        title: "Atenção".hardcoded,
        content: content,
        defaultActionText: 'Sim'.hardcoded,
        cancelActionText: 'Cancelar'.hardcoded,
        onOkPressed: () {
          ref.read(controllerProvider.notifier).judge(judgmentStatus);
        },
      );
    }

    final onPressed = hasSelectedProducts && !isLoading ? judge : null;

    if (areJudgedItems) {
      return Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: PrimaryButton(
          text: 'Anular julgamentos'.hardcoded,
          isLoading: isLoading,
          onPressed: onPressed == null
              ? null
              : () => onPressed(
                  BsfGoodsReceivingProductJudgmentStatus.withoutJudge,
                ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: PrimaryButton(
              text: 'Aceitar'.hardcoded,
              isLoading: isLoading,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(
                      BsfGoodsReceivingProductJudgmentStatus.accept,
                    ),
            ),
          ),
          gapW8,
          Expanded(
            flex: 8,
            child: PrimaryButton(
              text: 'Devolver'.hardcoded,
              isLoading: isLoading,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(
                      BsfGoodsReceivingProductJudgmentStatus.devolveAll,
                    ),
            ),
          ),
          gapW8,
          Expanded(
            flex: 16,
            child: PrimaryButton(
              text: 'Devolver excesso'.hardcoded,
              isLoading: isLoading,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(
                      BsfGoodsReceivingProductJudgmentStatus.devolveExcess,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
