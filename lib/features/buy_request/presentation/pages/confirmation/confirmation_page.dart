import 'package:celta_intelligence/localization/string_hardcoded.dart';
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
  const ConfirmationPage({super.key, required this.productsPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Confirmação'.hardcoded)),
      body: ResponsiveScrollableWidget(
        isSliverPage: true,
        child: CustomScrollView(
          slivers: [
            if (pendingAsync.value?.lastSavedRequestNumber != null) ...[
              TitleAndSubTitle(
                title: 'Último pedido salvo'.hardcoded,
                subTitle: pendingAsync.value!.lastSavedRequestNumber,
              ),
              gapSliverH8,
            ],
            BuyersDropdown(enabled: false),
            gapSliverH8,
            RequestTypeDropdown(enabled: false),
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
            if ((pendingAsync.value?.selectedEnterprises?.length ?? 0) > 0) ...[
              SliverToBoxAdapter(
                child: DefaultSmallTitle(title: 'Empresas'.hardcoded),
              ),
              SliverList.builder(
                itemCount: pendingAsync.value?.selectedEnterprises?.length ?? 0,
                itemBuilder: (_, index) {
                  final enterprise =
                      pendingAsync.value?.selectedEnterprises?[index];

                  return EnterpriseItem(
                    enterprise: enterprise!,
                    enabled: false,
                  );
                },
              ),
            ] else
              UnselectedMessage(title: 'Nenhuma empresa selecionada'.hardcoded),
            if (pendingAsync.value?.products != null &&
                pendingAsync.value!.products!.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: DefaultSmallTitle(title: 'Produtos'.hardcoded),
              ),
              ProductsItems(
                products:
                    pendingAsync.value?.products?.values
                        .map((e) => e.product)
                        .toList() ??
                    [],
                productsPage: productsPage,
              ),
            ] else
              UnselectedMessage(title: 'Nenhum produto informado'.hardcoded),
          ],
        ),
      ),
    );
  }
}
