import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrintLabelLayoutGeneralInformation extends HookConsumerWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutGeneralInformation({super.key, required this.layout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: layout.name);

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
              labelText: 'Nome do leiaute'.hardcoded,
              controller: nameController,
              maxLength: 100,
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
            gapH4,
            TitleAndSubTitle(
              title: 'Tipo'.hardcoded,
              subTitle: layout.layoutType.label.hardcoded,
            ),
            TitleAndSubTitle(
              title: 'Quantidade de colunas'.hardcoded,
              subTitle: layout.quantityColumns,
            ),
            TitleAndSubTitle(
              title: 'Impressora'.hardcoded,
              subTitle: layout.labelPrinter?.description,
              emptyMessage: 'Não informada'.hardcoded,
            ),
          ],
        ),
      ),
    );
  }
}
