import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:flutter/cupertino.dart';

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
    return BaseTextFormField(
      controller: reducedNameController,
      maxLength: 30,
      hintText: context.l10n.shortName2,
      labelText: context.l10n.shortName2,
      focusNode: reducedNameFocusNode,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(controller: reducedNameController),
    );
  }
}
