import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class InstructionsField extends StatelessWidget {
  final FocusNode instructionsFocusNode;
  final TextEditingController instructionsController;
  const InstructionsField({
    super.key,
    required this.instructionsFocusNode,
    required this.instructionsController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BaseTextFormField(
        labelText: 'Instruções'.hardcoded,
        hintText: 'Instruções'.hardcoded,
        maxLines: 3,
        maxLength: 300,
        controller: instructionsController,
        focusNode: instructionsFocusNode,
      ),
    );
  }
}
