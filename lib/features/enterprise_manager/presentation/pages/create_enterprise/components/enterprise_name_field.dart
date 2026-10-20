import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class EnterpriseNameField extends StatelessWidget {
  final bool isLoading;
  final TextEditingController enterpriseNameController;
  final FocusNode urlFocusNode;
  const EnterpriseNameField({
    super.key,
    required this.isLoading,
    required this.enterpriseNameController,
    required this.urlFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      enabled: !isLoading,
      controller: enterpriseNameController,
      onFieldSubmitted: (_) {
        urlFocusNode.requestFocus();
      },
      suffixIcon: DeleteIcon(
        onPress: isLoading ? null : enterpriseNameController.clear,
      ),
      hintText: "Nome da empresa".hardcoded,
      labelText: "Nome da empresa".hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormValidators.compose([
        const NonEmptyValidator(),
        MinLengthValidator(3),
      ]),
    );
  }
}
