part of '../print_label_layout_details_page.dart';

class _AppbarActions extends ConsumerWidget {
  final bool showProblemReportAction;
  final int enterpriseCode;
  final int labelCode;

  const _AppbarActions({
    required this.showProblemReportAction,
    required this.enterpriseCode,
    required this.labelCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelLayoutDetailsControllerProvider(labelCode);
    final saveProvider = printLabelLayoutSaveControllerProvider(labelCode);

    return Row(
      children: [
        if (showProblemReportAction)
          IconButton(
            key: const Key('report-print-label-problem'),
            tooltip: context.l10n.reportIssue,
            onPressed: () {
              if (ref.read(provider.notifier).shouldConfirmPop) {
                showAlertDialog(
                  context: context,
                  title: context.l10n.saveTheLayout,
                  content:
                      context.l10n.saveOrDiscardChangesBeforeReportingAnIssue,
                  defaultActionText: context.l10n.ok,
                );
                return;
              }
              context.pushNamed(
                Routes.printLabelProblemReport.name,
                pathParameters: {
                  'enterpriseCode': enterpriseCode.toString(),
                  'labelCode': labelCode.toString(),
                },
              );
            },
            icon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.exclamationmark_bubble,
              materialIcon: Icons.report_problem_outlined,
              color: Colors.red,
            ),
          ),
        Consumer(
          builder: (_, ref, _) {
            final isSaving = ref.watch(saveProvider.select((s) => s.isLoading));

            return IconButton(
              key: const Key('save-print-label-layout'),
              tooltip: context.l10n.save,
              onPressed: isSaving
                  ? null
                  : () async {
                      final result = await showAlertDialog(
                        context: context,
                        title: context.l10n.saveChanges,
                        content: context.l10n.saveTheseChanges,
                        defaultActionText: context.l10n.yes,
                        cancelActionText: context.l10n.no,
                      );

                      if (result == true && context.mounted) {
                        ref.read(saveProvider.notifier).save();
                      }
                    },
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.check_mark,
                materialIcon: Icons.save_outlined,
              ),
            );
          },
        ),
      ],
    );
  }
}
