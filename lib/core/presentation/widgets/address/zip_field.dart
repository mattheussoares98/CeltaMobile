import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../validators/validators.dart';

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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return DefaultTextFormField(
      controller: zipController,
      enabled: !isLoading,
      focusNode: zipFocusNode,
      maxLength: 8,
      labelText: 'CEP'.hardcoded,
      hintText: 'CEP'.hardcoded,
      prefixIcon: IconButton(
        onPressed: () {
          changeShowAllFields(false);
          zipController.clear();
        },
        icon: Icon(
          isIOS ? CupertinoIcons.delete : Icons.delete,
          color: Colors.red,
        ),
      ),
      suffixIcon: isLoading
          ? const LoadingWidget(size: Sizes.p16)
          : PrimaryTextButton(
              text: 'Pesquisar CEP'.hardcoded,
              onPressed: seekAddress,
            ),
      onChanged: (value) {
        if (value.length == 8) {
          seekAddress();
        }
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      onFieldSubmitted: (_) {
        seekAddress();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: false),
        MinLengthValidator(8),
      ]),
    );
  }
}
