import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class Informations extends StatelessWidget {
  final ReportScheduleEntity report;
  const Informations({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(title: null, subTitle: report.Name),
        TitleAndSubTitle(
          title: context.l10n.category,
          subTitle: report.CategoryName,
        ),
        TitleAndSubTitle(
          title: context.l10n.subcategory,
          subTitle: report.SubCategoryName,
        ),
        TitleAndSubTitle(
          title: context.l10n.report,
          subTitle: report.ReportModelName,
        ),

        if (report.LastExecutionContainsData == false)
          Text(
            context.l10n.reportHasNoDataToDisplay,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
