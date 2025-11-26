import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';

class Informations extends StatelessWidget {
  final ReportScheduleEntity report;
  const Informations({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(title: null, subTitle: report.Name),
        TitleAndSubTitle(
          title: 'Categoria'.hardcoded,
          subTitle: report.CategoryName,
        ),
        TitleAndSubTitle(
          title: 'Sub categoria'.hardcoded,
          subTitle: report.SubCategoryName,
        ),
        TitleAndSubTitle(
          title: 'Relatório'.hardcoded,
          subTitle: report.ReportModelName,
        ),

        if (report.LastExecutionContainsData == false)
          Text(
            'Relatório SEM DADOS para exibir'.hardcoded,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.disabledColor,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
