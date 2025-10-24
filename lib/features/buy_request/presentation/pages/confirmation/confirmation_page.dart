import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import '../enterprises/components/components.dart';
import '../identification/components/components.dart';
import '../pages.dart';
import '../products/components/components.dart';
import 'components/components.dart';

class ConfirmationPage extends ConsumerWidget {
  final ProductsPage productsPage;
  final TextEditingController observationsController;
  const ConfirmationPage({
    super.key,
    required this.productsPage,
    required this.observationsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    ref.listen(insertBuyRequestControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        showSnackBarMessage(context, 'Pedido salvo com sucesso'.hardcoded);
        observationsController.clear();
      });
      n.showAlertDialogOnError(context);
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ResponsiveScrollableWidget(
              isSliverPage: true,
              child: CustomScrollView(
                slivers: [
                  CleanAllDataButton(
                    observationsController: observationsController,
                  ),
                  if (pendingAsync.value?.lastSavedRequestNumber != null) ...[
                    LastSavedRequestsNumbers(),
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
                  BuyersDropdown(),
                  gapSliverH8,
                  RequestTypeDropdown(),
                  gapSliverH8,
                  if (pendingAsync.value?.selectedSupplier != null) ...[
                    SliverToBoxAdapter(
                      child: DefaultSmallTitle(title: 'Fornecedor'.hardcoded),
                    ),
                    SliverToBoxAdapter(
                      child: SupplierItem(
                        supplier: pendingAsync.value!.selectedSupplier!,
                        pending: pendingAsync.value,
                        enabled: false,
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
                    ProductsItems(
                      products:
                          pendingAsync.value?.products?.values
                              .map((e) => e.product)
                              .toList() ??
                          [],
                      productsPage: productsPage,
                    ),
                  ] else
                    UnselectedMessage(
                      title: 'Nenhum produto informado'.hardcoded,
                    ),
                ],
              ),
            ),
          ),
          Footer(observationsController: observationsController),
        ],
      ),
    );
  }
}
