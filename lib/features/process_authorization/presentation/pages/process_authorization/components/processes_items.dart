import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/pages.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProcessesItems extends ConsumerWidget {
  final BSFProcessAuthorizationJudgementStatus status;
  const ProcessesItems({super.key, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(BSFProcessAuthorizationJudgmentEntity process) async {
      final type = process.authorizationProcessItem?.typeAccordingToTheCode;
      final Routes? nextRoute = switch (type) {
        TypeAccordingToTheCode.saleRequestDiscount ||
        TypeAccordingToTheCode.saleRequestLucrativity =>
          Routes.processAuthorizationSaleRequest,
        TypeAccordingToTheCode.goodsReceivingLiberateDocument ||
        TypeAccordingToTheCode.goodsReceivingCancelDocument =>
          Routes.processAuthorizationGoodsReceiving,
        TypeAccordingToTheCode.goodsReceivingValueDocument ||
        TypeAccordingToTheCode.goodsReceivingValidateDocumentXml ||
        TypeAccordingToTheCode.goodsReceivingValidatePaymentCondition => null,
        null => null,
      };
      if (nextRoute == null) {
        showToastMessage(
          'O processo de autorização de tipo "${type?.label}" ainda não foi implementado para ser julgado através do aplicativo',
          type: ToastType.error,
        );
        return;
      }

      final pathParams = {
        'enterpriseCode': process.enterprise!.code.toString(),
        'processCode': process.code.toString(),
      };

      if (nextRoute == Routes.processAuthorizationSaleRequest) {
        pathParams['pageType'] =
            process.authorizationProcessItem?.typeAccordingToTheCode ==
                TypeAccordingToTheCode.saleRequestDiscount
            ? PageType.discount.name
            : PageType.lucrativity.name;
      }

      if (context.mounted) {
        context.goNamed(nextRoute.name, pathParameters: pathParams);
      }
    }

    return AsyncValueWidget(
      value: ref.watch(judgmentsStateControllerProvider),
      tryAgain: () => ref.invalidate(judgmentsStateControllerProvider),
      data: (data) {
        final filteredData = data.where((e) => e.status == status).toList();

        if (filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                BaseRichText(
                  textAlign: .center,
                  texts: [
                    BaseText.title(
                      'Não foram encontrados processos com o status '.hardcoded,
                    ),
                    BaseText.error('${status.label.toLowerCase()} '),
                  ],
                ),
              ],
            ),
          );
        }

        filteredData.sort((a, b) {
          final timeA = a.dateTimeOfCreation;
          final timeB = b.dateTimeOfCreation;

          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return -1;
          if (timeB == null) return 1;

          return timeB.compareTo(timeA);
        });

        return ResponsiveListFlow(
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final process = filteredData[index];
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => onTap(process),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TitleAndSubTitle(
                            title: null,
                            subTitle: process.enterprise?.name ?? '',
                          ),
                          BaseText.titleMedium(
                            process.authorizationProcessItem?.name ?? '',
                          ),
                          if (process.dateTimeOfCreation != null)
                            TitleAndSubTitle(
                              title: 'Data'.hardcoded,
                              subTitle: process.dateTimeOfCreation!.formatDate(
                                DateFormatType.ddMMyyyyHHmmss,
                              ),
                            ),
                          TitleAndSubTitle(
                            title: 'Processo iniciado por'.hardcoded,
                            subTitle: process.user?.identification,
                          ),
                          if (process.authorizators?.isNotEmpty ?? false)
                            TitleAndSubTitle(
                              title: 'Autorizadores'.hardcoded,
                              subTitle: process.authorizators
                                  ?.map((e) => e.identification)
                                  .join('; '),
                            ),
                          if (process.observationsVotes?.isNotEmpty ?? false)
                            TitleAndSubTitle(
                              title: 'Observações'.hardcoded,
                              subTitle: process.observationsVotes,
                            ),
                        ],
                      ),
                    ),
                    const Positioned(
                      bottom: Sizes.p8,
                      right: Sizes.p8,
                      child: PlatformIcon(
                        materialIcon: Icons.arrow_outward_rounded,
                        cupertinoIcon: CupertinoIcons.arrow_up_right,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
