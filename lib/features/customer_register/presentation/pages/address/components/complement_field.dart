import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../address.dart';

class ComplementField extends StatelessWidget {
  const ComplementField({
    super.key,
    required this.isLoading,
    required this.page,
  });

  final bool isLoading;
  final AddressPage page;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: page.complementController,
      focusNode: page.complementFocusNode,
      labelText: 'Complemento'.hardcoded,
      hintText: 'Complemento'.hardcoded,
      onFieldSubmitted: (_) {
        page.referenceFocusNode.requestFocus();
      },
    );
  }
}
