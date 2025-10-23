import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';
import '../../controllers/controllers.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final TextEditingController searchProductController;
  const ProductsPage({super.key, required this.searchProductController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    ref.listen(
      searchProductsStateControllerProvider(
        selectedEnterprise?.Code ?? 0,
        BsRoutine.buyRequest,
        Modules.buyRequest,
      ),
      (previous, next) {
        next.doOnSuccess(previous, () {
          widget.searchProductController.clear();
        });
      },
    );

    final productsState = ref.watch(
      searchProductsStateControllerProvider(
        selectedEnterprise?.Code ?? 0,
        BsRoutine.buyRequest,
        Modules.buyRequest,
      ),
    );

    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    Future<void> searchProducts() async {
      await ref
          .read(
            searchProductsStateControllerProvider(
              selectedEnterprise?.Code ?? 0,
              BsRoutine.buyRequest,
              Modules.buyRequest,
            ).notifier,
          )
          .loadProducts(
            enterpriseCodes:
                pendingAsync.value?.selectedEnterprises
                    ?.map((e) => e.Code!)
                    .toList() ??
                [],
            searchValue: widget.searchProductController.text,
          );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Produtos'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DefaultSearchProducts(
                isLoading: productsState.isLoading,
                searchProducts: searchProducts,
                searchValueController: widget.searchProductController,
              ),
            ),
            gapSliverH8,
            AsyncValueSliverWidget(
              value: productsState,
              tryAgain: null,
              data: (products) {
                return SliverList.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];

                    final correspondentEnterprise = pendingAsync
                        .value
                        ?.selectedEnterprises
                        ?.firstWhere((e) => e.Code == product.EnterpriseCode);

                    return Column(
                      children: [
                        ProductItemWidget(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          enterpriseCode: selectedEnterprise?.Code ?? 0,
                          product: product,
                          routine: BsRoutine.buyRequest,
                          showDropIcon: true,
                          isSelected: selectedIndex == index,
                          itemBeforeProductName: TitleAndSubTitle(
                            title: null,
                            subTitle:
                                '(${correspondentEnterprise?.PersonalizedCode}) - ${correspondentEnterprise?.name}',
                            subTitleStyle: theme.textTheme.titleMedium
                                ?.copyWith(color: theme.primaryColor),
                          ),
                          notClickableBottom: Row(
                            children: [
                              Expanded(child: DefaultTextFormField()),
                              gapW8,
                              Expanded(child: DefaultTextFormField()),
                              gapW8,
                              Expanded(
                                child: PrimaryButton(
                                  text: 'Confirmar'.hardcoded,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
