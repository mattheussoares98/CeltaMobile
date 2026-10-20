import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/save_sale_request_controller.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAndSaveButtons extends ConsumerWidget {
  const ProcessAndSaveButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSave() async {
      final args = ref.read(saleRequestArgsProvider);

      final (errorMessage, canSaveAndNeedProcessCart) = await ref
          .read(saveSaleRequestControllerProvider(args.enterpriseCode).notifier)
          .saveBsfSaleRequest(true);
      if (errorMessage?.isNotEmpty == true && context.mounted) {
        final proceed = await showAlertDialog(
          context: context,
          title: context.l10n.attention2,
          content: errorMessage?.formatBreakLines(),
          defaultActionText: canSaveAndNeedProcessCart
              ? context.l10n.save
              : context.l10n.ok,
          cancelActionText: canSaveAndNeedProcessCart
              ? context.l10n.cancel
              : null,
        );
        if (proceed != true || !canSaveAndNeedProcessCart) {
          return;
        }
      }

      final (failedMessage, _) = await ref
          .read(saveSaleRequestControllerProvider(args.enterpriseCode).notifier)
          .saveBsfSaleRequest(false);

      if (failedMessage?.isNotEmpty == true && context.mounted) {
        showAlertDialog(
          context: context,
          title: context.l10n.attention2,
          content: failedMessage?.formatBreakLines(),
          defaultActionText: context.l10n.ok,
        );
      } else {
        if (context.mounted) {
          showToastMessage(context.l10n.theOrderWasSavedSuccessfully);
        }
      }
    }

    void processCart() {
      ref
          .read(insertUpdateProcessCartControllerProvider.notifier)
          .processCart();
    }

    return Consumer(
      builder: (_, ref, _) {
        final needProcessingCart = ref.watch(
          saleRequestNeedsProcessingProvider,
        );

        return SizedBox(
          width: MediaQuery.sizeOf(context).width - Sizes.p16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: PrimaryButton(
                  text: context.l10n.calculatePrices,
                  onPressed: needProcessingCart ? processCart : null,
                  iconAlignment: IconAlignment.end,
                  icon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.refresh,
                    materialIcon: Icons.replay_outlined,
                  ),
                ),
              ),
              gapW8,
              Expanded(
                flex: 4,
                child: Consumer(
                  builder: (_, ref, _) {
                    final hasChanges = ref.watch(saleRequestHasChangesProvider);

                    return PrimaryButton(
                      onPressed: hasChanges ? onSave : null,
                      text: context.l10n.save,
                      iconAlignment: IconAlignment.end,
                      icon: const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.check_mark,
                        materialIcon: Icons.save,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
