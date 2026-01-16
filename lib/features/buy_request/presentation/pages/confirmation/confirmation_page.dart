import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import '../enterprises/components/components.dart';
import '../identification/components/components.dart';
import 'components/components.dart';

class ConfirmationPage extends ConsumerStatefulWidget {
  const ConfirmationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmationPageState();
}

class _ConfirmationPageState extends ConsumerState<ConfirmationPage> {
  final observationsController = TextEditingController();

  @override
  void dispose() {
    observationsController.dispose();
    super.dispose();
  }

  void onDelete(ProductEntity product, PendingBuyRequestEntity? pending) {
    final products = pending?.products;
    products?.removeWhere((key, value) {
      return key ==
          ProductKey(
            enterpriseCode: product.EnterpriseCode!,
            productPackingCode: product.ProductPackingCode!,
          );
    });

    ref
        .read(pendingBuyRequestStateControllerProvider.notifier)
        .updatePending(products: products);
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    ref.listen(insertBuyRequestControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  CleanAllDataButton(
                    observationsController: observationsController,
                  ),
                  if (pendingAsync.value?.lastSavedRequestNumber != null) ...[
                    const LastSavedRequestsNumbers(),
                    gapSliverH8,
                  ],
                  SliverToBoxAdapter(
                    child: DefaultTextFormField(
                      controller: observationsController,
                      hintText: 'Observações'.hardcoded,
                      labelText: 'Observações'.hardcoded,
                      maxLines: 4,
                    ),
                  ),
                  gapSliverH8,
                  const BuyersDropdown(enabled: false),
                  gapSliverH8,
                  const RequestTypeDropdown(enabled: false),
                  gapSliverH8,
                  if (pendingAsync.value?.selectedSupplier != null) ...[
                    SliverToBoxAdapter(
                      child: DefaultSmallTitle(title: 'Fornecedor'.hardcoded),
                    ),
                    SliverToBoxAdapter(
                      child: SupplierItem(
                        supplier: pendingAsync.value!.selectedSupplier!,
                        enabled: false,
                        onTap: () {},
                      ),
                    ),
                    gapSliverH8,
                  ] else
                    UnselectedMessage(
                      title: 'Nenhum fornecedor selecionado'.hardcoded,
                    ),
                  if ((pendingAsync.value?.selectedEnterprises?.length ?? 0) >
                      0) ...[
                    SliverToBoxAdapter(
                      child: DefaultSmallTitle(
                        title:
                            'Empresas (${pendingAsync.value!.selectedEnterprises!.length})'
                                .hardcoded,
                      ),
                    ),
                    SliverList.builder(
                      itemCount:
                          pendingAsync.value?.selectedEnterprises?.length ?? 0,
                      itemBuilder: (_, index) {
                        final enterprise =
                            pendingAsync.value?.selectedEnterprises?[index];

                        return EnterpriseItem(
                          enterprise: enterprise!,
                          enabled: false,
                        );
                      },
                    ),
                    gapSliverH8,
                  ] else
                    UnselectedMessage(
                      title: 'Nenhuma empresa selecionada'.hardcoded,
                    ),
                  if (pendingAsync.value?.products != null &&
                      pendingAsync.value!.products!.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: DefaultSmallTitle(
                        title:
                            'Produtos (${pendingAsync.value!.products!.length})'
                                .hardcoded,
                      ),
                    ),
                    gapSliverH8,
                    const ProductsItems(),
                  ] else
                    UnselectedMessage(
                      title: 'Nenhum produto informado'.hardcoded,
                    ),
                ],
              ),
            ),
            Footer(observationsController: observationsController),
          ],
        ),
      ),
    );
  }
}
