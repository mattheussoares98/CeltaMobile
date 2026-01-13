import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
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
          now: DateTime.now(),
          plu: widget.plu,
          price: priceController.text.toDouble() ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(widget.enterpriseCode, widget.plu),
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
          body: SafeArea(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
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
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              _DefaultDivider(),
                              SalesTypeWidget(plu: widget.plu),
                              _DefaultDivider(),
                              PricesTypesWidget(plu: widget.plu),
                              _DefaultDivider(),
                              ReplicationTypesWidget(plu: widget.plu),
                              _DefaultDivider(),
                              StartAndEndDates(plu: widget.plu),
                              _DefaultDivider(),
                              InfoButton(
                                ProductItemWidget(
                                  product: product!,
                                  routine: BsRoutine.adjustSalePrice,
                                ),
                              ),
                              PracticedSuggestionAndMinimumPrices(
                                product: product,
                              ),
                              _DefaultDivider(),
                              PriceFieldAndConfirmButton(
                                priceController: priceController,
                                isLoading: confirmAdjustAsync.isLoading,
                                onPressed: () => onPressed(product),
                              ),
                              gapH32,
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
