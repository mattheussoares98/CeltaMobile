import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class LocalHttpUrl extends StatelessWidget {
  final TextEditingController urlController;
  final FocusNode urlFocusNode;
  final bool isLoading;
  final FocusNode localHttpsUrlFocusNode;
  const LocalHttpUrl({
    super.key,
    required this.urlController,
    required this.urlFocusNode,
    required this.isLoading,
    required this.localHttpsUrlFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      enabled: !isLoading,
      controller: urlController,
      focusNode: urlFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.url,
      maxLength: 100,
      onFieldSubmitted: (_) {
        localHttpsUrlFocusNode.requestFocus();
      },
      labelText: "HTTP local".hardcoded,
      hintText: "HTTP local".hardcoded,
      suffixIcon: DeleteIcon(onPress: isLoading ? null : urlController.clear),
      validator: FormValidators.compose([UrlValidator(allowEmptyValue: true)]),
    );
  }
}
