import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/save_sale_request_controller.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAndSaveButtons extends ConsumerWidget {
  const ProcessAndSaveButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);
    final needProcessingCart = ref.watch(saleRequestNeedsProcessingProvider);

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
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (needProcessingCart) ...[
                Flexible(
                  //TODO check if I can cancel the request if he change the state from insertUpdateStateController while it is processing the cart
                  child: PrimaryButton(
                    text: 'Processar carrinho'.hardcoded,
                    onPressed: () {
                      ref
                          .read(
                            insertUpdateProcessCartControllerProvider.notifier,
                          )
                          .processCart();
                    },
                  ),
                ),
                gapH8,
              ],
              Flexible(
                child: PrimaryButton(
                  onPressed: needProcessingCart && !canChangePrice
                      ? null
                      : () async {
                          ref
                              .read(
                                saveSaleRequestControllerProvider(
                                  args.enterpriseCode,
                                ).notifier,
                              )
                              .saveBsfSaleRequest(
                                customerCode: args.customerCode,
                                saleRequestId: args.saleRequestId,
                              );
                        },
                  text: 'SALVAR'.hardcoded,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
