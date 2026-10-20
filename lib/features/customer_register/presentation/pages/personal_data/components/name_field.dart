import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:flutter/cupertino.dart';

class NameField extends StatelessWidget {
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final FocusNode reducedNameFocusNode;
  const NameField({
    super.key,
    required this.nameController,
    required this.nameFocusNode,
    required this.reducedNameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: nameController,
      hintText: context.l10n.name,
      labelText: context.l10n.name,
      focusNode: nameFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
        MinLengthValidator(3, translations: context.l10n),
      ]),
      onFieldSubmitted: (_) {
        reducedNameFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(controller: nameController),
    );
  }
}
