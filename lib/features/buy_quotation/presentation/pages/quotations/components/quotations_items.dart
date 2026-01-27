import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../routing/routing.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controller.dart';

class QuotationsItems extends ConsumerWidget {
  final int enterpriseCode;
  const QuotationsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: ResponsiveListFlow(
            padding: const EdgeInsets.only(bottom: Sizes.p64),
            itemCount: quotations.length,
            itemBuilder: (_, index) {
              final quotation = quotations[index];
              return _QuotationItem(
                key: ValueKey(quotation.Code.toString()),
                quotation: quotation,
                onTap: () => context.goNamed(
                  Routes.buyQuotationInsertUpdate.name,
                  pathParameters: {
                    'code': quotation.Code.toString(),
                    'enterpriseCode': enterpriseCode.toString(),
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _QuotationItem extends StatelessWidget {
  final BuyQuotationEntity quotation;
  final VoidCallback onTap;
  const _QuotationItem({
    super.key,
    required this.quotation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
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
                    subTitle: DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(quotation.DateOfCreation!),
                  ),
                TitleAndSubTitle(
                  title: 'Data limite'.hardcoded,
                  emptyMessage: 'Nenhuma data de limite'.hardcoded,
                  subTitle: quotation.DateOfLimit == null
                      ? null
                      : DateFormat('dd/MM/yyyy').format(quotation.DateOfLimit!),
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
      ),
    );
  }
}
