import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
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

    final currentSaleRequest = ref.watch(
      insertUpdateStateControllerProvider.select((s) => s.value),
    );
    final lastProcessed = ref
        .read(insertUpdateStateControllerProvider.notifier)
        .lastProcessedSaleRequest;
    final needProcessingCart = currentSaleRequest != lastProcessed;

    final summaryDataAsync = ref.watch(
      insertUpdateStateControllerProvider.select(
        (v) => v.whenData(
          (data) => (customer: data.customer, totalLiquid: data.totalLiquid),
        ),
      ),
    );

    return Column(
      children: [
        Expanded(
          child: AsyncValueWidget(
            value: summaryDataAsync,
            data: (summaryData) {
              return Padding(
                padding: const EdgeInsets.all(Sizes.p16),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Text(
                        'Cliente: ${summaryData.customer?.name ?? 'Não selecionado'.hardcoded}'
                            .hardcoded,
                        style: context.theme.textTheme.titleLarge,
                      ),
                    ),
                    gapSliverH16,
                    SliverToBoxAdapter(
                      child: Text(
                        'Total Líquido: ${summaryData.totalLiquid?.toString().toBrazilianNumber().addBrazilianCoin() ?? 'R\$ 0,00'.hardcoded}'
                            .hardcoded,
                      ),
                    ),
                    gapSliverH16,
                    const SliverToBoxAdapter(child: SellerDropdown()),

                    // const SliverToBoxAdapter(child: Spacer()),
                  ],
                ),
              );
            },
            tryAgain: () => ref.invalidate(insertUpdateStateControllerProvider),
          ),
        ),
        AsyncValueWidget(
          value: ref.watch(
            canAccessResourceStateControllerProvider(
              BsRoutine.saleRequest,
              BsResource.saleRequestChangeTPrice,
            ),
          ),
          tryAgain: () => ref.invalidate(
            canAccessResourceStateControllerProvider(
              BsRoutine.saleRequest,
              BsResource.saleRequestChangeTPrice,
            ),
          ),
          data: (canChangePrice) {
            return Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (needProcessingCart) ...[
                    Consumer(
                      builder: (_, ref, _) {
                        bool isLoading = ref.watch(
                          insertUpdateProcessCartControllerProvider.select(
                            (s) => s.isLoading,
                          ),
                        );
                        //TODO check if I can cancel the request if he change the state from insertUpdateStateController while it is processing the cart
                        return PrimaryButton(
                          text: 'Processar carrinho'.hardcoded,
                          isLoading: isLoading,
                          onPressed: () {
                            ref
                                .read(
                                  insertUpdateProcessCartControllerProvider
                                      .notifier,
                                )
                                .processCart();
                          },
                        );
                      },
                    ),
                    gapH16,
                  ],
                  PrimaryButton(
                    onPressed: needProcessingCart && !canChangePrice
                        ? null
                        : () async {
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
        ),
      ],
    );
  }
}
