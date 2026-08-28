import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutDetailsPage extends ConsumerWidget {
  final int labelCode;

  const PrintLabelLayoutDetailsPage({super.key, required this.labelCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelLayoutDetailsControllerProvider(labelCode);

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(title: 'Detalhes do leiaute'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (layout) => ResponsiveScrollableWidget(
          child: PrintLabelLayoutDetailsContent(layout: layout),
        ),
      ),
    );
  }
}
