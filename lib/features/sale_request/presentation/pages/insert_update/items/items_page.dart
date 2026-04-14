import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class ItemsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const ItemsPage({
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

    final productsAsync = ref.watch(
      provider.select((v) => v.whenData((data) => data.products)),
    );

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return AsyncValueWidget(
      value: productsAsync,
      data: (products) {
        final items = products ?? [];
        if (items.isEmpty) {
          return Center(child: Text('Nenhum item adicionado'.hardcoded));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(Sizes.p8),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(item.product?.name ?? ''),
              subtitle: Text('Qtd: ${item.quantity}'.hardcoded),
              trailing: IconButton(
                icon: Icon(
                  isIOS ? CupertinoIcons.delete : Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  ref.read(provider.notifier).removeItem(item);
                },
              ),
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(provider),
    );
  }
}
