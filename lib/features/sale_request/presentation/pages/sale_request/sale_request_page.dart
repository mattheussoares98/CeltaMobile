import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';
import 'sale_request.dart';

class SaleRequestPage extends ConsumerWidget {
  final int enterpriseCode;
  final int requestCode;
  const SaleRequestPage({
    super.key,
    required this.enterpriseCode,
    required this.requestCode,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            title: AppBarTitle(enterpriseCode: enterpriseCode),
            actionsPadding: const EdgeInsets.fromLTRB(
              0,
              Sizes.p8,
              Sizes.p12,
              Sizes.p8,
            ),
            actions: [
              ShowPdfButton(enterpriseCode: enterpriseCode),
              PrintButton(enterpriseCode: enterpriseCode),
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
                (e) => e.Code == requestCode,
              );

              return IndexedStack(
                index: ref.watch(pageIndexStateControllerProvider),
                children: [
                  InsertProductsPage(
                    enterpriseCode: enterpriseCode,
                    selectedRequest: selectedRequest,
                  ),
                  const CustomerPage(),
                  CartPage(selectedRequest: selectedRequest),
                ],
              );
            },
          ),
          bottomNavigationBar: const BottomNavBar(),
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
