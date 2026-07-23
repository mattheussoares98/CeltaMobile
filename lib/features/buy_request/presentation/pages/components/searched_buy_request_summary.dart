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
            title: 'Total bruto produtos/serviços'.hardcoded,
            subTitle: buyRequestDetails.totalBruteFromProductsAndServices,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalDiscount ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Total de descontos'.hardcoded,
            subTitle: buyRequestDetails.totalDiscount,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalCompensation ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Compensações'.hardcoded,
            subTitle: buyRequestDetails.totalCompensation,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalIncrement ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Acréscimo'.hardcoded,
            subTitle: buyRequestDetails.totalIncrement,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalDeliveryTax ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Taxa de entrega'.hardcoded,
            subTitle: buyRequestDetails.totalDeliveryTax,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsAndIssBase ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Base de ICMS e ISS'.hardcoded,
            subTitle: buyRequestDetails.icmsAndIssBase,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsAndIssValue ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor de ICMS e ISS'.hardcoded,
            subTitle: buyRequestDetails.icmsAndIssValue,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsSubstituteBase ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Base ICMS substituto'.hardcoded,
            subTitle: buyRequestDetails.icmsSubstituteBase,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsSubstituteValueOnFiscalNote ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor ICMS substituto nota fiscal'.hardcoded,
            subTitle: buyRequestDetails.icmsSubstituteValueOnFiscalNote,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsSubstituteValueOnGnre ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor ICMS substituto GNRE'.hardcoded,
            subTitle: buyRequestDetails.icmsSubstituteValueOnGnre,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.fcpSubstituteValue ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Valor FCP substituto'.hardcoded,
            subTitle: buyRequestDetails.fcpSubstituteValue,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalLiquidOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Frete'.hardcoded,
            subTitle: buyRequestDetails.totalLiquidOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalSecurityOfFreight ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Seguro frete'.hardcoded,
            subTitle: buyRequestDetails.totalSecurityOfFreight,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalExpenseAccessory ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Despesas acessórias'.hardcoded,
            subTitle: buyRequestDetails.totalExpenseAccessory,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.ipiValue ?? 0) > 0)
          TitleAndSubTitle(
            title: 'IPI'.hardcoded,
            subTitle: buyRequestDetails.ipiValue,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsValueAtDestiny ?? 0) > 0)
          TitleAndSubTitle(
            title: 'ICMS destino'.hardcoded,
            subTitle: buyRequestDetails.icmsValueAtDestiny,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.icmsValueAtOrigin ?? 0) > 0)
          TitleAndSubTitle(
            title: 'ICMS origem'.hardcoded,
            subTitle: buyRequestDetails.icmsValueAtOrigin,
            subTitleIsPrice: true,
          ),
        if ((buyRequestDetails.totalFundToCombatPovertyStateDestinyValue ?? 0) >
            0)
          TitleAndSubTitle(
            title: 'Fundo de combate à pobreza'.hardcoded,
            subTitle:
                buyRequestDetails.totalFundToCombatPovertyStateDestinyValue,
            subTitleIsPrice: true,
          ),
      ],
    );
  }
}
