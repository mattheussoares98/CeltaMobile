import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZipField extends ConsumerWidget {
  final VoidCallback seekAddress;
  final void Function(bool value) changeShowAllFields;
  final TextEditingController zipController;
  final FocusNode zipFocusNode;
  final bool isLoading;
  const ZipField({
    super.key,
    required this.seekAddress,
    required this.changeShowAllFields,
    required this.zipController,
    required this.zipFocusNode,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseTextFormField(
      controller: zipController,
      enabled: !isLoading,
      focusNode: zipFocusNode,
      maxLength: 8,
      labelText: context.l10n.postalCode,
      hintText: context.l10n.postalCode,
      prefixIcon: IconButton(
        onPressed: () {
          changeShowAllFields(false);
          zipController.clear();
        },
        icon: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.delete,
          materialIcon: Icons.delete,
          color: Colors.red,
        ),
      ),
      suffixIcon: isLoading
          ? const LoadingWidget()
          : PrimaryTextButton(
              text: context.l10n.searchPostalCode,
              onPressed: seekAddress,
            ),
      onChanged: (value) {
        if (value.length == 8) {
          seekAddress();
        }
      },
      keyboardType: const TextInputType.numberWithOptions(),
      onFieldSubmitted: (_) {
        seekAddress();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
        NumberValidator(translations: context.l10n, allowDecimal: false),
        MinLengthValidator(8, translations: context.l10n),
      ]),
    );
  }
}
