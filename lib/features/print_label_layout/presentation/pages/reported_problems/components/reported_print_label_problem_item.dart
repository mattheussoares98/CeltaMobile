import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/reported_problems/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class ReportedPrintLabelProblemItem extends StatelessWidget {
  final ReportedPrintLabelProblemEntity report;

  const ReportedPrintLabelProblemItem({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final value = report.report;
    final layout = value.savedLayout;
    final environment = value.environment;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText(report.createdAt.toLocal().formatDate(.ddMMyyyyHHmm)),
            gapH12,
            LayoutBuilder(
              builder: (context, constraints) {
                final images = [
                  ReportedProblemImage(
                    title: 'Foto da etiqueta'.hardcoded,
                    url: report.physicalLabelUrl,
                    aspectRatio:
                        value.physicalLabel.width / value.physicalLabel.height,
                  ),
                  ReportedProblemImage(
                    title: 'Imagem do canvas'.hardcoded,
                    url: report.canvasPreviewUrl,
                    aspectRatio: 16 / 9,
                    alignment: Alignment.topCenter,
                  ),
                ];
                if (constraints.maxWidth < 600) {
                  return Column(children: [images[0], gapH12, images[1]]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: images[0]),
                    gapW16,
                    Expanded(child: images[1]),
                  ],
                );
              },
            ),
            gapH16,
            TitleAndSubTitle(
              title: 'Empresa'.hardcoded,
              subTitle:
                  '${value.erpEnterpriseCode} - ${value.erpEnterpriseName}',
            ),
            gapH8,
            TitleAndSubTitle(
              title: 'Usuário'.hardcoded,
              subTitle: value.erpUserName,
            ),
            gapH8,
            TitleAndSubTitle(
              title: 'Relato'.hardcoded,
              subTitle: value.description,
            ),
            gapH8,
            TitleAndSubTitle(
              title: 'Leiaute'.hardcoded,
              subTitle: '${layout.code} - ${layout.name}',
            ),
            gapH8,
            TitleAndSubTitle(
              title: 'Impressora'.hardcoded,
              subTitle: layout.labelPrinter?.description,
              emptyMessage: 'Não informada'.hardcoded,
            ),
            gapH8,
            TitleAndSubTitle(
              title: 'Ambiente'.hardcoded,
              subTitle:
                  '${environment.operatingSystem} ${environment.operatingSystemVersion} | ${environment.deviceModel} | App ${environment.appVersion}',
            ),
          ],
        ),
      ),
    );
  }
}
