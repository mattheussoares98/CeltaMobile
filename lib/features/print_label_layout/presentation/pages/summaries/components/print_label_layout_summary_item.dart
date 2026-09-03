import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrintLabelLayoutSummaryItem extends StatelessWidget {
  final BSFPrintLabelLayoutSummaryEntity summary;
  final int enterpriseCode;

  const PrintLabelLayoutSummaryItem({
    super.key,
    required this.summary,
    required this.enterpriseCode,
  });

  String get _printerDescription {
    final description = summary.labelPrinterDescription;
    return description?.isNotEmpty == true
        ? description!
        : summary.labelPrinterModelType.apiValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => context.goNamed(
          Routes.printLabelLayoutDetails.name,
          pathParameters: {
            'enterpriseCode': enterpriseCode.toString(),
            'labelCode': summary.code.toString(),
          },
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubTitle(
                title: 'Nome'.hardcoded,
                subTitle: summary.name,
                subTitleStyle: context.theme.textTheme.titleMedium,
              ),
              TitleAndSubTitle(
                title: 'Impressora'.hardcoded,
                subTitle: _printerDescription,
              ),
              TitleAndSubTitle(
                title: 'Tipo'.hardcoded,
                subTitle: summary.layoutTypeDescription,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
