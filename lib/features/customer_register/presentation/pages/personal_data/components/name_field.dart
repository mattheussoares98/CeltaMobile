import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
      maxLength: 50,
      hintText: 'Nome'.hardcoded,
      labelText: 'Nome'.hardcoded,
      focusNode: nameFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(3),
      ]),
      onFieldSubmitted: (_) {
        reducedNameFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(controller: nameController),
    );
  }
}
