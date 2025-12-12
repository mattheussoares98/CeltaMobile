import 'package:flutter/widgets.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';

class ObservationField extends StatelessWidget {
  final TextEditingController observationController;
  const ObservationField({super.key, required this.observationController});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DefaultTextFormField(
        controller: observationController,
        labelText: 'Observações'.hardcoded,
        hintText: 'Observações'.hardcoded,
        maxLines: 3,
        maxLength: 300,
      ),
    );
  }
}
