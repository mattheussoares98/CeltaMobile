import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../controllers/controllers.dart';
import 'components/components.dart.dart';

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
        if (items.isEmpty) {
          return Center(child: Text('Lote vazio'.hardcoded));
        }
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
