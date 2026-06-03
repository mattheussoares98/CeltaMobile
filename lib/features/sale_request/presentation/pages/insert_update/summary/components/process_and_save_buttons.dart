import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/save_sale_request_controller.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAndSaveButtons extends ConsumerWidget {
  const ProcessAndSaveButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSave(bool needProcessingCart) async {
      final args = ref.read(saleRequestArgsProvider);
      final proceed = await showAlertDialog(
        context: context,
        title: needProcessingCart
            ? 'ATENÇÃO!'.hardcoded
            : 'Salvar pedido?'.hardcoded,
        content: needProcessingCart
            ? 'O pedido ainda não foi processado para calcular os preços de acordo com promoções, negociações de vendas, oferta, atacado, preço praticado pelo modelo de pedido, etc! Dependendo das regras do BS, o pedido pode ser salvo com preços diferentes do que estão no aplicativo\n\n Deseja salvar mesmo assim?'
                  .hardcoded
            : null,
        cancelActionText: 'Não'.hardcoded,
        defaultActionText: 'Sim'.hardcoded,
      );
      if (proceed != true) {
        return;
      }
      ref
          .read(saveSaleRequestControllerProvider(args.enterpriseCode).notifier)
          .saveBsfSaleRequest(
            customerCode: args.customerCode,
            saleRequestId: args.saleRequestId,
          );
    }

    void processCart() {
      ref
          .read(insertUpdateProcessCartControllerProvider.notifier)
          .processCart();
    }

    return AsyncValueWidget(
      value: ref.watch(
        canAccessResourceStateControllerProvider(
          BsRoutine.saleRequest,
          BsResource.saleRequestChangeTPrice,
        ),
      ),
      tryAgain: () => ref.invalidate(
        canAccessResourceStateControllerProvider(
          BsRoutine.saleRequest,
          BsResource.saleRequestChangeTPrice,
        ),
      ),
      data: (canChangePrice) {
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
                            text: 'Processar carrinho'.hardcoded,
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
                        final requestTypeAllowChangePriceOrCost = ref.watch(
                          insertUpdateStateControllerProvider.select(
                            (s) =>
                                s
                                    .value
                                    ?.requestType
                                    ?.allowAlterCostOrSalePrice ==
                                true,
                          ),
                        );
                        return PrimaryButton(
                          onPressed:
                              needProcessingCart &&
                                  (!canChangePrice ||
                                      !requestTypeAllowChangePriceOrCost)
                              ? null
                              : () => onSave(needProcessingCart),
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
      },
    );
  }
}
