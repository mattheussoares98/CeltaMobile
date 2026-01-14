import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';
import 'sale_request.dart';

class SaleRequestPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int requestCode;
  const SaleRequestPage({
    super.key,
    required this.enterpriseCode,
    required this.requestCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SaleRequestPageState();
}

class _SaleRequestPageState extends ConsumerState<SaleRequestPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final products = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (s) => s.value?.cart.values,
      ),
    );

    ref.listen(pendingSaleRequestStateControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });
    ref.listen(saveSaleRequestControllerProvider, (p, n) {
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'O pedido foi salvo com sucesso'.hardcoded,
      );
    });

    ref.listen(printLastSavedSaleRequestControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: AppBarTitle(enterpriseCode: widget.enterpriseCode),
            actionsPadding: const EdgeInsets.fromLTRB(
              0,
              Sizes.p8,
              Sizes.p12,
              Sizes.p8,
            ),
            actions: [
              ShowPdfButton(enterpriseCode: widget.enterpriseCode),
              PrintButton(enterpriseCode: widget.enterpriseCode),
              const CartBadge(),
            ],
          ),
          body: AsyncValueWidget(
            value: ref.watch(
              requestTypeStateControllerProvider(Modules.saleRequest),
            ),
            tryAgain: () {
              ref.invalidate(
                requestTypeStateControllerProvider(Modules.saleRequest),
              );
            },
            data: (requests) {
              final selectedRequest = requests!.firstWhere(
                (e) => e.Code == widget.requestCode,
              );

              return Consumer(
                builder: (_, ref, _) {
                  return IndexedStack(
                    index: ref.watch(pageIndexStateControllerProvider),
                    children: [
                      InsertProductsPage(
                        enterpriseCode: widget.enterpriseCode,
                        selectedRequest: selectedRequest,
                      ),
                      const CustomerPage(),
                      CartPage(selectedRequest: selectedRequest),
                    ],
                  );
                },
              );
            },
          ),
          bottomNavigationBar: Consumer(
            builder: (_, ref, _) {
              final index = ref.watch(pageIndexStateControllerProvider);

              return BottomNavigationBar(
                onTap: ref
                    .read(pageIndexStateControllerProvider.notifier)
                    .updateIndex,
                currentIndex: index,
                items: [
                  BottomNavigationBarItem(
                    label: 'Inserir produtos'.hardcoded,
                    icon: Icon(
                      isIOS
                          ? CupertinoIcons.cart_fill
                          : Icons.add_shopping_cart,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Cliente'.hardcoded,
                    icon: ValidatedBadge(
                      isSelected: index == 1,
                      isValid:
                          ref.watch(
                            pendingSaleRequestStateControllerProvider.select(
                              (state) => state.value?.customer,
                            ),
                          ) !=
                          null,
                      materialIcon: Icons.person,
                      cupertinoIcon: CupertinoIcons.person,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Carrinho'.hardcoded,
                    icon: QuantityBadge(
                      quantity: products?.length ?? 0,
                      materialIcon: Icons.shopping_cart,
                      cupertinoIcon: CupertinoIcons.shopping_cart,
                      isSelected: index == 2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        LoadingPage(
          providers: [
            processCartControllerProvider,
            saveSaleRequestControllerProvider,
          ],
        ),
      ],
    );
  }
}
