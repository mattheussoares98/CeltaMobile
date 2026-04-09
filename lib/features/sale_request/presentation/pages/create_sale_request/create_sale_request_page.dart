import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../../routing/routing.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import 'components/components.dart';
import 'create_sale_request.dart';

class CreateSaleRequestPage extends ConsumerWidget {
  final int enterpriseCode;
  final int requestCode;
  const CreateSaleRequestPage({
    super.key,
    required this.enterpriseCode,
    required this.requestCode,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(pendingSaleRequestStateControllerProvider(enterpriseCode), (
      p,
      n,
    ) {
      n.showAlertDialogOnError(context);
    });
    ref.listen(saveSaleRequestControllerProvider, (p, n) {
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'O pedido foi salvo com sucesso'.hardcoded,
      );
    });

    ref.listen(printSaleRequestControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    ref.observeLoading([
      processCartControllerProvider,
      saveSaleRequestControllerProvider,
    ]);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(enterpriseCode: enterpriseCode),
        actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
        titleSpacing: 0,
        actions: [
          if (screenWidth > 200) ...[
            ShowPdfButton(enterpriseCode: enterpriseCode),
            PrintButton(enterpriseCode: enterpriseCode),
          ],
          CartBadge(enterpriseCode: enterpriseCode),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, _) {
          final currentIndex = ref.watch(pageIndexStateControllerProvider);
          if (currentIndex != 1) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            child: Icon(
              isIOS
                  ? CupertinoIcons.person_add
                  : Icons.person_add_alt_1_outlined,
            ),
            onPressed: () {
              ref
                  .read(tryAccessModuleControllerProvider.notifier)
                  .tryAccess(
                    context: context,
                    module: Modules.customerRegister,
                    route: Routes.customerRegister,
                    enterpriseCode: enterpriseCode,
                  );
            },
          );
        },
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(
              requestTypeStateControllerProvider(
                Modules.saleRequest,
                enterpriseCode,
              ),
            ),
            tryAgain: () {
              ref.invalidate(
                requestTypeStateControllerProvider(
                  Modules.saleRequest,
                  enterpriseCode,
                ),
              );
            },
            data: (requests) {
              final selectedRequest = requests!.firstWhere(
                (e) => e.code == requestCode,
              );

              return IndexedStack(
                index: ref.watch(pageIndexStateControllerProvider),
                children: [
                  InsertProductsPage(
                    enterpriseCode: enterpriseCode,
                    selectedRequest: selectedRequest,
                  ),
                  CustomerPage(enterpriseCode: enterpriseCode),
                  CartPage(
                    selectedRequest: selectedRequest,
                    enterpriseCode: enterpriseCode,
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(enterpriseCode: enterpriseCode),
    );
  }
}
