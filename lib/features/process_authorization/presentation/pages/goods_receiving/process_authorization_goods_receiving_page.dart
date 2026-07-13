import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/vote/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationGoodsReceivingPage extends ConsumerWidget {
  final int processCode;
  const ProcessAuthorizationGoodsReceivingPage({
    super.key,
    required this.processCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = (judgmentDetailsStateControllerProvider(processCode));
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(title: 'Recebimento de mercadorias'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          final goodsReceiving = data.defendants
              ?.cast<BSFGoodsReceivingDefendantEntity>()
              .firstOrNull
              ?.goodsReceiving;
          if (goodsReceiving == null) {
            return Center(
              child: BaseText.error(
                'Não foi possível encontrar o documento'.hardcoded,
              ),
            );
          }

          return ResponsiveScrollableWidget(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        TitleAndSubTitle(
                          title: 'Empresa'.hardcoded,
                          subTitle: goodsReceiving.enterpriseString,
                        ),
                        if (goodsReceiving.type?.name != null)
                          TitleAndSubTitle(
                            title: 'Tipo de documento'.hardcoded,
                            subTitle: goodsReceiving.type?.name,
                          ),
                        if ((goodsReceiving
                                    .eletronicAccessKey
                                    ?.fiscalNoteNumber ??
                                0) >
                            0)
                          TitleAndSubTitle(
                            title: 'Chave NFe'.hardcoded,
                            subTitle: goodsReceiving
                                .eletronicAccessKey
                                ?.fiscalNoteNumber,
                          ),
                        if (goodsReceiving.dateTimeOfEntrance != null)
                          TitleAndSubTitle(
                            title: 'Entrada'.hardcoded,
                            subTitle: goodsReceiving.dateTimeOfEntrance
                                ?.formatDate(DateFormatType.ddMMyyyyHHmm),
                          ),
                        if (goodsReceiving.dateOfEmission != null)
                          TitleAndSubTitle(
                            title: 'Emissão'.hardcoded,
                            subTitle: goodsReceiving.dateOfEmission?.formatDate(
                              DateFormatType.ddMMyyyyHHmm,
                            ),
                          ),
                        if ((goodsReceiving.number ?? 0) > 0)
                          TitleAndSubTitle(
                            title: 'Número'.hardcoded,
                            subTitle: goodsReceiving.number,
                          ),
                        if ((goodsReceiving
                                    .eletronicAccessKey
                                    ?.fiscalNoteSerial ??
                                0) >
                            0)
                          TitleAndSubTitle(
                            title: 'Série NFe'.hardcoded,
                            subTitle: goodsReceiving
                                .eletronicAccessKey
                                ?.fiscalNoteSerial,
                          ),
                        if ((goodsReceiving.value ?? 0) > 0)
                          TitleAndSubTitle(
                            title: 'Valor'.hardcoded,
                            subTitle: goodsReceiving.value,
                            subTitleIsPrice: true,
                          ),
                        if (goodsReceiving.observations?.isNotEmpty ?? false)
                          TitleAndSubTitle(
                            title: 'Observações'.hardcoded,
                            subTitle: goodsReceiving.observations,
                          ),
                      ],
                    ),
                  ),
                ),
                gapH32,
                OpenVotePageButton(
                  processCode: processCode,
                  showDeviceRotationIcon: false,
                  usePrimaryButton: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
