import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entity/entity.dart';

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

    return TitleAndSubTitle(
      title:
          (receipt.Observacoes_ProcRecebDoc == null &&
              receipt.DefaultObservations != null
          ? 'Observação padrão'.hardcoded
          : 'Observações'),
      subTitle: observations == null
          ? null
          : '\n$observationsWithoutBreaklines',
      //TODO test in a enterprise that doesnt has default observations
    );
  }
}
