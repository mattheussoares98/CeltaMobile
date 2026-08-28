import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutSummariesPage extends ConsumerWidget {
  final int enterpriseCode;
  const PrintLabelLayoutSummariesPage({
    super.key,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelLayoutSummariesControllerProvider;

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(title: 'Leiautes de etiquetas'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (summaries) {
          if (summaries.isEmpty) {
            return EmptyPlaceholderWidget(
              message: 'Nenhum leiaute de etiqueta encontrado'.hardcoded,
            );
          }

          return ResponsiveListFlow(
            itemCount: summaries.length,
            itemBuilder: (_, index) {
              final summary = summaries[index];
              return PrintLabelLayoutSummaryItem(
                key: ValueKey(summary.code),
                summary: summary,
              );
            },
          );
        },
      ),
    );
  }
}
