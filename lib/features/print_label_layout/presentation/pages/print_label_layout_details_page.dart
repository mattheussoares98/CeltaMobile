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

          return Column(
            children: [
              PrintLabelLayoutPreview(layout: layout),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    gapSliverH8,
                    SliverToBoxAdapter(
                      child: PrintLabelLayoutGeneralInformation(layout: layout),
                    ),
                    gapSliverH8,
                    SliverToBoxAdapter(
                      child: BaseText.title(
                        'Campos (${layout.fields.length})'.hardcoded,
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
                            key: ValueKey(field.code),
                            layoutCode: layout.code,
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
