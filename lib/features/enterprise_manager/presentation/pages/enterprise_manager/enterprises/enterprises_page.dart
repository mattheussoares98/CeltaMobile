import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class EnterprisesPage extends ConsumerWidget {
  final TextEditingController filterEnterpriseNameController;
  const EnterprisesPage({
    super.key,
    required this.filterEnterpriseNameController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(enterpriseManagerControllerProvider),
      tryAgain: () => ref.invalidate(enterpriseManagerControllerProvider),
      data: (enterprises) {
        if (enterprises.isEmpty) {
          return Center(child: Text('Nenhuma empresa encontrada.'.hardcoded));
        }
        return EnterpriseItems(
          enterprises: enterprises,
          filterEnterpriseNameController: filterEnterpriseNameController,
        );
      },
    );
  }
}
