import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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
    ref.listen(saveSaleRequestControllerProvider(enterpriseCode), (p, n) {
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
    ref.observeLoading([saveSaleRequestControllerProvider(enterpriseCode)]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          saleRequestId == 0
              ? 'Inserir Pedido'.hardcoded
              : 'Atualizar Pedido'.hardcoded,
        ),
      ),
      body: InsertUpdateBody(
        enterpriseCode: enterpriseCode,
        customerCode: customerCode,
        saleRequestId: saleRequestId,
      ),
      bottomNavigationBar: const InsertUpdateBottomNavigationBar(),
    );
  }
}
