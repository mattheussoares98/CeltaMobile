import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../address.dart';

class ReferenceField extends StatelessWidget {
  const ReferenceField({
    super.key,
    required this.page,
    required this.isLoading,
  });

  final AddressPage page;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      focusNode: page.referenceFocusNode,
      enabled: !isLoading,
      controller: page.referenceController,
      labelText: 'Referência'.hardcoded,
      hintText: 'Referência'.hardcoded,
    );
  }
}
