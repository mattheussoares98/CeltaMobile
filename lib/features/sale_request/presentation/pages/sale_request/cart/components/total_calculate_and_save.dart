import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../controllers/controllers.dart';

class TotalCalculateAndSave extends ConsumerWidget {
  final RequestTypeEntity selectedRequest;
  const TotalCalculateAndSave({super.key, required this.selectedRequest});

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
                    final products = ref.watch(
                      pendingSaleRequestStateControllerProvider.select(
                        (s) => s.value?.cart.values,
                      ),
                    );

                    return TitleAndSubTitle(
                      title: null,
                      subTitle: (products?.fold<double>(0.0, (p, e) {
                        return p + e.TotalLiquid;
                      })),
                      subTitleIsPrice: true,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Consumer(
              builder: (_, ref, _) {
                final userCanChangePrices = ref.watch(
                  CanAccessResourceStateControllerProvider(
                    BsRoutine.saleRequest,
                    BsResource.saleRequest,
                    ref
                        .read(selectedEnterpriseStateControllerProvider)!
                        .Code!, //TODO remove this unecessary param from the controller
                  ),
                );

                final needProcessCart = ref.watch(
                  pendingSaleRequestStateControllerProvider.select(
                    (s) => s.value?.needProcessCart == true,
                  ),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (needProcessCart && userCanChangePrices.value != true)
                      //TODO test if is working correctly
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
                    PrimaryButton(text: 'Salvar pedido'.hardcoded),
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
