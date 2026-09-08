import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrintLabelProblemReportReview extends HookConsumerWidget {
  final int layoutCode;

  const PrintLabelProblemReportReview({super.key, required this.layoutCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelProblemReportControllerProvider(layoutCode);
    final state = ref.watch(provider).requireValue;
    final controller = ref.read(provider.notifier);
    final descriptionController = useTextEditingController(
      text: state.description,
    );

    return ResponsiveScrollableWidget(
      child: Column(
        key: const Key('print-label-problem-report-review'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.titleLarge('Detalhes do problema'.hardcoded),
          gapH8,
          BaseDropDown<PrintLabelProblemReportCategory>(
            key: const Key('print-label-problem-report-category'),
            label: 'Categoria'.hardcoded,
            selectedItem: state.category,
            items: PrintLabelProblemReportCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: BaseText(category.label.hardcoded),
                  ),
                )
                .toList(),
            onChanged: controller.updateCategory,
          ),
          gapH8,
          BaseTextFormField(
            key: const Key('print-label-problem-report-description'),
            controller: descriptionController,
            labelText: 'Descrição'.hardcoded,
            hintText: 'Explique o resultado esperado e o problema encontrado'
                .hardcoded,
            maxLength: 1950,
            maxLines: 5,
            onChanged: controller.updateDescription,
          ),
          gapH8,
          BaseCheckBox(
            key: const Key('print-label-problem-report-privacy-consent'),
            name:
                'Autorizo o envio das duas imagens, leiaute salvo, meu nome, empresa e dados seguros do app/dispositivo ao suporte técnico'
                    .hardcoded,
            enabled: state.privacyConsentAccepted,
            onChanged: (value) =>
                controller.updatePrivacyConsent(value ?? false),
          ),
          if (state.error != null) ...[
            gapH8,
            BaseText.bodyMedium(
              state.error.toString(),
              color: context.theme.colorScheme.error,
            ),
          ],
          gapH16,
          PrimaryButton(
            key: const Key('submit-print-label-problem-report'),
            text: 'Enviar relatório'.hardcoded,
            onPressed: controller.submit,
          ),
          PrimaryTextButton(
            text: 'Refazer capturas'.hardcoded,
            onPressed: controller.retakeImages,
          ),
        ],
      ),
    );
  }
}
