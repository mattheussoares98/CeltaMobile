part of 'searched_buy_movement_item.dart';

class _SearchedBuyMovementSummary extends ConsumerWidget {
  final int processCode;
  const _SearchedBuyMovementSummary({required this.processCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyMovementDetails = ref
        .watch(buyMovementDetailsStateControllerProvider(processCode))
        .value;
    if (buyMovementDetails == null) return const SizedBox();

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (buyMovementDetails.totalBruteFromProductsAndServices !=
                buyMovementDetails.totalLiquid &&
            (buyMovementDetails.totalBruteFromProductsAndServices ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.grossProductsServicesTotal,
            subTitle: buyMovementDetails.totalBruteFromProductsAndServices,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalDiscount ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.totalDiscounts,
            subTitle: buyMovementDetails.totalDiscount,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalCompensation ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.offsets,
            subTitle: buyMovementDetails.totalCompensation,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalIncrement ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.surcharge,
            subTitle: buyMovementDetails.totalIncrement,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalDeliveryTax ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.deliveryFee,
            subTitle: buyMovementDetails.totalDeliveryTax,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsAndIssBase ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.icmsIssBase,
            subTitle: buyMovementDetails.icmsAndIssBase,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsAndIssValue ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.icmsIssAmount,
            subTitle: buyMovementDetails.icmsAndIssValue,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsSubstituteBase ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.icmsStBase,
            subTitle: buyMovementDetails.icmsSubstituteBase,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsSubstituteValueOnFiscalNote ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.invoiceIcmsStAmount,
            subTitle: buyMovementDetails.icmsSubstituteValueOnFiscalNote,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsSubstituteValueOnGnre ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.gnreIcmsStAmount,
            subTitle: buyMovementDetails.icmsSubstituteValueOnGnre,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.fcpSubstituteValue ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.fcpStAmount,
            subTitle: buyMovementDetails.fcpSubstituteValue,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalLiquidOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.freight,
            subTitle: buyMovementDetails.totalLiquidOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalSecurityOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.freightInsurance,
            subTitle: buyMovementDetails.totalSecurityOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalExpenseAccessory ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.additionalExpenses,
            subTitle: buyMovementDetails.totalExpenseAccessory,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.ipiValue ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.ipi,
            subTitle: buyMovementDetails.ipiValue,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsValueAtDestiny ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.destinationIcms,
            subTitle: buyMovementDetails.icmsValueAtDestiny,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsValueAtOrigin ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.originIcms,
            subTitle: buyMovementDetails.icmsValueAtOrigin,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalFundToCombatPovertyStateDestinyValue ??
                0) >
            0)
          TitleAndSubTitle(
            title: context.l10n.povertyReductionFund,
            subTitle:
                buyMovementDetails.totalFundToCombatPovertyStateDestinyValue,
            subTitleIsPrice: true,
          ),
      ],
    );
  }
}
