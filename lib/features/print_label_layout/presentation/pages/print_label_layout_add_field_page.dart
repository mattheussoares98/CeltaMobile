import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutAddFieldPage extends ConsumerWidget {
  final int layoutCode;
  final List<PrintLabelFieldEditorOptionEntity> fieldOptions;
  final List<BSFPrintLabelFieldFormatEntity> formats;

  const PrintLabelLayoutAddFieldPage({
    super.key,
    required this.layoutCode,
    required this.fieldOptions,
    required this.formats,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addFieldProvider = printLabelLayoutAddFieldControllerProvider(
      layoutCode,
    );
    final addFieldState = ref.watch(addFieldProvider);
    final controller = ref.read(addFieldProvider.notifier);
    final coordinateUnit = ref.watch(
      printLabelLayoutDetailsControllerProvider(
        layoutCode,
      ).select((s) => s.value?.coordinateUnit),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.title(context.l10n.addFieldToLayout),
          gapH16,
          Expanded(
            child: SingleChildScrollView(
              child: PrintLabelLayoutFieldEditor(
                layoutCode: layoutCode,
                field: addFieldState.draft,
                fieldOptions: fieldOptions,
                selectedFieldOption: addFieldState.selectedOption,
                onFieldOptionChanged: controller.selectFieldOption,
                fieldDefinitions: fieldOptions
                    .map((option) => option.definition)
                    .toList(),
                formats: formats,
                coordinateUnit: coordinateUnit,
                onFieldChanged: controller.updateField,
              ),
            ),
          ),
          PrimaryButton(
            text: context.l10n.add,
            onPressed: addFieldState.draft == null
                ? null
                : () {
                    controller.addField();
                    context.pop();
                  },
          ),
        ],
      ),
    );
  }
}
