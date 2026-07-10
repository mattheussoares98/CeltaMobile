import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
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
        TypeAccordingToTheCode.saleRequestDiscount =>
          Routes.processAuthorizationSaleRequestDiscounts,
        TypeAccordingToTheCode.saleRequestLucrativity =>
          Routes.processAuthorizationSaleRequestLucrativity,
        TypeAccordingToTheCode.receiptLiberateDocument => null,
        null => null,
      };
      if (nextRoute == null) {
        showToastMessage(
          'O processo de autorização de tipo "${type?.label}" ainda não foi implementado para ser julgado através do aplicativo',
          type: ToastType.error,
        );
        return;
      }
      if (context.mounted) {
        context.pushNamed(
          //TODO test it in web page. Shouldn't create a new route
          nextRoute.name,
          pathParameters: {
            'enterpriseCode': process.enterprise!.code.toString(),
            'processCode': process.code.toString(),
          },
        );
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
              crossAxisAlignment: .center,
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
                          TitleAndSubTitle(
                            title: null,
                            subTitle:
                                process
                                    .authorizationProcessItem
                                    ?.category
                                    ?.label ??
                                '',
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
                          TitleAndSubTitle(
                            title: 'Autorizadores'.hardcoded,
                            subTitle: process.authorizators
                                ?.map((e) => e.identification)
                                .join('; '),
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
