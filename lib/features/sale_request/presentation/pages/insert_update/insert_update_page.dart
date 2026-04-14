import 'package:flutter/material.dart';

import '../../../../../localization/string_hardcoded.dart';
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
