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
        if ((buyMovementDetails.totalBruteFromProductsAndServices ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Total bruto produtos/serviços'.hardcoded,
            subTitle: buyMovementDetails.totalBruteFromProductsAndServices,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalDiscount ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Total de descontos'.hardcoded,
            subTitle: buyMovementDetails.totalDiscount,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalCompensation ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Compensações'.hardcoded,
            subTitle: buyMovementDetails.totalCompensation,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalIncrement ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Acréscimo'.hardcoded,
            subTitle: buyMovementDetails.totalIncrement,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalDeliveryTax ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Taxa de entrega'.hardcoded,
            subTitle: buyMovementDetails.totalDeliveryTax,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsAndIssBase ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Base de ICMS e ISS'.hardcoded,
            subTitle: buyMovementDetails.icmsAndIssBase,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsAndIssValue ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor de ICMS e ISS'.hardcoded,
            subTitle: buyMovementDetails.icmsAndIssValue,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsSubstituteBase ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Base ICMS substituto'.hardcoded,
            subTitle: buyMovementDetails.icmsSubstituteBase,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsSubstituteValueOnFiscalNote ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor ICMS substituto nota fiscal'.hardcoded,
            subTitle: buyMovementDetails.icmsSubstituteValueOnFiscalNote,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsSubstituteValueOnGnre ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor ICMS substituto GNRE'.hardcoded,
            subTitle: buyMovementDetails.icmsSubstituteValueOnGnre,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.fcpSubstituteValue ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor FCP substituto'.hardcoded,
            subTitle: buyMovementDetails.fcpSubstituteValue,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalLiquidOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Frete'.hardcoded,
            subTitle: buyMovementDetails.totalLiquidOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalSecurityOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Seguro frete'.hardcoded,
            subTitle: buyMovementDetails.totalSecurityOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalExpenseAccessory ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Despesas acessórias'.hardcoded,
            subTitle: buyMovementDetails.totalExpenseAccessory,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.ipiValue ?? 0) > 0)
          TitleAndSubTitle(
            title: 'IPI'.hardcoded,
            subTitle: buyMovementDetails.ipiValue,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsValueAtDestiny ?? 0) > 0)
          TitleAndSubTitle(
            title: 'ICMS destino'.hardcoded,
            subTitle: buyMovementDetails.icmsValueAtDestiny,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.icmsValueAtOrigin ?? 0) > 0)
          TitleAndSubTitle(
            title: 'ICMS origem'.hardcoded,
            subTitle: buyMovementDetails.icmsValueAtOrigin,
            subTitleIsPrice: true,
          ),
        if ((buyMovementDetails.totalFundToCombatPovertyStateDestinyValue ??
                0) >
            0)
          TitleAndSubTitle(
            title: 'Fundo de combate à pobreza'.hardcoded,
            subTitle:
                buyMovementDetails.totalFundToCombatPovertyStateDestinyValue,
            subTitleIsPrice: true,
          ),
      ],
    );
  }
}
