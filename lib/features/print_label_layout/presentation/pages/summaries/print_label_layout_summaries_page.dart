import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/summaries/components/components.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      appBar: BaseAppBar(
        title: context.l10n.labelLayouts,
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: context.l10n.reportedIssues,
              onPressed: () => context.goNamed(
                Routes.reportedPrintLabelProblems.name,
                pathParameters: {'enterpriseCode': enterpriseCode.toString()},
              ),
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.exclamationmark_bubble,
                materialIcon: Icons.bug_report_outlined,
              ),
            ),
          IconButton(
            onPressed: () => context.goNamed(
              Routes.printLabelLayoutDetails.name,
              pathParameters: {
                'enterpriseCode': enterpriseCode.toString(),
                'labelCode': '0',
              },
            ),
            icon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.add,
              materialIcon: Icons.add,
            ),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (summaries) {
          if (summaries.isEmpty) {
            return EmptyPlaceholderWidget(
              message: context.l10n.noLabelLayoutsFound,
            );
          }

          return ResponsiveListFlow(
            itemCount: summaries.length,
            itemBuilder: (_, index) {
              final summary = summaries[index];
              return PrintLabelLayoutSummaryItem(
                key: ValueKey(summary.code),
                summary: summary,
                enterpriseCode: enterpriseCode,
              );
            },
          );
        },
      ),
    );
  }
}
