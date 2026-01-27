import 'package:collection/collection.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.researchName == null || widget.concurrentName == null)
          FittedBox(
            child: Text(
              'Pesquisa ${widget.researchCode} - concorrente ${widget.concurrentCode}',
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.researchName!} (${widget.researchCode})",
                style: theme.textTheme.titleSmall,
              ),
              Text(
                "${widget.concurrentName!} (${widget.concurrentCode})",
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        Consumer(
          builder: (_, ref, _) {
            final restrictProducts = ref.watch(
              researchsStateControllerProvider(widget.enterpriseCode).select(
                (s) =>
                    s.value
                        ?.firstWhereOrNull((e) => e.Code == widget.researchCode)
                        ?.RestrictProducts ??
                    false,
              ),
            );

            return Text(
              restrictProducts == true
                  ? 'Produtos restringidos'
                  : 'Produtos não restringidos',
              style: theme.textTheme.bodySmall?.copyWith(
                color: restrictProducts == true
                    ? theme.primaryColor
                    : Colors.red,
              ),
            );
          },
        ),
      ],
    );
  }
}
