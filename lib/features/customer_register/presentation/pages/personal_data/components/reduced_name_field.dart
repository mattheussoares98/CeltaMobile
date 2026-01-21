import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import 'components.dart';

class ReducedNameField extends StatelessWidget {
  final TextEditingController reducedNameController;
  final FocusNode reducedNameFocusNode;
  final FocusNode passwordFocusNode;
  const ReducedNameField({
    super.key,
    required this.reducedNameController,
    required this.reducedNameFocusNode,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: reducedNameController,
      maxLength: 30,
      hintText: 'Nome reduzido'.hardcoded,
      labelText: 'Nome reduzido'.hardcoded,
      focusNode: reducedNameFocusNode,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(controller: reducedNameController),
    );
  }
}
