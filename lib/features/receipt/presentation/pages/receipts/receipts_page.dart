import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../controllers/controllers.dart';

class ReceiptsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ReceiptsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Recebimentos'.hardcoded)),
      body: AsyncValueWidget(
        value: ref.watch(receiptsStateControllerProvider(enterpriseCode)),
        tryAgain: () =>
            ref.invalidate(receiptsStateControllerProvider(enterpriseCode)),
        data: (receipts) {
          return ResponsiveListFlow(
            itemCount: receipts.length,
            itemBuilder: (_, index) {
              final receipt = receipts[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    //TODO implement
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubTitle(
                          title: 'Recebimento'.hardcoded,
                          subTitle: receipt.Numero_ProcRecebDoc.toString(),
                        ),
                        if (receipt.EmitterName != null)
                          TitleAndSubTitle(
                            title: 'Emitente'.hardcoded,
                            subTitle: receipt.EmitterName,
                          ),
                        Builder(
                          builder: (context) {
                            final observations =
                                receipt.Observacoes_ProcRecebDoc ??
                                receipt.DefaultObservations;
                            final observationsWithoutBreaklines = observations
                                ?.replaceAll(RegExp(r'\\r\\'), '')
                                .replaceAll(RegExp(r'\\n'), '\n')
                                .replaceAll(RegExp(r'\\'), '');
                            return TitleAndSubTitle(
                              title:
                                  receipt.Observacoes_ProcRecebDoc == null &&
                                      receipt.DefaultObservations != null
                                  ? 'Observação padrão'.hardcoded
                                  : 'Observações',
                              subTitle: observations == null
                                  ? null
                                  : '\n$observationsWithoutBreaklines',
                              emptyMessage: 'Sem observações'.hardcoded,
                              //TODO test in a enterprise that doesnt has default observations
                            );
                          },
                        ),
                        TitleAndSubTitle(
                          title: null,
                          subTitle: receipt.status.description,
                          subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                            color: receipt.status.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
