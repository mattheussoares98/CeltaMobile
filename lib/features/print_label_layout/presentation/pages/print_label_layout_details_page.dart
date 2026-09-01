import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
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
        data: (layout) {
          final coordinateUnit = layout.labelPrinter?.coordinateUnit;
          List<Widget> items = [
            PrintLabelLayoutGeneralInformation(layout: layout),
            PrintLabelLayoutPrinterParameters(layout: layout),
            PrintLabelLayoutFormParameters(layout: layout),
            PrintLabelLayoutLabelParameters(layout: layout),
          ];

          return Column(
            children: [
              PrintLabelLayoutPreview(layout: layout),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    gapSliverH8,
                    ResponsiveListFlow(
                      isSliver: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return item;
                      },
                    ),
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

                          return PrintLabelLayoutFieldItem(
                            key: ValueKey(index),
                            layoutCode: layout.code,
                            fieldIndex: index,
                            field: field,
                            coordinateUnit: coordinateUnit,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
