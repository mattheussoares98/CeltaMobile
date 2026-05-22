import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/summary/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                style: context.theme.textTheme.titleLarge,
              ),
              gapH16,
              Text(
                'Total Líquido: ${summaryData.totalLiquid?.toString().toBrazilianNumber().addBrazilianCoin() ?? 'R\$ 0,00'.hardcoded}'
                    .hardcoded,
              ),
              gapH16,
              const SellerDropdown(),
              const Spacer(),
              PrimaryButton(
                onPressed: () async {
                  ref
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
