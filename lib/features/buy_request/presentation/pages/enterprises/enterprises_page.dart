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
      body: ResponsiveScrollableWidget(
        isSliverPage: true,
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
