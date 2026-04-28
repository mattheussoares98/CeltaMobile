import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );

    ref.listen(provider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Pedido salvo com sucesso!'.hardcoded,
      );
    });

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
