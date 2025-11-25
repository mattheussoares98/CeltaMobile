import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';
import '../products.dart';

class AppBarTitle extends ConsumerWidget {
  final ProductsPage widget;
  const AppBarTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Consumer(
      builder: (_, ref, _) {
        final restrictProducts = ref.watch(
          researchsStateControllerProvider.select(
            (s) =>
                s.value
                    ?.firstWhere((e) => e.Code == widget.researchCode)
                    .RestrictProducts ??
                false,
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              //TODO use researchName and concurrentCode instead
              child: Text(
                'Pesquisa ${widget.researchCode} - concorrente ${widget.concurrentCode}',
              ),
            ),
            Text(
              restrictProducts == true
                  ? 'Produtos restringidos'
                  : 'Produtos não restringidos',
              style: theme.textTheme.bodySmall?.copyWith(
                color: restrictProducts == true
                    ? theme.primaryColor
                    : Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
