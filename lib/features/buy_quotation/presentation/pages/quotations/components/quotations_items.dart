import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        return ResponsiveListFlow(
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
    return Card(
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
                  subTitle: quotation.DateOfCreation?.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
              TitleAndSubTitle(
                title: 'Data limite'.hardcoded,
                emptyMessage: 'Nenhuma data de limite'.hardcoded,
                subTitle: quotation.DateOfLimit?.formatDate(
                  
                ),
              ),
              TitleAndSubTitle(
                title: 'Observações'.hardcoded,
                subTitle: quotation.Observations,
                emptyMessage: 'Sem observações'.hardcoded,
                removeColon: quotation.Observations?.isEmpty ?? true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
