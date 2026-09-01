import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutDetailsContent extends StatelessWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutDetailsContent({super.key, required this.layout});

  @override
  Widget build(BuildContext context) {
    final coordinateUnit = layout.labelPrinter?.coordinateUnit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrintLabelLayoutPreview(layout: layout),
        gapH8,
        PrintLabelLayoutGeneralInformation(layout: layout),
        gapH8,
        BaseText.title('Campos (${layout.fields.length})'.hardcoded),

        if (layout.fields.isEmpty)
          BaseText.caption('Nenhum campo configurado'.hardcoded)
        else
          ...layout.fields.map(
            (field) => PrintLabelLayoutFieldItem(
              key: ValueKey(field.code),
              layoutCode: layout.code,
              field: field,
              coordinateUnit: coordinateUnit,
            ),
          ),
      ],
    );
  }
}
