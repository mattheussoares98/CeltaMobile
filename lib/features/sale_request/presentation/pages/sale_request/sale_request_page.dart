import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../../core/presentation/mixins/mixins.dart';
import '../../../../../routing/routes.dart';
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

class _SaleRequestPageState extends ConsumerState<SaleRequestPage>
    with TryAccessRouteMixin {
  @override
  Widget build(BuildContext context) {
    ref.listen(
      pendingSaleRequestStateControllerProvider(widget.enterpriseCode),
      (p, n) {
        n.showAlertDialogOnError(context);
      },
    );
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

    ref.observeLoading([
      processCartControllerProvider,
      saveSaleRequestControllerProvider,
    ]);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(enterpriseCode: widget.enterpriseCode),
        actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
        titleSpacing: 0,
        actions: [
          if (screenWidth > 200) ...[
            ShowPdfButton(enterpriseCode: widget.enterpriseCode),
            PrintButton(enterpriseCode: widget.enterpriseCode),
          ],
          CartBadge(enterpriseCode: widget.enterpriseCode),
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
              tryAccessRoute(
                Routes.customerRegister,
                Modules.customerRegister,
                widget.enterpriseCode,
                replace: false,
              );
            },
          );
        },
      ),
      body: AsyncValueWidget(
        value: ref.watch(
          requestTypeStateControllerProvider(
            Modules.saleRequest,
            widget.enterpriseCode,
          ),
        ),
        tryAgain: () {
          ref.invalidate(
            requestTypeStateControllerProvider(
              Modules.saleRequest,
              widget.enterpriseCode,
            ),
          );
        },
        data: (requests) {
          final selectedRequest = requests!.firstWhere(
            (e) => e.Code == widget.requestCode,
          );

          return IndexedStack(
            index: ref.watch(pageIndexStateControllerProvider),
            children: [
              InsertProductsPage(
                enterpriseCode: widget.enterpriseCode,
                selectedRequest: selectedRequest,
              ),
              CustomerPage(enterpriseCode: widget.enterpriseCode),
              CartPage(
                selectedRequest: selectedRequest,
                enterpriseCode: widget.enterpriseCode,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(enterpriseCode: widget.enterpriseCode),
    );
  }
}
