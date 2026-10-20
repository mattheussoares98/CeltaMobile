import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';

class ComplementField extends StatelessWidget {
  final TextEditingController complementController;
  final FocusNode complementFocusNode;
  final FocusNode referenceFocusNode;
  const ComplementField({
    super.key,
    required this.isLoading,
    required this.complementController,
    required this.complementFocusNode,
    required this.referenceFocusNode,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      enabled: !isLoading,
      controller: complementController,
      focusNode: complementFocusNode,
      labelText: context.l10n.complement,
      hintText: context.l10n.complement,
      onFieldSubmitted: (_) {
        referenceFocusNode.requestFocus();
      },
    );
  }
}
