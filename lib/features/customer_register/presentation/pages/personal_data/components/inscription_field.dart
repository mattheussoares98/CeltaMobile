import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:flutter/material.dart';

class InscriptionField extends StatelessWidget {
  final TextEditingController inscriptionController;
  final FocusNode inscriptionFocusNode;
  final FocusNode nameFocusNode;
  const InscriptionField({
    super.key,
    required this.inscriptionController,
    required this.inscriptionFocusNode,
    required this.nameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: inscriptionController,
      focusNode: inscriptionFocusNode,
      maxLength: 9,
      hintText: context.l10n.stateTaxRegistration,
      labelText: context.l10n.stateTaxRegistration,
      keyboardType: const TextInputType.numberWithOptions(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        nameFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(controller: inscriptionController),
    );
  }
}
