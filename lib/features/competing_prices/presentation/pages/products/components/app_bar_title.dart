import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/products/products.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:celta_inventario/utils/utils.dart';

class AppBarTitle extends ConsumerWidget {
  final ProductsPage widget;
  const AppBarTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.researchName == null || widget.concurrentName == null) ...[
          if (screenWidth < Breakpoint.tablet)
            FittedBox(
              child: DefaultText(
                'Pesquisa ${widget.researchCode} - concorrente ${widget.concurrentCode}',
              ),
            )
          else
            DefaultText(
              'Pesquisa ${widget.researchCode} - concorrente ${widget.concurrentCode}',
            ),
        ] else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText.title(
                "${widget.researchName!} (${widget.researchCode})",
              ),
              DefaultText.title(
                "${widget.concurrentName!} (${widget.concurrentCode})",
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

            return DefaultText.bodySmall(
              restrictProducts == true
                  ? 'Produtos restringidos'
                  : 'Produtos não restringidos',
              color: restrictProducts == true
                  ? context.theme.primaryColor
                  : Colors.red,
            );
          },
        ),
      ],
    );
  }
}
