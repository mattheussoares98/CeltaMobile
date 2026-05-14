import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class InsertUpdatePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
      child: const _InsertUpdateContent(),
    );
  }
}

class _InsertUpdateContent extends ConsumerWidget {
  const _InsertUpdateContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    ref.listen(saveSaleRequestControllerProvider(args.enterpriseCode), (p, n) {
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Pedido salvo com sucesso!'.hardcoded,
      );
      n.doOnSuccess(p, () {
        context.pop();
      });
    });
    ref.observeLoading([
      saveSaleRequestControllerProvider(args.enterpriseCode),
    ]);

    return Consumer(
      child: Scaffold(
        appBar: AppBar(
          title: DefaultAppBarTitle(
            title: args.saleRequestId == 0
                ? 'Inserir pedido'.hardcoded
                : 'Atualizar pedido'.hardcoded,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
          actions: [
            Consumer(
              builder: (_, ref, _) {
                return QuantityBadge(
                  quantity: ref.watch(
                    insertUpdateStateControllerProvider.select(
                      (s) => s.value?.products?.length,
                    ),
                  ),
                  totalPrice: ref.watch(
                    insertUpdateStateControllerProvider.select(
                      (s) => s.value?.totalProductsLiquid,
                    ),
                  ),
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
      ),
      builder: (context, ref, child) {
        final hasChanges =
            args.saleRequestId != 0 &&
            ref.watch(
                  saleRequestDetailsStateControllerProvider(
                    args,
                  ).select((s) => s.value),
                ) !=
                ref.watch(
                  insertUpdateStateControllerProvider.select((s) => s.value),
                );

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
