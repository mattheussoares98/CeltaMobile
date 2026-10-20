import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
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
      labelText: context.l10n.reference,
      hintText: context.l10n.reference,
      onFieldSubmitted: (_) => addAddress(),
    );
  }
}
