import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PrintLabelLayoutAddFieldPage extends ConsumerStatefulWidget {
  final int layoutCode;
  final List<PrintLabelFieldEditorOptionEntity> fieldOptions;

  const PrintLabelLayoutAddFieldPage({
    super.key,
    required this.layoutCode,
    required this.fieldOptions,
  });

  @override
  ConsumerState<PrintLabelLayoutAddFieldPage> createState() =>
      _PrintLabelLayoutAddFieldPageState();
}

class _PrintLabelLayoutAddFieldPageState
    extends ConsumerState<PrintLabelLayoutAddFieldPage> {
  PrintLabelFieldEditorOptionEntity? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.title('Adicionar campo ao leiaute'.hardcoded),
          gapH16,
          BaseDropDown<PrintLabelFieldEditorOptionEntity>(
            label: 'Campo'.hardcoded,
            selectedItem: selectedOption,
            items: widget.fieldOptions
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: BaseText(option.definition.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedOption = value),
          ),
          if (selectedOption != null) ...[
            gapH16,
            TitleAndSubTitle(
              title: 'Tipo'.hardcoded,
              subTitle: selectedOption!.definition.fieldType.name,
            ),
          ],
          const Spacer(),
          PrimaryButton(
            text: 'Adicionar'.hardcoded,
            onPressed: selectedOption == null ? null : _addField,
          ),
        ],
      ),
    );
  }

  void _addField() {
    ref
        .read(
          printLabelLayoutDetailsControllerProvider(widget.layoutCode).notifier,
        )
        .addField(selectedOption!.draft);
    context.pop();
  }
}
