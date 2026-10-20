part of 'searched_buy_request_item.dart';

class _SearchedBuyRequestSummary extends ConsumerWidget {
  final int processCode;
  const _SearchedBuyRequestSummary({required this.processCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyRequestDetails = ref
        .watch(buyRequestDetailsStateControllerProvider(processCode))
        .value;
    if (buyRequestDetails == null) return const SizedBox();

    return Column(
      crossAxisAlignment: .start,
      children: [
        if ((buyRequestDetails.totalBruteFromProductsAndServices ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.grossProductsServicesTotal,
            subTitle: buyRequestDetails.totalBruteFromProductsAndServices,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalDiscount ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.totalDiscounts,
            subTitle: buyRequestDetails.totalDiscount,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalCompensation ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.offsets,
            subTitle: buyRequestDetails.totalCompensation,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalIncrement ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.surcharge,
            subTitle: buyRequestDetails.totalIncrement,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalDeliveryTax ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.deliveryFee,
            subTitle: buyRequestDetails.totalDeliveryTax,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsAndIssBase ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.icmsIssBase,
            subTitle: buyRequestDetails.icmsAndIssBase,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsAndIssValue ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.icmsIssAmount,
            subTitle: buyRequestDetails.icmsAndIssValue,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsSubstituteBase ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.icmsStBase,
            subTitle: buyRequestDetails.icmsSubstituteBase,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsSubstituteValueOnFiscalNote ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.invoiceIcmsStAmount,
            subTitle: buyRequestDetails.icmsSubstituteValueOnFiscalNote,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsSubstituteValueOnGnre ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.gnreIcmsStAmount,
            subTitle: buyRequestDetails.icmsSubstituteValueOnGnre,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.fcpSubstituteValue ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.fcpStAmount,
            subTitle: buyRequestDetails.fcpSubstituteValue,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalLiquidOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.freight,
            subTitle: buyRequestDetails.totalLiquidOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalSecurityOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.freightInsurance,
            subTitle: buyRequestDetails.totalSecurityOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalExpenseAccessory ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.additionalExpenses,
            subTitle: buyRequestDetails.totalExpenseAccessory,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.ipiValue ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.ipi,
            subTitle: buyRequestDetails.ipiValue,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsValueAtDestiny ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.destinationIcms,
            subTitle: buyRequestDetails.icmsValueAtDestiny,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsValueAtOrigin ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.originIcms,
            subTitle: buyRequestDetails.icmsValueAtOrigin,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalFundToCombatPovertyStateDestinyValue ?? 0) >
            0)
          TitleAndSubTitle(
            title: context.l10n.povertyReductionFund,
            subTitle:
                buyRequestDetails.totalFundToCombatPovertyStateDestinyValue,
            subTitleIsPrice: true,
          ),
      ],
    );
  }
}
