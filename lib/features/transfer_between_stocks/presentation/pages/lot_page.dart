import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
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
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            final item = items[index];
            return InkWell(
              onTap: () {
                setState(() {
                  changingQuantityIndex = index;
                });
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.fromLTRB(
                  Sizes.p8,
                  Sizes.p8,
                  Sizes.p8,
                  0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleAndSubTitle(
                        title: null,
                        subTitle: "${item.product.Name} (${item.product.PLU})",
                      ),
                      TitleAndSubTitle(
                        title: 'Just '.hardcoded,
                        subTitle: item.selectedJustification.Descricao_JustMov,
                      ),
                      TitleAndSubTitle(
                        title: 'De '.hardcoded,
                        subTitle: item.selectedOriginStock.Nome_TipoEstoque,
                      ),
                      TitleAndSubTitle(
                        title: 'Para '.hardcoded,
                        subTitle: item.selectedDestinyStock.Nome_TipoEstoque,
                      ),
                      TitleAndSubTitle(
                        title: 'Qtd '.hardcoded,
                        subTitle: item.quantity.toString().toBrazilianNumber(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
