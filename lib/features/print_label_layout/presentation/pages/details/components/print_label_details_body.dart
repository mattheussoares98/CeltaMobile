part of '../print_label_layout_details_page.dart';

class _PrintLabelDetailsBody extends ConsumerWidget {
  const _PrintLabelDetailsBody({
    super.key,
    required this.items,
    required this.layout,
    required this.isWide,
  });

  final bool isWide;
  final List<Widget> items;
  final BSFPrintLabelLayoutEntity layout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        gapSliverH8,
        SliverToBoxAdapter(
          child: ExpansionTile(
            title: BaseText.title(context.l10n.settings),
            subtitle: BaseText.caption(context.l10n.printerFormAndLabel),
            tilePadding: const .symmetric(horizontal: Sizes.p8),
            children: [
              Wrap(
                spacing: Sizes.p8,
                runSpacing: Sizes.p8,
                children: [...items.map((e) => SizedBox(width: 380, child: e))],
              ),
            ],
          ),
        ),
        gapSliverH8,
        SliverToBoxAdapter(
          child: Row(
            children: [
              Expanded(
                child: BaseText.title(
                  context.l10n.layoutFieldsCount(layout.fields.length),
                ),
              ),
              Flexible(
                child: PrintLabelLayoutAddFieldButton(layoutCode: layout.code),
              ),
            ],
          ),
        ),
        gapSliverH8,
        if (layout.fields.isEmpty)
          SliverToBoxAdapter(
            child: BaseText.caption(context.l10n.noFieldsConfigured),
          )
        else
          ResponsiveListFlow(
            isSliver: true,
            itemCount: layout.fields.length,
            maxItemWidth: isWide ? 500 : 380,
            itemBuilder: (context, index) {
              final field = layout.fields[index];
              final controller = ref.read(
                printLabelLayoutDetailsControllerProvider(layout.code).notifier,
              );

              return Padding(
                padding: const .only(bottom: Sizes.p8),
                child: ExpansionTile(
                  title: BaseText.title(field.field?.name ?? ''),
                  subtitle:
                      field.previewValue?.isNotEmpty == true ||
                          field.field?.content.isNotEmpty == true
                      ? BaseText.caption(
                          field.previewValue ?? field.field!.content,
                        )
                      : null,
                  tilePadding: const .only(left: Sizes.p8),
                  trailing: Row(
                    mainAxisSize: .min,
                    children: [
                      IconButton(
                        onPressed: () =>
                            controller.toggleFieldVisibility(index),
                        tooltip: field.isVisible
                            ? context.l10n.hideFromPreview
                            : context.l10n.showInPreview,
                        icon: PlatformIcon(
                          cupertinoIcon: field.isVisible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          materialIcon: field.isVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final confirmed = await showAlertDialog(
                            context: context,
                            title: context.l10n.removeItem,
                            cancelActionText: context.l10n.cancel,
                            defaultActionText: context.l10n.remove,
                          );

                          if (confirmed != true || !context.mounted) return;
                          controller.removeField(index);
                        },
                        icon: const PlatformIcon(
                          cupertinoIcon: CupertinoIcons.delete,
                          materialIcon: Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    PrintLabelLayoutFieldItem(
                      key: ValueKey(index),
                      showVisibilityButton: false,
                      layoutCode: layout.code,
                      fieldIndex: index,
                      field: field,
                      coordinateUnit: layout.coordinateUnit,
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
