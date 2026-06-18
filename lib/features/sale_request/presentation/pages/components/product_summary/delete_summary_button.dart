import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteSummaryButton extends ConsumerWidget {
  final BSFProductItemEntity item;

  const DeleteSummaryButton({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(insertUpdateStateControllerProvider.notifier)
          .removeItem(item),
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete_outline,
        size: 32,
        color: Colors.red,
      ),
      padding: const EdgeInsets.all(Sizes.p4),
    );
  }
}
