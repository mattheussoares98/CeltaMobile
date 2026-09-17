import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GRJudgmentButtons extends ConsumerWidget {
  final int processCode;
  final bool areJudgedItems;

  const GRJudgmentButtons({
    super.key,
    required this.processCode,
    required this.areJudgedItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerProvider = judgmentControllerProvider(processCode);
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

    void judge(BsfGRProductJudgmentStatus judgmentStatus) async {
      final content = switch (judgmentStatus) {
        BsfGRProductJudgmentStatus.devolveAll =>
          "Deseja devolver todas as quantidades dos produtos selecionados?"
              .hardcoded,
        BsfGRProductJudgmentStatus.devolveExcess =>
          "Deseja devolver somente a quantidade excedente dos produtos selecionados?"
              .hardcoded,
        BsfGRProductJudgmentStatus.accept =>
          "Deseja aceitar as divergências dos produtos selecionados?".hardcoded,
        BsfGRProductJudgmentStatus.withoutJudge =>
          "Deseja anular os julgamentos dos produtos selecionados?".hardcoded,
      };
      final confirmed = await showAlertDialog(
        context: context,
        title: "Atenção".hardcoded,
        content: content,
        defaultActionText: 'Sim'.hardcoded,
        cancelActionText: 'Cancelar'.hardcoded,
      );

      if (confirmed != true || !context.mounted) return;
      final controller = ref.read(controllerProvider.notifier);
      judgmentStatus == BsfGRProductJudgmentStatus.withoutJudge
          ? controller.annulStatus()
          : controller.judgeStatus(
              judgmentStatus,
              areJudgedItems: areJudgedItems,
            );
    }

    final onPressed = hasSelectedProducts ? judge : null;

    if (areJudgedItems) {
      return Padding(
        padding: const EdgeInsets.all(Sizes.p4),
        child: PrimaryButton(
          text: 'Anular julgamentos'.hardcoded,
          onPressed: onPressed == null
              ? null
              : () => onPressed(BsfGRProductJudgmentStatus.withoutJudge),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: PrimaryButton(
              text: 'Aceitar'.hardcoded,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(BsfGRProductJudgmentStatus.accept),
            ),
          ),
          gapW8,
          Expanded(
            flex: 8,
            child: PrimaryButton(
              text: 'Devolver'.hardcoded,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(BsfGRProductJudgmentStatus.devolveAll),
            ),
          ),
          gapW8,
          Expanded(
            flex: 16,
            child: PrimaryButton(
              text: 'Devolver excesso'.hardcoded,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(BsfGRProductJudgmentStatus.devolveExcess),
            ),
          ),
        ],
      ),
    );
  }
}
