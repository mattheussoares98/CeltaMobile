import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class CurrentObservations extends StatelessWidget {
  final ReceiptEntity receipt;
  const CurrentObservations({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final observations =
        receipt.Observacoes_ProcRecebDoc ?? receipt.DefaultObservations;
    final observationsWithoutBreaklines = observations
        ?.replaceAll(RegExp(r'\\r\\'), '')
        .replaceAll(RegExp(r'\\n'), '\n')
        .replaceAll(RegExp(r'\\'), '');

    final shouldInsertObservations =
        receipt.DefaultObservations != null &&
        receipt.DefaultObservations!.isNotEmpty &&
        (receipt.Observacoes_ProcRecebDoc == null ||
            receipt.Observacoes_ProcRecebDoc!.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: shouldInsertObservations
              ? 'Observação padrão'.hardcoded
              : 'Observações'.hardcoded,
          titleStyle: context.theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: observations == null || observations.isEmpty
                ? Colors.transparent
                : null,
          ),
          subTitle: null,
        ),
        TitleAndSubTitle(
          title: null,
          titleStyle: context.theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
          subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: shouldInsertObservations
                ? context.theme.disabledColor
                : Colors.black,
          ),
          subTitle: observations == null
              ? null
              : '$observationsWithoutBreaklines',
        ),
      ],
    );
  }
}
