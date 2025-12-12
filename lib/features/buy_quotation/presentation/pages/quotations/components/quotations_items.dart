import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../routing/routing.dart';
import '../../../controllers/controller.dart';

class QuotationsItems extends ConsumerWidget {
  final int enterpriseCode;
  const QuotationsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return AsyncValueWidget(
      value: ref.watch(buyQuotationsStateControllerProvider(enterpriseCode)),
      tryAgain: () =>
          ref.invalidate(buyQuotationsStateControllerProvider(enterpriseCode)),
      data: (quotations) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              buyQuotationsStateControllerProvider(enterpriseCode),
            );
          },
          child: ListView.builder(
            itemCount: quotations.length,
            itemBuilder: (_, index) {
              final quotation = quotations[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.goNamed(
                      Routes.buyQuotationInsertUpdate.name,
                      pathParameters: {
                        'code': quotation.Code.toString(),
                        'enterpriseCode': enterpriseCode.toString(),
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubTitle(
                          title: 'Código'.hardcoded,
                          subTitle: quotation.Code.toString(),
                        ),
                        if (quotation.PersonalizedCode != null)
                          TitleAndSubTitle(
                            title: 'Código personalizado'.hardcoded,
                            subTitle: quotation.PersonalizedCode.toString(),
                          ),
                        if (quotation.DateOfCreation != null)
                          TitleAndSubTitle(
                            title: 'Data de criação'.hardcoded,
                            subTitle: formatter.format(
                              quotation.DateOfCreation!,
                            ),
                          ),
                        TitleAndSubTitle(
                          title: 'Data limite'.hardcoded,
                          emptyMessage: 'Nenhuma data de limite'.hardcoded,
                          subTitle: quotation.DateOfLimit == null
                              ? null
                              : formatter.format(quotation.DateOfLimit!),
                        ),
                        TitleAndSubTitle(
                          title: 'Observações'.hardcoded,
                          subTitle: quotation.Observations,
                          emptyMessage: 'Sem observações'.hardcoded,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
