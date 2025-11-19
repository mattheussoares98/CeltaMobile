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
  int currentIndex = 0;
  int? selectedProductIndex;

  final appBarTitles = [
    'Inserir produtos'.hardcoded,
    'Cliente'.hardcoded,
    'Carrinho'.hardcoded,
  ];

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
            title: FittedBox(child: Text(appBarTitles[currentIndex])),
            actionsPadding: const EdgeInsets.fromLTRB(
              0,
              Sizes.p8,
              Sizes.p12,
              Sizes.p8,
            ),
            actions: [
              const ShowPdfButton(),
              const PrintButton(),
              QuantityBadge(
                quantity: products?.length ?? 0,
                materialIcon: Icons.shopping_cart,
                cupertinoIcon: CupertinoIcons.shopping_cart,
                isSelected: false,
                offset: const Offset(3, -3),
                subtitle: Text(
                  (products?.fold<double>(0.0, (p, e) {
                            return p + e.TotalLiquid;
                          }).toString() ??
                          '0')
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                  style: const TextStyle(fontSize: 9),
                ),
              ),
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

              return IndexedStack(
                index: currentIndex,
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
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) => setState(() => currentIndex = index),
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                label: 'Inserir produtos'.hardcoded,
                icon: Icon(
                  isIOS ? CupertinoIcons.cart_fill : Icons.add_shopping_cart,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Cliente'.hardcoded,
                icon: ValidatedBadge(
                  isSelected: currentIndex == 1,
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
                  isSelected: currentIndex == 2,
                ),
              ),
            ],
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
