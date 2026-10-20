import 'package:celta_inventario/features/print_label_layout/presentation/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrintLabelLayoutGeneralInformation extends HookConsumerWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutGeneralInformation({super.key, required this.layout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: layout.name);
    final controller = ref.read(
      printLabelLayoutDetailsControllerProvider(layout.code).notifier,
    );

    useEffect(() {
      if (nameController.text != layout.name) {
        nameController.text = layout.name;
      }
      return null;
    }, [layout.name]);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseTextFormField(
              key: const Key('print-label-layout-name'),
              labelText: context.l10n.layoutName,
              controller: nameController,
              onChanged: (value) {
                ref
                    .read(
                      printLabelLayoutDetailsControllerProvider(
                        layout.code,
                      ).notifier,
                    )
                    .updateName(value);
              },
            ),
            gapH8,
            if (layout.capabilities.canEditLayoutType)
              Padding(
                padding: const .only(bottom: Sizes.p8),
                child: BaseDropDown<BSFPrintLabelLayoutType>(
                  key: const Key('print-label-layout-type'),
                  label: context.l10n.type,
                  showLabelAtTopLeft: true,
                  selectedItem: layout.layoutType,
                  items: BSFPrintLabelLayoutType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: BaseText(
                            context.l10n.labelLayoutTypeName(type),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) async {
                    final hasIncompatibleFields = controller
                        .hasIncompatibleFieldsForLayoutType(value);
                    if (hasIncompatibleFields) {
                      final confirmed = await showAlertDialog(
                        context: context,
                        title: context.l10n.attention,
                        cancelActionText: context.l10n.cancel,
                        defaultActionText: context.l10n.continueAction,
                        content: context
                            .l10n
                            .fieldsIncompatibleWithTheNewTypeWillBeRemoved,
                      );
                      if (confirmed != true || !context.mounted) return;
                    }
                    controller.updateLayoutType(
                      value,
                      removeIncompatibleFields: hasIncompatibleFields,
                    );
                  },
                ),
              )
            else
              TitleAndSubTitle(
                title: context.l10n.type,
                subTitle: context.l10n.labelLayoutTypeName(layout.layoutType),
              ),
            if (layout.capabilities.showsAddressType) ...[
              gapH4,
              BaseText.caption(context.l10n.addressType),
              gapH4,
              BaseSegmentedButtons<BSFPrintLabelAddressType>(
                key: const Key('print-label-layout-address-type'),
                items: BSFPrintLabelAddressType.values
                    .where(
                      (type) => type != BSFPrintLabelAddressType.notApplicable,
                    )
                    .toList(),
                selectedValue: layout.addressType,
                itemLabelBuilder: (type) => _addressTypeLabel(context, type),
                onChanged: layout.capabilities.canEditAddressType
                    ? (value) {
                        ref
                            .read(
                              printLabelLayoutDetailsControllerProvider(
                                layout.code,
                              ).notifier,
                            )
                            .updateAddressType(value);
                      }
                    : null,
              ),
            ],
            if (layout.capabilities.canEditPrinter)
              Padding(
                padding: const EdgeInsets.only(top: Sizes.p8),
                child: BaseDropDown<BSFPrintLabelPrinterEntity>(
                  key: const Key('print-label-layout-printer'),
                  label: context.l10n.printer,
                  showLabelAtTopLeft: true,
                  selectedItem:
                      controller.printers.contains(layout.labelPrinter)
                      ? layout.labelPrinter
                      : null,
                  items: controller.printers
                      .map(
                        (printer) => DropdownMenuItem(
                          value: printer,
                          child: BaseText(printer.description),
                        ),
                      )
                      .toList(),
                  onChanged: controller.updatePrinter,
                ),
              )
            else
              TitleAndSubTitle(
                title: context.l10n.printer,
                subTitle: layout.labelPrinter?.description,
                emptyMessage: context.l10n.notProvided3,
              ),
          ],
        ),
      ),
    );
  }

  String _addressTypeLabel(
    BuildContext context,
    BSFPrintLabelAddressType type,
  ) => switch (type) {
    BSFPrintLabelAddressType.principal => context.l10n.main,
    BSFPrintLabelAddressType.collection => context.l10n.billing,
    BSFPrintLabelAddressType.delivery => context.l10n.delivery,
    BSFPrintLabelAddressType.notApplicable => context.l10n.notApplicable,
  };
}
