import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class RequestSummary extends ConsumerWidget {
  final int saleRequestId;
  final int enterpriseCode;
  final int customerCode;
  final VoidCallback? onTap;
  final bool showCustomer;
  final bool showDetails;
  const RequestSummary({
    super.key,
    this.onTap,
    required this.saleRequestId,
    required this.enterpriseCode,
    required this.customerCode,
    this.showCustomer = true,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final saleRequest = ref.watch(
      saleRequestsStateControllerProvider(enterpriseCode).select(
        (s) => s.value?.collection.firstWhereOrNull(
          (sr) => sr.Id == saleRequestId,
        ),
      ),
    );

    if (saleRequest == null) {
      return const SizedBox.shrink();
    }

    return Card(
      clipBehavior: onTap == null ? null : Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isIOS ? CupertinoIcons.doc_text : Icons.receipt_long,
                        ),
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

                    if (showDetails)
                      Consumer(
                        builder: (context, ref, child) {
                          final requestDetails = ref.watch(
                            saleRequestDetailsStateControllerProvider(
                              customerCode: customerCode,
                              enterpriseCode: enterpriseCode,
                              saleRequestCode: saleRequest.Id!,
                            ).select((s) => s.value),
                          );

                          final deliveryTax =
                              requestDetails?.deliveryTax?.deliveryTax;
                          final deliveryTaxIsPercentage =
                              deliveryTax?.type == PercentageOrValue.percentage;
                          final increment = requestDetails?.increment;
                          final incrementIsPercentage =
                              increment?.type == PercentageOrValue.percentage;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((deliveryTax?.value ?? 0) > 0)
                                TitleAndSubTitle(
                                  title: 'Delivery'.hardcoded,
                                  subTitle: deliveryTax!.value,
                                  subTitleIsPercentage: deliveryTaxIsPercentage,
                                  subTitleIsPrice: !deliveryTaxIsPercentage,
                                ),
                              if ((increment?.value ?? 0) > 0)
                                TitleAndSubTitle(
                                  title: 'Acréscimo'.hardcoded,
                                  subTitle: increment!.value
                                      .toString()
                                      .toBrazilianNumber(2, true),
                                  subTitleStyle: theme.textTheme.titleMedium
                                      ?.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                  subTitleIsPercentage: incrementIsPercentage,
                                  subTitleIsPrice: !incrementIsPercentage,
                                ),
                              TitleAndSubTitle(
                                title: 'Desconto'.hardcoded,
                                subTitle: requestDetails?.discounts.toString(),
                                subTitleIsPrice: true,
                              ),
                            ],
                          );
                        },
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
                if (onTap != null) const _CliclableIconIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CliclableIconIndicator extends StatelessWidget {
  const _CliclableIconIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Positioned(
      right: 0,
      bottom: 0,
      child: Icon(
        isIOS ? CupertinoIcons.arrow_up_right : Icons.arrow_outward_sharp,
      ),
    );
  }
}
