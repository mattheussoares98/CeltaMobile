import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/enterprise_manager/enterprises/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          return Center(child: BaseText(context.l10n.noCompaniesFound));
        }
        return EnterpriseItems(
          enterprises: enterprises,
          filterEnterpriseNameController: filterEnterpriseNameController,
        );
      },
    );
  }
}
