import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class AdjustSalePricePage extends ConsumerStatefulWidget {
  final String plu;
  final int enterpriseCode;
  final ProductEntity? product;
  final EnterpriseEntity? enterprise;
  const AdjustSalePricePage({
    super.key,
    required this.plu,
    required this.enterpriseCode,
    required this.product,
    required this.enterprise,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends ConsumerState<AdjustSalePricePage> {
  SaleType? selectedSaleType = SaleType.retail;
  PriceType? selectedPriceType = PriceType.sale;
  bool? isSelectedClass = false;
  bool? isSelectedGrid = false;
  bool? isSelectedOperationalGrouping = false;
  bool? isSelectedPackings = false;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  final Set<ReplicationTypes> _selectedReplications = {
    ReplicationTypes.packings,
  };
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    priceController.dispose();
  }

  Future<void> onPressed(ProductEntity product) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(confirmAdjustControllerProvider.notifier)
        .confirm(
          enterpriseCode: widget.enterpriseCode,
          productCode: product.ProductCode,
          productPackingCode: product.ProductPackingCode,
          saleType: selectedSaleType!,
          replications: _selectedReplications.toList(),
          offerParams: selectedPriceType == PriceType.offer
              ? OfferParams(
                  price: priceController.text.toDouble() ?? 0,
                  effectuationDateOffer: selectedStartDate,
                  endDateOffer: selectedEndDate,
                )
              : null,
          retailParams: RetailParams(
            price: priceController.text.toDouble() ?? 0,
            effectuationDatePrice: selectedStartDate,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(
        widget.enterpriseCode,
        widget.plu,
        widget.product,
      ),
    );
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    final confirmAdjustAsync = ref.watch(confirmAdjustControllerProvider);

    ref.listen(confirmAdjustControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        showSnackBarMessage(context, 'Preço alterado com sucesso'.hardcoded);
        context.pop();
      });
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leadingWidth: 40,
            title: FittedBox(
              child: Text(
                selectedProductAsync.value == null
                    ? ""
                    : "(${selectedProductAsync.value!.PLU}) ${selectedProductAsync.value!.Name}",
              ),
            ),
          ),
          body: AsyncValueWidget(
            value: selectedProductAsync,
            tryAgain: () {
              ref.invalidate(
                selectedProductStateControllerProvider(
                  widget.enterpriseCode,
                  widget.plu,
                  widget.product,
                ),
              );
            },
            data: (product) {
              final availableReplications = <ReplicationTypes>{
                ReplicationTypes.packings,
                if (product?.IsFatherOfGrate == true ||
                    product?.IsChildOfGrate == true)
                  ReplicationTypes.grid,
                if (product?.InClass == true) ReplicationTypes.classess,
                if (selectedEnterprise?.EnterpriseParticipateEnterpriseGroup ==
                    true)
                  ReplicationTypes.operationalGrouping,
              };

              return ResponsiveScrollableWidget(
                padding: Sizes.p4,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text("Schedules"),
                      _DefaultDivider(),
                      SalesTypeWidget(
                        selectedSaleType: selectedSaleType,
                        selectedEnterprise: selectedEnterprise,
                        onTap: (value) {
                          setState(() {
                            selectedSaleType = value;
                          });
                        },
                      ),
                      _DefaultDivider(),
                      PricesTypesWidget(
                        selectedPriceType: selectedPriceType,
                        onTap: (value) {
                          setState(() {
                            selectedPriceType = value;
                          });
                        },
                      ),
                      _DefaultDivider(),
                      ReplicationTypesWidget(
                        availableReplications: availableReplications.toList(),
                        selectedReplications: _selectedReplications,
                        onChanged: (replicationType) {
                          setState(() {
                            if (_selectedReplications.contains(
                              replicationType,
                            )) {
                              _selectedReplications.remove(replicationType);
                            } else {
                              _selectedReplications.add(replicationType);
                            }
                          });
                        },
                      ),
                      _DefaultDivider(),
                      StartAndEndDates(
                        selectedStartDate: selectedStartDate,
                        selectedEndDate: selectedEndDate,
                        enableEndDate: selectedPriceType == PriceType.offer,
                        onChangeStartDate: (newDate) {
                          setState(() {
                            selectedStartDate = newDate;
                          });
                        },
                        onChangeEndDate: (newDate) {
                          setState(() {
                            selectedEndDate = newDate;
                          });
                        },
                      ),
                      _DefaultDivider(),
                      PricesCostsAndMarginsButton(product: product!),
                      PracticedSuggestionAndMinimumPrices(
                        product: product,
                        selectedSaleType: selectedSaleType,
                        selectedPriceType: selectedPriceType!,
                      ),
                      _DefaultDivider(),
                      PriceFieldAndConfirmButton(
                        priceController: priceController,
                        isLoading: confirmAdjustAsync.isLoading,
                        onPressed: () => onPressed(product),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (confirmAdjustAsync.isLoading) LoadingPage(),
      ],
    );
  }
}

class _DefaultDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: Sizes.p8);
  }
}
