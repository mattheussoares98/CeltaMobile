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
            title: BaseText.title('Configurações'.hardcoded),
            subtitle: BaseText.caption(
              'Impressora, formulário e etiqueta'.hardcoded,
            ),
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
          child: Wrap(
            runSpacing: Sizes.p8,
            spacing: Sizes.p8,
            alignment: .spaceBetween,
            children: [
              BaseText.title('Campos (${layout.fields.length})'.hardcoded),
              PrintLabelLayoutAddFieldButton(layoutCode: layout.code),
            ],
          ),
        ),
        gapSliverH8,
        if (layout.fields.isEmpty)
          SliverToBoxAdapter(
            child: BaseText.caption('Nenhum campo configurado'.hardcoded),
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
                            ? 'Ocultar do preview'.hardcoded
                            : 'Exibir no preview'.hardcoded,
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
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showAlertDialog(
                            context: context,
                            title: 'Remover item?'.hardcoded,
                            onOkPressed: () => controller.removeField(index),
                            cancelActionText: 'Cancelar'.hardcoded,
                            defaultActionText: 'Remover'.hardcoded,
                          );
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
