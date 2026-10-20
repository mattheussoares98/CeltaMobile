import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
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
          padding: const EdgeInsets.only(bottom: Sizes.p120),
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
                title: context.l10n.code,
                subTitle: quotation.Code.toString(),
              ),
              if (quotation.PersonalizedCode != null)
                TitleAndSubTitle(
                  title: context.l10n.customCode,
                  subTitle: quotation.PersonalizedCode.toString(),
                ),
              if (quotation.DateOfCreation != null)
                TitleAndSubTitle(
                  title: context.l10n.creationDate,
                  subTitle: quotation.DateOfCreation?.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
              TitleAndSubTitle(
                title: context.l10n.deadline,
                emptyMessage: context.l10n.noDeadline,
                subTitle: quotation.DateOfLimit?.formatDate(),
              ),
              TitleAndSubTitle(
                title: context.l10n.notes,
                subTitle: quotation.Observations,
                emptyMessage: context.l10n.noNotes,
                removeColon: quotation.Observations?.isEmpty ?? true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
