import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/create_sale_request/components/components.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/create_sale_request/create_sale_request.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ref.listen(saveSaleRequestControllerProvider(enterpriseCode), (p, n) {
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'O pedido foi salvo com sucesso'.hardcoded,
      );
    });

    ref.listen(printSaleRequestControllerProvider, (p, n) {
      n.showSnackbarOnError(context, p);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Impressão enviada com sucesso'.hardcoded,
      );
    });

    ref.observeLoading([
      processCartControllerProvider,
      saveSaleRequestControllerProvider(enterpriseCode),
    ]);

    final screenWidth = MediaQuery.sizeOf(context).width;

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
      floatingActionButton: CreateCustomerFloatingButton(
        enterpriseCode: enterpriseCode,
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
