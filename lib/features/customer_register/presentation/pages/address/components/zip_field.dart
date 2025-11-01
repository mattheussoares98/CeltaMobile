import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../address.dart';

class ZipField extends StatelessWidget {
  final AddressPage page;
  final bool isLoading;
  final VoidCallback seekAddress;
  final void Function(bool value) changeShowAllFields;
  const ZipField({
    super.key,
    required this.page,
    required this.isLoading,
    required this.seekAddress,
    required this.changeShowAllFields,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return DefaultTextFormField(
      controller: page.zipController,
      enabled: !isLoading,
      focusNode: page.zipFocusNode,
      maxLength: 8,
      labelText: 'CEP'.hardcoded,
      hintText: 'CEP'.hardcoded,
      prefixIcon: IconButton(
        onPressed: () {
          changeShowAllFields(false);
          page.zipController.clear();
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
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
      ), //TODO test in iOS
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
