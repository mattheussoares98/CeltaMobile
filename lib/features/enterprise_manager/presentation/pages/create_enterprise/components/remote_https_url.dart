import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';

class RemoteHttpsUrl extends StatelessWidget {
  final TextEditingController urlController;
  final FocusNode urlFocusNode;
  final bool isLoading;
  final FocusNode localHttpUrlFocusNode;
  const RemoteHttpsUrl({
    super.key,
    required this.urlController,
    required this.urlFocusNode,
    required this.isLoading,
    required this.localHttpUrlFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: urlController,
      focusNode: urlFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 100,
      onFieldSubmitted: (_) {
        localHttpUrlFocusNode.requestFocus();
      },
      labelText: "HTTPS remota".hardcoded,
      hintText: "HTTPS remota".hardcoded,
      keyboardType: TextInputType.url,
      suffixIcon: DeleteIcon(onPress: isLoading ? null : urlController.clear),
      validator: FormValidators.compose([
        UrlValidator(allowEmptyValue: true, shouldBeHttps: true),
      ]),
    );
  }
}
