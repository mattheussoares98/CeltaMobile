import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../controllers/controllers.dart';

class TotalCalculateAndSave extends ConsumerWidget {
  final RequestTypeEntity selectedRequest;
  const TotalCalculateAndSave({super.key, required this.selectedRequest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (s) => s.value?.cart.values,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text('Total'.hardcoded),
                TitleAndSubTitle(
                  title: null,
                  subTitle: (products?.fold<double>(0.0, (p, e) {
                    return p + e.TotalLiquid;
                  })),
                  subTitleIsPrice: true,
                ),
              ],
            ),
          ),
          gapW8,
          Expanded(
            flex: 7,
            child: AsyncValueWidget(
              value: ref.watch(
                CanAccessResourceStateControllerProvider(
                  BsRoutine.generic,
                  BsResource.saleRequestChangeTPrice,
                ),
              ),
              tryAgain: () {
                ref.invalidate(
                  CanAccessResourceStateControllerProvider(
                    BsRoutine.generic,
                    BsResource.saleRequestChangeTPrice,
                  ),
                );
              },
              data: (canChangePrice) {
                final needProcessCart = ref.watch(
                  pendingSaleRequestStateControllerProvider.select(
                    (s) => s.value?.needProcessCart == true,
                  ),
                );

                final selectedCustomer = ref.watch(
                  pendingSaleRequestStateControllerProvider.select(
                    (s) => s.value?.customer,
                  ),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (selectedCustomer != null &&
                        needProcessCart &&
                        products != null &&
                        products.isNotEmpty)
                      PrimaryButton(
                        text: 'Calcular preços'.hardcoded,
                        onPressed: () {
                          showAlertDialog(
                            context: context,
                            title: 'Calcular preços?'.hardcoded,
                            cancelActionText: 'Cancelar'.hardcoded,
                            content:
                                'Ao calcular os preços, serão obtidos os preços calculados pelo BS de acordo com promoções, negociações de vendas, oferta, atacado de acordo com a quantidade mínima, etc'
                                    .hardcoded,
                            onOkPressed: () {
                              ref
                                  .read(processCartControllerProvider.notifier)
                                  .process(
                                    requestTypeCode: selectedRequest.Code,
                                  );
                            },
                          );
                        },
                      ),
                    gapH4,
                    PrimaryButton(
                      text: products == null || products.isEmpty
                          ? 'Adicione produtos'.hardcoded
                          : selectedCustomer == null
                          ? 'Selecione o cliente'.hardcoded
                          : 'Salvar pedido'.hardcoded,
                      onPressed:
                          selectedCustomer == null ||
                              products == null ||
                              products.isEmpty
                          ? null
                          : () async {
                              showAlertDialog(
                                context: context,
                                title: needProcessCart
                                    ? 'Atenção!'.hardcoded
                                    : 'Salvar pedido?'.hardcoded,
                                content: needProcessCart
                                    ? 'O pedido ainda não foi processado para calcular os preços de acordo com promoções, negociações de vendas, oferta, atacado, etc!. Deseja salvar mesmo assim?'
                                          .hardcoded
                                    : null,
                                defaultActionText: 'Salvar'.hardcoded,
                                cancelActionText: 'Cancelar'.hardcoded,
                                onOkPressed: () {
                                  ref
                                      .read(
                                        saveSaleRequestControllerProvider
                                            .notifier,
                                      )
                                      .save(
                                        requestTypeCode: selectedRequest.Code,
                                      );
                                },
                              );
                            },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
