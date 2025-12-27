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
  const AdjustSalePricePage({
    super.key,
    required this.plu,
    required this.enterpriseCode,
    required this.product,
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
  final Set<ReplicationTypes> _selectedReplications = {};
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<ReplicationTypes> _availableReplications = [];

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final product =
            widget.product ??
            await ref.read(
              selectedProductStateControllerProvider(
                widget.enterpriseCode,
                widget.plu,
              ).future,
            );
        final selectedEnterprise = ref.read(
          selectedEnterpriseStateControllerProvider,
        );

        setState(() {
          updateReplicationsSelectesByDefault(product, selectedEnterprise);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    priceController.dispose();
  }

  Future<void> onPressed(ProductEntity product) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    bool? confirmed = await showAlertDialog(
      context: context,
      title: 'Confirmar?'.hardcoded,
      cancelActionText: 'Cencelar'.hardcoded,
      defaultActionText: 'Sim'.hardcoded,
    );

    if (confirmed != true) {
      return;
    }

    await ref
        .read(confirmAdjustControllerProvider.notifier)
        .confirm(
          enterpriseCode: widget.enterpriseCode,
          productCode: product.ProductCode!,
          productPackingCode: product.ProductPackingCode!,
          saleType: selectedSaleType!,
          replications: _selectedReplications.toList(),
          now: DateTime.now(),
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

  List<ReplicationTypes> getAvailableReplications(
    ProductEntity? product,
    EnterpriseEntity? selectedEnterprise,
  ) {
    return <ReplicationTypes>{
      ReplicationTypes.packings,
      if (product?.IsFatherOfGrate == true || product?.IsChildOfGrate == true)
        ReplicationTypes.grid,
      if (product?.InClass == true) ReplicationTypes.classess,
      if (selectedEnterprise?.EnterpriseParticipateEnterpriseGroup == true)
        ReplicationTypes.operationalGrouping,
    }.toList();
  }

  void updateReplicationsSelectesByDefault(
    ProductEntity? product,
    EnterpriseEntity? selectedEnterprise,
  ) {
    _availableReplications = getAvailableReplications(
      product,
      selectedEnterprise,
    );

    if (product?.AlterationPriceForAllPackings == true) {
      _selectedReplications.add(ReplicationTypes.packings);
    }
    if (product?.MarkUpdateClassInAdjustSalePriceIndividual == true) {
      _selectedReplications.add(ReplicationTypes.classess);
    }
    if (_availableReplications.contains(ReplicationTypes.operationalGrouping)) {
      _selectedReplications.add(ReplicationTypes.operationalGrouping);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(widget.enterpriseCode, widget.plu),
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

    final product = widget.product ?? selectedProductAsync.value;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leadingWidth: 40,
            title: FittedBox(
              child: Text(
                product == null ? "" : "(${product.PLU}) ${product.Name}",
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              if (product != null)
                PriceSchedules(
                  enterpriseCode: widget.enterpriseCode,
                  product: product,
                ),
              AsyncValueSliverWidget(
                value: selectedProductAsync,
                tryAgain: () {
                  ref.invalidate(
                    selectedProductStateControllerProvider(
                      widget.enterpriseCode,
                      widget.plu,
                    ),
                  );
                },
                data: (product) {
                  return SliverToBoxAdapter(
                    child: ResponsiveScrollableWidget(
                      padding: Sizes.p4,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
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
                              availableReplications: _availableReplications,
                              selectedReplications: _selectedReplications,
                              onChanged: (replicationType) {
                                setState(() {
                                  if (_selectedReplications.contains(
                                    replicationType,
                                  )) {
                                    _selectedReplications.remove(
                                      replicationType,
                                    );
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
                              enableEndDate:
                                  selectedPriceType == PriceType.offer,
                              onChangeStartDate: (newDate) {
                                if (selectedEndDate != null &&
                                    newDate.isAfter(selectedEndDate!)) {
                                  showSnackBarMessage(
                                    context,
                                    'A data de início deve ser antes da data de término',
                                    backgroundColor: Colors.red,
                                  );
                                } else {
                                  setState(() {
                                    selectedStartDate = newDate;
                                  });
                                }
                              },
                              onChangeEndDate: (newDate) {
                                if (newDate == null) {
                                  setState(() {
                                    selectedEndDate = null;
                                  });
                                } else if (selectedStartDate != null &&
                                    newDate.isBefore(selectedStartDate!) ==
                                        true) {
                                  showSnackBarMessage(
                                    context,
                                    'A data de término deve ser depois da data de início',
                                    backgroundColor: Colors.red,
                                  );
                                } else {
                                  setState(() {
                                    selectedEndDate = newDate;
                                  });
                                }
                              },
                            ),
                            _DefaultDivider(),
                            InfoButton(
                              ProductItemWidget(
                                product: product!,
                                routine: BsRoutine.adjustSalePrice,
                              ),
                            ),
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
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        LoadingPage(providers: [confirmAdjustControllerProvider]),
      ],
    );
  }
}

class _DefaultDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: Sizes.p8);
  }
}
