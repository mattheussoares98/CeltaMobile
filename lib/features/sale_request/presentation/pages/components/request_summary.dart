import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';

class RequestSummary extends StatelessWidget {
  final SaleRequestEntity saleRequest;
  final VoidCallback? onTap;
  const RequestSummary({super.key, required this.saleRequest, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      clipBehavior: onTap == null ? null : Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAndSubTitle(
                title: 'Núm pedido'.hardcoded,
                copyableSubtitle: true,
                subTitle: saleRequest.SaleRequestNumber,
              ),
              if (saleRequest.DateHourOfCreation != null)
                TitleAndSubTitle(
                  title: 'Data'.hardcoded,
                  subTitle: dateFormat.format(saleRequest.DateHourOfCreation!),
                ),
              if (saleRequest.customer != null)
                TitleAndSubTitle(
                  title: 'Cliente'.hardcoded,
                  subTitle: saleRequest.customer!.Name,
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
    );
  }
}
