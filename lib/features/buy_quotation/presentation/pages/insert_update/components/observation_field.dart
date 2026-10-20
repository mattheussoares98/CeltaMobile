import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/widgets.dart';

class ObservationField extends StatelessWidget {
  final TextEditingController observationController;
  final FocusNode observationsFocusNode;
  const ObservationField({
    super.key,
    required this.observationController,
    required this.observationsFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BaseTextFormField(
        controller: observationController,
        focusNode: observationsFocusNode,
        labelText: context.l10n.notes,
        hintText: context.l10n.notes,
        maxLines: 3,
        maxLength: 300,
      ),
    );
  }
}
