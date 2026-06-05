import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InsertUpdatePage extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const InsertUpdatePage({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        saleRequestArgsProvider.overrideWithValue(
          SaleRequestArgs(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ),
        ),
      ],
      child: _InsertUpdateContent(
        enterpriseCode: enterpriseCode,
        customerCode: customerCode,
        saleRequestId: saleRequestId,
      ),
    );
  }
}

class _InsertUpdateContent extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const _InsertUpdateContent({
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(insertUpdateProcessCartControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });
    ref.listen(processCartControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    ref.listen(saveSaleRequestControllerProvider(enterpriseCode), (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, context.pop);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Pedido salvo com sucesso!'.hardcoded,
      );
    });
    ref.observeLoading([
      saveSaleRequestControllerProvider(enterpriseCode),
      insertUpdateProcessCartControllerProvider,
    ]);

    return Consumer(
      child: Scaffold(
        appBar: AppBar(
          title: DefaultAppBarTitle(
            title: saleRequestId == 0
                ? 'Inserir pedido'.hardcoded
                : 'Atualizar pedido'.hardcoded,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
          actions: [
            Consumer(
              builder: (_, ref, _) {
                final (int quantity, double totalPrice) = ref.watch(
                  insertUpdateStateControllerProvider.select(
                    (s) => (
                      s.value?.products?.length ?? 0,
                      s.value?.totalProductsLiquid ?? 0,
                    ),
                  ),
                );
                return QuantityBadge(
                  quantity: quantity,
                  totalPrice: totalPrice,
                  platformIcon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.cart,
                    materialIcon: Icons.shopping_cart,
                  ),
                  isSelected: false,
                );
              },
            ),
          ],
        ),
        body: const InsertUpdateBody(),
        bottomNavigationBar: const InsertUpdateBottomNavigationBar(),
        floatingActionButton: CreateCustomerFloatingButton(
          enterpriseCode: enterpriseCode,
        ),
      ),
      builder: (context, ref, child) {
        final hasChanges = ref.watch(saleRequestHasChangesProvider);

        return PopScope(
          canPop: !hasChanges,
          child: child!,
          onPopInvokedWithResult: (didPop, _) async {
            void dispose() {
              ref
                  .read(insertUpdateStateControllerProvider.notifier)
                  .disposeFlow();
            }

            if (didPop) {
              dispose();
              return;
            }

            final shouldPop = await showAlertDialog(
              context: context,
              title: 'Alterações não salvas'.hardcoded,
              content:
                  'Existem alterações que não foram salvas. Deseja realmente sair?'
                      .hardcoded,
              cancelActionText: 'Não'.hardcoded,
              defaultActionText: 'Sim'.hardcoded,
            );

            if (shouldPop == true && context.mounted) {
              dispose();
              context.pop();
            }
          },
        );
      },
    );
  }
}
