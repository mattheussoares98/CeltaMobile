import 'dart:math';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
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
      padding: const .fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
      appBar: Consumer(
        builder: (_, ref, _) {
          final layoutName = ref.watch(provider.select((s) => s.value?.name));

          return BaseAppBar(
            title: layoutName ?? 'Detalhes do leiaute'.hardcoded,
          );
        },
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (layout) {
          final coordinateUnit = layout.labelPrinter?.coordinateUnit;
          List<Widget> items = [
            PrintLabelLayoutGeneralInformation(layout: layout),
            PrintLabelLayoutPrinterParameters(layout: layout),
            PrintLabelLayoutFormParameters(layout: layout),
            PrintLabelLayoutLabelParameters(layout: layout),
          ];

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: min(constraints.maxHeight * 0.3, 250),
                    ),
                    child: PrintLabelLayoutPreview(layout: layout),
                  ),
                  gapH8,
                  Expanded(
                    child: CustomScrollView(
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
                                children: [
                                  ...items.map(
                                    (e) => SizedBox(width: 380, child: e),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        gapSliverH8,
                        SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              BaseText.title(
                                'Campos (${layout.fields.length})'.hardcoded,
                              ),
                              Flexible(
                                child: PrintLabelLayoutAddFieldButton(
                                  layoutCode: layout.code,
                                ),
                              ),
                            ],
                          ),
                        ),
                        gapSliverH8,
                        if (layout.fields.isEmpty)
                          SliverToBoxAdapter(
                            child: BaseText.caption(
                              'Nenhum campo configurado'.hardcoded,
                            ),
                          )
                        else
                          ResponsiveListFlow(
                            isSliver: true,
                            itemCount: layout.fields.length,
                            itemBuilder: (context, index) {
                              final field = layout.fields[index];

                              return ExpansionTile(
                                title: BaseText.title(field.field?.name ?? ''),
                                subtitle:
                                    field.previewValue?.isNotEmpty == true ||
                                        field.field?.content.isNotEmpty == true
                                    ? BaseText.caption(
                                        field.previewValue ??
                                            field.field!.content,
                                      )
                                    : null,
                                trailing: IconButton(
                                  onPressed: () => ref
                                      .read(
                                        printLabelLayoutDetailsControllerProvider(
                                          layout.code,
                                        ).notifier,
                                      )
                                      .toggleFieldVisibility(index),
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
                                children: [
                                  PrintLabelLayoutFieldItem(
                                    key: ValueKey(index),
                                    showVisibilityButton: false,
                                    layoutCode: layout.code,
                                    fieldIndex: index,
                                    field: field,
                                    coordinateUnit: coordinateUnit,
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
