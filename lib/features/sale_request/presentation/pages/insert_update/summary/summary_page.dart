import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class SummaryPage extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const SummaryPage({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );

    final summaryDataAsync = ref.watch(
      provider.select(
        (v) => v.whenData(
          (data) => (customer: data.customer, totalLiquid: data.totalLiquid),
        ),
      ),
    );

    ref.listen(provider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Pedido salvo com sucesso!'.hardcoded,
      );
    });

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
                onPressed: ref.read(provider.notifier).save,
                text: 'SALVAR'.hardcoded,
              ),
            ],
          ),
        );
      },
      tryAgain: () => ref.invalidate(provider),
    );
  }
}
