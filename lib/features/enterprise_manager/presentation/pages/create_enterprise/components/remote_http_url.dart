import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';

class RemoteHttpUrl extends StatelessWidget {
  final TextEditingController urlController;
  final FocusNode urlFocusNode;
  final bool isLoading;
  final FocusNode remoteHttpsFocusNode;
  const RemoteHttpUrl({
    super.key,
    required this.urlController,
    required this.urlFocusNode,
    required this.isLoading,
    required this.remoteHttpsFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: urlController,
      focusNode: urlFocusNode,
      maxLength: 100,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        remoteHttpsFocusNode.requestFocus();
      },
      labelText: "HTTP remota".hardcoded,
      hintText: "HTTP remota".hardcoded,
      keyboardType: TextInputType.url,
      suffixIcon: DeleteIcon(onPress: isLoading ? null : urlController.clear),
      validator: FormValidators.compose([UrlValidator()]),
    );
  }
}
