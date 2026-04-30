import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class DeleteSummaryButton extends ConsumerWidget {
  final BSFProductItemEntity item;
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const DeleteSummaryButton({
    super.key,
    required this.item,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: saleRequestId,
            ).notifier,
          )
          .removeItem(item),
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete_outline,
        size: 24,
        color: Colors.red,
      ),
      padding: const EdgeInsets.all(Sizes.p4),
      constraints: const BoxConstraints(),
    );
  }
}
