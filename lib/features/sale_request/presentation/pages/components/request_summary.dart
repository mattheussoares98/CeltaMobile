import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';

class RequestSummary extends StatelessWidget {
  final SaleRequestEntity saleRequest;
  final VoidCallback? onTap;
  final bool showCustomer;
  const RequestSummary({
    super.key,
    this.onTap,
    required this.saleRequest,
    this.showCustomer = true,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Card(
      clipBehavior: onTap == null ? null : Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(isIOS ? CupertinoIcons.doc_text : Icons.receipt_long),
                    gapW12,
                    Text(
                      'Resumo'.hardcoded,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                TitleAndSubTitle(
                  title: 'Núm pedido'.hardcoded,
                  copyableSubtitle: true,
                  subTitle: saleRequest.SaleRequestNumber,
                ),
                if (saleRequest.RequestType != null)
                  TitleAndSubTitle(
                    title: 'Modelo de pedido'.hardcoded,
                    copyableSubtitle: true,
                    subTitle: saleRequest.RequestType?.Name,
                  ),
                if (saleRequest.Seller != null)
                  TitleAndSubTitle(
                    title: 'Vendedor'.hardcoded,
                    copyableSubtitle: true,
                    subTitle: saleRequest.Seller?.Name,
                  ),
                if (saleRequest.DateHourOfCreation != null)
                  TitleAndSubTitle(
                    title: 'Data'.hardcoded,
                    subTitle: dateFormat.format(
                      saleRequest.DateHourOfCreation!,
                    ),
                  ),
                if (showCustomer && saleRequest.customer != null)
                  TitleAndSubTitle(
                    title: 'Cliente'.hardcoded,
                    subTitle: saleRequest.customer!.Name,
                  ),
                if ((saleRequest.DiscountValue ?? 0) > 0)
                  TitleAndSubTitle(
                    title: 'Desconto'.hardcoded,
                    subTitle: saleRequest.DiscountValue,
                    subTitleIsPrice: true,
                  ),
                TitleAndSubTitle(
                  title: 'Total'.hardcoded,
                  subTitle: saleRequest.TotalLiquid,
                  subTitleIsPrice: true,
                ),
                if (saleRequest.observations != null)
                  TitleAndSubTitle(
                    title: 'Observações'.hardcoded,
                    subTitle: saleRequest.observations,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
