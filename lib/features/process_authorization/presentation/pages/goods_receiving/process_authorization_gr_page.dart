import 'package:celta_inventario/features/process_authorization/presentation/localization/localization.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/vote/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationGRPage extends ConsumerWidget {
  final int processCode;
  const ProcessAuthorizationGRPage({super.key, required this.processCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = (judgmentDetailsStateControllerProvider(processCode));
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(title: context.l10n.coreBsResourceGoodsReceiving),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          final goodsReceiving = data.defendants
              ?.cast<BSFGRDefendantEntity>()
              .firstOrNull
              ?.goodsReceiving;
          if (goodsReceiving == null) {
            return Center(
              child: BaseText.error(context.l10n.unableToFindTheDocument),
            );
          }

          return Column(
            crossAxisAlignment: .stretch,
            children: [
              if (data.authorizationProcessItem?.typeAccordingToTheCode != null)
                BaseText.error(
                  context.l10n.authorizationProcessType(
                    data.authorizationProcessItem!.typeAccordingToTheCode!,
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      TitleAndSubTitle(
                        title: context.l10n.enterprise,
                        subTitle: goodsReceiving.enterpriseString,
                      ),
                      if (goodsReceiving.detail?.enterpriseOrigin != null)
                        TitleAndSubTitle(
                          title: context.l10n.sourceCompany2,
                          subTitle:
                              '${goodsReceiving.detail!.enterpriseOrigin!.personalizedCode}'
                              '-${goodsReceiving.detail!.enterpriseOrigin!.fantasizesName}',
                        ),
                      if (goodsReceiving.type?.name != null)
                        TitleAndSubTitle(
                          title: context.l10n.documentType,
                          subTitle: goodsReceiving.type?.name,
                        ),
                      if ((goodsReceiving
                                  .eletronicAccessKey
                                  ?.fiscalNoteNumber ??
                              0) >
                          0)
                        TitleAndSubTitle(
                          title: context.l10n.nfeKey,
                          subTitle: goodsReceiving
                              .eletronicAccessKey
                              ?.fiscalNoteNumber,
                        ),
                      if (goodsReceiving.dateTimeOfEntrance != null)
                        TitleAndSubTitle(
                          title: context.l10n.coreOperationTypeEntrance,
                          subTitle: goodsReceiving.dateTimeOfEntrance
                              ?.formatDate(DateFormatType.ddMMyyyyHHmm),
                        ),
                      if (goodsReceiving.dateOfEmission != null)
                        TitleAndSubTitle(
                          title: context.l10n.issueDate,
                          subTitle: goodsReceiving.dateOfEmission?.formatDate(
                            DateFormatType.ddMMyyyyHHmm,
                          ),
                        ),
                      if ((goodsReceiving.number ?? 0) > 0)
                        TitleAndSubTitle(
                          title: context.l10n.number,
                          subTitle: goodsReceiving.number,
                        ),
                      if ((goodsReceiving
                                  .eletronicAccessKey
                                  ?.fiscalNoteSerial ??
                              0) >
                          0)
                        TitleAndSubTitle(
                          title: context.l10n.nfeSeries,
                          subTitle: goodsReceiving
                              .eletronicAccessKey
                              ?.fiscalNoteSerial,
                        ),
                      if ((goodsReceiving.value ?? 0) > 0)
                        TitleAndSubTitle(
                          title: context.l10n.amount,
                          subTitle: goodsReceiving.value,
                          subTitleIsPrice: true,
                        ),
                      if (goodsReceiving.observations?.isNotEmpty ?? false)
                        TitleAndSubTitle(
                          title: context.l10n.notes,
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
          );
        },
      ),
    );
  }
}
