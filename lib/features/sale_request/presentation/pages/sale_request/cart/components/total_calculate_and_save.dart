import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../controllers/controllers.dart';

class TotalCalculateAndSave extends ConsumerWidget {
  final RequestTypeEntity selectedRequest;
  final TextEditingController instructionsController;
  final TextEditingController observationsController;
  final int enterpriseCode;
  const TotalCalculateAndSave({
    super.key,
    required this.selectedRequest,
    required this.instructionsController,
    required this.observationsController,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Consumer(
                  builder: (_, ref, _) {
                    final totalLiquid = ref.watch(
                      pendingSaleRequestStateControllerProvider(
                        enterpriseCode,
                      ).select(
                        (s) => s.value?.cart.values.fold<double>(
                          0.0,
                          (p, e) => p + e.TotalLiquid,
                        ),
                      ),
                    );
                    return TitleAndSubTitle(
                      title: null,
                      subTitle: totalLiquid,
                      subTitleIsPrice: true,
                    );
                  },
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
                //TODO test with a user that cant change price
                final needProcessCart = ref.watch(
                  pendingSaleRequestStateControllerProvider(
                    enterpriseCode,
                  ).select((s) => s.value?.needProcessCart == true),
                );

                final selectedCustomer = ref.watch(
                  pendingSaleRequestStateControllerProvider(
                    enterpriseCode,
                  ).select((s) => s.value?.customer),
                );

                return Consumer(
                  builder: (_, ref, _) {
                    final bool cartIsEmpty = ref.watch(
                      pendingSaleRequestStateControllerProvider(
                        enterpriseCode,
                      ).select((s) => s.value?.cart.values.isEmpty ?? true),
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (selectedCustomer != null &&
                            needProcessCart &&
                            !cartIsEmpty)
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
                                      .read(
                                        processCartControllerProvider.notifier,
                                      )
                                      .process(
                                        enterpriseCode: enterpriseCode,
                                        requestTypeCode: selectedRequest.Code,
                                      );
                                },
                              );
                            },
                          ),
                        gapH4,
                        PrimaryButton(
                          text: cartIsEmpty
                              ? 'Adicione produtos'.hardcoded
                              : selectedCustomer == null
                              ? 'Selecione o cliente'.hardcoded
                              : 'Salvar pedido'.hardcoded,
                          onPressed: selectedCustomer == null || cartIsEmpty
                              ? null
                              : () async {
                                  showAlertDialog(
                                    context: context,
                                    title: needProcessCart
                                        ? 'Atenção!'.hardcoded
                                        : 'Salvar pedido?'.hardcoded,
                                    content: needProcessCart
                                        ? 'Pode ser que o pedido seja salvo no BS com um preço diferente!\n\n'
                                                  .toUpperCase() +
                                              'O pedido ainda não foi processado para calcular os preços de acordo com promoções, negociações de vendas, oferta, atacado, preço praticado pelo modelo de pedido, etc! Dependendo das regras do BS, o pedido pode ser salvo com preços diferentes do que estão no aplicativo\n\n Deseja salvar mesmo assim?'
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
                                            enterpriseCode: enterpriseCode,
                                            requestTypeCode:
                                                selectedRequest.Code,
                                            instructions:
                                                instructionsController.text,
                                            observations:
                                                observationsController.text,
                                          );
                                    },
                                  );
                                },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
