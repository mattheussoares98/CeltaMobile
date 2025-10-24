import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class EnterprisesPage extends ConsumerWidget {
  const EnterprisesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesAsync = ref.watch(enterprisesStateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Empresas'.hardcoded)),
      body: ResponsiveScrollableWidget(
        isSliverPage: true, //TODO change this param name
        child: AsyncValueWidget(
          value: enterprisesAsync,
          tryAgain: () {
            ref.invalidate(enterprisesStateControllerProvider);
          },
          data: (enterprises) {
            return ListView.builder(
              itemCount: enterprises.length,
              itemBuilder: (_, index) {
                final enterprise = enterprises[index];
                return EnterpriseItem(enterprise: enterprise);
              },
            );
          },
        ),
      ),
    );
  }
}
