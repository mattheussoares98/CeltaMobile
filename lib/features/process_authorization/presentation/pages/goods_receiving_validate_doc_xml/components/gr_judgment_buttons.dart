import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
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
          context.l10n.returnAllQuantitiesOfTheSelectedProducts,
        BsfGRProductJudgmentStatus.devolveExcess =>
          context.l10n.returnOnlyTheExcessQuantityOfTheSelectedProducts,
        BsfGRProductJudgmentStatus.accept =>
          context.l10n.acceptTheDiscrepanciesForTheSelectedProducts,
        BsfGRProductJudgmentStatus.withoutJudge =>
          context.l10n.voidTheReviewsOfTheSelectedProducts,
      };
      final confirmed = await showAlertDialog(
        context: context,
        title: context.l10n.attention2,
        content: content,
        defaultActionText: context.l10n.yes,
        cancelActionText: context.l10n.cancel,
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
          text: context.l10n.voidReviews,
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
              text: context.l10n.accept,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(BsfGRProductJudgmentStatus.accept),
            ),
          ),
          gapW8,
          Expanded(
            flex: 8,
            child: PrimaryButton(
              text: context.l10n.returnAction,
              onPressed: onPressed == null
                  ? null
                  : () => onPressed(BsfGRProductJudgmentStatus.devolveAll),
            ),
          ),
          gapW8,
          Expanded(
            flex: 16,
            child: PrimaryButton(
              text: context.l10n.returnExcess,
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
