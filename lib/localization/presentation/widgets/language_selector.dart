import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(languageControllerProvider);
    final controller = ref.read(languageControllerProvider.notifier);
    ref.listen(languageControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });
    return BaseDropDown<AppLanguage>(
      label: context.l10n.language,
      showLabelAtTopLeft: true,
      selectedItem: state.value ?? controller.language,
      items: AppLanguage.values
          .map(
            (language) => DropdownMenuItem(
              value: language,
              child: Text(
                language == AppLanguage.portuguese
                    ? context.l10n.portuguese
                    : context.l10n.english,
              ),
            ),
          )
          .toList(),
      onChanged: controller.setLanguage,
    );
  }
}
