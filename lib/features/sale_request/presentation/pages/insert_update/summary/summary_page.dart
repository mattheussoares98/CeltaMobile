import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../providers.dart';
import '../../../controllers/controllers.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    final summaryDataAsync = ref.watch(
      insertUpdateStateControllerProvider.select(
        (v) => v.whenData(
          (data) => (customer: data.customer, totalLiquid: data.totalLiquid),
        ),
      ),
    );

    return AsyncValueWidget(
      value: summaryDataAsync,
      data: (summaryData) {
        return Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cliente: ${summaryData.customer?.name ?? 'Não selecionado'.hardcoded}'
                    .hardcoded,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              gapH16,
              Text(
                'Total Líquido: ${summaryData.totalLiquid?.toString().toBrazilianNumber().addBrazilianCoin() ?? 'R\$ 0,00'.hardcoded}'
                    .hardcoded,
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () async {
                  await ref
                      .read(
                        saveSaleRequestControllerProvider(
                          args.enterpriseCode,
                        ).notifier,
                      )
                      .saveBsfSaleRequest(
                        customerCode: args.customerCode,
                        saleRequestId: args.saleRequestId,
                      );
                },
                text: 'SALVAR'.hardcoded,
              ),
            ],
          ),
        );
      },
      tryAgain: () => ref.invalidate(insertUpdateStateControllerProvider),
    );
  }
}
