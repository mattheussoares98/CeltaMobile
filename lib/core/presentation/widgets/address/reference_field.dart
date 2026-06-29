import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class ReferenceField extends StatelessWidget {
  final bool isLoading;
  final FocusNode referenceFocusNode;
  final TextEditingController referenceController;
  final VoidCallback addAddress;
  const ReferenceField({
    super.key,
    required this.isLoading,
    required this.referenceFocusNode,
    required this.referenceController,
    required this.addAddress,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      focusNode: referenceFocusNode,
      enabled: !isLoading,
      controller: referenceController,
      labelText: 'Referência'.hardcoded,
      hintText: 'Referência'.hardcoded,
      onFieldSubmitted: (_) => addAddress(),
    );
  }
}
