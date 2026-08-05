import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components.dart';

class RequestSummaryWidget extends ConsumerWidget {
  final VoidCallback? onTap;
  final bool showCustomer;
  final bool showDetails;
  final SaleRequestArgs args;
  final bool showPrintAndPdfButtons;
  final BSFSaleRequestEntity? saleRequestDetails;
  const RequestSummaryWidget({
    super.key,
    this.onTap,
    this.showCustomer = true,
    this.showDetails = false,
    this.showPrintAndPdfButtons = false,
    this.saleRequestDetails,
    required this.args,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleRequest = ref.watch(
      saleRequestsStateControllerProvider(args.enterpriseCode).select(
        (s) => s.value?.collection.firstWhereOrNull(
          (sr) => sr.Id == args.saleRequestId,
        ),
      ),
    );

    if (saleRequest == null && saleRequestDetails == null) {
      return const SizedBox.shrink();
    }

    final saleRequestNumber =
        saleRequest?.SaleRequestNumber ?? saleRequestDetails?.personalizedCode;
    final requestTypePersonalizedCode =
        saleRequest?.RequestType?.PersonalizedCode ??
        saleRequestDetails?.requestType?.personalizedCode;
    final requestTypeName =
        saleRequest?.RequestType?.Name ?? saleRequestDetails?.requestType?.name;
    final sellerName =
        saleRequest?.Seller?.Name ?? saleRequestDetails?.seller?.name;
    final dateHourOfCreation =
        saleRequest?.DateHourOfCreation ?? saleRequestDetails?.dateOfEmission;
    final customerName =
        saleRequest?.customer?.Name ?? saleRequestDetails?.customer?.name;
    final observations =
        saleRequest?.observations ?? saleRequestDetails?.observations;
    final totalLiquid =
        saleRequest?.TotalLiquid ?? saleRequestDetails?.totalLiquid;

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
                          style: context.theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    TitleAndSubTitle(
                      title: 'Núm pedido'.hardcoded,
                      copyableSubtitle: true,
                      subTitle: saleRequestNumber,
                    ),
                    if (requestTypePersonalizedCode != null)
                      TitleAndSubTitle(
                        title: 'Modelo de pedido'.hardcoded,
                        copyableSubtitle: true,
                        subTitle:
                            '${requestTypePersonalizedCode.isEmpty ? '' : '($requestTypePersonalizedCode)'} $requestTypeName',
                      ),
                    if (sellerName != null)
                      TitleAndSubTitle(
                        title: 'Vendedor'.hardcoded,
                        copyableSubtitle: true,
                        subTitle: sellerName,
                      ),
                    if (dateHourOfCreation != null)
                      TitleAndSubTitle(
                        title: 'Data'.hardcoded,
                        subTitle: dateHourOfCreation.formatDate(
                          DateFormatType.ddMMyyyyHHmm,
                        ),
                      ),
                    if (showCustomer && (customerName?.isNotEmpty ?? false))
                      TitleAndSubTitle(
                        title: 'Cliente'.hardcoded,
                        subTitle: customerName,
                      ),
                    if (observations?.isNotEmpty ?? false)
                      TitleAndSubTitle(
                        title: 'Observações'.hardcoded,
                        subTitle: observations,
                      ),
                    if (showDetails)
                      Consumer(
                        builder: (context, ref, child) {
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
                      subTitle: totalLiquid,
                      subTitleIsPrice: true,
                    ),
                    if (showPrintAndPdfButtons) ...[
                      gapH8,
                      Row(
                        children: [
                          Expanded(child: PrintButton(args: args)),
                          gapW12,
                          Expanded(child: PdfButton(args: args)),
                        ],
                      ),
                    ],
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
