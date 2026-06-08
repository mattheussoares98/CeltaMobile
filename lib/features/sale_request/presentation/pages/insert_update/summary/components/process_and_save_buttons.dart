import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/save_sale_request_controller.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProcessAndSaveButtons extends ConsumerWidget {
  const ProcessAndSaveButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSave() async {
      final args = ref.read(saleRequestArgsProvider);

      final (errorMessage, canSaveAndNeedProcessCart) = await ref
          .read(saveSaleRequestControllerProvider(args.enterpriseCode).notifier)
          .saveBsfSaleRequest(
            customerCode: args.customerCode,
            saleRequestId: args.saleRequestId,
            isOnlyValidating: true,
          );
      if (errorMessage?.isNotEmpty == true && context.mounted) {
        final proceed = await showAlertDialog(
          context: context,
          title: 'Atenção'.hardcoded,
          content: errorMessage,
          defaultActionText: canSaveAndNeedProcessCart
              ? 'Salvar'.hardcoded
              : 'OK'.hardcoded,
          cancelActionText: canSaveAndNeedProcessCart
              ? 'Cancelar'.hardcoded
              : null,
        );
        if (proceed != true || !canSaveAndNeedProcessCart) {
          return;
        }
      }

      final (failedMessage, _) = await ref
          .read(saveSaleRequestControllerProvider(args.enterpriseCode).notifier)
          .saveBsfSaleRequest(
            customerCode: args.customerCode,
            saleRequestId: args.saleRequestId,
            isOnlyValidating: false,
          );

      if (failedMessage?.isNotEmpty == true && context.mounted) {
        showAlertDialog(
          context: context,
          title: 'Atenção'.hardcoded,
          content: failedMessage,
          defaultActionText: 'OK'.hardcoded,
        );
      } else {
        if (context.mounted) {
          context.pop();
          showSnackBarMessage(
            context,
            'O pedido foi salvo com sucesso'.hardcoded,
          );
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
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: PrimaryButton(
                        text: 'Processar pedido'.hardcoded,
                        onPressed: needProcessingCart ? processCart : null,
                        iconAlignment: IconAlignment.end,
                        icon: const PlatformIcon(
                          cupertinoIcon: CupertinoIcons.refresh,
                          materialIcon: Icons.replay_outlined,
                        ),
                      ),
                    ),
                    gapW8,
                  ],
                ),
              ),
              Flexible(
                child: Consumer(
                  builder: (_, ref, _) {
                    final hasChanges = ref.watch(saleRequestHasChangesProvider);

                    return PrimaryButton(
                      onPressed: hasChanges ? onSave : null,
                      text: 'Salvar pedido'.hardcoded,
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
