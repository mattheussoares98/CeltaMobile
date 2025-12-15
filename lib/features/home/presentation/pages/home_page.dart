import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/controllers/enterprises/enterprises.dart';
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
        context.goNamed(Routes.auth.name);
      }
    });

    final enterprisesAsync = ref.watch(enterprisesStateControllerProvider());

    return Scaffold(
      drawer: const CompleteDrawer(),
      appBar: AppBar(
        leadingWidth: 40,
        title: AsyncValueWidget(
          value: enterprisesAsync,
          tryAgain: () => ref.invalidate(enterpriseRepositoryProvider),
          data: (enterprises) {
            return SelectEnterpriseDropDown(enterprises: enterprises);
          },
        ),
      ),

      body: enterprisesAsync.hasValue && !enterprisesAsync.isLoading
          ? AsyncValueWidget(
              value: ref.watch(
                enabledModulesByEnterpriseNameStateControllerProvider(
                  selectedEnterpriseStateControllerProvider.name!,
                ),
              ),
              tryAgain: () => ref.invalidate(
                enabledModulesByEnterpriseNameStateControllerProvider(
                  selectedEnterpriseStateControllerProvider.name!,
                ),
              ),
              data: (_) => const ModulesWidget(),
            )
          : null,
    );
  }
}
