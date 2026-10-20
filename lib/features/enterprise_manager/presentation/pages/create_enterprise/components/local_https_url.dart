import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/material.dart';

class LocalHttpsUrl extends StatelessWidget {
  final TextEditingController urlController;
  final FocusNode urlFocusNode;
  final bool isLoading;
  final FocusNode userNameFocusNode;
  const LocalHttpsUrl({
    super.key,
    required this.urlController,
    required this.urlFocusNode,
    required this.isLoading,
    required this.userNameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      enabled: !isLoading,
      controller: urlController,
      focusNode: urlFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 100,
      onFieldSubmitted: (_) {
        userNameFocusNode.requestFocus();
      },
      labelText: "HTTPS local".hardcoded,
      hintText: "HTTPS local".hardcoded,
      keyboardType: TextInputType.url,
      suffixIcon: DeleteIcon(onPress: isLoading ? null : urlController.clear),
      validator: FormValidators.compose([
        UrlValidator(
          translations: context.l10n,
          allowEmptyValue: true,
          shouldBeHttps: true,
        ),
      ]),
    );
  }
}
