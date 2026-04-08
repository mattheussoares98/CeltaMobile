import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../routing/routing.dart';

class EditButton extends StatelessWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const EditButton({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return IconButton(
      onPressed: () {
        context.goNamed(
          Routes.insertUpdateSaleRequest.name,
          pathParameters: {
            'enterpriseCode': enterpriseCode.toString(),
            'customerCode': customerCode.toString(),
            'saleRequestId': saleRequestId.toString(),
          },
        );
      },
      icon: Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
    );
  }
}
