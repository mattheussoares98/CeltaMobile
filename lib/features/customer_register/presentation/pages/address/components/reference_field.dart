import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';

class ReferenceField extends StatelessWidget {
  final bool isLoading;
  final FocusNode referenceFocusNode;
  final TextEditingController referenceController;
  const ReferenceField({
    super.key,
    required this.isLoading,
    required this.referenceFocusNode,
    required this.referenceController,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      focusNode: referenceFocusNode,
      enabled: !isLoading,
      controller: referenceController,
      labelText: 'Referência'.hardcoded,
      hintText: 'Referência'.hardcoded,
    );
  }
}
