import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/localization/localization.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
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
          BaseText.titleLarge(context.l10n.issueDetails),
          gapH8,
          BaseDropDown<PrintLabelProblemReportCategory>(
            key: const Key('print-label-problem-report-category'),
            label: context.l10n.category,
            selectedItem: state.category,
            items: PrintLabelProblemReportCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: BaseText(
                      context.l10n.problemReportCategoryName(category),
                    ),
                  ),
                )
                .toList(),
            onChanged: controller.updateCategory,
          ),
          gapH8,
          BaseTextFormField(
            key: const Key('print-label-problem-report-description'),
            controller: descriptionController,
            labelText: context.l10n.description,
            hintText:
                context.l10n.describeTheExpectedResultAndTheIssueEncountered,
            maxLength: 1950,
            maxLines: 5,
            onChanged: controller.updateDescription,
          ),
          gapH8,
          BaseCheckBox(
            key: const Key('print-label-problem-report-privacy-consent'),
            name: context.l10n.iAuthorizeSendingBothImagesTheSavedLayoutMyName,
            enabled: state.privacyConsentAccepted,
            onChanged: (value) =>
                controller.updatePrivacyConsent(value ?? false),
          ),
          if (state.error != null) ...[
            gapH8,
            BaseText.bodyMedium(
              parseErrorMessage(state.error, translations: context.l10n),
              color: context.theme.colorScheme.error,
            ),
          ],
          gapH16,
          PrimaryButton(
            key: const Key('submit-print-label-problem-report'),
            text: context.l10n.sendReport,
            onPressed: controller.submit,
          ),
          PrimaryTextButton(
            text: context.l10n.retakeCaptures,
            onPressed: controller.retakeImages,
          ),
        ],
      ),
    );
  }
}
