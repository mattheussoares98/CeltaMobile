import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../controllers/controllers.dart';

class LotPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const LotPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LotPageState();
}

class _LotPageState extends ConsumerState<LotPage> {
  int? changingQuantityIndex;

  @override
  Widget build(BuildContext context) {
    final lotAsync = ref.watch(
      lotStateControllerProvider(widget.enterpriseCode),
    );

    return AsyncValueWidget(
      value: lotAsync,
      tryAgain: () {
        ref.invalidate(lotStateControllerProvider(widget.enterpriseCode));
      },
      data: (items) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: (index == items.length - 1) ? Sizes.p32 : 0,
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            changingQuantityIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.p8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleAndSubTitle(
                                title: null,
                                subTitle:
                                    "${item.product.Name} (${item.product.PLU})",
                              ),
                              TitleAndSubTitle(
                                title: 'Just '.hardcoded,
                                subTitle: item
                                    .selectedJustification
                                    .Descricao_JustMov,
                              ),
                              TitleAndSubTitle(
                                title: 'De '.hardcoded,
                                subTitle:
                                    item.selectedOriginStock.Nome_TipoEstoque,
                              ),
                              TitleAndSubTitle(
                                title: 'Para '.hardcoded,
                                subTitle:
                                    item.selectedDestinyStock.Nome_TipoEstoque,
                              ),
                              TitleAndSubTitle(
                                title: 'Qtd '.hardcoded,
                                subTitle: item.quantity
                                    .toString()
                                    .toBrazilianNumber(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p4,
                0,
                Sizes.p4,
                Sizes.p4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ConfirmOrRequestButton(
                      isRequest: true,
                      enterpriseCode: widget.enterpriseCode,
                    ),
                  ),
                  gapW8,
                  Expanded(
                    child: ConfirmOrRequestButton(
                      isRequest: false,
                      enterpriseCode: widget.enterpriseCode,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ConfirmOrRequestButton extends ConsumerWidget {
  final bool isRequest;
  final int enterpriseCode;
  const ConfirmOrRequestButton({
    super.key,
    required this.isRequest,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      text: isRequest ? 'Solicitar'.hardcoded : 'Confirmar'.hardcoded,
      onPressed: () async {
        //TODO show message to confirm and validate if is working correctly
        final items = await ref.read(
          lotStateControllerProvider(enterpriseCode).future,
        );

        ref
            .read(confirmAdjustStockControllerProvider.notifier)
            .confirm(
              items
                  .map(
                    (e) => AdjustStockItemEntity(
                      EnterpriseCode: e.product.EnterpriseCode,
                      ProductCode: e.product.ProductCode,
                      ProductPackingCode: e.product.ProductPackingCode,
                      JustificationCode:
                          e.selectedJustification.CodigoInterno_JustMov,
                      StockTypeCode:
                          e.selectedOriginStock.CodigoInterno_TipoEstoque!,
                      StockTypeRecipientCode:
                          e.selectedDestinyStock.CodigoInterno_TipoEstoque,
                      IsPendingAdjust: isRequest,
                      Quantity: e.quantity,
                    ),
                  )
                  .toList(),
            );
      },
    );
  }
}
