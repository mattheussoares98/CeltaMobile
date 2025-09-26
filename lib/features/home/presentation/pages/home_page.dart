import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/enterprise/enterprise.dart';
import '../../../../utils/utils.dart';
import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../routing/routing.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import 'components/components.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userSessionProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      if (next.value == null) {
        context.goNamed(AppRoute.auth.name);
      }
    });

    final enterprisesAsync = ref.watch(enterprisesStateControllerProvider);
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    return Scaffold(
      drawer: CompleteDrawer(),
      appBar: AppBar(
        leadingWidth: 40,
        title: AsyncValueWidget(
          value: enterprisesAsync,
          tryAgain: () => ref.invalidate(enterpriseRepositoryProvider),
          data: (enterprises) {
            return SelectEnterpriseDropDown(
              selectedEnterprise: selectedEnterprise,
              enterprises: enterprises,
            );
          },
        ),
      ),

      body: Modules(),
    );
  }
}
