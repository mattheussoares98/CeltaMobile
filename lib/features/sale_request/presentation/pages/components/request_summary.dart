import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../providers.dart';
import '../../controllers/controllers.dart';

class RequestSummary extends ConsumerWidget {
  final VoidCallback? onTap;
  final bool showCustomer;
  final bool showDetails;
  final int enterpriseCode;
  final int saleRequestId;
  const RequestSummary({
    super.key,
    this.onTap,
    this.showCustomer = true,
    this.showDetails = false,
    required this.enterpriseCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final theme = Theme.of(context);

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
                        const PlatformIcon(
                          cupertinoIcon: CupertinoIcons.doc_text,
                          materialIcon: Icons.receipt_long,
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

                    if (saleRequest.observations != null)
                      TitleAndSubTitle(
                        title: 'Observações'.hardcoded,
                        subTitle: saleRequest.observations,
                      ),
                    if (showDetails)
                      Consumer(
                        builder: (context, ref, child) {
                          final args = ref.watch(saleRequestArgsProvider);
                          final requestDetails = ref.watch(
                            saleRequestDetailsStateControllerProvider(
                              args,
                            ).select((s) => s.value),
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (requestDetails?.instructions?.isNotEmpty ??
                                  false)
                                TitleAndSubTitle(
                                  title: 'Instruções'.hardcoded,
                                  subTitle: requestDetails?.instructions,
                                ),
                              if ((requestDetails?.totalProductsBrut ?? 0) >
                                      0 &&
                                  requestDetails?.totalProductsBrut !=
                                      requestDetails?.totalLiquid)
                                TitleAndSubTitle(
                                  title: 'Total bruto'.hardcoded,
                                  subTitle: requestDetails?.totalProductsBrut,
                                  subTitleIsPrice: true,
                                ),
                              if ((requestDetails?.totalFreight ?? 0) > 0)
                                TitleAndSubTitle(
                                  title: 'Total delivery'.hardcoded,
                                  subTitle: requestDetails?.totalFreight,
                                  subTitleIsPrice: true,
                                ),
                              if ((requestDetails?.totalIncrement ?? 0) > 0)
                                TitleAndSubTitle(
                                  title: 'Total acréscimos'.hardcoded,
                                  subTitle: requestDetails?.totalIncrement,
                                  subTitleIsPrice: true,
                                ),
                              if ((requestDetails?.totalDiscount ?? 0) > 0)
                                TitleAndSubTitle(
                                  title: 'Total descontos'.hardcoded,
                                  subTitle: requestDetails?.totalDiscount,
                                  subTitleIsPrice: true,
                                ),
                            ],
                          );
                        },
                      ),
                    TitleAndSubTitle(
                      title: 'Total líquido'.hardcoded,
                      subTitle: saleRequest.TotalLiquid,
                      subTitleIsPrice: true,
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
    return const Positioned(
      right: 0,
      bottom: 0,
      child: PlatformIcon(
        cupertinoIcon: CupertinoIcons.arrow_up_right,
        materialIcon: Icons.arrow_outward_sharp,
      ),
    );
  }
}
