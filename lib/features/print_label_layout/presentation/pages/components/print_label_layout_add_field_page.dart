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
  final List<BSFPrintLabelLayoutFieldEntity> fieldDrafts;

  const PrintLabelLayoutAddFieldPage({
    super.key,
    required this.layoutCode,
    required this.fieldDrafts,
  });

  @override
  ConsumerState<PrintLabelLayoutAddFieldPage> createState() =>
      _PrintLabelLayoutAddFieldPageState();
}

class _PrintLabelLayoutAddFieldPageState
    extends ConsumerState<PrintLabelLayoutAddFieldPage> {
  BSFPrintLabelLayoutFieldEntity? selectedDraft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.title('Adicionar campo ao leiaute'.hardcoded),
          gapH16,
          BaseDropDown<BSFPrintLabelLayoutFieldEntity>(
            label: 'Campo'.hardcoded,
            selectedItem: selectedDraft,
            items: widget.fieldDrafts
                .map(
                  (draft) => DropdownMenuItem(
                    value: draft,
                    child: BaseText(draft.field?.name ?? 'Sem nome'.hardcoded),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedDraft = value),
          ),
          if (selectedDraft != null) ...[
            gapH16,
            TitleAndSubTitle(
              title: 'Tipo'.hardcoded,
              subTitle: selectedDraft!.field?.fieldType.name,
            ),
          ],
          const Spacer(),
          PrimaryButton(
            text: 'Adicionar'.hardcoded,
            onPressed: selectedDraft == null ? null : _addField,
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
        .addField(selectedDraft!);
    context.pop();
  }
}
